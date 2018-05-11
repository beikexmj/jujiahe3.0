//
//  BalanceRechargeViewController.m
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "BalanceRechargeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
@interface BalanceRechargeViewController ()
{
    NSInteger selectflag;
    CGFloat moneyFloat;
    BOOL isHaveDian;
    BOOL isZero;
    NSString *moneyStr;
}

@end

@implementation BalanceRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+24;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    [self setOtherFromNib];
    // Do any additional setup after loading the view from its nib.
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.subviewHeight.constant = 504;
}
-(void)setOtherFromNib{
    self.restMoneyView.layer.cornerRadius = 5;
    self.restMoneyView.layer.masksToBounds = YES;
    self.payView.layer.cornerRadius = 5;
    self.payView.layer.masksToBounds = YES;
    self.moneyView.layer.cornerRadius = 5;
    self.moneyView.layer.masksToBounds = YES;

    UIColor *color = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    self.tenYuan.layer.cornerRadius = 3;
    self.tenYuan.layer.borderColor =color.CGColor;
    self.tenYuan.layer.borderWidth = 1;
    
    self.thirtyYuan.layer.cornerRadius = 3;
    self.thirtyYuan.layer.borderColor =color.CGColor;
    self.thirtyYuan.layer.borderWidth = 1;
    
    self.fiftyYuan.layer.cornerRadius = 3;
    self.fiftyYuan.layer.borderColor =color.CGColor;
    self.fiftyYuan.layer.borderWidth = 1;
    
    self.oneHundredYuan.layer.cornerRadius = 3;
    self.oneHundredYuan.layer.borderColor =color.CGColor;
    self.oneHundredYuan.layer.borderWidth = 1;
    
    self.fiftyHundredYuan.layer.cornerRadius = 3;
    self.fiftyHundredYuan.layer.borderColor =color.CGColor;
    self.fiftyHundredYuan.layer.borderWidth = 1;
    
    self.thirtyHundredYuan.layer.cornerRadius = 3;
    self.thirtyHundredYuan.layer.borderColor =color.CGColor;
    self.thirtyHundredYuan.layer.borderWidth = 1;
    
    self.otherMoney.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 40)];
    self.otherMoney.leftViewMode = UITextFieldViewModeAlways;
    self.otherMoney.layer.cornerRadius = 3;
    self.otherMoney.layer.borderWidth = 1;
    self.otherMoney.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1].CGColor;
    self.payMoney.layer.cornerRadius = 5;
    
    self.weixinpayHeight.constant = 0;
    self.wedxinPayView.hidden = YES;
    self.payViewHeight.constant = 102;
    if (SCREENWIDTH<=320) {
        self.payMoneyBtnToBottom.constant = 5;
    }else{
        self.payMoneyBtnToBottom.constant = 0;

    }
    
    selectflag = 1;//微信2 支付宝1
    moneyFloat = -1;
    self.myScrollView.contentSize = CGSizeMake(SCREENWIDTH, 564);
    self.balance.text = [StorageUserInfromation storageUserInformation].accountBalance;
    if (self.rechargeValue) {
        self.otherMoney.text = [NSString stringWithFormat:@"%.2f",self.rechargeValue];
    }
    if (_comfromFlag == 2) {
        self.moneyChoseLable.text = @"充值补差额";
        self.moneyChoseView.hidden = YES;
        self.moneyChoseViewTwo.hidden = YES;
        self.moneyChoseViewConstrant.constant = 0;
        self.moneyChoseViewTwoConstrant.constant = 0;
        self.moneyViewConstrantHeight.constant = 100;
        self.subviewHeight.constant -= 100;
        self.otherMoney.userInteractionEnabled = NO;
    }
    [self moneyChooseBtnClick:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)selectTypeBtnClick:(id)sender {
    UIButton *button = sender;
    if (button.tag == 20) {
        self.weichatSelectOrNotImage.image = [UIImage imageNamed:@"icon_unchoice_gray"];
        self.zhifubaoSelectOrNotImage.image = [UIImage imageNamed:@"life_icon_choice"];
        selectflag = 1;
    }else if(button.tag == 10) {
        self.weichatSelectOrNotImage.image = [UIImage imageNamed:@"life_icon_choice"];
        self.zhifubaoSelectOrNotImage.image = [UIImage imageNamed:@"icon_unchoice_gray"];
        selectflag = 2;
    }
}
- (IBAction)payMoneyBtnClick:(id)sender {
    
    if ([JGIsBlankString isBlankString:self.otherMoney.text]&&moneyFloat<0) {
        [MBProgressHUD showError:@"请选择或输入金额！"];
        return;
    }else{
        if (![JGIsBlankString isBlankString:self.otherMoney.text]) {
            if (_comfromFlag == 0) {
                if ([self.otherMoney.text floatValue]<0.9999) {
                    [MBProgressHUD showError:@"充值金额应不少于1元"];
                    return;
                }else{
                    moneyStr = self.otherMoney.text;
                }
            }else{
                if ([self.otherMoney.text floatValue]*100<0.9999) {
                    [MBProgressHUD showError:@"充值金额应不少于0.01元"];
                    return;
                }else{
                    moneyStr = self.otherMoney.text;
                }
            }
            
        }else{
            moneyStr = [NSString stringWithFormat:@"%0.2f",moneyFloat];
        }
        
    }
    
    if (self.comfromFlag == 1) {
        if ([moneyStr floatValue]<_rechargeValue-0.0000001) {
            [MBProgressHUD showError:@"购电金额不足"];
            return;
        }
    }
    if ([moneyStr doubleValue]*100>=10000000000) {
        [MBProgressHUD showError:@"购电金额过大"];
        return;
    }
    
    [MBProgressHUD showMessage:@"充值中..."];
    NSDictionary *dict;
    NSString *urlStr;
    if (self.comfromFlag == 1) {
        dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"username":[StorageUserInfromation storageUserInformation].username,@"device":@"1",@"chargeAmount":moneyStr,@"payway":[NSString stringWithFormat:@"%ld",selectflag],@"payAmount":[NSString stringWithFormat:@"%.2f",self.rechargeValue + [[StorageUserInfromation storageUserInformation].accountBalance floatValue]],@"accountNo":self.accountNo};
        urlStr = @"user/addOrder/autoPay";
    }else if(self.comfromFlag == 0){
        dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"username":[StorageUserInfromation storageUserInformation].username,@"device":@"1",@"amount":moneyStr,@"payway":[NSString stringWithFormat:@"%ld",selectflag]};
        urlStr = @"jujiaheuser/v1/orderCharge/addOrder";
    }else if (self.comfromFlag == 2){
        dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"username":[StorageUserInfromation storageUserInformation].username,@"device":@"1",@"fee":moneyStr,@"payway":[NSString stringWithFormat:@"%ld",selectflag],@"accountNo":self.accountNo};
        urlStr = @"postPayBill/applyPayInfo";
    }
    
    
    [ZTHttpTool postWithUrl:urlStr param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue]== 0) {
            [MBProgressHUD hideHUD];
            if (selectflag == 1) {
                [self aliPay:[DictToJson dictionaryWithJsonString:str][@"form"][@"payInfo"]];

            }
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
    }];

}
-(void)aliPay:(NSString *)payInfo{
    [MBProgressHUD hideHUD];
    NSUserDefaults * defaut = [NSUserDefaults standardUserDefaults];
    [defaut setValue:[NSNumber numberWithInteger:self.comfromFlag] forKey:@"comfromFlag"];
    [defaut setValue:[NSString stringWithFormat:@"%0.2f",self.rechargeValue] forKey:@"rechargeValue"];
    [defaut setValue:moneyStr forKey:@"moneyStr"];
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:payInfo fromScheme:@"alisdkdemo" callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] integerValue] == 9000) {
            if (self.comfromFlag == 1||self.comfromFlag == 2) {
                [StorageUserInfromation storageUserInformation].accountBalance = [NSString stringWithFormat:@"%0.2f",[[StorageUserInfromation storageUserInformation].accountBalance floatValue]+[moneyStr floatValue]-self.rechargeValue];
            }else{
                [StorageUserInfromation storageUserInformation].accountBalance =[NSString stringWithFormat:@"%0.2f",[[StorageUserInfromation storageUserInformation].accountBalance floatValue]+[moneyStr floatValue]];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IntegralChangeSuccess" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"支付失败！"];
        }
        NSLog(@"reslut = %@",resultDic);
    }];
}

