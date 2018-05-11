//
//  MyPageVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/15.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "MyPageVC.h"
#import "XMJButton.h"
#import "MyPageCell.h"
#import "JSBadgeView.h"
#import "PersonalInformationViewController.h"
#import "WallentVC.h"
#import "MyIntegralVC.h"
#import "InvitedRegistrationViewController.h"
#import "SetVC.h"
#import "MyQRCodeViewController.h"
#import "MessageCenterVC.h"
#import "AppDelegate.h"
#import "BaseTabbarVC.h"
#import "LoginViewController.h"
#import "UIView+Extensions.h"
#import "CommunityJSVC.h"
#import "LifeJSVC.h"
#import "registDataModle.h"
@interface MyPageVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIAlertViewDelegate>
{
    NSArray *iconArr;
    NSArray *nameArr;
    JSBadgeView *_badgeView1;
    JSBadgeView *_badgeView2;
    JSBadgeView *_badgeView3;
    JSBadgeView *_badgeView4;
    UIView *meaasgeFlagView;


}
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)UIImageView *headerBackguandImg;
@property (nonatomic,strong)UIImageView *headerIcon;
@property (nonatomic,strong)UIButton *nicknameBtn;
@property (nonatomic,strong)UIButton *rePayBtn;
@property (nonatomic,strong)UIButton *reTakeOverBtn;
@property (nonatomic,strong)UIButton *customerServiceBtn;
@property (nonatomic,strong)UIButton *allOrderBtn;
@property (nonatomic,strong)UIButton *QRBtn;
@end

