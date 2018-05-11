//
//  LoginViewController.m
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/16.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "LoginViewController.h"
#import "BaseTabbarVC.h"
#import "registDataModle.h"
#import "AppDelegate.h"
#import "RegestViewController.h"
#import "ResetPasswordViewController.h"
#import "JFCityViewController.h"
#import "JPUSHService.h"
@interface LoginViewController ()
{
    BOOL flag;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden = YES;
//    self.backView.layer.cornerRadius = 5;
//    self.backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1].CGColor;
//    self.backView.layer.borderWidth = 2;
    self.loginBtn.layer.cornerRadius = 5;
    self.logoToCenter.constant = SCREENHEIGHT/2.0 - 250;
    self.btnHeightConstraint.constant = (SCREENWIDTH -40)*1/8.0;
    UIView *userNameLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
    UIImageView *usewrNameLeftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 20, 22)];
    usewrNameLeftImgView.image = [UIImage imageNamed:@"name"];
    [userNameLeftView addSubview:usewrNameLeftImgView];
    self.userName.leftView = userNameLeftView;//[[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.userName.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *passwordLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
    UIImageView *passwordLeftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 14, 16, 22)];
    passwordLeftImgView.image = [UIImage imageNamed:@"secret"];
    [passwordLeftView addSubview:passwordLeftImgView];
    self.password.leftView = passwordLeftView;//[[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.password.leftViewMode = UITextFieldViewModeAlways;
    self.password.secureTextEntry = YES;
    
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"button1_normal"] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"button1_press"] forState:UIControlStateHighlighted];
    self.btnHeightConstraint.constant = (SCREENWIDTH -40)*1/8.0;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userName.text = [defaults valueForKey:@"username"]?[defaults valueForKey:@"username"]:@"";
    self.password.text = [defaults valueForKey:@"password"]?[defaults valueForKey:@"password"]:@"";
    
    
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    storage.userId = @"";
    storage.access_token = @"";
    storage.uuid = @"";
    storage.choseUnitPropertyId = @"";
    storage.nickname = @"";
    storage.token = @"123456";
    storage.sex = @"-1";
    storage.socialUnread = @"0";
    storage.systemUnread = @"0";
    storage.countShippingSend = @"0";
    storage.countShipping = @"0";
    storage.countPaying = @"0";
    [NSKeyedArchiver archiveRootObject:storage toFile:file];
    if (is_iPhone_X) {
        _backBtnToTop.constant = 20 +24;
    }
    flag = YES;
    if (!([self.userName.text isEqual:@""]|[self.password.text isEqual:@""])&&![StorageUserInfromation storageUserInformation].token) {
 //       [self homePageBtnClick:nil];
    }
//    if (!_backBtnFlag) {
//        _backBtn.hidden = YES;
//    }
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)homePageBtnClick:(id)sender {
//    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
//    storage.token = @"123456";
//    storage.userId = @"123456";
//
//    [self login];
//    return;
    if ([JGIsBlankString isBlankString:self.userName.text]) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }
    if (![StorageUserInfromation valiMobile:self.userName.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号码"];
        return;
    }
    if ([JGIsBlankString isBlankString:self.password.text]) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    if ([self.password.text length]<6) {
        [MBProgressHUD showError:@"密码长度不足6位"];
        return;
    }
    if ([self.password.text length]>20) {
        [MBProgressHUD showError:@"请输入20位或以下密码"];
        return;
    }
    if (![StorageUserInfromation judgePassWordLegal:self.password.text]) {
        [MBProgressHUD showError:@"密码只能包含可见字符"];
        return;
    }
    [MBProgressHUD showMessage:@"登录中..."];
     [self getToken];

}
#pragma mark 获取token
- (void)getToken{
    NSDictionary *dict = @{@"username":self.userName.text,@"password":self.password.text,@"grant_type":@"password"};
    [ZTHttpTool postWithUrl:@"uaa/oauth/token" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary *onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([onceDict[@"rcode"] integerValue] == 0) {
            StorageUserInfromation *storge = [StorageUserInfromation storageUserInformation];
            storge.access_token = onceDict[@"form"][@"access_token"];
            storge.refresh_token = onceDict[@"form"][@"refresh_token"];
            storge.expires_in = onceDict[@"form"][@"expires_in"];
            storge.uuid = onceDict[@"form"][@"uuid"];
            storge.userId = onceDict[@"form"][@"user_id"];
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
            [NSKeyedArchiver archiveRootObject:storge toFile:file];
            [self loading];
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:onceDict[@"msg"]];
        }
       
    } failure:^(NSError *error) {
//        NSLog(@"%ld,%@",error.code,[error.userInfo[@"NSLocalizedDescription"] containsObject:@"400"]);
        [MBProgressHUD hideHUD];
        NSString * str = error.userInfo[@"NSLocalizedDescription"];
        
        if ([str containsString:@"400"]) {
            [MBProgressHUD showError:@"用户名或密码错误"];
        }else{
            [MBProgressHUD showError:@"网络不给力，请检测您的网络设置"];
        }
    }];
}

