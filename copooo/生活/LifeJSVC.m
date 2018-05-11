//
//  LifeJSVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/24.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "LifeJSVC.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "JKEventHandler.h"
#import "JKEventHandler+LifeJSVC.h"
#import "JKEventHandler+CommunityJSVC.h"
#import "JKEventHandler+Demo.h"
#import "EmptyView.h"
#import "UMWKHybrid.h"
#import <WebKit/WebKit.h>

@interface LifeJSVC ()<WKNavigationDelegate, WKUIDelegate,UIAlertViewDelegate>
{
    
}
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation LifeJSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isShowNav = YES;
    _backButton.hidden = YES;
    self.leftImgName = @"icon_back_gray";

    _backButton.hidden = YES;
    _titleStr = @"生活";
    //    self.leftImgName = @"icon_back_gray";
    if (_titleStr) {
        self.titleLabel.text = _titleStr;
    }
    _url = [NSString stringWithFormat:@"%@#!/lifeList",BASE_H5_URL];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configureWKWebview];
    
    WeakSelf
    [[self.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        StrongSelf
        if ([strongSelf.webView canGoBack]) {
            [strongSelf.webView goBack];
            [strongSelf.webView reload];
        }else {
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    // 添加进入条
    _progressView = [[UIProgressView alloc] init];
    _progressView.frame = CGRectMake(0, NAVHEIGHT - 2, SCREENWIDTH, 2);
    self.progressView.alpha = 0.0;
    [self.view addSubview:_progressView];
    _progressView.backgroundColor = [UIColor clearColor];
    
}
-(void)goBack{
    if ([_webView canGoBack]) {
        [_webView goBack];
        [_webView reload];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //    // 开启返回手势
    //    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    //    }
}
- (void)reloadWebView{
    [JKEventHandler getInject:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}
- (void)configureWKWebview{
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];
    
    
    
    
    
    WKUserScript *usrScript = [[WKUserScript alloc] initWithSource:[JKEventHandler shareInstance].handlerJS injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    
    [config.userContentController addUserScript:usrScript];
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    JKEventHandler *jKEventHandler = [JKEventHandler shareInstance];
    jKEventHandler.goodsId = _goodsId;
    jKEventHandler.goodsTypeId = _goodsTypeId;
    jKEventHandler.orderType =  _orderType;
    jKEventHandler.orderId = _orderId;
    [config.userContentController addScriptMessageHandler:jKEventHandler name:EventHandler];
    
    
    
    
    //通过默认的构造器来创建对象
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT)
                                  configuration:config];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    [self.view addSubview:_webView];
    
    [JKEventHandler getInject:_webView];
    
    // 导航代理
    _webView.navigationDelegate = self;
    // 与webview UI交互代理
    _webView.UIDelegate = self;
    
    // 添加KVO监听
    [_webView addObserver:self
               forKeyPath:@"loading"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    [_webView addObserver:self
               forKeyPath:@"title"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    [_webView addObserver:self
               forKeyPath:@"estimatedProgress"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    
    
    
    
}



- (void)goback {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)gofarward {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}



#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"loading");
        
    } else if ([keyPath isEqualToString:@"title"]) {
        self.titleLabel.text = self.webView.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"progress: %f", self.webView.estimatedProgress);
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    if (!self.webView.loading) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
    }
}

#pragma mark - WKNavigationDelegate
// 请求开始前，会先调用此代理方法
// 与UIWebView的
// 类型，在请求先判断能不能跳转（请求）


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:
(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *url = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *parameters = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [UMWKHybrid execute:parameters webView:webView];
    
    NSString *hostname = navigationAction.request.URL.host.lowercaseString;
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated
        && ![hostname containsString:@".lanou.com"]) {
        // 对于跨域，需要手动跳转
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        self.progressView.alpha = 1.0;
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    NSLog(@"00===%s", __FUNCTION__);
}


// 在响应完成时，会回调此方法
// 如果设置为不允许响应，web内容就不会传过来
- (void)webView:(WKWebView *)webView
decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse
decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
    
    NSLog(@"11===%s", __FUNCTION__);
    self.progressView.alpha = 0.0;
}


// 开始导航跳转时会回调
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"22===%s", __FUNCTION__);
    
}

// 接收到重定向时会回调
- (void)webView:(WKWebView *)webView
didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"33===%s", __FUNCTION__);
}


// 导航失败时会回调
- (void)webView:(WKWebView *)webView
didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"44===%s", __FUNCTION__);
   EmptyView *myView = [[EmptyView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, 0, SCREENHEIGHT - NAVHEIGHT)];
    WeakSelf
    myView.freshBlock = ^{
        StrongSelf
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strongSelf.url]]];
    };
    [self.view addSubview:myView];
}

// 页面内容到达main frame时回调
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"55===%s", __FUNCTION__);
}


// 导航完成时，会回调（也就是页面载入完成了）
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"66===%s", __FUNCTION__);
    [webView evaluateJavaScript:@"setWebViewFlag()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
    }];
    //    [webView evaluateJavaScript:@"JKEventHandler.getCommunityTag();" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
    //        XMJLog(@"error%@",error);
    //    }];
//    WKNavigation *backNavigation = [webView goBack];
//    if ([backNavigation isEqual:navigation]) {
//        // 这次的加载是点击返回产生的，刷新
//        [webView reload];
//        backNavigation = nil;
//    }
    
}


// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailNavigation:
(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"77===%s", __FUNCTION__);
    
}


// 对于HTTPS的都会触发此代理，如果不要求验证，传默认就行
// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:
(NSURLAuthenticationChallenge *)challenge completionHandler:
(void (^)(NSURLSessionAuthChallengeDisposition disposition,
          NSURLCredential *__nullable credential))completionHandler {
    NSLog(@"88===%s", __FUNCTION__);
    NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    
}


// 9.0才能使用，web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"99===%s", __FUNCTION__);
}



// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message
initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"100===%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:
                      UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          completionHandler();
                      }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    NSLog(@"%@", message);
}

// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView
runJavaScriptConfirmPanelWithMessage:(NSString *)message
initiatedByFrame:(WKFrameInfo *)frame
completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"101===%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                @"confirm" message:@"JS调用confirm"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                                  completionHandler(YES);
                                              }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                  completionHandler(NO);
                                              }]];
    [self presentViewController:alert animated:YES completion:NULL];
    NSLog(@"%@", message);
}


// JS端调用prompt函数时，会触发此方法
// 要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView
runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt
    defaultText:(nullable NSString *)defaultText
initiatedByFrame:(WKFrameInfo *)frame
completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSLog(@"102===%s", __FUNCTION__);
    NSLog(@"%@", prompt);
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                prompt message:defaultText
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                  completionHandler([[alert.textFields lastObject] text]);
                                              }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    
    
    
    
}



- (void)dealloc{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:EventHandler];
    [self.webView evaluateJavaScript:@"JKEventHandler.removeAllCallBacks();" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
    }];//删除所有的回调事件
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


