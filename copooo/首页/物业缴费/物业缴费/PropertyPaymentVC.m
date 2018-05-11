//
//  PropertyPaymentVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/30.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PropertyPaymentVC.h"
#import "PropertyPaymentHomeCell.h"
#import "PropertyFeePayToTimeCell.h"
#import "PropertyFeeArreargeTimeCell.h"
#import "HooDatePicker.h"
#import "PayTypeChoseView.h"
#import "PasswordAlertView.h"
#import "RecordQueryVC.h"
#import "PropertyFeePayDataModel.h"
#import "ModifyPaymentPasswordFirstStepViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NSString+ZF.h"

@interface PropertyPaymentVC ()<UITableViewDelegate,UITableViewDataSource,HooDatePickerDelegate,PasswordAlertViewDelegate,UIAlertViewDelegate>
{
    BOOL flag;
    PropertyFeePayToTimeCell *propertyFeePayToTimeCell;
    PasswordAlertView *passwordAlertView;
    PayTypeChoseView *payView;
    NSInteger payWay;
    UIView *coverView;
    CGFloat bottomBtnHight;
}
@property (nonatomic,strong)UILabel *propertyFeeLabel;
@property (nonatomic,strong)UILabel *propertyFeeMark;
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)UILabel *detail;
@property (nonatomic,strong)UILabel *total;
@property (nonatomic,strong)HooDatePicker *datePicker;
@property (nonatomic,strong)PropertyFeePayForm *propertyFeePayData;

@end

