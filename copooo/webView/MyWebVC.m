//
//  MyWebVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/23.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "MyWebVC.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "LoopProgressView.h"
@interface MyWebVC ()<WKScriptMessageHandler>
{
    LoopProgressView *custom;
}
@end

@implementation MyWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowNav = YES;
    _backButton.hidden = YES;
    self.leftImgName = @"icon_back_gray";
    _myWebView =[[WKWebView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT)];
    [self.view addSubview:_myWebView];
    NSURL* url = [NSURL URLWithString:_url];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [[_myWebView configuration].userContentController addScriptMessageHandler:self name:@"getCommunityTag"];
    [_myWebView loadRequest:request];
    custom = [[LoopProgressView alloc]initWithFrame:CGRectMake(50, 100, 100, 100)];
    custom.center = CGPointMake(SCREENWIDTH/2.0, SCREENHEIGHT/2.0);
    custom.progress = 0.0;
    [[UIApplication sharedApplication].keyWindow addSubview:custom];
    
    @weakify(self)
    [RACObserve(self.myWebView, estimatedProgress) subscribeNext:^(id x) {
        @strongify(self)
        [custom setAlpha:1.0f];
        custom.progress = self.myWebView.estimatedProgress * 100;
        if(self.myWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [custom setAlpha:0.0f];

            } completion:^(BOOL finished) {
                [custom removeFromSuperview];
            }];
        }
    }];
    WeakSelf
    [[self.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        StrongSelf
        if ([strongSelf.myWebView canGoBack]) {
            [strongSelf.myWebView goBack];
        } else {
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
    }];

    // Do any additional setup after loading the view.
}
- (void)leftButtonClick:(UIButton *)button{
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [custom removeFromSuperview];
}
//WKScriptMessageHandler协议方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"getCommunityTag"]) {
        JSValue *Callback = self.jsContext[@"getCommunityTag"];
        [Callback callWithArguments:nil];
    }
    //code
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
