//
//  ZTHttpTool.m
//  oneweibo
//
//  Created by zhuangtao on 15/6/3.
//  Copyright (c) 2015年 zhuangtao. All rights reserved.
//

#import "ZTHttpTool.h"
#import <AFNetworking/AFNetworking.h>
#import "CommonCrypto/CommonDigest.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ZKUDID.h"
#import "CMUUIDManager.h"
@implementation ZTHttpTool

+ (void)getWithUrl:(NSString *)url param:(NSDictionary *)params myDownloadProgress:(void(^)(NSProgress *progress))myDownloadProgress success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure{
    
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
}

+ (void)postWithUrl:(NSString *)url param:(id)params success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure{
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",textUrl,url];
//    json字符串转化为数据字典
//    NSData *jsonData = [params dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
  NSMutableDictionary  *mutableDict = [NSMutableDictionary dictionaryWithDictionary:params];

    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    if (![JGIsBlankString isBlankString:storage.uuid]) {
        [mutableDict setValue:storage.uuid forKey:@"uuid"];
    }
    if (![JGIsBlankString isBlankString:storage.userId]) {
        [mutableDict setValue:storage.userId forKey:@"userId"];
    }
    if (![url isEqualToString:@"uaa/oauth/token"]) {
        if (![JGIsBlankString isBlankString:storage.access_token]) {
            [mutableDict setValue:storage.access_token forKey:@"access_token"];
        }
    }
    
    [mutableDict setValue:@"jujiahe_app" forKey:@"device"];
    
    [mutableDict setValue:[CMUUIDManager readUUID] forKey:@"deviceCode"];

    NSString *str = [DictToJson jsonStringWithDictionary:mutableDict];
    NSLog(@"jsonstr:=====:%@",str);
//    NSString *str = [params ];
   str = [JGEncrypt encryptWithContent:str type:kCCEncrypt key:KEY];
//    str = [AESCrypt encrypt:str password:KEY];
//     NSLog(@"加密str:=====:%@",str);
//   NSString *str2 = [JGEncrypt encryptWithContent:str type:kCCDecrypt key:KEY];
//    NSLog(@"解密str2:=====:%@",str2);

    NSURL *SessionUrl = [NSURL URLWithString:BASE_URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:SessionUrl sessionConfiguration:config];
    // 加上这行代码，https ssl 验证。
    [mgr setSecurityPolicy:[ZTHttpTool customSecurityPolicy]];
    
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    mgr.requestSerializer.timeoutInterval=60;
    [mgr.requestSerializer setValue:storage.sessionId?storage.sessionId:@"" forHTTPHeaderField:@"cookie"];
    if ([url isEqualToString:@"uaa/oauth/token"]) {
        if ([params[@"grant_type"] isEqualToString:@"password"]|[params[@"grant_type"] isEqualToString:@"refresh_token"]) {
            [mgr.requestSerializer setAuthorizationHeaderFieldWithUsername:basicUserName password:basicPassword];
        }
    }
    [mgr POST:url parameters:
     @{@"data":str} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSString * str = [JGEncrypt encryptWithContent:[responseObject mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
            if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] == 9999){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:nil forKey:@"accountNo"];
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
                [MBProgressHUD showError:@"登录已过期或账号已在其他终端登录" toView:controller.view];
            }
            success(responseObject);
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSString * str = error.userInfo[@"NSLocalizedDescription"];
            
            if ([str containsString:@"401"]) {
                NSDictionary *dict2 = @{@"grant_type":@"refresh_token",@"refresh_token":storage.refresh_token?storage.refresh_token:@""};
                [self postWithUrl:@"uaa/oauth/token" param:dict2 success:^(id responseObj) {
                    NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
                    if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] == 0) {
                        NSDictionary *onceDict = [DictToJson dictionaryWithJsonString:str];
                        onceDict = onceDict[@"form"];
                        storage.access_token = onceDict[@"access_token"];
                        storage.refresh_token = onceDict[@"refresh_token"];
                        storage.uuid = onceDict[@"uuid"];
                        storage.expires_in = onceDict[@"expires_in"];
                        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
                        [NSKeyedArchiver archiveRootObject:storage toFile:file];
                        [self postWithUrl:url param:params success:^(id responseObj) {
                            success(responseObj);
                        } failure:^(NSError *error) {
                            failure(error);
                        }];
                    }
                } failure:^(NSError *error) {
                    failure(error);
                }];
            }else{
                failure(error);
            }
    }];
}
+ (void)postWithUrl2:(NSString *)url param:(id)params success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure{
    //    NSString *urlStr = [NSString stringWithFormat:@"%@%@",textUrl,url];
    //    json字符串转化为数据字典
    //    NSData *jsonData = [params dataUsingEncoding:NSUTF8StringEncoding];
    //    NSError *err;
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    NSString *str = [DictToJson jsonStringWithDictionary:params];
    //    NSLog(@"jsonstr:=====:%@",str);
    //    NSString *str = [params ];
    str = [JGEncrypt encryptWithContent:str type:kCCEncrypt key:KEY];
    //    str = [AESCrypt encrypt:str password:KEY];
    NSLog(@"加密str:=====:%@",str);
    NSString *str2 = [JGEncrypt encryptWithContent:str type:kCCDecrypt key:KEY];
    NSLog(@"解密str2:=====:%@",str2);
    
    NSURL *SessionUrl = [NSURL URLWithString:BASE_URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:SessionUrl sessionConfiguration:config];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    mgr.requestSerializer.timeoutInterval=10;
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    [mgr.requestSerializer setValue:storage.sessionId?storage.sessionId:@"" forHTTPHeaderField:@"cookie"];
    if ([url isEqualToString:@"uaa/oauth/token"]) {
        if ([params[@"grant_type"] isEqualToString:@"password"]|[params[@"grant_type"] isEqualToString:@"refresh_token"]) {
            [mgr.requestSerializer setAuthorizationHeaderFieldWithUsername:basicUserName password:basicPassword];
        }
    }
    [mgr POST:url parameters:
     @{@"data":str} progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         success(responseObject);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         failure(error);
     }];
}
+ (void)postWithImageUrl:(NSString *)url param:(id)params postImageArr:(NSArray*)postImageArr  mimeType:(NSString*)mimeType success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure{
    NSURL *SessionUrl = [NSURL URLWithString:BASE_URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:SessionUrl sessionConfiguration:config];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    // 加上这行代码，https ssl 验证。
    [mgr setSecurityPolicy:[ZTHttpTool customSecurityPolicy]];
    
    NSMutableDictionary  *mutableDict = [NSMutableDictionary dictionaryWithDictionary:params];
    
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    if (![JGIsBlankString isBlankString:storage.uuid]) {
        [mutableDict setValue:storage.uuid forKey:@"uuid"];
    }
    if (![JGIsBlankString isBlankString:storage.userId ]) {
        [mutableDict setValue:storage.userId forKey:@"userId"];
    }
    if (![url isEqualToString:@"uaa/oauth/token"]) {
        if (![JGIsBlankString isBlankString:storage.access_token]) {
            [mutableDict setValue:storage.access_token forKey:@"access_token"];
        }
    }
    [mutableDict setValue:@"jujiahe_app" forKey:@"device"];
    [mutableDict setValue:[CMUUIDManager readUUID] forKey:@"deviceCode"];
    [mgr POST:url parameters:mutableDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         NSArray * array = [postImageArr objectAtIndex:0];
         NSArray * array1 = [postImageArr objectAtIndex:1];

         // 上传 多张图片
         for(NSInteger i = 0; i < [array count]; i++) {
             NSData * picData = UIImageJPEGRepresentation([[postImageArr objectAtIndex:0] objectAtIndex: i], 1);
            UIImage * images = [UIImage imageWithData:picData];
             while ([picData length]>1024*500) {
                 
                 picData =  UIImageJPEGRepresentation(images, 0.3);
                 if ([picData length]>1024*500) {
                     images =  [StorageUserInfromation imageCompressForWidth:images targetWidth:images.size.width*0.5];
                     picData =  UIImageJPEGRepresentation(images, 0.3);

                 }
             }
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             formatter.dateFormat = @"yyyyMMddHHmmss";
             NSString *str = [formatter stringFromDate:[NSDate date]];
             NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
//             NSURL *filePath = [NSURL fileURLWithPath:[array objectAtIndex:i]];
             [formData appendPartWithFileData:picData name:[array1 objectAtIndex:i] fileName:fileName mimeType:mimeType];
         }
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString * str = [JGEncrypt encryptWithContent:[responseObject mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
            if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] == 9999){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:nil forKey:@"accountNo"];
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
                [MBProgressHUD showError:@"登录已过期或账号已在其他终端登录" toView:controller.view];
            }
             success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSString * str = error.userInfo[@"NSLocalizedDescription"];
            
            if ([str containsString:@"401"]) {
                NSDictionary *dict2 = @{@"grant_type":@"refresh_token",@"refresh_token":storage.refresh_token?storage.refresh_token:@""};
                [self postWithUrl:@"uaa/oauth/token" param:dict2 success:^(id responseObj) {
                    NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
                    if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] == 0) {
                        NSDictionary *onceDict = [DictToJson dictionaryWithJsonString:str];
                        onceDict = onceDict[@"form"];
                        storage.access_token = onceDict[@"access_token"];
                        storage.refresh_token = onceDict[@"refresh_token"];
                        storage.uuid = onceDict[@"uuid"];
                        storage.expires_in = onceDict[@"expires_in"];
                        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
                        [NSKeyedArchiver archiveRootObject:storage toFile:file];
                        [self postWithImageUrl:url param:params postImageArr:postImageArr mimeType:mimeType success:^(id responseObj) {
                            success(responseObj);
                        } failure:^(NSError *error) {
                            failure(error);
                        }];
                    }
                } failure:^(NSError *error) {
                    failure(error);
                }];
            }else{
                failure(error);
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
            }
        }];
    
}
+ (void)postWithVideoUrl:(NSString *)url param:(id)params postData:(NSData *)data name:(NSString *)name mimeType:(NSString*)mimeType success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure{
    NSURL *SessionUrl = [NSURL URLWithString:BASE_URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:SessionUrl sessionConfiguration:config];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    // 加上这行代码，https ssl 验证。
    [mgr setSecurityPolicy:[ZTHttpTool customSecurityPolicy]];
    
    NSMutableDictionary  *mutableDict = [NSMutableDictionary dictionaryWithDictionary:params];
    
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    if (![JGIsBlankString isBlankString:storage.uuid]) {
        [mutableDict setValue:storage.uuid forKey:@"uuid"];
    }
    if (![JGIsBlankString isBlankString:storage.userId ]) {
        [mutableDict setValue:storage.userId forKey:@"userId"];
    }
    if (![url isEqualToString:@"uaa/oauth/token"]) {
        if (![JGIsBlankString isBlankString:storage.access_token]) {
            [mutableDict setValue:storage.access_token forKey:@"access_token"];
        }
    }
    [mutableDict setValue:[CMUUIDManager readUUID] forKey:@"deviceCode"];

    [mgr POST:url parameters:mutableDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         formatter.dateFormat = @"yyyyMMddHHmmss";
         NSString *str = [formatter stringFromDate:[NSDate date]];
         NSString *fileName = [NSString stringWithFormat:@"%@.mp4", str];
         [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];

     } progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString * str = [JGEncrypt encryptWithContent:[responseObject mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
         if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] == 9999){
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setValue:nil forKey:@"accountNo"];
             AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
             delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
             [MBProgressHUD showError:@"登录已过期或账号已在其他终端登录" toView:controller.view];
         }
             success(responseObject);
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSString * str = error.userInfo[@"NSLocalizedDescription"];
         
         if ([str containsString:@"401"]) {
              NSDictionary *dict2 = @{@"grant_type":@"refresh_token",@"refresh_token":storage.refresh_token?storage.refresh_token:@""};
             [self postWithUrl:@"uaa/oauth/token" param:dict2 success:^(id responseObj) {
                 NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
                 if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] == 0) {
                     
                     NSDictionary *onceDict = [DictToJson dictionaryWithJsonString:str];
                     onceDict = onceDict[@"form"];
                     storage.access_token = onceDict[@"access_token"];
                     storage.refresh_token = onceDict[@"refresh_token"];
                     storage.uuid = onceDict[@"uuid"];
                     storage.expires_in = onceDict[@"expires_in"];
                     NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
                     [NSKeyedArchiver archiveRootObject:storage toFile:file];
                     
                     [self postWithVideoUrl:url param:params postData:data name:name mimeType:mimeType success:^(id responseObj) {
                         success(responseObj);
                     } failure:^(NSError *error) {
                         failure(error);
                     }];
                 }
             } failure:^(NSError *error) {
                 failure(error);
             }];
         }else{
             failure(error);
             [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
         }
     }];
}

