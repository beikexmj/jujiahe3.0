//
//  StorageUserInfromation.h
//  letter
//
//  Created by 钟亮 on 15/8/13.
//  Copyright (c) 2015年 huangcen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StorageUserInfromation : NSObject
@property (nonatomic, strong)NSString       *userId;//用户id
@property (nonatomic, strong)NSString       *nickname;//昵称
@property (nonatomic, strong)NSString       *username;//手机号
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *sessionId;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *accountBalance;
@property (nonatomic, copy) NSString *point;//合币;
@property (nonatomic, copy) NSString *sex;//性别;-1无，0男，1女；
@property (nonatomic, copy) NSString *refresh_token;//
@property (nonatomic, copy) NSString *access_token;//
@property (nonatomic, copy) NSString *uuid;//
@property (nonatomic, copy) NSString *expires_in;//失效时间
@property (nonatomic,copy) NSString *invitationCode;//邀请码
@property (nonatomic,copy) NSString *invitationLink;//二维码生成链接
@property (nonatomic, copy) NSString *payPasswordSet;
@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, copy) NSString *socialUnread;
@property (nonatomic, copy) NSString *systemUnread;
@property (nonatomic, copy) NSString *countShippingSend;
@property (nonatomic, copy) NSString *countShipping;
@property (nonatomic, copy) NSString *countPaying;

@property (nonatomic,copy) NSString *choseUnitPropertyId;
@property (nonatomic,copy) NSString *choseUnitName;
@property (nonatomic,copy) NSString *cityNumber;
@property (nonatomic,copy) NSString *currentCity;

+ (StorageUserInfromation *)storageUserInformation;

+(UIImage*)scaleToSize:(CGSize)size image:(UIImage *)image;
-(UIImage*)convertViewToImage:(UIView*)v;
+(NSString*)doDevicePlatform;

+ (void)storyBoradAutoLay:(UIView *)allView;
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
-(NSString *) jsonStringWithObject:(id) object;
-(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;
+(NSString *)stringFromDataString:(NSString *)str;//时间转换
+(NSString *)stringFromDataString2:(NSString *)str;
+(NSString *)stringFromDataString3:(NSString *)str;
+(NSString *)stringFromDataString33:(NSString *)str;
+(NSString *)stringFromDataString4:(NSString *)str;
+(NSString *)stringFromDataString5:(NSString *)str;
+(NSString *)stringFromDataString6:(NSString *)str;
+(NSString *)mystringFromDataString5:(NSString *)str;
+(UIImage *) imageCompressForWidth2:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
+ (NSString *)minuteDescription:(NSString *)dateSting;
+ (NSString *)minuteDescription2:(NSString *)dateSting;
+ (NSString *)timeStrFromDateString:(NSString *)dateString;//内蒙2时间转化（2017-11-17新增）
+ (NSString *)timeStrFromDateString2:(NSString *)dateString;//（2018-3-2新增）
+ (NSString *)timeStrFromDateString3:(NSString *)dateString;//（2018-3-2新增）
+(NSString *)timeStrFromDateString4:(NSString *)str;//（2018-3-19新增）
+(NSString *)timeStrFromDateString5:(NSString *)str;//（2018-3-21新增）
//+(void)initTableViewRefresh:(UITableView*)myTableView Url:(NSString*)url array:(NSMutableArray*)array controller:(JGBaseViewController*)controller;
//+(void)initColletionViewRefresh:(UICollectionView*)myTableView Url:(NSString*)url array:(NSMutableArray*)array controller:(JGBaseViewController*)controller;
//+(void)initScrollViewRefresh:(UIScrollView*)myTableView Url:(NSString*)url array:(NSMutableArray*)array controller:(JGBaseViewController*)controller;


+ (NSString *)dayFromDateString:(NSString *)dateString;
+ (NSString *)monthFromDateString:(NSString *)dateString;
+ (NSString *)weekFromDateString:(NSString *)dateString;


/**
 *  检查手机号码合法性
 */
+(BOOL)valiMobile:(NSString *)mobile;

/**
 *  16进制转uiclor
 *
 *  @param UIColor 输出颜色
 *
 */
#pragma mark 16进制转uiclor
+(UIColor *) stringTOColor:(NSString *)str;

+(NSString*)dateTimeInterval;
+(BOOL)isValidateEmail:(NSString *)email;
//判断是否是同一天
+ (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2;
//密码6-20位
+(BOOL)judgePassWordLegal:(NSString *)pass;
/****
 iOS比较日期大小默认会比较到秒
 ****/
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
//时间戳转换成时间
+(NSDate *)timeWithTimeIntervalString:(NSString *)timeString;
// 字符串高度
+ (CGSize)getStringSizeWith:(NSString *)goalString withStringFont:(CGFloat)font withWidthOrHeight:(CGFloat)fixedSize; //间隔3
+ (CGSize)getStringSizeWith2:(NSString *)goalString withStringFont:(CGFloat)font withWidthOrHeight:(CGFloat)fixedSize lineSpacing:(CGFloat)lineSpacing; //间隔lineSpacing
+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height;
- (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size;
+ (float) heightForString:(NSString *)value andWidth:(float)width addFont:(NSInteger)fontSize;
@end


