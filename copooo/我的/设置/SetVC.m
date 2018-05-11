//
//  SetVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/2.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "SetVC.h"
#import "SetCell.h"
#import "PersonalInformationViewController.h"
#import "ModifyLoginPasswordFirstStepViewController.h"
#import "ModifyPaymentPasswordFirstStepViewController.h"
#import "MyWebVC.h"
#import "AboutViewController.h"
#import "MessagePushSetUpVC.h"
#import "FeedBackVC.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "CommunityJSVC.h"
#import "JPUSHService.h"
@interface SetVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,strong) UITableView *myTableView;
@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self addBottomBtn];
    [self.view addSubview:self.myTableView];
    // Do any additional setup after loading the view.
}
- (void)setNav{
    self.isShowNav = YES;
    _backButton.hidden = NO;
    self.titleLabel.text = @"设置";
    
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - 200 - NAVHEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}
- (void)addBottomBtn{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12, SCREENHEIGHT - 100 + 20, SCREENWIDTH - 12*2, 40)];
    [btn setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    [btn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    btn.layer.cornerRadius = 10.0;
    btn.layer.borderColor = RGBA(0x00a7ff, 1).CGColor;
    btn.layer.borderWidth = 1;
    [btn addTarget:self action:@selector(loadingOffBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)loadingOffBtn{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定退出登录？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        } seq:0];
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//        [self.navigationController pushViewController:controller animated:YES];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:controller];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifierCell = @"SetCell";
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifierCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:indentifierCell owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.typeName.text = @[@"个人资料设置",@"登录密码设置",@"支付密码设置"][indexPath.row];
    }
//    else if (indexPath.section == 1){
//        cell.typeName.text = @"消息推送设置";
//    }
    else if (indexPath.section == 1){
        cell.typeName.text = @[@"意见反馈",@"协议与隐私",@"关于"][indexPath.row];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 3;
    }else{
        return 3;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    myView.backgroundColor = RGBA(0xeeeeee, 1);
    return myView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PersonalInformationViewController *page = [[PersonalInformationViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }else if (indexPath.row == 1){
            ModifyLoginPasswordFirstStepViewController *page = [[ModifyLoginPasswordFirstStepViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }else if (indexPath.row == 2){
            ModifyPaymentPasswordFirstStepViewController *page = [[ModifyPaymentPasswordFirstStepViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }
    }
//    else if (indexPath.section == 1){
//        if (indexPath.row == 0) {
//            MessagePushSetUpVC *page = [[MessagePushSetUpVC alloc]init];
//            [self.navigationController pushViewController:page animated:YES];
//        }
//    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            FeedBackVC *page = [[FeedBackVC alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }else if (indexPath.row == 1){
             CommunityJSVC *page = [[CommunityJSVC alloc]init];
//            page.isShowNav = YES;
//            page.leftImgName = @"icon_back_gray";
            page.titleStr = @"协议及隐私";
            page.url = [NSString stringWithFormat:@"%@%@", BASE_URL2,@"/jujiaheDocument/jujiaheuser/privacy.html"];
            [self.navigationController pushViewController:page animated:YES];
        }else if (indexPath.row == 2){
            AboutViewController *page = [[AboutViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
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
