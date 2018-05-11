//
//  WallentVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/1.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "WallentVC.h"
#import "MyPageCell.h"
#import "BillingInquiriesVC.h"
#import "BalanceRechargeViewController.h"
#import "BalanceDetailVC.h"
#import "ModifyPaymentPasswordFirstStepViewController.h"
#import "TicketCenterViewController.h"
@interface WallentVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) UIImageView *headerBackguandImg;
@property (nonatomic,strong) UILabel *balance;
@property (nonatomic,strong) UILabel *voucher;

@end

@implementation WallentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self.view addSubview:self.myTableView];
    self.balance.text = [NSString stringWithFormat:@"%0.2f",[StorageUserInfromation storageUserInformation].accountBalance.floatValue];
    self.voucher.text = @"2";
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.balance.text = [NSString stringWithFormat:@"%0.2f",[StorageUserInfromation storageUserInformation].accountBalance.floatValue];
    [self fetchData];
}
- (void)fetchData{
    NSDictionary *dict = @{@"userId":[StorageUserInfromation storageUserInformation].userId,@"apiv":@"1.0"};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/balance/mywallet" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary *dict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",dict);
        if ([dict[@"rcode"] integerValue] == 0) {
            self.balance.text = [NSString stringWithFormat:@"%0.2f",[dict[@"form"][@"balance"] doubleValue]];
            StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
            storage.accountBalance = self.balance.text;
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
            
            [NSKeyedArchiver archiveRootObject:storage toFile:file];
            
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)setNav{
    [self.view addSubview:self.headerBackguandImg];
    self.isShowNav = YES;
    self.titleLabel.text = @"我的钱包";
    self.titleLabel.textColor = RGBA(0xffffff, 1);
    self.navView.backgroundColor = [UIColor clearColor];
    self.lineView.hidden = YES;
    _backButton.hidden = NO;
    [_backButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    [self addSubView];
}
- (void)addSubView{
    for (int i = 0; i<1; i++) {
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(i*SCREENWIDTH/2.0,NAVHEIGHT, SCREENWIDTH, 86)];
        if (i == 0) {
            [myView addSubview:self.balance];
        }else{
            [myView addSubview:self.voucher];
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGBA(0xffffff, 1);
        label.font = [UIFont systemFontOfSize:15.0];
        label.text = @[@"余额(元)",@"优惠券(张)"][i];
        [myView addSubview:label];
        [self.view addSubview:myView];
    }
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + 150 - 64, SCREENWIDTH, SCREENHEIGHT - (NAVHEIGHT + 150 - 64)) style:UITableViewStylePlain];
        _myTableView.backgroundColor = RGBA(0xeeeeee, 1);
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}
- (UIImageView *)headerBackguandImg{
    if (!_headerBackguandImg) {
        _headerBackguandImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT - 64 + 150)];
        _headerBackguandImg.image = [UIImage imageNamed:@"my_bg2"];
    }
    return _headerBackguandImg;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = @"MyPageCell";
    MyPageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifierCell owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        NSString *nameStr = @[@"my_icon_list",@"my_icon_recharge",@"my_icon_detail"][indexPath.row];
        cell.icon.image = [UIImage imageNamed:nameStr];
        cell.name.text = @[@"账单查询",@"余额充值",@"余额明细"][indexPath.row];
    }else if (indexPath.section == 1){
        cell.icon.image = [UIImage imageNamed:@"my_icon_payword"];
        cell.name.text = @"支付密码设置";
    }else if (indexPath.section == 2){
        cell.icon.image = [UIImage imageNamed:@"my_icon_ticket"];
        cell.name.text = @"查看优惠券";
    }
//    cell.icon.image = [UIImage imageNamed:iconArr[indexPath.row]];
//    cell.name.text = nameArr[indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 1;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    footerView.backgroundColor = RGBA(0xeeeeee, 1);
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BillingInquiriesVC *page = [[BillingInquiriesVC alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }else if (indexPath.row == 1){
            BalanceRechargeViewController  *page = [[BalanceRechargeViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }else if (indexPath.row == 2){
            BalanceDetailVC *page = [[BalanceDetailVC alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            ModifyPaymentPasswordFirstStepViewController *page = [[ModifyPaymentPasswordFirstStepViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            TicketCenterViewController *page = [[TicketCenterViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }
    }
}
- (UILabel *)balance{
    if (!_balance) {
        _balance = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
        _balance.font = [UIFont systemFontOfSize:30.0];
        _balance.textColor = RGBA(0xffffff, 1);
        _balance.textAlignment = NSTextAlignmentCenter;
    }
    return _balance;
}
- (UILabel *)voucher{
    if (!_voucher) {
        _voucher = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH/2.0, 40)];
        _voucher.font = [UIFont systemFontOfSize:30.0];
        _voucher.textColor = RGBA(0xffffff, 1);
        _voucher.textAlignment = NSTextAlignmentCenter;
    }
    return _voucher;
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
