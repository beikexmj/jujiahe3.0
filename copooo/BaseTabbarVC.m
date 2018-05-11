//
//  BaseTabbarVC.m
//  Weizhi
//
//  Created by 何月 on 2017/6/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "BaseTabbarVC.h"
#import "CommunityVC.h"
#import "LifeVC.h"
#import "HomePageVC.h"
#import "MyPageVC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "AppDelegate.h"
#import "CMUUIDManager.h"
@interface BaseTabbarVC ()<UITabBarDelegate>
{
    NSString *choseUnitPropertyId;
    NSString *choseUnitName;
    NSString *cityNumber;
    NSString *currentCity;
}

@end
BaseTabbarVC *manager = nil;
@implementation BaseTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    choseUnitPropertyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"choseUnitPropertyId"];
    choseUnitName = [[NSUserDefaults standardUserDefaults] objectForKey:@"choseUnitName"];
    cityNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityNumber"];
    currentCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"];
    
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];

    
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    storage.choseUnitPropertyId = choseUnitPropertyId;
    storage.choseUnitName = choseUnitName;
    storage.cityNumber = cityNumber;
    storage.currentCity = currentCity;
    
    [NSKeyedArchiver archiveRootObject:storage toFile:file];

    
    // Do any additional setup after loading the view.
    HomePageVC *vc1 = [[HomePageVC alloc] init];
    CommunityVC *vc2 = [[CommunityVC alloc] init];
    LifeVC *vc3 = [[LifeVC alloc] init];
    MyPageVC *vc4 = [[MyPageVC alloc] init];
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"首页",
                            CYLTabBarItemImage : @"nav_bar_home1",
                            CYLTabBarItemSelectedImage : @"nav_bar_home2",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"社区",
                            CYLTabBarItemImage : @"nav_bar_community1",
                            CYLTabBarItemSelectedImage : @"nav_bar_community2",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : @"生活",
                            CYLTabBarItemImage : @"nav_bar_life1",
                            CYLTabBarItemSelectedImage : @"nav_bar_life2",
                            };
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"我的",
                            CYLTabBarItemImage : @"nav_bar_my1",
                            CYLTabBarItemSelectedImage : @"nav_bar_my2",
                            };
    NSArray *tabBarItemsAttributes = @[ dict1, dict2 , dict3,dict4];
    self.tabBarItemsAttributes = tabBarItemsAttributes;
    
    [self setViewControllers:@[
                                           vc1,
                                           vc2,
                                           vc3,
                                           vc4
                                           ]];
    self.tabBar.tintColor = RGBA(0x31B3EF, 1);
//    self.tabBar.delegate = self;
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = RGBA(0x9c9c9c, 1);
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = RGBA(0x303030, 1);
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];

    [[UITabBar appearance] setBackgroundImage:CreateImageWithColor(RGBA(0xffffff, 1), CGSizeMake(1, 1))];
    [UITabBar appearance].translucent = NO;
    [self uploadInfo];
    
