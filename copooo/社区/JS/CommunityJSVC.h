//
//  CommunityJSVC.h
//  copooo
//
//  Created by XiaMingjiang on 2018/2/7.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface CommunityJSVC : BaseViewController
@property (nonatomic,strong) NSString *url;
@property (nonatomic,copy)NSString *titleStr;
@property (nonatomic, copy)NSString *tagId;
@property (nonatomic, copy)NSString *postId;
@property (nonatomic, copy)NSString *PersonUserId;
@property (nonatomic, copy)NSString *PersonUserType;
@property (nonatomic, copy)NSString *userId;
@property (nonatomic,copy)NSString *orderType;
@property (nonatomic,copy)NSString *goodsId;
@property (nonatomic,copy)NSString *goodsTypeId;
@property (nonatomic, copy)NSString *orderId;
- (void)goBack;
- (void)reloadWebView;

@end
