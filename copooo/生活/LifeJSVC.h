//
//  LifeJSVC.h
//  copooo
//
//  Created by XiaMingjiang on 2018/2/24.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeJSVC : BaseViewController
@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)NSString *titleStr;
@property (nonatomic,copy)NSString *goodsId;
@property (nonatomic,copy)NSString *goodsTypeId;
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *orderType;
@property (nonatomic, copy)NSString *orderId;
- (void)goBack;
- (void)reloadWebView;

@end