//    //IM被踢下线
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LogoutNotifi:) name:OnKickNotifi object:nil];
//
//    //用户主动退出
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LogoutNotifi:) name:UserLogoutNotifi object:nil];
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSString *str = @"0";
    if ([item.title isEqualToString:@"首页"]) {
        str = @"0";
        HomePageVC *page = (HomePageVC *)self.viewControllers[0];
        if (page) {
            [page fetchData2];
        }
    }else if ([item.title isEqualToString:@"社区"]){
        str = @"1";
        CommunityVC *page = (CommunityVC *)self.viewControllers[1];
        if (page) {
            [page fetchHeaderData];
            [page fetchList:1];
        }
    }else if ([item.title isEqualToString:@"生活"]){
        str = @"2";
        LifeVC *page = (LifeVC *)self.viewControllers[2];
        if (page) {
            page.goodsTypeId = @"";
            [page reloadWebView];
        }
    }else if ([item.title isEqualToString:@"我的"]){
        str = @"3";
        MyPageVC *page = ( MyPageVC *)self.viewControllers[3];
        if (page) {
            [page freshInterface];
        }
    }
    [MobClick event:[NSString stringWithFormat:@"maintab_c_%@",str]];
    XMJLog(@"item name = %@", item.title);
}
- (void)uploadInfo{
    static BOOL flag = YES;
    if (!flag) {
        return;
    }
    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 2 *NSEC_PER_SEC); //设置时间2秒
    dispatch_after(time, dispatch_get_main_queue(), ^{
        //2秒后执行操作
        //添加操作
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //此获取的版本号对应version，打印出来对应为1.2.3.4.5这样的字符串
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *widthStr = [NSString stringWithFormat:@"%0.0f",SCREENWIDTH];
        NSString *heightStr = [NSString stringWithFormat:@"%0.0f",SCREENHEIGHT];
        NSString * uuid = [CMUUIDManager readUUID];
//        uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSDictionary *dict = @{@"apiv":@"1.0",@"deviceCode":uuid,@"pushId":delegate.registrationID?delegate.registrationID:@"",@"version":version,@"deviceType":@"iphone",@"brand":[StorageUserInfromation doDevicePlatform],@"systemVersion":[UIDevice currentDevice].systemVersion,@"deviceWidth":widthStr,@"deviceHeight":heightStr};
        XMJLog(@"9876543210 == %@",dict);
        [ZTHttpTool postWithUrl:@"sys/v1/device/register" param:dict success:^(id responseObj) {
            NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
            NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
            NSLog(@"%@",onceDict);
            if ([onceDict[@"rcode"] integerValue] == 0) {
                
            }else{
                [self uploadInfo];
                flag = NO;
            }
        } failure:^(NSError *error) {
            XMJLog(@"12345678%@",error);
            [self uploadInfo];
            flag = NO;
        }];
    });
    
}
//-(void)LogoutNotifi:(NSNotification *)noti
//{
//    NSString *msgString = [noti object];
//    [self.navigationController popToRootViewControllerAnimated:false];
//    self.selectedIndex = 1;
//
//    LoginViewController *login = [[LoginViewController alloc] init];
//    [self.navigationController pushViewController:login animated:false];
//
//    [SVProgressHUD showInfoWithStatus:msgString];
//
//    [AppDelegate app].currentDevice = nil;
//    [AppDelegate app].deviceArr = nil;
//    [AppDelegate app].curentdeviceIndex = -1;
//    //清空token
//    UserInfoModule *userInfo = [UserInfoModule shareInfoModule];
//    [userInfo cleanUserInfo];
//}

-(UILabel *)createPointLable:(CGRect )pointFrame
{
    UILabel *pointLabel = [[UILabel alloc] init];
    pointLabel.frame = pointFrame;
    pointLabel.clipsToBounds = true;
    pointLabel.layer.cornerRadius = pointLabel.width/2;
    pointLabel.backgroundColor = [UIColor redColor];
    pointLabel.userInteractionEnabled = false;
    pointLabel.hidden = true;
    [self.view addSubview:pointLabel];
    return pointLabel;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{    
    return true;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    XMJLog(@"%lu",(unsigned long)tabBarController.selectedIndex);
    XMJLog(@"viewcontrol = %@",NSStringFromClass([viewController class]));
}
+ (instancetype)Shareinstance{
    if(!manager){
       static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                manager = [BaseTabbarVC new];
            });
    }
    return manager;
}
// 防止使用alloc开辟空间
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    if(!manager){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [super allocWithZone:zone];
        });
    }
    return manager;
}

// 防止copy
+ (id)copyWithZone:(struct _NSZone *)zone{
    if(!manager){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [super copyWithZone:zone];
        });
    }
    return manager;
}

// 使用同步锁保证init创建唯一单例 ( 与once效果相同 )
- (instancetype)init{
    @synchronized(self) {
        self = [super init];
    }
    return self;
}

@end
