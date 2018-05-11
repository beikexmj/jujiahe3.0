//
//  ModifyEmailViewController.m
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "ModifyEmailViewController.h"

@interface ModifyEmailViewController ()

@end

@implementation ModifyEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+24;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    self.identifyingCode.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.identifyingCode.leftViewMode = UITextFieldViewModeAlways;
    [self.comfirmBtn setBackgroundImage:[UIImage imageNamed:@"button1_press"] forState:UIControlStateNormal];
    [self.comfirmBtn setBackgroundImage:[UIImage imageNamed:@"button1_normal"] forState:UIControlStateHighlighted];
    self.btnHeightConstraint.constant = (SCREENWIDTH -20)*1/8.0;
//    self.emailView.layer.cornerRadius = 5;
//    self.emailView.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)comfirmBtnClick:(id)sender {
    if ([JGIsBlankString isBlankString:self.emailAdress.text]) {
        [MBProgressHUD showError:@"请输入新的邮箱"];
        return;
    }
    if (![StorageUserInfromation isValidateEmail:self.emailAdress.text]) {
        [MBProgressHUD showError:@"请输入正确的邮箱"];
        return;
    }
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"passwordType":@"1",@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"email":self.emailAdress.text};
    [ZTHttpTool postWithUrl:@"uaa/v1/modify" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD showSuccess:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] == 0) {
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
            StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
            storage.email = self.emailAdress.text;
            [NSKeyedArchiver archiveRootObject:storage toFile:file];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    

}

- (IBAction)getIndentidfyCodeBtnClick:(id)sender {
    
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
