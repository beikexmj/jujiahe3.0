//
//  DailyWordVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/14.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "DailyWordVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "NSString+URL.h"

@interface DailyWordVC ()

@property (nonatomic, strong) UILabel *dailyWord;

@property (nonatomic, strong) UILabel *day;

@property (nonatomic, strong) UILabel *month;

@property (nonatomic, strong) UILabel *week;

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation DailyWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];

    // Do any additional setup after loading the view.
}
- (void)initSubView{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    UIImageView *topImageView = [[UIImageView alloc]init];
    topView.contentMode = UIViewContentModeScaleAspectFill;
    //    topImageView.image = [UIImage imageNamed:@"banner_pic"];
    [topImageView sd_setImageWithURL:[NSURL URLWithString:_daily_word_data.background_image] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
    [topView addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.view addSubview:topView];
    
    [topView addSubview:self.dailyWord];
    [topView addSubview:self.day];
    [topView addSubview:self.week];
    [topView addSubview:self.month];
    [topView addSubview:self.shareBtn];
    [topView addSubview:self.backBtn];
    self.dailyWord.text = _daily_word_data.name;
    CGFloat titleLabelX = 15;
    CGFloat titleLabelW = SCREENWIDTH - titleLabelX*2;
    CGSize size = [self.dailyWord sizeThatFits:CGSizeMake(titleLabelW, MAXFLOAT)];
    CGFloat titleLabelY = SCREENHEIGHT - size.height - 30;
    self.dailyWord.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, size.height);
    self.day.text = [StorageUserInfromation dayFromDateString:_daily_word_data.time];
    self.month.text = [StorageUserInfromation monthFromDateString:_daily_word_data.time];
    self.week.text = [StorageUserInfromation weekFromDateString:_daily_word_data.time];
}
- (UILabel *)dailyWord{
    if (!_dailyWord) {
        CGFloat titleLabelH = 40;
        CGFloat titleLabelX = 15;
        CGFloat titleLabelW = SCREENWIDTH - titleLabelX*2;
        CGFloat titleLabelY = SCREENHEIGHT - titleLabelH - 30;
        _dailyWord = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        _dailyWord.numberOfLines = 0;
        _dailyWord.font = [UIFont systemFontOfSize:14.0];
        _dailyWord.textColor = [UIColor whiteColor];
        //阴影颜色
        _dailyWord.shadowColor = RGBA(0x000000, 0.3);
        //阴影偏移  x，y为正表示向右下偏移
        _dailyWord.shadowOffset = CGSizeMake(1, 1);
    }
    return _dailyWord;
}
- (UILabel *)day{
    if (!_day) {
        CGFloat titleLabelH = 60;
        CGFloat titleLabelX = 15;
        CGFloat titleLabelW = titleLabelH+5;
        CGFloat titleLabelY = NAVHEIGHT + 20;
        _day = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        _day.font = [UIFont systemFontOfSize:50.0];
        _day.textColor = [UIColor whiteColor];
        //阴影颜色
        _day.shadowColor = RGBA(0x000000, 0.2);
        //阴影偏移  x，y为正表示向右下偏移
        _day.shadowOffset = CGSizeMake(1, 1);
    }
    return _day;
}
- (UILabel *)week{
    if (!_week) {
        CGFloat titleLabelH = 30;
        CGFloat titleLabelX = 15 + 65;
        CGFloat titleLabelW = 100;
        CGFloat titleLabelY = NAVHEIGHT +20 +5;
        _week = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        _week.font = [UIFont systemFontOfSize:15.0];
        _week.textColor = [UIColor whiteColor];
        //阴影颜色
        _week.shadowColor = RGBA(0x000000, 0.3);
        //阴影偏移  x，y为正表示向右下偏移
        _week.shadowOffset = CGSizeMake(1, 1);
    }
    return _week;
}
- (UILabel *)month{
    if (!_month) {
        CGFloat titleLabelH = 25;
        CGFloat titleLabelX = 15 + 65;
        CGFloat titleLabelW = 100;
        CGFloat titleLabelY = NAVHEIGHT + 20 + 25;
        _month = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        _month.font = [UIFont systemFontOfSize:19.0];
        _month.textColor = [UIColor whiteColor];
        //阴影颜色
        _month.shadowColor = RGBA(0x000000, 0.3);
        //阴影偏移  x，y为正表示向右下偏移
        _month.shadowOffset = CGSizeMake(1, 1);
    }
    return _month;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        CGFloat titleLabelH = 44;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelW = 60;
        CGFloat titleLabelY = NAVHEIGHT - 44;
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        [_backBtn setImage:[UIImage imageNamed:@"icon_back_white2"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UIButton *)shareBtn{
    if (!_shareBtn) {
        CGFloat titleLabelH = 44;
        CGFloat titleLabelX = SCREENWIDTH - 60;
        CGFloat titleLabelW = 60;
        CGFloat titleLabelY = NAVHEIGHT - 44;
        _shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        [_shareBtn setImage:[UIImage imageNamed:@"icon_share_white2"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
- (void)shareBtnClick{
//    if([[StorageUserInfromation storageUserInformation].userId isEqualToString:@""]){
//        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"未登录" message:@"确定跳回登陆界面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
//    }else{
        [self showShareActionSheet:self.view];
//    }
}
/**
 *  显示分享菜单
 *
 *  @param view 容器视图
 */
- (void)showShareActionSheet:(UIView *)view
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    //    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"shareImg" ofType:@"png"];
    //    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"];
    //    NSArray* imageArray = @[@"http://ww4.sinaimg.cn/bmiddle/005Q8xv4gw1evlkov50xuj30go0a6mz3.jpg",[UIImage imageNamed:@"shareImg.png"]];
    
    NSString *url = [NSString stringWithFormat:@"%@?id=%@",BASE_SHARE,_daily_word_data.ids];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    XMJLog(@"%@",url);
    [shareParams SSDKSetupShareParamsByText:_daily_word_data.name
                                     images:[UIImage imageNamed:@"登录logo"]
                                        url:[NSURL URLWithString:url]
                                      title:@"居家合"
                                       type:SSDKContentTypeAuto];
    

    [ShareSDK showShareActionSheet:view
                             items:@[
                                     @(SSDKPlatformTypeQQ),
                                     @(SSDKPlatformSubTypeQQFriend),
                                     @(SSDKPlatformSubTypeWechatSession),
                                     @(SSDKPlatformSubTypeWechatTimeline),
                                     ]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                           if (platformType == SSDKPlatformTypeFacebookMessenger)
                           {
                               break;
                           }
                           
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }else if([error code] == 105)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"没有有效的分享平台可以显示。原因可能是：分享平台需要安装qq或者微信客户端才能分享，而这台iOS设备没有安装这些平台的客户端。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           //                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                           //                                                                               message:nil
                           //                                                                              delegate:nil
                           //                                                                     cancelButtonTitle:@"确定"
                           //                                                                     otherButtonTitles:nil];
                           //                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin && state != SSDKResponseStateBeginUPLoad)
                   {
                   }
               }];
}
- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
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
