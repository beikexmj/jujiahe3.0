//
//  ModifyLoginPasswordFirstStepViewController.m
//  copooo
//
//  Created by 夏明江 on 16/9/5.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "ModifyLoginPasswordFirstStepViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
//#import "JPUSHService.h"
@interface ModifyLoginPasswordFirstStepViewController ()<UIAlertViewDelegate>

@end

@implementation ModifyLoginPasswordFirstStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+24;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    self.comfirmBtn.layer.cornerRadius = 5;
    [self.comfirmBtn setBackgroundImage:[UIImage imageNamed:@"button1_normal"] forState:UIControlStateNormal];
    [self.comfirmBtn setBackgroundImage:[UIImage imageNamed:@"button1_press"] forState:UIControlStateHighlighted];
    self.btnHeightConstraint.constant = (SCREENWIDTH -20)*1/8.0;
//    self.phoneView.layer.cornerRadius = 5;
//    self.phoneView.layer.masksToBounds = YES;
//    self.identifyingCode.layer.cornerRadius = 5;
    self.identifyingCode.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.identifyingCode.leftViewMode = UITextFieldViewModeAlways;
    
//    self.password.layer.cornerRadius = 5;
    self.password.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.password.leftViewMode = UITextFieldViewModeAlways;
    self.password.secureTextEntry = YES;
    StorageUserInfromation * storage =[StorageUserInfromation storageUserInformation];
    self.phoneNum.text = [NSString stringWithFormat:@"%@****%@",[storage.username substringToIndex:3],[storage.username substringFromIndex:7]];
    
    
    [_identifyingCodeBtn addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view from its nib.
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
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
- (IBAction)getIdentifyingCodeBtnClick:(id)sender {
//    if ([JGIsBlankString isBlankString:self.phoneNum.text]) {
//        [MBProgressHUD showError:@"请输入注册手机号"];
//        return;
//    }
//    if (![StorageUserInfromation valiMobile:self.phoneNum.text]) {
//        [MBProgressHUD showError:@"请输入正确手机号"];
//        return;
//    }
    StorageUserInfromation * storage =[StorageUserInfromation storageUserInformation];

    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"username":storage.username,@"device":@"1",@"aim":@""};
    [ZTHttpTool postWithUrl:@"uaa/v1/getSmscode" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD showSuccess:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] ==0) {
//            self.identifyingCode.text = [DictToJson dictionaryWithJsonString:str][@"form"][@"smscode"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
- (IBAction)comfirmBtnClick:(id)sender {
    if ([JGIsBlankString isBlankString:self.identifyingCode.text]) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    if ([JGIsBlankString isBlankString:self.password.text]) {
        [MBProgressHUD showError:@"请输入新的密码"];
        return;
    }
    if ([self.password.text length]<6) {
        [MBProgressHUD showError:@"请输入6位或以上密码"];
        return;
    }
    for(int i=0; i< [self.password.text length];i++){
        int a = [self.password.text characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            [MBProgressHUD showError:@"密码不能包含中文"];
            return;
        }
        
    }
    StorageUserInfromation * storage =[StorageUserInfromation storageUserInformation];
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"password":self.password.text,@"passwordType":@"0",@"username":storage.username,@"smscode":self.identifyingCode.text,@"device":@"1"};
    [ZTHttpTool postWithUrl:@"uaa/v1/resetPassword" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD showSuccess:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue]==0) {
            [self login];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
   
}
-(void)login{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"修改登录密码成功" message:@"App将跳回登录界面" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"username"];
    [defaults setObject:@"" forKey:@"password"];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
}
-(void)startTime{
//    if ([JGIsBlankString isBlankString:self.phoneNum.text]) {
//        return;
//    }
//    if (![StorageUserInfromation valiMobile:self.phoneNum.text]) {
//        return;
//    }
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_identifyingCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                _identifyingCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_identifyingCodeBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _identifyingCodeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