@implementation PropertyPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHeaderView];
    [self setNav];
    bottomBtnHight = TABBARHEIGHT;
    [self.view addSubview:self.myTableView];
    [self setBottomView];
    flag = NO;
    payWay = 2;// == 1 账户余额支付， == 2支付宝支付 ==3微信支付 ==4 其他支付方式
    propertyFeePayToTimeCell = [[[NSBundle mainBundle] loadNibNamed:@"PropertyFeePayToTimeCell" owner:self options:nil] lastObject];
    [self datePickerInit];

    WeakSelf
    propertyFeePayToTimeCell.choseTimeBtnBlock = ^{
        StrongSelf
        NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
        [dateFormatter setDateFormat:kDateFormatYYYYMMDD];
        NSDate *maxDate = [dateFormatter dateFromString:@"2050-01-01"];
        NSDateFormatter *formatter = [NSDate shareDateFormatter];
        formatter.dateFormat = @"yyyy年MM月";
        NSDate *minDate = [formatter dateFromString:[StorageUserInfromation timeStrFromDateString4:strongSelf.propertyFeePayData.time]];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *comps = nil;
        comps = [calendar components:NSCalendarUnitYear |NSCalendarUnitMonth|NSCalendarUnitDay fromDate:minDate];
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:1];
        [adcomps setDay:0];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:minDate options:0];
        strongSelf.datePicker.minimumDate = newdate;
        strongSelf.datePicker.maximumDate = maxDate;
        [strongSelf.datePicker setDate:newdate animated:YES];
        [strongSelf.datePicker show];
    };
    [self fetchData];
    // Do any additional setup after loading the view.
}
- (void)fetchData{
    NSDictionary *dict = @{@"propertyHouseId":_propertyHouseId,@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId};
    [ZTHttpTool postWithUrl:@"property/v1/propertyCard/queryPropertyCardInfos" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        PropertyFeePayDataModel *data = [PropertyFeePayDataModel mj_objectWithKeyValues:str];

        if (data.rcode == 0) {
            _propertyFeePayData = data.form;
            [self rebuildData];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)rebuildData{
    if (_propertyFeePayData.status == 1) {
        _propertyFeeLabel.text = [StorageUserInfromation timeStrFromDateString4:_propertyFeePayData.time];
        _propertyFeeMark.text = @"你的物管费已缴纳至";
        
    }else{
        _propertyFeeLabel.text = [NSString stringWithFormat:@"￥%@",_propertyFeePayData.arrearsPrice];//@"￥89.03";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_propertyFeeLabel.text attributes:@{NSForegroundColorAttributeName:RGBA(0xffffff, 1),NSFontAttributeName:[UIFont systemFontOfSize:30]}];
        // 添加字体大小
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:20]
                        range:NSMakeRange(0, 1)];
        _propertyFeeLabel.attributedText = attrStr;
        _propertyFeeMark.text = @"已欠费";

    }
    _detail.text = [NSString stringWithFormat:@"欠费%@+预存%@",_propertyFeePayData.status?@"0.00":_propertyFeePayData.arrearsPrice,@"0.00"];
    _total.text = [NSString stringWithFormat:@"合计缴费：%@",_propertyFeePayData.status?@"0.00":_propertyFeePayData.arrearsPrice];
    [self.myTableView reloadData];

}
- (void)setHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150 +(is_iPhone_X?24:0))];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150 +(is_iPhone_X?24:0))];
    imageView.image = [UIImage imageNamed:@"home_bg1"];
    [headerView addSubview:imageView];
    
    _propertyFeeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40 + (is_iPhone_X?24:0))];
    _propertyFeeLabel.textAlignment = NSTextAlignmentCenter;
    _propertyFeeLabel.font = [UIFont systemFontOfSize:30.0];
    _propertyFeeLabel.textColor = RGBA(0xffffff, 1);
    _propertyFeeLabel.center = CGPointMake(SCREENWIDTH/2.0, 150/2.0 + 10 + (is_iPhone_X?24:0));
    [headerView addSubview:_propertyFeeLabel];
 
    
    _propertyFeeMark = [[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH -200)/2.0, _propertyFeeLabel.y + _propertyFeeLabel.height, 200, 30)];
    _propertyFeeMark.textAlignment = NSTextAlignmentCenter;
    _propertyFeeMark.font = [UIFont systemFontOfSize:15.0];
    _propertyFeeMark.textColor = RGBA(0xffffff, 1);
    [headerView addSubview:_propertyFeeMark];
    [self.view addSubview:headerView];
    
}
- (void)setNav{
    self.isShowNav = YES;
    self.navView.backgroundColor = [UIColor clearColor];
    _backButton.hidden = NO;
    self.lineView.hidden = YES;
    [_backButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    self.titleLabel.text = @"物业缴费";
    self.titleLabel.textColor = RGBA(0xffffff, 1);
    self.rightImgName = @"记录查询";
    [self.rightButton setTitleColor:RGBA(0xffffff, 1) forState:UIControlStateNormal];
}
- (void)rightButtonClick:(UIButton *)button{
    RecordQueryVC *page = [[RecordQueryVC alloc]init];
    page.propertyHouseId = _propertyHouseId;
    [self.navigationController pushViewController:page animated:YES];
}
-(void)setBottomView{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - bottomBtnHight, SCREENWIDTH, bottomBtnHight)];
    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH*(3/5.0), bottomBtnHight)];
    [myView addSubview:subView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH*(3/5.0), 1)];
    lineView.backgroundColor = RGBA(0x00a7ff, 1);
    [subView addSubview:lineView];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, bottomBtnHight - 1, SCREENWIDTH*(3/5.0), 1)];
    lineView2.backgroundColor = RGBA(0x00a7ff, 1);
    [subView addSubview:lineView2];
    
    _detail = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, SCREENWIDTH*(3/5.0) -24, 21)];
    _detail.font = [UIFont systemFontOfSize:11];
    _detail.textColor = RGBA(0x7ac5ff, 1);
    [subView addSubview:_detail];
    
    _total = [[UILabel alloc]initWithFrame:CGRectMake(12, 26, SCREENWIDTH*(3/5.0) -24, 21)];
    _total.font = [UIFont systemFontOfSize:15];
    _total.textColor = RGBA(0x00a7ff, 1);
    [subView addSubview:_total];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH*(3/5.0), 0, SCREENWIDTH*(2/5.0), bottomBtnHight)];
    [btn setBackgroundImage:[UIImage imageNamed:@"home_button2"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"home_button2"] forState:UIControlStateHighlighted];
    [btn setTitle:@"去缴费" forState:UIControlStateNormal];
    [btn setTitleColor:RGBA(0xffffff, 1) forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [btn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:btn];
    
    [self.view addSubview:myView];
}
- (void)payBtnClick{
    if (_propertyFeePayData.status) {
        if ([propertyFeePayToTimeCell.rechargeAmount.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"请选择预存金额"];
            return;
        }
    }
    if ((_propertyFeePayData.status?0.00:_propertyFeePayData.arrearsPrice.floatValue)+ propertyFeePayToTimeCell.rechargeAmount.text.floatValue <0.01) {
        [MBProgressHUD showError:@"预存金额不能为0"];
        return;
    }
    payView = [[[NSBundle mainBundle] loadNibNamed:@"PayTypeChoseView" owner:self options:nil] lastObject];
    payView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 190);
    NSString * aStr = [NSString stringWithFormat:@"立即支付：%0.2f",(_propertyFeePayData.status?0.00:_propertyFeePayData.arrearsPrice.floatValue)+ propertyFeePayToTimeCell.rechargeAmount.text.floatValue];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",aStr] attributes:@{NSForegroundColorAttributeName:RGBA(0xffffff, 1)}];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0,4)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(5,str.length - 5)];

    [payView.payBtn setAttributedTitle:str forState:UIControlStateNormal];
    [payView.payBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [payView.payBtn setBackgroundImage:[UIImage imageNamed:@"home_button1_normal"] forState:UIControlStateNormal];
    [payView.payBtn setBackgroundImage:[UIImage imageNamed:@"home_button1_press"] forState:UIControlStateHighlighted];
    //设置蒙版
    coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha =0.5;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [coverView addGestureRecognizer:tap];
    //实现弹出方法
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.windowLevel =UIWindowLevelNormal;
    
    [window addSubview:coverView];
    [window addSubview:payView];
    [UIView animateWithDuration:0.3 animations:^{
        payView.frame = CGRectMake(0, SCREENHEIGHT - 190, SCREENWIDTH, 190);
    }];
    __weak typeof(payView) weakPayView = payView;

    payView.choseBtnBlock = ^(NSInteger integer) {
        if (integer == 1) {
            weakPayView.alyPayImg.image = [UIImage imageNamed:@"life_icon_unchoice"];
            weakPayView.banlancePayImg.image = [UIImage imageNamed:@"life_icon_choice"];
        }else if (integer == 2){
            weakPayView.alyPayImg.image = [UIImage imageNamed:@"life_icon_choice"];
            weakPayView.banlancePayImg.image = [UIImage imageNamed:@"life_icon_unchoice"];
        }
        payWay = integer;
    };
    passwordAlertView =[[PasswordAlertView alloc]initWithType:PasswordAlertViewType_sheet];
    passwordAlertView.delegate = self;
    passwordAlertView.moneyLable.text = [NSString stringWithFormat:@"¥%0.2f",(_propertyFeePayData.status?0.00:_propertyFeePayData.arrearsPrice.floatValue)+ propertyFeePayToTimeCell.rechargeAmount.text.floatValue];
    passwordAlertView.titleLable.text = @"输入支付密码";
    passwordAlertView.tipsLalbe.text = @"您输入的密码不正确！";
    __weak typeof(passwordAlertView) weakPasswordAlertView = passwordAlertView;
    WeakSelf
    payView.payBtnBlock = ^{
        StrongSelf
        if (payWay == 1) {
            if ([StorageUserInfromation storageUserInformation].payPasswordSet.integerValue == 1) {
                [weakPasswordAlertView show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"设置支付密码" message:@"为保障您的账户资金安全，请先设置支付密码" delegate:strongSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 100;
                [alert show];
            }
        }else{
            [strongSelf aliPay];
        }
    };
    __weak typeof(coverView) weakCoverView = coverView;
    payView.backBtnBlock = ^{
        [weakCoverView removeFromSuperview];
    };
}
- (void)tapClick:(UIGestureRecognizer *)gesture{
    [UIView animateWithDuration:0.3 animations:^{
        payView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 190);
    } completion:^(BOOL finished) {
        [payView removeFromSuperview];
        [gesture.view removeFromSuperview];
    }];
    
}
- (void)aliPay{
    [self pay];
}
- (void)pay{
    NSDictionary *dict = @{@"userId":[StorageUserInfromation storageUserInformation].userId,@"type":@"2",@"apiv":@"1.0",@"time":([propertyFeePayToTimeCell.time.text isEqualToString:@"点击选择时间"]?@"":[StorageUserInfromation timeStrFromDateString5:propertyFeePayToTimeCell.time.text]),@"propertyHouseId":_propertyHouseId,@"password":@""};
    [ZTHttpTool postWithUrl:@"property/v1/property/propertyPay" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary *dict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",dict);
        if ([dict[@"rcode"] integerValue] == 0) {
            [UIView animateWithDuration:0.3 animations:^{
                payView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 190);
            } completion:^(BOOL finished) {
                [payView removeFromSuperview];
                [coverView removeFromSuperview];
            }];
            [self aliPay:dict[@"form"]];
        }else{
            [MBProgressHUD showError:dict[@"msg"]];
        }
    } failure:^(NSError *error) {
        XMJLog(@"%@",error);
        [MBProgressHUD showError:@"网络异常"];
        
    }];
}
-(void)aliPay:(NSString *)payInfo{
    [MBProgressHUD hideHUD];
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:payInfo fromScheme:@"alisdkdemo" callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] integerValue] == 9000) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付成功" message:@"你可以在“我的”-“全部订单”中查看订单详情。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 10;
            [alert show];
            
        }else{
            [MBProgressHUD showError:@"支付失败！"];
        }
        NSLog(@"reslut = %@",resultDic);
    }];
}
#pragma mark password delegate
-(void)PasswordAlertViewCompleteInputWith:(NSString*)password{
    NSLog(@"完成了密码输入,密码为：%@",password);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = @{@"userId":[StorageUserInfromation storageUserInformation].userId,@"type":@"1",@"password":password,@"apiv":@"1.0",@"time": ([propertyFeePayToTimeCell.time.text isEqualToString:@"点击选择时间"]?@"":[StorageUserInfromation timeStrFromDateString5:propertyFeePayToTimeCell.time.text]),@"propertyHouseId":_propertyHouseId};
        [ZTHttpTool postWithUrl:@"property/v1/property/propertyPay" param:dict success:^(id responseObj) {
            NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
            NSDictionary *dict = [DictToJson dictionaryWithJsonString:str];
            NSLog(@"%@",dict);
            passwordAlertView.tipsLalbe.text = dict[@"msg"];
            if ([dict[@"rcode"] integerValue] == 0) {
                [passwordAlertView passwordCorrect];
                [UIView animateWithDuration:0.3 animations:^{
                    payView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 190);
                } completion:^(BOOL finished) {
                    [payView removeFromSuperview];
                    [coverView removeFromSuperview];
                }];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付成功" message:@"你可以在“我的”-“全部订单”中查看订单详情。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert.tag = 10;
                [alert show];
            }else{
                [passwordAlertView passwordError];
                [MBProgressHUD showError:dict[@"msg"]];
            }
        } failure:^(NSError *error) {
            XMJLog(@"%@",error);
            [MBProgressHUD showError:@"网络异常"];
            
        }];
    });
}

