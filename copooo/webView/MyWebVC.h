//
//  MyWebVC.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/23.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface MyWebVC : BaseViewController
@property (nonatomic,strong)WKWebView *myWebView;
@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic,copy)NSString *url;
@end
