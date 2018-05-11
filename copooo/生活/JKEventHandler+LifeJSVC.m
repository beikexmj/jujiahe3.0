//
//  JKEventHandler+LifeJSVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/28.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "JKEventHandler+LifeJSVC.h"
#import "UIView+Extensions.h"
#import "LifeJSVC.h"
#import "DeliveryAddressVC.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ModifyPaymentPasswordFirstStepViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <MOBFoundation/MOBFoundation.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "CommunityJSVC.h"
@implementation JKEventHandler (LifeJSVC)
static char goodsIdKey;
static char goodsTypeIdKey;
static char passwordAlertViewKey;
static char payInfoKey;
static char orderTypeKey;
static char orderIdKey;
//getter
- (NSString *)orderId {
    NSString *orderId = objc_getAssociatedObject(self, &orderIdKey);
    if (!orderId) {
        
        objc_setAssociatedObject(self, &orderIdKey, orderId, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return orderId;
}
//setter
- (void)setOrderId:(NSString *)orderId{
    objc_setAssociatedObject(self, &orderIdKey, orderId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
//getter
- (NSString *)orderType {
    NSString *orderType = objc_getAssociatedObject(self, &orderTypeKey);
    if (!orderType) {
        
        objc_setAssociatedObject(self, &orderTypeKey, orderType, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return orderType;
}
//setter
- (void)setOrderType:(NSString *)orderType{
    objc_setAssociatedObject(self, &orderTypeKey, orderType, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
//getter
- (NSMutableDictionary *)payInfo {
    NSMutableDictionary *payInfo = objc_getAssociatedObject(self, &payInfoKey);
    if (!payInfo) {
        
        objc_setAssociatedObject(self, &payInfoKey, payInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return payInfo;
}
//setter
- (void)setPayInfo:(NSMutableDictionary *)payInfo{
    objc_setAssociatedObject(self, &payInfoKey, payInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//getter
- (PasswordAlertView *)passwordAlertView {
    PasswordAlertView *passwordAlertView = objc_getAssociatedObject(self, &passwordAlertViewKey);
    if (!passwordAlertView) {
        
        objc_setAssociatedObject(self, &passwordAlertViewKey, passwordAlertView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return passwordAlertView;
}
//setter
- (void)setPasswordAlertView:(PasswordAlertView *)passwordAlertView{
    objc_setAssociatedObject(self, &passwordAlertViewKey, passwordAlertView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//getter
- (NSString *)goodsTypeId {
    NSString *goodsTypeId = objc_getAssociatedObject(self, &goodsTypeIdKey);
    if (!goodsTypeId) {
        
        objc_setAssociatedObject(self, &goodsTypeIdKey, goodsTypeId, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return goodsTypeId;
}
//setter
- (void)setGoodsTypeId:(NSString *)goodsTypeId{
    objc_setAssociatedObject(self, &goodsTypeIdKey, goodsTypeId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//getter
- (NSString *)goodsId {
    NSString *goodsId = objc_getAssociatedObject(self, &goodsIdKey);
    if (!goodsId) {
        
        objc_setAssociatedObject(self, &goodsIdKey, goodsId, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return goodsId;
}
//setter
- (void)setGoodsId:(NSString *)goodsId{
    objc_setAssociatedObject(self, &goodsIdKey, goodsId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)getUserId:(id)params :(void(^)(id response))callBack{
    //    NSLog(@"%@",self.postId);
    NSString * userId = [StorageUserInfromation storageUserInformation].userId;
    NSString * token = [StorageUserInfromation storageUserInformation].access_token;
    NSString * uuid = [StorageUserInfromation storageUserInformation].uuid;
    NSString *str3 = [NSString stringWithFormat:@"%@",uuid?uuid:@""];
    NSString *str2 = [NSString stringWithFormat:@"%@",token?token:@""];
    NSString *str = [NSString stringWithFormat:@"%@",userId?userId:@""];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":str,@"token":str2,@"areaId":[StorageUserInfromation storageUserInformation].choseUnitPropertyId,@"uuid":str3}];
    if ([params count]) {
        [dict setObject:params[@"index"] forKey:@"index"];
        [dict setObject:params[@"postId"] forKey:@"postId"];
    }    //    XMJLog(@"%@",[DictToJson jsonStringWithDictionary:dict]);
    callBack([DictToJson jsonStringWithDictionary:dict]);
}
- (void)getOrderType:(id)params :(void(^)(id response))callBack{
    //    NSLog(@"%@",self.postId);
    NSString * userId = [StorageUserInfromation storageUserInformation].userId;
    NSString * token = [StorageUserInfromation storageUserInformation].access_token;
    NSString * uuid = [StorageUserInfromation storageUserInformation].uuid;
    NSString *str3 = [NSString stringWithFormat:@"%@",uuid?uuid:@""];
    NSString *str2 = [NSString stringWithFormat:@"%@",token?token:@""];
    NSString *str = [NSString stringWithFormat:@"%@",userId?userId:@""];
    NSDictionary *dict;
    if ([params count] == 2) {
        dict = @{@"userId":str,@"token":str2,@"type":self.orderType?self.orderType:@"",@"id":params[@"id"],@"index":params[@"index"],@"uuid":str3};
    }else{
        dict = @{@"userId":str,@"token":str2,@"type":self.orderType?self.orderType:@"",@"uuid":str3};
    }
    callBack([DictToJson jsonStringWithDictionary:dict]);
}
- (void)getUserIdAndGoodsId:(id)params :(void(^)(id response))callBack{
    NSString * userId = [StorageUserInfromation storageUserInformation].userId;
    NSString * token = [StorageUserInfromation storageUserInformation].access_token;
    NSString *str2 = [NSString stringWithFormat:@"%@",token?token:@""];
    NSString *str = [NSString stringWithFormat:@"%@",userId?userId:@""];
    NSString * uuid = [StorageUserInfromation storageUserInformation].uuid;
    NSString *str3 = [NSString stringWithFormat:@"%@",uuid?uuid:@""];
    NSDictionary *dict = @{@"userId":str,@"token":str2,@"goodsId":self.goodsId?self.goodsId:@"",@"orderId":self.orderId?self.orderId:@"",@"uuid":str3};
    callBack([DictToJson jsonStringWithDictionary:dict]);
}
- (void)getToken:(id)params :(void(^)(id response))callBack{
    NSString * token = [StorageUserInfromation storageUserInformation].access_token;
    NSString *str = [NSString stringWithFormat:@"'%@'",token?token:@""];
    callBack(str);
}
- (void)login:(id)params{
    
  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"未登录或token失效" message:@"确定返回登录界面重新登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 5;
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 5) {
        if (buttonIndex == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [delegate.window.currentViewController.navigationController pushViewController:controller animated:YES];
                
//                delegate.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:controller];
            });
        }
    }else if (alertView.tag == 10) {
        [self close:nil];
    }else if (alertView.tag == 100){
        if (buttonIndex == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{

            ModifyPaymentPasswordFirstStepViewController *controller = [[ModifyPaymentPasswordFirstStepViewController alloc]initWithNibName:@"ModifyPaymentPasswordFirstStepViewController" bundle:nil];
            controller.titleStr = @"设置支付密码";
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                XMJLog(@"%@",delegate.window.currentViewController);
            [delegate.window.currentViewController.navigationController pushViewController:controller animated:YES];
            });
        }
    }
    
}
- (void)share:(id)params{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self showShareActionSheet:delegate.window.currentViewController.view];
}
- (void)getGoodsTypeId:(id)params :(void(^)(id response))callBack{
    NSString *str = @"";
    if (self.goodsTypeId) {
        str = [NSString stringWithFormat:@"'%@'",self.goodsTypeId];
    }else{
        str = @"''";

    }
    callBack(str);
}
- (void)getGoodsId:(id)params :(void(^)(id response))callBack{
    
    NSString *str = @"";
    if (self.goodsId) {
        str = [NSString stringWithFormat:@"'%@'",self.goodsId];
    }else{
        str = @"''";
        
    }
    callBack(str);
}

- (void)gotoLifeDetail:(id)goodsId{
    XMJLog(@"%@",goodsId);
    dispatch_async(dispatch_get_main_queue(), ^{
        // 主线程
        NSString  *url = [NSString stringWithFormat:@"%@%@%@",BASE_H5_URL,@"#!/",@"lifeDetail"];
        CommunityJSVC * page = [[CommunityJSVC alloc]init];
        page.url = url;
        page.goodsId = goodsId[@"id"];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window.currentViewController.navigationController pushViewController:page animated:YES];
    });
}

- (void)close:(id)params{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        [self.webView reload];
    }else{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.window.currentViewController.navigationController popViewControllerAnimated:YES];
        CommunityJSVC *jsVC = (CommunityJSVC *)delegate.window.currentViewController;
        if ([jsVC isKindOfClass:[CommunityJSVC class]]) {
            [jsVC reloadWebView];
        }
    }
    
}
- (void)logistics:(id)params{
    XMJLog(@"%@",params);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString  *url =
        [NSString stringWithFormat:@"https://www.baidu.com/ssid=cbbc6c696a753032338208/from=844b/s?word=%@&ts=6790553&t_kt=0&ie=utf-8&fm_kl=021394be2f&rsv_iqid=0865127641&rsv_t=911bnrTtbk1Aalg%@252BKEl6Yoc5h0EFUWb9uYHVsYGxcG5FSjoGweYwkMC4sg&sa=ib&ms=1&rsv_pq=0865127641&rsv_sug4=958&ss=001&inputT=652&tj=1",params[@"logistics"],@"%"];
        CommunityJSVC * page = [[CommunityJSVC alloc]init];
        page.url = url;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window.currentViewController.navigationController pushViewController:page animated:YES];
    });
}
- (void)orderType:(id)params{
    self.orderType = params[@"type"];
}

- (void)gotoPay:(id)params{
    XMJLog(@"%@",params);
    self.payInfo = params;
    if ([self.payInfo[@"totalPrice"] isEqualToString:@"NaN"]) {
        [MBProgressHUD showError:@"商品金额有误"];
        return;
    }
    if (params) {
        if ([params[@"codeType"] integerValue] == 1) {//余额支付
            if ([StorageUserInfromation storageUserInformation].payPasswordSet.integerValue == 0) {
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"设置支付密码" message:@"为保障您的账户资金安全，请先设置支付密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag = 100;
                    [alert show];
                    
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showPasswordInputView];
                });
            }
          
        }else if ([params[@"codeType"] integerValue] == 2) {//支付宝支付
            dispatch_async(dispatch_get_main_queue(), ^{
                [self aliPay];
            });
        }
    }
    
}

- (void)gotoAddressActivity:(id)params{
    XMJLog(@"%@",params);
    dispatch_async(dispatch_get_main_queue(), ^{
        DeliveryAddressVC *controller = [[DeliveryAddressVC alloc] init];
        WeakSelf
        controller.deliverAddressBlock = ^(NSDictionary *param) {
            StrongSelf
            NSString *str = [NSString stringWithFormat:@"selectAddress('%@')",[DictToJson jsonStringWithDictionary:param]];
            [strongSelf.webView evaluateJavaScript:str completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                XMJLog(@"%@",error);
            }];
        };
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.window.currentViewController.navigationController pushViewController:controller animated:YES];
    });
    
}
- (void)qq:(id)params{
    XMJLog(@"%@",params);
    dispatch_async(dispatch_get_main_queue(), ^{
        //方法1:
        if ([QQApiInterface isQQInstalled]) {
            //安装
            QQApiTextObject *wpaObj = [QQApiTextObject objectWithText:params[@"qq"]];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:wpaObj];
            [QQApiInterface sendReq:req];
        }else{
            //未安装
            [MBProgressHUD showError:@"未安装qq"];
        }
    });
}
- (void)phoneCall:(id)params{
    XMJLog(@"%@",params);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *callPhone = [NSString stringWithFormat:@"tel://%@", params];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    });
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
    [shareParams SSDKSetupShareParamsByText:@"分享内容 http://www.mob.com"
                                     images:@"http://ww4.sinaimg.cn/bmiddle/005Q8xv4gw1evlkov50xuj30go0a6mz3.jpg"
                                        url:[NSURL URLWithString:@"http://www.mob.com"]
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
    
    [ShareSDK showShareActionSheet:view
                             items:nil
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
- (void)showPasswordInputView{
    self.passwordAlertView =[[PasswordAlertView alloc]initWithType:PasswordAlertViewType_sheet];
    self.passwordAlertView.delegate = self;
    self.passwordAlertView.titleLable.text = @"输入支付密码";
    self.passwordAlertView.tipsLalbe.text = @"您输入的密码不正确！";
    self.passwordAlertView.moneyLable.text = [NSString stringWithFormat:@"￥%@",self.payInfo[@"totalPrice"]];
   [self.passwordAlertView show];
    
}

#pragma mark password delegate
-(void)PasswordAlertViewCompleteInputWith:(NSString*)password{
    NSLog(@"完成了密码输入,密码为：%@",password);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = @{@"userId":[StorageUserInfromation storageUserInformation].userId,@"orderId":self.payInfo[@"orderId"],@"purchaseExplain":self.payInfo[@"purchaseExplain"],@"shippingAddrId":self.payInfo[@"addressId"],@"type":@"1",@"password":password,@"apiv":@"1.0"};
        [ZTHttpTool postWithUrl:@"jujiahe/v1/goods/payment" param:dict success:^(id responseObj) {
            NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
            NSDictionary *dict = [DictToJson dictionaryWithJsonString:str];
            NSLog(@"%@",dict);
            self.passwordAlertView.tipsLalbe.text = dict[@"msg"];
            if ([dict[@"rcode"] integerValue] == 0) {
                [self.passwordAlertView passwordCorrect];
               UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付成功" message:@"你可以在“我的”-“全部订单”中查看订单详情。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert.tag = 10;
                [alert show];
            }else{
                [self.passwordAlertView passwordError];
                [MBProgressHUD showError:dict[@"msg"]];
            }
        } failure:^(NSError *error) {
            XMJLog(@"%@",error);
            [MBProgressHUD showError:@"网络异常"];

        }];
    });
}

-(void)PasswordAlertViewDidClickCancleButton{
    NSLog(@"点击了取消按钮");
}


-(void)PasswordAlertViewDidClickForgetButton{
    NSLog(@"点击了忘记密码按钮");
    dispatch_async(dispatch_get_main_queue(), ^{
        ModifyPaymentPasswordFirstStepViewController *page = [[ModifyPaymentPasswordFirstStepViewController alloc]init];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window.currentViewController.navigationController pushViewController:page animated:YES];
        
    });
    
}
- (void)aliPay{
    NSDictionary *dict = @{@"userId":[StorageUserInfromation storageUserInformation].userId,@"orderId":self.payInfo[@"orderId"],@"purchaseExplain":self.payInfo[@"purchaseExplain"],@"shippingAddrId":self.payInfo[@"addressId"],@"type":@"2",@"password":@"",@"apiv":@"1.0"};
    [ZTHttpTool postWithUrl:@"jujiahe/v1/goods/payment" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary *dict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",dict);
        if ([dict[@"rcode"] integerValue] == 0) {
            [self aliPay:dict[@"form"]];
        }else{
            [MBProgressHUD showError:dict[@"msg"]];
        }
    } failure:^(NSError *error) {
        XMJLog(@"%@",error);
        [MBProgressHUD showError:@"网络异常"];
        
    }];
}
-(void)aliPay:(NSString *)payInfo{
    [MBProgressHUD hideHUD];
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:payInfo fromScheme:@"alisdkdemo" callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] integerValue] == 9000) {

            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付成功" message:@"你可以在“我的”-“全部订单”中查看订单详情。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 10;
            [alert show];
            
        }else{
            [MBProgressHUD showError:@"支付失败！"];
        }
        NSLog(@"reslut = %@",resultDic);
    }];
}
- (void)gotoPayActivity:(id)params{
    if (params) {
        CommunityJSVC *webVC = [[CommunityJSVC alloc]init];
        webVC.url = [NSString stringWithFormat:@"%@#!/buy?JJHH5",BASE_H5_URL];
        XMJLog(@"%@",params[@"id"]);
        webVC.orderId = params[@"id"];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window.currentViewController.navigationController pushViewController:webVC animated:YES];
    }
}
- (void)onEvent:(id)params{
    if ([params count]>1) {
        [MobClick event:params[@"point"] label:params[@"id"]];
    }else if([params count] == 1){
        [MobClick event:params[@"point"]];
        
    }
}
- (void)refreshToken:(id)params :(void(^)(id response))callBack{
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    storage.access_token = params[@"access_token"]?params[@"access_token"]:@"";
    storage.refresh_token = params[@"refresh_token"]?params[@"refresh_token"]:@"";
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
    [NSKeyedArchiver archiveRootObject:storage toFile:file];
    callBack(nil);
}
- (void)getRefreshToken:(id)params :(void(^)(id response))callBack{
//    XMJLog(@"%@",self.orderType);
    NSString * token = [StorageUserInfromation storageUserInformation].refresh_token;
    NSString *str = [NSString stringWithFormat:@"'%@'",token?token:@""];
    callBack(str);
}
- (void)gotoLoginView:(id)params{
    dispatch_async(dispatch_get_main_queue(), ^{
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:controller];
        [MBProgressHUD showError:@"登录已过期或账号已在其他终端登录" toView:controller.view];
    });
}
@end
