//
//  HStringData.m
//  Weizhi
//
//  Created by hy on 17/2/15.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "HStringData.h"
@implementation HStringData


#pragma mark JSONData
id objectFromJSONData(NSData *data) {
    if (!data) {
        return nil;
    }
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error != nil) return nil;
    return result;
}

id objectFromString(NSString *string) {
    if (!StringIsValid(string)) {
        return nil;
    }
    NSError *error;
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    
#if defined(DEBUG) || defined(_DEBUG)
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *response = [NSMutableDictionary dictionaryWithDictionary:result];
        [response removeObjectForKey:@"debug"];
        return response;
    }
#endif
    return result;
}

id objectJsonFillterFromeString(NSString *string) {
    NSString *result = [NSString stringWithString:string];
    result = [result stringByReplacingOccurrencesOfString:@"(null)" withString:@"\"\""];
    result = [result stringByReplacingOccurrencesOfString:@"<null>" withString:@"\"\""];
    result = [result stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
    result = [result stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",[NSNull null]] withString:@"\"\""];
    return result;
}

BOOL isHttpSuccessForData(id data) {
    NSInteger resultStatus = IntegerValueFrom([data objectForKey:@"code"]);
    BOOL result = NO;
    if(resultStatus == 200){
        result = YES;
    }
    return result;
}

NSString *JSONStringFromObject(id object) {
    if (!object) {
        return nil;
    }
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

NSString *StringValueWithData(NSData *data) {
    if (!data) {
        return nil;
    }
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
    /*
     NSMutableString *buffer = [NSMutableString stringWithCapacity:([data length] * 2)];
     const unsigned char *dataBuffer = [data bytes];
     for (int i = 0; i < [data length]; ++i) {
     [buffer appendFormat:@"%02lX", (unsigned long)dataBuffer[i]];
     }
     
     return buffer;
     */
}

NSData *MyJSONDataFromObject(id object) {
    if (!object) {
        return nil;
    }
    NSError *error;
    NSData *result = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    if (error) {
        return nil;
    }
    
    return result;
}

BOOL StringIsValid(id string)
{
    if (!string) {
        return NO;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    if ([string length] == 0) {
        return NO;
    }
    return YES;
}

NSString *StringWithObject(id object) {
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    
    if ([object isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%lld", LonglongValueFrom(object)];
    }
    
    return @"";
}

NSInteger IntegerValueFrom(id object) {
    NSInteger value = 0;
    if ([object respondsToSelector:@selector(integerValue)]) {
        value = [object integerValue];
    }
    return value;
}

long LongValueFrom(id object) {
    long value = 0;
    if ([object respondsToSelector:@selector(longLongValue)]) {
        value = [object longValue];
    }
    return value;
}

long long LonglongValueFrom(id object) {
    long long value = 0;
    if ([object respondsToSelector:@selector(longLongValue)]) {
        value = [object longLongValue];
    }
    return value;
}

int IntValueFrom(id object) {
    int value = 0;
    if ([object respondsToSelector:@selector(intValue)]) {
        value = [object intValue];
    }
    return value;
}

float FloatValueFrom(id object) {
    float value = 0.f;
    if ([object respondsToSelector:@selector(floatValue)]) {
        value = [object floatValue];
    }
    return value;
}

CGFloat CGFloatValueFrom(id object) {
    CGFloat value = 0.f;
    if ([object respondsToSelector:@selector(floatValue)]) {
        value = [object floatValue];
    }
    return value;
}

double DoubleValueFrom(id object) {
    double value = 0;
    if ([object respondsToSelector:@selector(doubleValue)]) {
        value = [object doubleValue];
    }
    return value;
}

BOOL BoolValueFrom(id object) {
    BOOL value = NO;
    if ([object respondsToSelector:@selector(boolValue)]) {
        value = [object boolValue];
    }
    return value;
}

NSString * _Nullable StringPinyinFromString(NSString *_Nullable string,BOOL isTone)
{
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    if (isTone) {
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    }else {
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    }
    
    NSString *PinyinStr = [mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return PinyinStr;
}

NSString * _Nullable StringFromMD5WithString(NSString * _Nullable string)  {
    if(!StringIsValid(string))
        return @"";
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

//数组转成中括号[]数组
NSString *stringWithArr(NSArray *arr)
{
    NSString *string = @"";
    if (arr.count == 1) {
        string = [NSString stringWithFormat:@"[\"%@\"]",StringWithObject(arr.firstObject)];
    }else {
        for (int i = 0; i < arr.count;i++) {
            
            if (i == 0) {
                string = [NSString stringWithFormat:@"[\"%@\",",StringWithObject(arr[i])];
            }else if(i == arr.count - 1) {
                string = [NSString stringWithFormat:@"%@\"%@\"]",string,StringWithObject(arr[i])];
            }else {
                string = [NSString stringWithFormat:@"%@\"%@\",",string,StringWithObject(arr[i])];
            }
        }
    }
    
    return string;
}

NSString *_Nullable compareCricleCurrentTime(NSString * _Nullable str)
{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    
    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
    //timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

NSString *_Nullable compareChatCurrentTime(NSTimeInterval time1970)
{

    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time1970];
    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
    //timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    
    if ((temp = (timeInterval/60/60)/24) < 1) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"a HH:mm"];
        
        result = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:timeDate]];
    }
    else if((temp = temp/24) == 1) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm a"];
        
        result = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:timeDate]];
    }
    else if((temp = temp/30) >= 12 ) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        result = [dateFormatter stringFromDate:timeDate];
    }
    else {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        
        result = [dateFormatter stringFromDate:timeDate];
    }
    
    return  result;
}

