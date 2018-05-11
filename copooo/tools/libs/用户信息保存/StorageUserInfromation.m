//
//  StorageUserInfromation.m
//  letter
//
//  Created by 钟亮 on 15/8/13.
//  Copyright (c) 2015年 huangcen. All rights reserved.
//

#import "StorageUserInfromation.h"
#import <UIKit/UIKit.h>
#import "sys/sysctl.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
#import <sys/utsname.h>
@implementation StorageUserInfromation
//解档
- (id)initWithCoder:(NSCoder *)aDecoder {
    if ([super init]) {
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.sessionId = [aDecoder decodeObjectForKey:@"sessionId"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.accountBalance = [aDecoder decodeObjectForKey:@"accountBalance"];
        self.point = [aDecoder decodeObjectForKey:@"point"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.invitationCode = [aDecoder decodeObjectForKey:@"invitationCode"];
        self.invitationLink = [aDecoder decodeObjectForKey:@"invitationLink"];
        self.choseUnitPropertyId = [aDecoder decodeObjectForKey:@"choseUnitPropertyId"];
        self.choseUnitName = [aDecoder decodeObjectForKey:@"choseUnitName"];
        self.cityNumber = [aDecoder decodeObjectForKey:@"cityNumber"];
        self.currentCity = [aDecoder decodeObjectForKey:@"currentCity"];
        self.refresh_token = [aDecoder decodeObjectForKey:@"refresh_token"];
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
        self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
        self.payPasswordSet = [aDecoder decodeObjectForKey:@"payPasswordSet"];
        self.socialUnread = [aDecoder decodeObjectForKey:@"socialUnread"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.socialUnread = [aDecoder decodeObjectForKey:@"socialUnread"];
        self.systemUnread = [aDecoder decodeObjectForKey:@"systemUnread"];
        self.countShippingSend = [aDecoder decodeObjectForKey:@"countShippingSend"];
        self.countShipping = [aDecoder decodeObjectForKey:@"countShipping"];
        self.countPaying = [aDecoder decodeObjectForKey:@"countPaying"];

    }
    return self;
}
//归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.sessionId forKey:@"sessionId"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.accountBalance forKey:@"accountBalance"];
    [aCoder encodeObject:self.point forKey:@"point"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.invitationLink forKey:@"invitationLink"];
    [aCoder encodeObject:self.invitationCode forKey:@"invitationCode"];
    [aCoder encodeObject:self.choseUnitPropertyId forKey:@"choseUnitPropertyId"];
    [aCoder encodeObject:self.choseUnitName forKey:@"choseUnitName"];
    [aCoder encodeObject:self.cityNumber forKey:@"cityNumber"];
    [aCoder encodeObject:self.currentCity forKey:@"currentCity"];
    [aCoder encodeObject:self.refresh_token forKey:@"refresh_token"];
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [aCoder encodeObject:self.payPasswordSet forKey:@"payPasswordSet"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];

    [aCoder encodeObject:self.socialUnread forKey:@"socialUnread"];
    [aCoder encodeObject:self.systemUnread forKey:@"systemUnread"];
    [aCoder encodeObject:self.countShippingSend forKey:@"countShippingSend"];
    [aCoder encodeObject:self.countShipping forKey:@"countShipping"];
    [aCoder encodeObject:self.countPaying forKey:@"countPaying"];

}


+ (StorageUserInfromation *)storageUserInformation
{
    static  StorageUserInfromation *user = nil;
    if (!user) {
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
        if([NSKeyedUnarchiver unarchiveObjectWithFile:file]&& [NSKeyedUnarchiver unarchiveObjectWithFile:file] != [NSNull null]){
            user = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
        }else{
            user = [[StorageUserInfromation alloc] init];
        }
    }
    return user;
}
-(void)setSessionId:(NSString*)sessionId{
    _sessionId =[NSString stringWithFormat:@"JSESSIONID=%@",sessionId];
}
+(UIImage*)scaleToSize:(CGSize)size image:(id)self2
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    //Determine whether the screen is retina
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(size, YES, 2.0);
    }else{
        UIGraphicsBeginImageContext(size);
    }
    // 绘制改变大小的图片
    [self2 drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(UIImage*)convertViewToImage:(UIView*)v
{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (NSString*)doDevicePlatform //判断机型
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,3"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone9,4"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"])  return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])  return@"iPhone Simulator";
    
    return platform;
}

//storyBoard view自动适配
+ (void)storyBoradAutoLay:(UIView *)allView
{
    for (UIView *temp in allView.subviews) {
        temp.frame = CGRectMake(temp.frame.origin.x, temp.frame.origin.y, temp.frame.size.width, temp.frame.size.height);
        for (UIView *temp1 in temp.subviews) {
            temp1.frame = CGRectMake(temp1.frame.origin.x, temp1.frame.origin.y, temp1.frame.size.width, temp1.frame.size.height);
        }
    }
}
//等比压缩
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *) imageCompressForWidth2:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

-(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}
-(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [self jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [self jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [self jsonStringWithArray:object];
    }
    return value;
}
-(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}
-(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+(NSString *)stringFromDataString:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"MM-dd HH:mm"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+(NSString *)stringFromDataString2:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd  HH:mm"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+(NSString *)stringFromDataString3:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+(NSString *)stringFromDataString33:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"MM-dd"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+(NSString *)stringFromDataString4:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+(NSString *)stringFromDataString5:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+(NSString *)mystringFromDataString5:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+(NSString *)stringFromDataString6:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd'T'HH:mm:ss"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"MM-dd HH:mm"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+ (NSString *)minuteDescription:(NSString *)dateSting
{
    NSString *dateString=dateSting;
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date2=[dateFormatter2 dateFromString:dateString];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:date2];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    if ([theDay isEqualToString:currentDay]) {//当天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [dateFormatter stringFromDate:date2];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) {//昨天
        [dateFormatter setDateFormat:@"yy/MM/dd"];
        return [dateFormatter stringFromDate:date2];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] < 86400 * 365) {//间隔一年内
        [dateFormatter setDateFormat:@"yy/MM/dd"];
        return [dateFormatter stringFromDate:date2];
    } else {//一年以前
        NSInteger inter = [[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]];
        inter = inter/(86400 * 365);
        return [NSString stringWithFormat:@"%ld年前",inter];
    }
}
+ (NSString *)minuteDescription2:(NSString *)dateSting
{
    NSString *dateString=dateSting;
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date2=[dateFormatter2 dateFromString:dateString];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:date2];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    if ([theDay isEqualToString:currentDay]) {//当天
        return @"今天";
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) {//昨天
        return @"昨天";
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] < 86400 * 365) {//间隔一年内
        [dateFormatter setDateFormat:@"MM-dd"];
        return [dateFormatter stringFromDate:date2];
    } else {//一年以前
        NSInteger inter = [[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]];
        inter = inter/(86400 * 365);
        return [NSString stringWithFormat:@"%ld年前",inter];
    }
}