#pragma mark 登录
- (void)loading{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"username":self.userName.text,@"password":self.password.text,@"device":@"1"};
    [ZTHttpTool postWithUrl:@"uaa/v1/user" param:dict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        registDataModle *user = [registDataModle yy_modelWithJSON:str];
        StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
        if (user.rcode == 0) {
            storage.email = user.form.email;
            storage.nickname = user.form.nickname;
            storage.token = @"";
            storage.username = user.form.username;
            storage.sessionId = user.form.sessionId;
            storage.accountBalance =  [NSString stringWithFormat:@"%.2f",user.form.accountBalance.floatValue];
            storage.point = user.form.point;
            storage.sex = user.form.sex;
            storage.birthday = user.form.birthday;
            storage.invitationCode = user.form.invitationCode;
            storage.invitationLink = user.form.invitationLink;
            storage.payPasswordSet = user.form.payPasswordSet;
            storage.socialUnread = user.form.socialUnread;
            storage.systemUnread = user.form.systemUnread;
            storage.countShippingSend = user.form.countShippingSend;
            storage.countShipping = user.form.countShipping;
            storage.countPaying = user.form.countPaying;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([storage.userId isEqualToString:user.form.userId] && (![JGIsBlankString isBlankString: storage.choseUnitPropertyId])) {
                storage.userId = user.form.userId;
                [NSKeyedArchiver archiveRootObject:storage toFile:file];

                [defaults setObject:self.userName.text forKey:@"username"];
                if (flag) {
                    [defaults setObject:self.password.text forKey:@"password"];
                    
                }else{
                    [defaults setObject:@"" forKey:@"password"];
                    
                }
                [self login];
            }else{
                storage.userId = user.form.userId;
                [NSKeyedArchiver archiveRootObject:storage toFile:file];
                [defaults setObject:self.userName.text forKey:@"username"];
                if (flag) {
                    [defaults setObject:self.password.text forKey:@"password"];
                    
                }else{
                    [defaults setObject:@"" forKey:@"password"];
                    
                }
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:nil forKey:@"roomNo"];
                [self cityChose];
            }
//            [MBProgressHUD showSuccess:@"登录成功"];
        }else{
            [MBProgressHUD showError:user.msg];

        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];

        if (error.code == 400) {
            [MBProgressHUD showError:@"用户名或密码错误"];
        }else{
            [MBProgressHUD showError:@"网络不给力，请检测您的网络设置"];
        }
        
    }];

}
     
- (IBAction)regestBtnClick:(id)sender {
    RegestViewController * page = [[RegestViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}

- (IBAction)forgetPassword:(id)sender {
    ResetPasswordViewController * page = [[ResetPasswordViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
-(void)login{
    //用于绑定Alias的  使用NSString 即可
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    [JPUSHService setAlias:storage.userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
    } seq:0];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:nil forKey:@"roomNo"];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BaseTabbarVC *tabBarController = [BaseTabbarVC Shareinstance];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tabBarController];
    nav.fd_fullscreenPopGestureRecognizer.enabled = true;
    nav.fd_prefersNavigationBarHidden = true;
    nav.fd_interactivePopDisabled = true;
    nav.fd_viewControllerBasedNavigationBarAppearanceEnabled = false;
    [nav setNavigationBarHidden:YES animated:YES];
    tabBarController.selectedIndex = 0;
    delegate.window.rootViewController = nav;
   
    NSLog(@"%d %s",__LINE__,__PRETTY_FUNCTION__);
}
- (void)cityChose{
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];

    [JPUSHService setAlias:storage.userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
    } seq:0];
    JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
    cityViewController.title = @"选择城市";
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:cityViewController];
    
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    
    NSLog(@"TagsAlias回调:%@", callbackString);
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


- (IBAction)rememberPassword:(id)sender {
    
    if (flag) {
        [self.rememberPassword setImage:[UIImage imageNamed:@"login_unchoice"] forState:UIControlStateNormal];
    }else{
        [self.rememberPassword setImage:[UIImage imageNamed:@"login_choice"] forState:UIControlStateNormal];
    }
    flag = !flag;
}
- (IBAction)thridPartBtnClcik:(id)sender {
}
- (IBAction)backBtnClick:(id)sender {
    JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
    cityViewController.title = @"选择城市";
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:cityViewController];
}
@end
