//
//  ZTHttpTool.h
//
//  Created by zhuangtao on 15/6/3.
//  Copyright (c) 2015年 zhuangtao. All rights reserved.
//
/**
 *  封装一个网络请求类，让整个项目不直接依赖于网络请求（AFN，ASI）框架，降低controller的耦合性
 */
#import <Foundation/Foundation.h>
typedef void(^BlockAction)(void);
typedef void(^GroupResponseFailure)(NSArray * errorArray);
typedef void(^BlockResponseFailure)(NSError *error);
typedef void(^BlockResponse)(id responseObject);
static char groupErrorKey;
static char queueGroupKey;

@interface ZTHttpTool : NSObject
/**
 *  get
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后回调函数
 *  @param failure 请求失败后回调函数
 */
+ (void)getWithUrl:(NSString *)url param:(NSDictionary *)params myDownloadProgress:(void(^)(NSProgress *progress))myDownloadProgress success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure;

+ (void)postWithUrl:(NSString *)url param:(id)params success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure;
+ (void)sendGroupPostRequest:(BlockAction)requests success:(BlockAction)success failure:(GroupResponseFailure)failure;
//+ (void)postWithUrl2:(NSString *)url param:(id)params success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure;
//批量上传图片
+ (void)postWithImageUrl:(NSString *)url param:(id)params postImageArr:(NSArray*)postImageArr  mimeType:(NSString*)mimeType success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure;
//上传视频
+ (void)postWithVideoUrl:(NSString *)url param:(id)params postData:(NSData *)data name:(NSString *)name mimeType:(NSString*)mimeType success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure;
@end