+ (NSString *)timeStrFromDateString2:(NSString *)dateString{
    // 毫秒值转化为秒
    NSDate* date2 = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]/ 1000.0];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:date2];//日期的年月日
    return theDay;
}
+ (NSString *)timeStrFromDateString3:(NSString *)dateString{
    // 毫秒值转化为秒
    NSDate* date2 = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]/ 1000.0];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *theDay = [dateFormatter stringFromDate:date2];//日期的年月日
    return theDay;
}
+(NSString *)timeStrFromDateString4:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyyy年MM月"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+(NSString *)timeStrFromDateString5:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy年MM月"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyyy-MM"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+ (NSString *)timeStrFromDateString:(NSString *)dateString{
    // 毫秒值转化为秒
    NSDate* date2 = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]/ 1000.0];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:date2];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSCalendarUnitYear;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date2];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:[NSDate date]];
    
    if ([theDay isEqualToString:currentDay]) {//当天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [dateFormatter stringFromDate:date2];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) {//昨天
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString * str = [dateFormatter stringFromDate:date2];
        return [NSString stringWithFormat:@"昨天%@",str];
    }else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400*2) {//前天
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString * str = [dateFormatter stringFromDate:date2];
        return [NSString stringWithFormat:@"前天%@",str];
    }else if ( [comp1 year] == [comp2 year]){//同一年
        [dateFormatter setDateFormat:@"MM月dd日"];
        return [dateFormatter stringFromDate:date2];
    }else{//一年以前
        [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
        return [dateFormatter stringFromDate:date2];
    }
}
+ (NSString *)dayFromDateString:(NSString *)dateString{
    
    NSDate *date = [StorageUserInfromation dateFromDateString:dateString];
    // 利用NSCalendar处理日期
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:date];
    if (day<10) {
        return [NSString stringWithFormat:@"0%ld",day];
    }
    return [NSString stringWithFormat:@"%ld",day];
}
+ (NSString *)monthFromDateString:(NSString *)dateString{
    
    NSDate *date = [StorageUserInfromation dateFromDateString:dateString];
    // 利用NSCalendar处理日期
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:date];
    NSString * monthStr = @"";
    switch (month) {
        case 1:
        {
            monthStr = @"JAN";
        }
            break;
        case 2:
        {
            monthStr = @"FEB";

        }
            break;
        case 3:
        {
            monthStr = @"MAR";

        }
            break;
        case 4:
        {
            monthStr = @"APR";

        }
            break;
        case 5:
        {
            monthStr = @"MAY";

        }
            break;
        case 6:
        {
            monthStr = @"JUN";

        }
            break;
        case 7:
        {
            monthStr = @"JUL";

        }
            break;
        case 8:
        {
            monthStr = @"AUG";

        }
            break;
        case 9:
        {
            monthStr = @"SEPT";

        }
            break;
        case 10:
        {
            monthStr = @"OCT";

        }
            break;
        case 11:
        {
            monthStr = @"NOV";

        }
            break;
        case 12:
        {
            monthStr = @"DEC";

        }
            break;
            
        default:
            break;
    }
    return monthStr;
}
+ (NSString *)weekFromDateString:(NSString *)dateString{
    
    NSDate *date = [StorageUserInfromation dateFromDateString:dateString];
    // 利用NSCalendar处理日期
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger week = [calendar component:NSCalendarUnitWeekday fromDate:date];
    NSString * weekStr = @"";
    switch (week) {
        case 2:
        {
            weekStr = @"Mon.";
        }
        break;
        case 3:
        {
            weekStr = @"Tues.";
        }
            break;
        case 4:
        {
            weekStr = @"Wed.";
        }
            break;
        case 5:
        {
            weekStr = @"Thur.";
        }
            break;
        case 6:
        {
            weekStr = @"Fri.";
        }
            break;
        case 7:
        {
            weekStr = @"Sat.";
        }
            break;
        case 1:
        {
            weekStr = @"Sun.";
        }
            break;
        default:
            break;
    }
    return weekStr;
}
+(NSDate *)dateFromDateString:(NSString *)dateString{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(为了转换成功)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // NSString * -> NSDate *
    NSDate *date = [fmt dateFromString:dateString];
    return date;
}
+(BOOL)valiMobile:(NSString *)mobile{
    if (mobile.length < 11)
    {
        return NO;
    }else{
//        /**
//         * 移动号段正则表达式
//         */
//        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
//        /**
//         * 联通号段正则表达式
//         */
//        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
//        /**
//         * 电信号段正则表达式
//         */
//        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
//        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
//        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
//        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
//        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
//        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
//        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        NSPredicate *pred4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^1[3,4,5,7,8]\\d{9}$"];
        BOOL isMatch4 = [pred4 evaluateWithObject:mobile];
        
        if (isMatch4) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}

#pragma mark 16进制转uiclor
+(UIColor *) stringTOColor:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}
#pragma mark dateTimeInterval
+(NSString*)dateTimeInterval{
    NSDate *date = [NSDate date];
    UInt64 recordTime = [date timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%llu",recordTime];
}
#pragma mark 邮箱地址的正则表达式
+(BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma mark 判断是否是同一天
+ (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
}

+(BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 6){
        // 判断长度大于6位后再接着判断是否同时包含数字和字符
        NSString * regex = @"[^ \f\n\r\t\v]{6,20}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}
/****
 iOS比较日期大小默认会比较到秒
 ****/
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result ==NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}
//时间戳转换成时间
+(NSDate *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    return date;
}
/**
 *  @brief  根据一定高度/宽度返回宽度/高度
 *  @category
 *  @param  goalString            目标字符串
 *  @param  font;                 字号
 *  @param  fixedSize;            固定的宽/高
 *  @param  isWidth;              是否是宽固定(用于区别宽/高)
 **/
// 根据文字（宽度/高度一定,字号一定的情况下）  算出高度/宽度
+ (CGSize)getStringSizeWith:(NSString *)goalString withStringFont:(CGFloat)font withWidthOrHeight:(CGFloat)fixedSize{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 3; //设置行间距
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paraStyle};
    
    CGSize   sizeC = CGSizeMake(fixedSize ,MAXFLOAT);
    
    CGSize   sizeFileName = [goalString boundingRectWithSize:sizeC
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:dic
                                                     context:nil].size;
    return sizeFileName;
}
+ (CGSize)getStringSizeWith2:(NSString *)goalString withStringFont:(CGFloat)font withWidthOrHeight:(CGFloat)fixedSize lineSpacing:(CGFloat)lineSpacing{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpacing; //设置行间距
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paraStyle};
    
    CGSize   sizeC = CGSizeMake(fixedSize ,MAXFLOAT);
    
    CGSize   sizeFileName = [goalString boundingRectWithSize:sizeC
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:dic
                                                     context:nil].size;
    return sizeFileName;
}
/**
 *  生成图片
 *
 *  @param color  图片颜色
 *  @param height 图片高度
 *
 *  @return 生成的图片
 */
+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
/**
 * 压缩图片到指定尺寸大小
 *
 * @param image 原始图片
 * @param size 目标大小
 *
 * @return 生成图片
 */
- (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIImage * resultImage = image;
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 @method 获取指定宽度width,字体大小fontSize,字符串value的高度
 @param value 待计算的字符串
 @param width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (float) heightForString:(NSString *)value andWidth:(float)width addFont:(NSInteger)fontSize{
    NSString *str = value;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.lineSpacing = 10;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
//    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    return rect.size.height;
}

@end
