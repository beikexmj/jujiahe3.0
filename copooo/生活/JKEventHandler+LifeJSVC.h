//
//  JKEventHandler+LifeJSVC.h
//  copooo
//
//  Created by XiaMingjiang on 2018/2/28.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JKWKWebViewHandler/JKWKWebViewHandler.h>
#import "PasswordAlertView.h"
@interface JKEventHandler (LifeJSVC)<UIAlertViewDelegate,PasswordAlertViewDelegate>

@property (nonatomic,copy)NSString *goodsId;

@property (nonatomic,copy)NSString *orderId;

@property (nonatomic,copy)NSString *goodsTypeId;

@property (nonatomic,copy)NSString *orderType;

@property (nonatomic,strong) PasswordAlertView *passwordAlertView;

@property (nonatomic,strong) NSMutableDictionary *payInfo;

- (void)getUserId:(id)params :(void(^)(id response))callBack;

- (void)getOrderType:(id)params :(void(^)(id response))callBack;

- (void)getUserIdAndGoodsId:(id)params :(void(^)(id response))callBack;

- (void)getToken:(id)params :(void(^)(id response))callBack;

- (void)login:(id)params;

- (void)close:(id)params;

- (void)share:(id)params;

- (void)getGoodsTypeId:(id)params :(void(^)(id response))callBack;

- (void)getGoodsId:(id)params :(void(^)(id response))callBack;

- (void)logistics:(id)params;

- (void)gotoLifeDetail:(id)params;

- (void)gotoPay:(id)params;

- (void)gotoAddressActivity:(id)params;

- (void)qq:(id)params;

- (void)phoneCall:(id)params;

- (void)orderType:(id)params;

- (void)onEvent:(id)params;

- (void)gotoPayActivity:(id)params;

- (void)refreshToken:(id)params :(void(^)(id response))callBack;

- (void)getRefreshToken:(id)params :(void(^)(id response))callBack;

- (void)gotoLoginView:(id)params;
@end