+ (void)sendPOSTRequestInGroup:(NSString *)strURL param:(id)params success:(BlockResponse)success failure:(BlockResponseFailure)failure {
    
    dispatch_group_t group = objc_getAssociatedObject([NSOperationQueue currentQueue], &queueGroupKey);
    
    // 如果是非组请求
    if (group == nil) {
        // 执行original method
        [ZTHttpTool sendPOSTRequestInGroup:strURL param:params success:success failure:failure];
        return;
    }
    
    dispatch_group_enter(group);
    // 执行original method
    [ZTHttpTool sendPOSTRequestInGroup:strURL param:params success:^(id responseObject) {
        success(responseObject);
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        NSMutableArray *arrayM = objc_getAssociatedObject(group, &groupErrorKey);
        [arrayM addObject:error];
        failure(error);
        dispatch_group_leave(group);
    }];
}
+ (void)sendGroupPostRequest:(BlockAction)requests success:(BlockAction)success failure:(GroupResponseFailure)failure {
    if (requests == nil) {
        return;
    }
    
    dispatch_group_t group = dispatch_group_create();
    objc_setAssociatedObject(group, &groupErrorKey, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    Method originalPost = class_getClassMethod(self.class, @selector(postWithUrl:param:success:failure:));
    Method groupPost = class_getClassMethod(self.class, @selector(sendPOSTRequestInGroup:param:success:failure:));
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    objc_setAssociatedObject(queue, &queueGroupKey, group, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    queue.qualityOfService = NSQualityOfServiceUserInitiated;
    queue.maxConcurrentOperationCount = 3;
    
    [queue addOperationWithBlock:^{
        
        method_exchangeImplementations(originalPost, groupPost);
        requests();
        // 发出请求后就可以替换回original method，不必等待回调，尽量减小替换的时间窗口
        method_exchangeImplementations(originalPost, groupPost);
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSMutableArray *arrayM = objc_getAssociatedObject(group, &groupErrorKey);
            if (arrayM.count > 0) {
                if (failure) {
                    failure(arrayM.copy);
                }
            } else if(success) {
                success();
            }
            
        });
    }];
}


+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"jujiahe" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate]; //withPinnedCertificates:[[NSSet alloc] initWithObjects:certData, nil]];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    [securityPolicy setPinnedCertificates: [[NSSet alloc] initWithObjects:certData, nil]];

//    securityPolicy.pinnedCertificates =  (NSSet *)@[certData];
    
    return securityPolicy;
}
@end

