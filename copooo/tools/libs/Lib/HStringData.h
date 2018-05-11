//
//  HStringData.h
//  Weizhi
//
//  Created by hy on 17/2/15.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>


@interface HStringData : NSObject

#pragma mark JSONData
id _Nullable objectFromJSONData(NSData * _Nullable data);
id _Nullable objectFromString(NSString * _Nullable string);
id _Nullable objectJsonFillterFromeString(NSString * _Nullable string);
BOOL isHttpSuccessForData(id _Nullable data);
NSString * _Nullable JSONStringFromObject(id _Nullable object);
NSString * _Nullable StringValueWithData(NSData * _Nullable data);
NSData * _Nullable MyJSONDataFromObject(id _Nullable object);

BOOL StringIsValid(id _Nullable string);
NSString * _Nonnull StringWithObject(id _Nullable object);
NSInteger IntegerValueFrom(id _Nullable object);
long LongValueFrom(id _Nullable object) ;
long long LonglongValueFrom(id _Nullable object);
int IntValueFrom(id _Nullable object);
float FloatValueFrom(id _Nullable object);
CGFloat CGFloatValueFrom(id _Nullable object) ;
double DoubleValueFrom(id _Nullable object);
BOOL BoolValueFrom(id _Nullable object);
NSString * _Nullable StringPinyinFromString(NSString *_Nullable string,BOOL isTone);
NSString * _Nullable StringFromMD5WithString(NSString * _Nullable string);
//数组转成中括号[]数组
NSString *stringWithArr(NSArray *arr);

//几分钟前
NSString *_Nullable compareCricleCurrentTime(NSString * _Nullable str);
NSString *_Nullable compareChatCurrentTime(NSTimeInterval time1970);

//13位时间戳转换10位
long long time1970Withtime1970(long long time1970);

/**
 获取“消息”指定样式的时间字符串
 
 @param dateString 传入的时间字符串
 @param dateFmtString 对应的格式
 @return 处理后的时间字符串
 */
NSString *_Nullable getHandledTimeString(NSString * _Nullable dateString, NSString * _Nullable dateFmtString);

NSString *_Nullable getHandledTimeStrFromTimestamp(NSTimeInterval timetsamp);

NSString *_Nullable getNewHandledTimeString(long long dateTime);
@end