//long long time1970Withtime1970(long long time1970)
//{
//    long long returnTime = time1970;
//    XMJLog(@"heyue-----------------------------time1970Withtime1970-1 = %lld",returnTime);
//
//    if (StringLength(StringWithObject(@(time1970))) == 13) {
//        XMJLog(@"heyue-----------------------------time1970Withtime1970-2 = %lld",time1970);
//
//        returnTime = time1970/1000;
//    }
//    XMJLog(@"heyue-----------------------------time1970Withtime1970-3 = %lld",returnTime);
//
//    return returnTime;
//}

/**
 获取“消息”指定样式的时间字符串

 @param dateString 传入的时间字符串
 @param dateFmtString 对应的格式
 @return 处理后的时间字符串
 */
NSString *_Nullable getHandledTimeString(NSString *dateString, NSString *dateFmtString) {
    
    if (dateFmtString.length == 0) {
        dateFmtString = @"yyyy-MM-dd HH:mm:ss";
    }
    
    // ------实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.AMSymbol = @"上午";
    dateFormatter.PMSymbol = @"下午";
    [dateFormatter setDateFormat:dateFmtString];//这里的格式必须和DateString格式一致
    // ------将需要转换的时间转换成 NSDate 对象
    NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
    
    NSDate * nowDate = [NSDate date];
    
    
    // ------取当前时间和转换时间两个日期对象的时间间隔
    NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
    
    // ------再然后，把间隔的秒数折算成天数和小时数：
    NSString *dateStr = [[NSString alloc] init];
    
    if (time<=60) {  //1分钟以内的
        
        dateStr = @"刚刚";
        
    }else if(time<=60*60){  //一个小时以内的
        
        int mins = time/60;
        dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
        
    }else if(time<=60*60*24){  //在两天内的
        
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
        NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
        
        if ([need_yMd isEqualToString:now_yMd]) {
            [dateFormatter setDateFormat:@"aaa HH:mm"];
            //在同一天
            dateStr = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:needFormatDate]];
        }else{
            //昨天
            [dateFormatter setDateFormat:@"HH:mm"];
            dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
        }
    }else {
        
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *yearStr = [dateFormatter stringFromDate:needFormatDate];
        NSString *nowYear = [dateFormatter stringFromDate:nowDate];
        
        if ([yearStr isEqualToString:nowYear]) {
            //在同一年
            [dateFormatter setDateFormat:@"MM月dd日"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }else{
            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }
    }
    
    return dateStr;
}


NSString * _Nullable getHandledTimeStrFromTimestamp(NSTimeInterval timetsamp) {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timetsamp];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSString *fmt = @"yyyy年MM月dd日 HH:mm:ss";
    format.dateFormat = fmt;
    NSString *string = [format stringFromDate:date];
    return getHandledTimeString(string, fmt);
}

/**
 获取“消息”指定样式的时间字符串
 
 @param dateTime 传入的时间
 @return 处理后的时间字符串
 */
NSString *_Nullable getNewHandledTimeString(long long dateTime) {
    // ------实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateFmtString = @"yyyy-MM-dd HH:mm:ss";
    dateFormatter.AMSymbol = @"上午";
    dateFormatter.PMSymbol = @"下午";
    // ------将需要转换的时间转换成 NSDate 对象
    [dateFormatter setDateFormat:dateFmtString];
    NSDate * needFormatDate = [NSDate dateWithTimeIntervalSince1970:dateTime];
    NSDate * nowDate = [NSDate date];
    
    XMJLog(@"heyue-----------------------------getNewHandledTimeString = %@",[dateFormatter stringFromDate:needFormatDate]);
    
    // ------取当前时间和转换时间两个日期对象的时间间隔
    long long time = [nowDate timeIntervalSinceDate:needFormatDate];
    
    // ------再然后，把间隔的秒数折算成天数和小时数：
    NSString *dateStr = [[NSString alloc] init];
    
    if (time<=60) {  //1分钟以内的
        
        dateStr = @"刚刚";
        
    }else if(time<=60*60){  //一个小时以内的
        
        long long mins = time/60;
        dateStr = [NSString stringWithFormat:@"%lld分钟前",mins];
        
    }else if(time<=60*60*24){  //在两天内的
        
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
        NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
        
        if ([need_yMd isEqualToString:now_yMd]) {
            [dateFormatter setDateFormat:@"aaa HH:mm"];
            //在同一天
            dateStr = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:needFormatDate]];
        }else{
            //昨天
            [dateFormatter setDateFormat:@"HH:mm"];
            dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
        }
    }else {
        
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *yearStr = [dateFormatter stringFromDate:needFormatDate];
        NSString *nowYear = [dateFormatter stringFromDate:nowDate];
        
        if ([yearStr isEqualToString:nowYear]) {
            //在同一年
            [dateFormatter setDateFormat:@"MM月dd日"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }else{
            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }
    }
    
    return dateStr;
}
@end