- (IBAction)moneyChooseBtnClick:(id)sender {
    
    UIColor *color = [UIColor colorWithRed:0/255.0 green:167/255.0 blue:255/255.0 alpha:1];
    UIColor *color2 = [UIColor whiteColor];
    self.tenYuan.layer.borderColor =color.CGColor;
    self.thirtyYuan.layer.borderColor =color.CGColor;
    self.fiftyYuan.layer.borderColor =color.CGColor;
    self.oneHundredYuan.layer.borderColor =color.CGColor;
    self.fiftyHundredYuan.layer.borderColor =color.CGColor;
    self.thirtyHundredYuan.layer.borderColor =color.CGColor;
    [self.tenYuan setTitleColor:color forState:UIControlStateNormal];
    [self.thirtyYuan setTitleColor:color forState:UIControlStateNormal];
    [self.fiftyYuan setTitleColor:color forState:UIControlStateNormal];
    [self.oneHundredYuan setTitleColor:color forState:UIControlStateNormal];
    [self.thirtyHundredYuan setTitleColor:color forState:UIControlStateNormal];
    [self.fiftyHundredYuan setTitleColor:color forState:UIControlStateNormal];
    [self.tenYuan setBackgroundColor:color2];
    [self.thirtyYuan setBackgroundColor:color2];
    [self.fiftyYuan setBackgroundColor:color2];
    [self.oneHundredYuan setBackgroundColor:color2];
    [self.thirtyHundredYuan setBackgroundColor:color2];
    [self.fiftyHundredYuan setBackgroundColor:color2];

    if (sender) {
        UIButton *button = sender;
        [button setTitleColor:color2 forState:UIControlStateNormal];
        [button setBackgroundColor:color];
        if (button == self.tenYuan) {
            moneyFloat = 10.00;
        }else if(button == self.thirtyYuan){
            moneyFloat = 30.00;
        }else if(button == self.fiftyYuan){
            moneyFloat = 50.00;
        }else if(button == self.oneHundredYuan){
            moneyFloat = 100.00;
        }else if(button == self.fiftyHundredYuan){
            moneyFloat = 500.00;
        }else if(button == self.thirtyHundredYuan){
            moneyFloat = 300.00;
        }
        self.otherMoney.text = @"";
        [self.otherMoney resignFirstResponder];
    }else{
        moneyFloat = -1;
    }
   
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self moneyChooseBtnClick:nil];

}
//带小数点的金额数字键盘输入判定
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0') {
                    isZero = YES;
                }else{
                    isZero = NO;
                }
            }
            if ([textField.text length] == 1) {//首字母为零时第二个必须是小数点
                if (single != '.') {
                    if (isZero) {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}
@end
