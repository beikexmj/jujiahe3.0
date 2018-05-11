//
//  RankRuleViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/12/13.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "RankRuleViewController.h"
#import <WebKit/WebKit.h>

@interface RankRuleViewController ()
@property (nonatomic,strong) WKWebView *myWebView;

@end

@implementation RankRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+24;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    _myWebView  = [[WKWebView alloc]initWithFrame:CGRectMake(15, _navHight.constant , SCREENWIDTH-30, SCREENHEIGHT)];
    [self.view addSubview:_myWebView];
    NSString * htmlStr = @"&nbsp;&nbsp;&nbsp;<strong><span style=\"color:#303030;\">&nbsp;</span></strong><strong><span style=\"font-size:32px;color:#303030;\">1.排名规则</span></strong><br /><p><span style=\"font-size:32px;\">&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color:#606060;\">统计排行个人有效邀请用户（完成注册）数量，取前10名进行发布。</span></span></p><p><br /></p><span style=\"font-size:32px;\">&nbsp; &nbsp;</span><strong><span style=\"font-size:32px;\">&nbsp;</span></strong><strong><span style=\"font-size:32px;color:#303030;\">2.时间周期</span></strong><br /><p><span style=\"font-size:32px;\">&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color:#606060;\">及时统计更新数据，以月为周期结算</span>。</span></p><p><br /></p><span style=\"font-size:32px;\">&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color:#303030;\">3</span></span><strong><span style=\"font-size:32px;color:#303030;\">.榜单奖励</span></strong><br /><span style=\"font-size:32px;\">&nbsp; &nbsp;（<span style=\"color:#606060;\">1）针对桂东的奖励</span></span><br /><span style=\"font-size:32px;color:#606060;\">&nbsp; &nbsp; &nbsp; 排名前3名的用户予以奖励累计10元、5元、2元的电费抵扣券，其余榜单达人予以奖励1元的电费抵扣券。</span><br /><span style=\"font-size:32px;color:#606060;\">&nbsp; &nbsp; &nbsp;&nbsp;a.元/5元电费抵扣券可拆分成5元、3元、1元领取，但是单次缴费时只能使用1张，不可拆分、重复使用;</span><br /><span style=\"font-size:32px;color:#606060;\">&nbsp; &nbsp; &nbsp; b.抵扣券不可提现，有效期60天；</span><br /><span style=\"font-size:32px;color:#606060;\">&nbsp; &nbsp; &nbsp; c.活动之后3个工作日内发放奖励；</span><br /><span style=\"font-size:32px;color:#606060;\">&nbsp; &nbsp; &nbsp;&nbsp;d.票券中心领取、查看电费抵扣券。</span><br /><span style=\"font-size:32px;\"><span style=\"color:#606060;\">&nbsp; </span><span style=\"color:#606060;\">&nbsp;</span><span style=\"color:#606060;\">（2）日常奖励</span></span><br /><span style=\"font-size:32px;color:#606060;\">&nbsp; &nbsp; &nbsp; a.前3名分别奖励500、200、100合币，4-10名奖励50合币；</span><br /><span style=\"font-size:32px;color:#606060;\">&nbsp; &nbsp; &nbsp;&nbsp;b.结算日24:00发放合币奖励。</span><br />";
    [_myWebView loadHTMLString:htmlStr baseURL:nil];
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

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
