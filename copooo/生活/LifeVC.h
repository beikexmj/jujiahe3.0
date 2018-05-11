//
//  LifeVC.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/15.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

@interface LifeVC : BaseViewController
@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)NSString *titleStr;
@property (nonatomic, copy)NSString *userId;
@property (nonatomic,copy)NSString *goodsTypeId;
@property (nonatomic, strong) WKWebView *webView;
- (void)reloadWebView;
@end