@implementation MyPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    iconArr = [NSArray arrayWithObjects:@"my_icon_integral",@"my_icon_wallet",@"my_icon_post",@"my_icon_set", nil];
    nameArr = [NSArray arrayWithObjects:@"合币",@"钱包",@"我的发帖",@"设置", nil];
    [self.view addSubview:self.myTableView];
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    _badgeView1.badgeText = [storage.countPaying isEqualToString:@"0"]?@"":storage.countPaying;
    _badgeView2.badgeText = [storage.countShipping isEqualToString:@"0"]?@"":storage.countShipping;
    _badgeView3.badgeText = [storage.countShippingSend isEqualToString:@"0"]?@"":storage.countShippingSend;
    
    meaasgeFlagView  = [[UIView alloc]initWithFrame:CGRectMake(31, 12, 7, 7)];
    meaasgeFlagView.layer.cornerRadius = 7/2.0;
    meaasgeFlagView.backgroundColor =RGBA(0xfe4b20, 1);
    [self.rightButton addSubview:meaasgeFlagView];
    
    _headerIcon.image = [UIImage imageNamed:@"默认头像60x60"];
    [self reSetHeaderIcon];
    if ([StorageUserInfromation storageUserInformation].sex.integerValue == 0) {
        [_nicknameBtn setImage:[UIImage imageNamed:@"com_icon_man"] forState:UIControlStateNormal];
    }else if ([StorageUserInfromation storageUserInformation].sex.integerValue == 1){
        [_nicknameBtn setImage:[UIImage imageNamed:@"com_icon_woman"] forState:UIControlStateNormal];

    }else{
        [_nicknameBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

    }
    [_nicknameBtn setTitle:[NSString stringWithFormat:@" %@",[StorageUserInfromation storageUserInformation].nickname?[StorageUserInfromation storageUserInformation].nickname:@""
                            ] forState:UIControlStateNormal];
//    _badgeView4 = [[JSBadgeView alloc] initWithParentView:self.rightButton alignment:JSBadgeViewAlignmentCenterRight];
    NSInteger num = storage.socialUnread.integerValue + storage.systemUnread.integerValue;
    if (num) {
        meaasgeFlagView.hidden = NO;
    }else{
        meaasgeFlagView.hidden = YES;
    }
//    _badgeView4.badgeText = num == 0?@"":[NSString stringWithFormat:@"%ld",num];
    if(![[StorageUserInfromation storageUserInformation].userId isEqualToString:@""]){
        [self fetchData];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replaceHeaderImg) name:@"ReplaceHeaderImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replaceSex) name:@"ReplaceSex" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyNickname) name:@"ModifyNickname" object:nil];

    // Do any additional setup after loading the view.
}
- (void)freshInterface{
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    _badgeView1.badgeText = [storage.countPaying isEqualToString:@"0"]?@"":storage.countPaying;
    _badgeView2.badgeText = [storage.countShipping isEqualToString:@"0"]?@"":storage.countShipping;
    _badgeView3.badgeText = [storage.countShippingSend isEqualToString:@"0"]?@"":storage.countShippingSend;
    NSInteger num = storage.socialUnread.integerValue + storage.systemUnread.integerValue;
//    _badgeView4.badgeText = num == 0?@"":[NSString stringWithFormat:@"%ld",num];
    if (num) {
        meaasgeFlagView.hidden = NO;
    }else{
        meaasgeFlagView.hidden = YES;
    }
    [_nicknameBtn setTitle:[NSString stringWithFormat:@" %@",[StorageUserInfromation storageUserInformation].nickname] forState:UIControlStateNormal];
    if ([StorageUserInfromation storageUserInformation].sex.integerValue == 0) {
        [_nicknameBtn setImage:[UIImage imageNamed:@"com_icon_man"] forState:UIControlStateNormal];
    }else if ([StorageUserInfromation storageUserInformation].sex.integerValue == 1){
        [_nicknameBtn setImage:[UIImage imageNamed:@"com_icon_woman"] forState:UIControlStateNormal];
        
    }else{
        [_nicknameBtn setImage:[UIImage imageNamed:@"com_icon_woman"] forState:UIControlStateNormal];

    }
    [self reSetHeaderIcon];
    [self fetchUnreadMessageCount];
    [self fetchUnreadGoodsMessageCount];

}
- (void)fetchUnreadMessageCount{
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/userInfo/unreadMessageCount" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([onceDict[@"rcode"] integerValue] == 0) {
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
            StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
            storage.socialUnread = [NSString stringWithFormat:@"%ld",[onceDict[@"form"][@"socialUnread"] integerValue]];
            storage.systemUnread = [NSString stringWithFormat:@"%ld",[onceDict[@"form"][@"systemUnread"] integerValue] ];
            [NSKeyedArchiver archiveRootObject:storage toFile:file];
            NSInteger num = storage.socialUnread.integerValue + storage.systemUnread.integerValue;
//            _badgeView4.badgeText = (num == 0?@"":[NSString stringWithFormat:@"%ld",num]);
            if (num) {
                meaasgeFlagView.hidden = NO;
            }else{
                meaasgeFlagView.hidden = YES;
            }
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
- (void)fetchUnreadGoodsMessageCount{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"apiv":@"1.0",@"device":@"1"};
    [ZTHttpTool postWithUrl:@"uaa/v1/user" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        registDataModle *user = [registDataModle mj_objectWithKeyValues:str];
        StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
        if (user.rcode == 0) {
            storage.email = user.form.email;
            storage.nickname = user.form.nickname;
            storage.token = @"123456";
            storage.username = user.form.username;
            storage.sessionId = user.form.sessionId;
            storage.accountBalance =  [NSString stringWithFormat:@"%.2f",user.form.accountBalance.floatValue];
            storage.point = user.form.point;
            storage.sex = user.form.sex;
            storage.invitationCode = user.form.invitationCode;
            storage.invitationLink = user.form.invitationLink;
            storage.payPasswordSet = user.form.payPasswordSet;
            storage.socialUnread = user.form.socialUnread;
            storage.systemUnread = user.form.systemUnread;
            storage.countShippingSend = user.form.countShippingSend;
            storage.countShipping = user.form.countShipping;
            storage.countPaying = user.form.countPaying;
            storage.userId = user.form.userId;
            [NSKeyedArchiver archiveRootObject:storage toFile:file];
            
            _badgeView1.badgeText = [storage.countPaying isEqualToString:@"0"]?@"":storage.countPaying;
            _badgeView2.badgeText = [storage.countShipping isEqualToString:@"0"]?@"":storage.countShipping;
            _badgeView3.badgeText = [storage.countShippingSend isEqualToString:@"0"]?@"":storage.countShippingSend;
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    NSInteger num = storage.socialUnread.integerValue + storage.systemUnread.integerValue;
    //    _badgeView4.badgeText = num == 0?@"":[NSString stringWithFormat:@"%ld",num];
    if (num) {
        meaasgeFlagView.hidden = NO;
    }else{
        meaasgeFlagView.hidden = YES;
    }
 
}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//}
- (void)reSetHeaderIcon{
    NSString * str = [NSString stringWithFormat:@"%@/%@%@",BASE_URL,@"uaa/v1/getAvatar?userId=",[StorageUserInfromation storageUserInformation].userId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str] options:NSDataReadingUncached error:nil];
        if (data.length) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _headerIcon.image = [UIImage imageWithData:data];
            });
        }
    });
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([[StorageUserInfromation storageUserInformation].userId isEqualToString:@""]){
        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"未登录" message:@"确定跳回登录界面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
- (void)fetchData{
    [self freshInterface];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        self.tabBarController.selectedIndex = 0;
    }else{
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:controller];

    }
}
- (void)setNav{
    [self.view addSubview:self.headerBackguandImg];
    self.isShowNav = YES;
    self.navView.backgroundColor = [UIColor clearColor];
    self.lineView.hidden = YES;
    self.rightImgName = @"my_icon_massage";
    [self.view addSubview:self.headerIcon];
    [self.view addSubview:self.nicknameBtn];
//    [self.view addSubview:self.QRBtn];
}
- (void)rightButtonClick:(UIButton *)button{
    [MobClick event:@"pcxx_c"];
    MessageCenterVC *page = [[MessageCenterVC alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}

//获取当前时间戳有两种方法(以秒为单位)
- (NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%0.0lf", [datenow timeIntervalSince1970]];
    XMJLog(@"%@",timeSp);
    return timeSp;
    
}
- (void)QRBtnClick{
    [MobClick event:@"pcewm_c"];
    MyQRCodeViewController *page = [[MyQRCodeViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
- (UIButton *)QRBtn{
    if (!_QRBtn) {
        _QRBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 40 - 44, NAVHEIGHT - 44, 50, 44)];
        [_QRBtn setImage:[UIImage imageNamed:@"my_icon_二维码2"] forState:UIControlStateNormal];
        [_QRBtn addTarget:self action:@selector(QRBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _QRBtn;
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + 130 - 64, SCREENWIDTH, SCREENHEIGHT - 130 - TABBARHEIGHT) style:UITableViewStylePlain];
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        // 手动添加下拉刷新
//        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//        refreshControl.tintColor = RGBA(0xffffff, 1);
//        [refreshControl addTarget:self action:@selector(refreshControlStateChange:) forControlEvents:UIControlEventValueChanged];
//        [_myTableView addSubview:refreshControl];
        [self addTableHeaderView];
    }
    return _myTableView;
}
- (void)refreshControlStateChange:(UIRefreshControl  *)refresh{
    [refresh endRefreshing];
}
- (void)addTableHeaderView{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 130)];
    myView.backgroundColor = [UIColor clearColor];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    backImageView.image = [UIImage imageNamed:@"白色凹形背景"];
    [myView addSubview:backImageView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREENWIDTH, 10)];
    lineView.backgroundColor = RGBA(0xeeeeee, 1);
    [myView addSubview:lineView];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(3*(SCREENWIDTH - 15)/4.0, 45, 1, 50)];
    lineView2.backgroundColor = RGBA(0xeeeeee, 1);
    [myView addSubview:lineView2];

    [myView addSubview:self.rePayBtn];
    [myView addSubview:self.reTakeOverBtn];
    [myView addSubview:self.customerServiceBtn];
    [myView addSubview:self.allOrderBtn];

    _badgeView1 = [[JSBadgeView alloc] initWithParentView:_rePayBtn alignment:JSBadgeViewAlignmentTopRight];
    _badgeView2 = [[JSBadgeView alloc] initWithParentView:_reTakeOverBtn alignment:JSBadgeViewAlignmentTopRight];
    _badgeView3 = [[JSBadgeView alloc] initWithParentView:_customerServiceBtn alignment:JSBadgeViewAlignmentTopRight];

    _myTableView.tableHeaderView = myView;
}
- (UIImageView *)headerBackguandImg{
    if (!_headerBackguandImg) {
        _headerBackguandImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT - 64 + 150)];
        _headerBackguandImg.image = [UIImage imageNamed:@"my_bg2"];
    }
    return _headerBackguandImg;
}
- (UIImageView *)headerIcon{
    if (!_headerIcon) {
        _headerIcon = [[UIImageView alloc]initWithFrame:CGRectMake(12, NAVHEIGHT, 60, 60)];
        _headerIcon.layer.cornerRadius = 30;
        _headerIcon.layer.masksToBounds = YES;
        _headerIcon.userInteractionEnabled = YES;
        _headerIcon.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerIconTapClick:)];
        [_headerIcon addGestureRecognizer:tap];
    }
    return _headerIcon;
}
- (UIButton *)nicknameBtn{
    if (!_nicknameBtn) {
        _nicknameBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, NAVHEIGHT + 30 - 15, SCREENWIDTH - 80, 30)];
        [_nicknameBtn setTitleColor:RGBA(0xffffff, 1) forState:UIControlStateNormal];
        [_nicknameBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        _nicknameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    }
    return _nicknameBtn;
}
- (UIButton *)rePayBtn{
    if (!_rePayBtn) {
        _rePayBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, (SCREENWIDTH - 15)/4.0, 100)];
        [_rePayBtn setImage:[UIImage imageNamed:@"my_icon_待付款"] forState:UIControlStateNormal];
        [_rePayBtn setTitle:@"待付款" forState:UIControlStateNormal];
        [_rePayBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
        [_rePayBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        _rePayBtn.tag = 10;
        [_rePayBtn verticalImageAndTitle:5.0];
        [_rePayBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rePayBtn;
}
- (UIButton *)reTakeOverBtn{
    if (!_reTakeOverBtn) {
        _reTakeOverBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREENWIDTH - 15)/4.0, 20, (SCREENWIDTH - 15)/4.0, 100)];
        [_reTakeOverBtn setImage:[UIImage imageNamed:@"my_icon_待收货"] forState:UIControlStateNormal];
        [_reTakeOverBtn setTitle:@"待发货" forState:UIControlStateNormal];
        [_reTakeOverBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
        [_reTakeOverBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        _reTakeOverBtn.tag = 20;
        [_reTakeOverBtn verticalImageAndTitle:5.0];
        [_reTakeOverBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _reTakeOverBtn;
}
- (UIButton *)customerServiceBtn{
    if (!_customerServiceBtn) {
        _customerServiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(2*(SCREENWIDTH - 15)/4.0, 20, (SCREENWIDTH - 15)/4.0, 100)];
        [_customerServiceBtn setImage:[UIImage imageNamed:@"my_icon_已发货"] forState:UIControlStateNormal];
        [_customerServiceBtn setTitle:@"已发货" forState:UIControlStateNormal];
        [_customerServiceBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
        [_customerServiceBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        _customerServiceBtn.tag = 30;
        [_customerServiceBtn verticalImageAndTitle:5.0];
        [_customerServiceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _customerServiceBtn;
}
- (UIButton *)allOrderBtn{
    if (!_allOrderBtn) {
        _allOrderBtn = [[UIButton alloc]initWithFrame:CGRectMake(3*(SCREENWIDTH - 15)/4.0, 20, (SCREENWIDTH - 15)/4.0 +15, 100)];
        [_allOrderBtn setImage:[UIImage imageNamed:@"my_icon_all"] forState:UIControlStateNormal];
        [_allOrderBtn setTitle:@"全部订单" forState:UIControlStateNormal];
        [_allOrderBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
        [_allOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        _allOrderBtn.tag = 40;
        [_allOrderBtn verticalImageAndTitle:5.0];
        [_allOrderBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _allOrderBtn;
}
- (void)headerIconTapClick:(UIGestureRecognizer *)tap{
    [MobClick event:@"pczl_c"];
    PersonalInformationViewController *page = [[PersonalInformationViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
- (void)btnClick:(UIButton*)btn{
    
    NSString *orderType = @"";
    
    switch (btn.tag) {
        case 10:
        {
            orderType = @"2";
        }
            break;
        case 20:
        {
            orderType = @"9";
        }
            break;
        case 30:
        {
            orderType = @"6";
        }
            break;
        case 40:
        {
            orderType = @"";
        }
            break;
            
        default:
            break;
    }
    [MobClick event:@"pczt_c" label:orderType];

    CommunityJSVC *webVC = [[CommunityJSVC alloc]init];

    webVC.url = [NSString stringWithFormat:@"%@#!/orderCenter",BASE_H5_URL];
    webVC.orderType = orderType;
    [self.navigationController pushViewController:webVC animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat f = scrollView.contentOffset.y;
    if (f <=0) {
        _headerBackguandImg.frame = CGRectMake(0, 0, SCREENWIDTH, 150 - f);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = @"MyPageCell";
    MyPageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifierCell owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.icon.image = [UIImage imageNamed:iconArr[indexPath.row]];
    cell.name.text = nameArr[indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            {
                [MobClick event:@"pcjf_c"];
                MyIntegralVC *page = [[MyIntegralVC alloc]init];
                [self.navigationController pushViewController:page animated:YES];
            }
            break;
        case 1:
        {
                [MobClick event:@"pcqb_c"];
                WallentVC *page = [[WallentVC alloc]init];
                [self.navigationController pushViewController:page animated:YES];
            }
            break;
//        case 2:
//            {
//                 [MobClick event:@"pcyq_c"];
//                InvitedRegistrationViewController *page = [[InvitedRegistrationViewController alloc]init];
//                [self.navigationController pushViewController:page animated:YES];
//            }
//            break;
        case 2:
            {
                [MobClick event:@"pcft_c"];
                CommunityJSVC *webVC = [[CommunityJSVC alloc]init];
                webVC.url = [NSString stringWithFormat:@"%@#!/peopleDetail",BASE_H5_URL];
                webVC.PersonUserType = @"1";
                webVC.PersonUserId = [StorageUserInfromation storageUserInformation].userId;
                [self.navigationController pushViewController:webVC animated:YES];
            }
            break;
        case 3:
            {
                [MobClick event:@"pcsz_c"];
                SetVC *page = [[SetVC alloc]init];
                [self.navigationController pushViewController:page animated:YES];
            }
            break;
            
        default:
            break;
    }
}
- (void)replaceHeaderImg{
    [self reSetHeaderIcon];
}
- (void)modifyNickname{
    [_nicknameBtn setTitle:[NSString stringWithFormat:@" %@",[StorageUserInfromation storageUserInformation].nickname?[StorageUserInfromation storageUserInformation].nickname:@""] forState:UIControlStateNormal];
}
- (void)replaceSex{
    if ([StorageUserInfromation storageUserInformation].sex.integerValue == 0) {
        [_nicknameBtn setImage:[UIImage imageNamed:@"com_icon_man"] forState:UIControlStateNormal];
    }else if ([StorageUserInfromation storageUserInformation].sex.integerValue == 1){
        [_nicknameBtn setImage:[UIImage imageNamed:@"com_icon_woman"] forState:UIControlStateNormal];
        
    }else{
        [_nicknameBtn setImage:[UIImage imageNamed:@"com_icon_woman"] forState:UIControlStateNormal];
        
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