-(void)PasswordAlertViewDidClickCancleButton{
    NSLog(@"点击了取消按钮");
}


-(void)PasswordAlertViewDidClickForgetButton{
    NSLog(@"点击了忘记密码按钮");
    ModifyPaymentPasswordFirstStepViewController *controller = [[ModifyPaymentPasswordFirstStepViewController alloc]init];
//    controller.titleStr = @"设置支付密码";
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)datePickerInit{
    self.datePicker = [[HooDatePicker alloc] initWithSuperView:self.view];
    self.datePicker.delegate = self;
    self.datePicker.datePickerMode = HooDatePickerModeYearAndMonth;
    self.datePicker.title = @"请选择日期";

}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150 + (is_iPhone_X?24:0), SCREENWIDTH, SCREENHEIGHT - 150 - (is_iPhone_X?24:0) - bottomBtnHight) style:UITableViewStylePlain];
        _myTableView.backgroundColor = RGBA(0xeeeeee, 1);
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        // 手动添加下拉刷新
//        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//        [refreshControl addTarget:self action:@selector(refreshControlStateChange:) forControlEvents:UIControlEventValueChanged];
//        [_myTableView addSubview:refreshControl];
    }
    return _myTableView;
}
//- (void)refreshControlStateChange:(UIRefreshControl  *)refresh{
//    [refresh endRefreshing];
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifierCell = @"PropertyFeeArreargeTimeCell";
    PropertyFeeArreargeTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifierCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:indentifierCell owner:self options:nil] lastObject];
    }
    if (_propertyFeePayData.history.count) {
        PropertyFeePayHistory *dict = _propertyFeePayData.history[indexPath.row];
        cell.time.text = [StorageUserInfromation timeStrFromDateString4:dict.time];
        cell.price.text = [NSString stringWithFormat:@"¥%@",dict.price];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_propertyFeePayData) {
        if (_propertyFeePayData.status == 1) {
            return 2;
        }else{
            return 3;
        }
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        if (_propertyFeePayData.history) {
            return _propertyFeePayData.history.count;

        }else{
            return 0;
        }
        
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        PropertyPaymentHomeCell *myCell = [[[NSBundle mainBundle] loadNibNamed:@"PropertyPaymentHomeCell" owner:self options:nil] lastObject];
        if (_propertyFeePayData) {
            PropertyFeePayForm *dict = _propertyFeePayData;
            NSString * str = dict.headName;
            if (dict.headName.length == 2) {
                str = [dict.headName replaceStringWithAsterisk:1 length: dict.headName.length-1];
            }else if (dict.headName.length > 2){
                str = [dict.headName replaceStringWithAsterisk:1 length: dict.headName.length-2];
            }
            myCell.headName.text = str;
            myCell.tel.text = dict.headTelphone;
            myCell.propertyUnitName.text = [NSString stringWithFormat:@"单元：%@",dict.propertyUnitName] ;
            myCell.propertyFloorName.text = [NSString stringWithFormat:@"楼层：%@层",dict.propertyFloorName];
            myCell.propertyHouseName.text = [NSString stringWithFormat:@"户号：%@",dict.propertyHouseName];
            myCell.propertyBuildingName.text = [NSString stringWithFormat:@"楼栋：%@",dict.propertyBuildingName];
            myCell.address.text = dict.address;
            myCell.tips.text = dict.remarks;
        }
        return myCell;
    }else if (section == 1){
        if (flag == NO) {
            propertyFeePayToTimeCell.secondRowHight.constant = 0;
            propertyFeePayToTimeCell.secondRowView.hidden = YES;
        }else{
            propertyFeePayToTimeCell.secondRowHight.constant = 40;
            propertyFeePayToTimeCell.secondRowView.hidden = NO;
        }
        return propertyFeePayToTimeCell;
    }else if (section == 2){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
        UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 30)];
        labelOne.textColor = RGBA(0x9c9c9c, 1);
        labelOne.font = [UIFont systemFontOfSize:13.0];
        labelOne.text = @"欠费时间";
        
        UILabel *labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - (100+12), 0, 100, 30)];
        labelTwo.textColor = RGBA(0x9c9c9c, 1);
        labelTwo.font = [UIFont systemFontOfSize:13.0];
        labelTwo.textAlignment = NSTextAlignmentRight;
        labelTwo.text = @"金额明细";
        
        [view addSubview:labelOne];
        [view addSubview:labelTwo];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(12, 30-1, SCREENWIDTH - 12*2, 1)];
        lineView.backgroundColor = RGBA(0xeeeeee, 1);
        [view addSubview:lineView];
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 169;
    }else if (section == 1){
        return flag?120:80;
    }else if (section == 2){
        return 30;
    }
    return 0;
}
- (void)datePicker:(HooDatePicker *)datePicker didSelectedDate:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
//    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == HooDatePickerModeDate) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    } else if (datePicker.datePickerMode == HooDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else if (datePicker.datePickerMode == HooDatePickerModeYearAndMonth){
        [dateFormatter setDateFormat:@"yyyy年MM月"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    
    NSString *selectDate = [dateFormatter stringFromDate:date];
    NSLog(@"selectDate:%@",selectDate);
    
    propertyFeePayToTimeCell.time.text = selectDate;
    propertyFeePayToTimeCell.time.textColor = RGBA(0x303030, 1);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月";
    NSDate *date1 = [formatter dateFromString:[StorageUserInfromation timeStrFromDateString4:_propertyFeePayData.time]];
    NSDate *date2 = [formatter dateFromString:selectDate];
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    NSInteger num = cmps.year *12 + cmps.month;
    
    propertyFeePayToTimeCell.rechargeAmount.text = [NSString stringWithFormat:@"%0.2f",_propertyFeePayData.price.floatValue *num];
    _detail.text = [NSString stringWithFormat:@"欠费%@+预存%@",_propertyFeePayData.status?@"0.00":_propertyFeePayData.arrearsPrice,propertyFeePayToTimeCell.rechargeAmount.text];
    _total.text = [NSString stringWithFormat:@"合计缴费：%0.2f",(_propertyFeePayData.status?0.00:_propertyFeePayData.arrearsPrice.floatValue)+ _propertyFeePayData.price.floatValue *num];
    flag = YES;
    [self.myTableView reloadData];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (alertView.tag == 100){
        if (buttonIndex == 1) {
            ModifyPaymentPasswordFirstStepViewController *controller = [[ModifyPaymentPasswordFirstStepViewController alloc]init];
            controller.titleStr = @"设置支付密码";
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
