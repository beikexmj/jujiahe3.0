//
//  HPublic.m
//  Weizhi
//
//  Created by hy on 17/2/15.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "HPublic.h"
#import "HStringData.h"
#include <sys/param.h>
#include <sys/mount.h>
#include <sys/sysctl.h>
#import <AVFoundation/AVFoundation.h>
#import "SKPSMTPMessage.h"
@interface HPublic()<SKPSMTPMessageDelegate>
{
    sucessEmailBlock _emailSuc;
    failEmailBlock _emailFail;
}


@end

@implementation HPublic

+(instancetype)shareInstance
{
    static dispatch_once_t pred;
    __strong static HPublic *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[HPublic alloc] init];
    });
    return sharedInstance;
}


#pragma mark 快捷方法

//得到字节数函数
NSInteger StringLength(NSString * _Nullable strtemp) {
    if (!StringIsValid(strtemp)) {
        return 0;
    }
    
    return strtemp.length;
}

//得到字节数函数
NSInteger StringConvertToInt(NSString * _Nullable strtemp) {
    if (!StringIsValid(strtemp)) {
        return 0;
    }
    //strtemp = [@" " stringByAppendingString:strtemp];
    
    NSInteger strlength = 0;
    
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    NSInteger a = 0;
    if ([strtemp containsString:@"一"]) {
        a = 1;
    }
    return strlength+a;
}

float LikePercent(NSString * _Nullable ori, NSString * _Nullable target) {
    NSUInteger n = ori.length;
    NSUInteger m = target.length;
    if (m==0) return n;
    if (n==0) return m;
    
    //Construct a matrix, need C99 support
    int matrix[n+1][m+1];
    memset(&matrix[0], 0, m+1);
    for(int i=1; i<=n; i++) {
        memset(&matrix[i], 0, m+1);
        matrix[i][0]=i;
    }
    for(int i=1; i<=m; i++) {
        matrix[0][i]=i;
    }
    for(int i=1;i<=n;i++) {
        unichar si = [ori characterAtIndex:i-1];
        for(int j=1;j<=m;j++)
        {
            unichar dj = [target characterAtIndex:j-1];
            int cost;
            if(si==dj){
                cost=0;
            }
            else{
                cost=1;
            }
            const int above=matrix[i-1][j]+1;
            const int left=matrix[i][j-1]+1;
            const int diag=matrix[i-1][j-1]+cost;
            matrix[i][j]=MIN(above,MIN(left,diag));
        }
    }
    
    return 100.0 - 100.0*matrix[n][m]/ori.length;
}

BOOL HasChinese(NSString * _Nullable strtemp) {
    for (int i = 0; i < strtemp.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [strtemp substringWithRange:range];
        if (!StringIsValid(subString)) {
            continue;
        }
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {
            return YES;
        }
        /*
         int a = [strtemp characterAtIndex:i];
         if( a > 0x4e00 && a < 0x9fff) {
         return YES;
         }
         */
    }
    return NO;
}

//BOOL IsNetwork() {
//    return GetNetworkStatus() != NotReachable;
//}
//
//NetworkStatus GetNetworkStatus() {
//    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
//    return networkStatus;
//}

/*手机号码验证 MODIFIED BY HELENSONG*/
BOOL IsValidateMobile(NSString * _Nullable mobile)
{
    if (!StringIsValid(mobile)) {
        return NO;
    }
    if (mobile.length < 11) {
        return NO;
    }
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,(增加)181,171,173,177
     22         */
    NSString * CT = @"^1((33|53|8[019]|7[0137])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobile]
         ||
         [regextestcm evaluateWithObject:mobile]
         ||
         [regextestct evaluateWithObject:mobile]
         ||
         [regextestcu evaluateWithObject:mobile])) {
        return YES;
    }
    
    return NO;
}

//验证邮箱的合法性
BOOL IsValidateEmail(NSString *email) {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


void AfterDispatch(double delayInSeconds, dispatch_block_t _Nullable block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

void MainDispatch(dispatch_block_t _Nullable block) {
    dispatch_async(dispatch_get_main_queue(), block);
}

void GlobalDispatch(dispatch_block_t _Nullable block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

CGSize getImgWithSize(CGSize originalSize)
{
    CGSize size = CGSizeZero;
    NSInteger multiple = 2;
    
    CGFloat maxWidth = SCREENWIDTH * 0.3;  //限制最大宽度或高度
    CGFloat imageViewW = originalSize.width/multiple;
    CGFloat imageViewH = originalSize.height/multiple;
    
    CGFloat factor = 1.0f;
    
    if(imageViewW > maxWidth) {
        
        factor = maxWidth/imageViewW;
        imageViewW = imageViewW*factor;
        imageViewH = imageViewH*factor;
        
    }else if (imageViewH > maxWidth) {
        
        factor = maxWidth/imageViewH;
        imageViewW = MAX(imageViewW*factor,maxWidth);  //限制宽度不能超过200.0
        imageViewH = imageViewH*factor;
    }
    
    size = CGSizeMake(imageViewW, imageViewH);
    
    return size;
}


#pragma mark 语言
NSString *_curLan = nil;

NSString * _Nonnull mylocallang(NSString *key) {
    if (!StringIsValid(key)) {
        return @"";
    }
    
    return key;
}

NSString * _Nullable CurrentLanguage()
{
    if (StringIsValid(_curLan)) {
        return _curLan;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = languages.firstObject;
    if (!StringIsValid(currentLang)) {
        _curLan = @"en";
    }else {
        NSArray *_s = [currentLang componentsSeparatedByString:@"-"];
        _curLan = _s.firstObject;
    }
    //[[AFNetworkClient shareInstance] upLanguage:currentLang];
    
    return _curLan;
    //zh-Hans   简体中文
    //zh-Hant   繁体中文
    //zh-HK     繁体中文香港
    //en        英语
    //ja        日语
    //ko        韩语
    //fr        法语
    
    /*
     AppleLanguages =     @[@"zh-Hans",
     @"en",
     @"fr",
     @"de",
     @"ja",
     @"nl",
     @"it",
     @"es",
     @"pt",
     @"pt-PT",
     @"da",
     @"fi",
     @"nb",
     @"sv",
     @"ko",
     @"zh-Hant",
     @"ru",
     @"pl",
     @"tr",
     @"uk",
     @"ar",
     @"hr",
     @"cs",
     @"el",
     @"he",
     @"ro",
     @"sk",
     @"th",
     @"id",
     @"en-GB",
     @"ca",
     @"hu",
     @"vi"];
     */
}

NSString * _Nullable CurInputMode()
{
    NSString *mode = nil;
    NSArray *modes = [UITextInputMode activeInputModes];
    if (modes.count > 0) {
        mode = [modes[0] primaryLanguage];
    }
    return mode;
}

NSString * _Nullable getCurrentLanguageString() {
    NSString *languageString = mylocallang(@"英语");
    if ([@"zh" isEqualToString:CurrentLanguage()]) {
        languageString = mylocallang(@"简体中文");
    }else if ([@"en" isEqualToString:CurrentLanguage()]) {
        languageString = mylocallang(@"英语");
    }else if ([@"fr" isEqualToString:CurrentLanguage()]) {
        languageString = mylocallang(@"法语");
    }else if ([@"ja" isEqualToString:CurrentLanguage()]) {
        languageString = mylocallang(@"日语");
    }else if ([@"ko" isEqualToString:CurrentLanguage()]) {
        languageString = mylocallang(@"韩语");
    }
    
    return languageString;
}



#pragma mark 时间
NSString * _Nonnull TimeBefore(NSDate * _Nullable date) {
    if (date == nil) {
        return @"";
    }
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSDate *now = [NSDate date];
    NSTimeInterval nowinterval = [now timeIntervalSince1970];
    NSTimeInterval before = nowinterval-interval;
    NSString *str = mylocallang(@"前");
    if (before < 3600) {
        int min = before/60;
        if (min == 0) {
            min++;
        }
        NSString *minstr = [[NSString stringWithFormat:@"%d", min] stringByAppendingString:mylocallang(@"分钟")];
        
        str = [minstr stringByAppendingString:str];
    } else if (before < 3600*24) {
        int hour = before/3600;
        
        if (hour == 0) {
            hour++;
        }
        NSString *hourstr = [[NSString stringWithFormat:@"%d", hour] stringByAppendingString:mylocallang(@"小时")];
        
        str = [hourstr stringByAppendingString:str];
    } else {
        int day = before/(3600*24);
        
        if (day == 0) {
            day++;
        }
        NSString *daystr = [[NSString stringWithFormat:@"%d", day] stringByAppendingString:mylocallang(@"天")];
        
        str = [daystr stringByAppendingString:str];
    }
    return str;
}

#pragma mark 钥匙链
#define uniqueDeviceIdentifierKey           @"H_uniqueDeviceIdentifierKey_H"

NSMutableDictionary *GetKeychainQuery(NSString *service) {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

void SaveKeychain(NSString *service, id data) {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = GetKeychainQuery(service);
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

id LoadKeychain(NSString *service) {
    id ret = nil;
    NSMutableDictionary *keychainQuery = GetKeychainQuery(service);
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

void DeleteKeychain(NSString *service) {
    NSMutableDictionary *keychainQuery = GetKeychainQuery(service);
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

NSString * _Nullable LocalUniqueDeviceIdentifier() {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"LocalUniqueDeviceIdentifier"];
}

void SaveLocalUniqueDeviceIdentifier(NSString * _Nullable uuid) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:uuid forKey:@"LocalUniqueDeviceIdentifier"];
    [defaults synchronize];
}

NSString * _Nullable GetUniqueDeviceIdentifier() {
    //SaveLocalUniqueDeviceIdentifier(@"uniqueDeviceIdentifierKey_test");
    
    NSString *uuid = LocalUniqueDeviceIdentifier();
    if (!StringIsValid(uuid)) {
        uuid = LoadKeychain(uniqueDeviceIdentifierKey);
        if (!StringIsValid(uuid)) {
            uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            uuid = StringFromMD5WithString(uuid);
            SaveKeychain(uniqueDeviceIdentifierKey, uuid);
        }
        
        SaveLocalUniqueDeviceIdentifier(uuid);
    }
    
    return uuid;
}

#pragma mark 系统
//获取磁盘总容量
unsigned long long getTotalDiskSize()
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return freeSpace;
}

//获取磁盘剩余容量
unsigned long long getAvailableDiskSize()
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return freeSpace;
}


//容量转换
NSString * _Nullable fileSizeToString(unsigned long long fileSize){
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    if (fileSize < 10) {
        return @"0 B";
        
    }else if (fileSize < KB) {
        return @"< 1 KB";
        
    }else if (fileSize < MB)  {
        return [NSString stringWithFormat:@"%.1f KB",((CGFloat)fileSize)/KB];
        
    }else if (fileSize < GB)  {
        return [NSString stringWithFormat:@"%.1f MB",((CGFloat)fileSize)/MB];
        
    }else {
        return [NSString stringWithFormat:@"%.1f GB",((CGFloat)fileSize)/GB];
    }
}

//获取本机名称
NSString * _Nullable GetPhoneName()
{
    NSString *phoneName = [[UIDevice currentDevice] name];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）￥「」“”＂、”[]{}#%-*+=_\\|~＜＞$€^·'@#$%^&*()”_+'\""];
    phoneName = [phoneName stringByTrimmingCharactersInSet:set];
    phoneName = [phoneName stringByReplacingOccurrencesOfString:@"“" withString:@""];
    phoneName = [phoneName stringByReplacingOccurrencesOfString:@"”" withString:@""];
    phoneName = [phoneName stringByReplacingOccurrencesOfString:@"“" withString:@""];
    phoneName = [phoneName stringByReplacingOccurrencesOfString:@"iPhone" withString:@""];
    phoneName = [phoneName stringByReplacingOccurrencesOfString:@"的" withString:@""];
    phoneName = [phoneName stringByReplacingOccurrencesOfString:@"de" withString:@""];

    phoneName = [NSString stringWithFormat:@"%@%@的导入",phoneName,GetDevicePlatform()];

    if ([phoneName isEqualToString:@""]) {
        phoneName = GetDevicePlatform();
    }
    
    return phoneName;
}


//获取本机型号
NSString * _Nullable GetDevicePlatform()
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";// (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";// (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";// (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";// (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";// (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";// (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";// (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";// (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";// (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";// (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";// (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";// (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";// (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";// (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";// (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s Plus";// (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s";// (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7 Plus";// (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7";// (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1";// (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2";// (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3";// (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4";// (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5";// (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1";// (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";// (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";// (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";// (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";// (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1";// (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1";// (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1";// (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";// (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";// (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";// (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";// (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";// (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";// (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";// (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";// (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";// (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2";// (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2";// (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2";// (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

//对话框
void ShowMsgAlert(NSString * _Nullable title,NSString * _Nullable msg)
{
//    [UIAlertView bk_showAlertViewWithTitle:title message:msg cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//
//    }];
}

//是否是数字
BOOL inputShouldNumber(NSString * _Nullable inputString) {
    
    if (inputString.length == 0) return NO;
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

//是否是数字或字母
BOOL inputShouldLetterOrNum(NSString * _Nullable inputString) {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

//获取自定义缓存地址
NSString * _Nullable getAppDir(NSString * _Nullable inputString)
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directryPath = [path stringByAppendingPathComponent:@"WeizhiApp"];
    if (StringIsValid(inputString)) {
        directryPath = [directryPath stringByAppendingPathComponent:inputString];
    }
    if (![fileManager fileExistsAtPath:directryPath]) {
        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    XMJLog(@"App directryPath = %@",directryPath);
    return directryPath;
}


//正则去除HTML网络标签
NSString * _Nullable filterHtmlwithString(NSString * _Nullable string)
{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n|&nbsp"
                                                                                    options:0
                                                                                      error:nil];
    NSString *newstring=[regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    return newstring;
}
//正则获取HTML <img> 网络标签
NSArray *_Nullable filterHtmlImgWithString(NSString * _Nullable htmlText)
{
    if (htmlText == nil) {
        return nil;
    }
    
    
    NSMutableArray * imageurlArray = [NSMutableArray arrayWithCapacity:1];
    
    //标签匹配
    NSString *parten = @"<img(.*?)>";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    
    NSArray* match = [reg matchesInString:htmlText options:0 range:NSMakeRange(0, [htmlText length] - 1)];
    
    for (NSTextCheckingResult * result in match) {
        
        //过去数组中的标签
        NSRange range = [result range];
        NSString * subString = [htmlText substringWithRange:range];
        
        
        //从图片中的标签中提取ImageURL
        NSRegularExpression *subReg = [NSRegularExpression regularExpressionWithPattern:@"http://(.*?)\"" options:0 error:NULL];
        NSArray* match = [subReg matchesInString:subString options:0 range:NSMakeRange(0, [subString length] - 1)];
        NSTextCheckingResult * subRes = match[0];
        NSRange subRange = [subRes range];
        subRange.length = subRange.length -1;
        NSString * imagekUrl = [subString substringWithRange:subRange];
        
        //将提取出的图片URL添加到图片数组中
        [imageurlArray addObject:imagekUrl];
    }
    
    return imageurlArray;
}

//表情符号的判断
BOOL stringContainsEmoji(NSString *_Nullable string)
{
    __block BOOL returnValue = NO;
    if (!StringIsValid(string)) {
        return returnValue;
    }
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
    
}

/**
 *  mov格式转mp4格式
 */

void movFileTransformToMP4WithSourceUrl(NSURL * _Nullable sourceUrl, TansformVedioCompleted _Nullable comepleteBlock,TansformVedioFail _Nullable failBlock)
{

    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    XMJLog(@"%@",compatiblePresets);
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *uniqueName = [NSString stringWithFormat:@"%@.mp4",[formatter stringFromDate:date]];
        
        NSString *PATH_OF_DOCUMENT = getAppDir(@"");
        NSString * resultPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:uniqueName]; //PATH_OF_DOCUMENT为documents路径
        XMJLog(@"output File Path : %@",resultPath);
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4;//可以配置多种输出文件格式
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
             
             switch (exportSession.status) {
                     
                 case AVAssetExportSessionStatusUnknown:
                     //                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     if (failBlock) {
                         failBlock();
                     }
                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     //                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     if (failBlock) {
                         failBlock();
                     }
                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     //                     NSLog(@"AVAssetExportSessionStatusExporting");
                     if (failBlock) {
                         failBlock();
                     }
                     
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:
                 {
                     //                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     
                     if (comepleteBlock) {
                         comepleteBlock(resultPath);
                     }
                     
                     XMJLog(@"mp4 file size:%lf MB",[NSData dataWithContentsOfURL:exportSession.outputURL].length/1024.f/1024.f);
                 }
                     break;
                     
                 case AVAssetExportSessionStatusFailed:
                     //                     NSLog(@"AVAssetExportSessionStatusFailed");
                     if (failBlock) {
                         failBlock();
                     }
                     
                     break;
                     
                 case AVAssetExportSessionStatusCancelled:
                     //                     NSLog(@"AVAssetExportSessionStatusFailed");
                     if (failBlock) {
                         failBlock();
                     }
                     
                     break;
                 default:
                     break;
             }
         }];
    }
}

#pragma mark 音乐

void PlayEffectSound(NSString * _Nullable sound,NSString * _Nullable type)
{
    if ([[AVAudioSession sharedInstance] isOtherAudioPlaying]) {
        return;
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSString *thesoundFilePath = [[NSBundle mainBundle] pathForResource:sound ofType:type];    //创建音乐文件路径
    if (!StringIsValid(thesoundFilePath)) {
        return;
    }
    
    CFURLRef thesoundURL = (__bridge CFURLRef) [NSURL fileURLWithPath:thesoundFilePath];
    SystemSoundID sameViewSoundID;
    AudioServicesCreateSystemSoundID(thesoundURL, &sameViewSoundID);
    //变量SoundID与URL对应
    AudioServicesPlaySystemSound(sameViewSoundID);  //播放SoundID声音
}


FileType getFileType(NSString * _Nullable pathEx)
{
    FileType fileType = FileTypeUnknown;
    
    NSArray *videoEx = @[@"3gp", @"avi",@"flv", @"mkv",@"mov", @"mp4",@"rmvb",@"vob", @"wmv",@"asf",@"dat",@"f4v",@"mod",@"mpe",@"mpeg",@"mpg",@"m4v",@"flv",@"fla",@"swf",@"vcd",@"svcd",@"dvd",@"ts",@"mts",@"tod",@"3GP", @"AVI",@"FLV", @"MKV",@"MOV", @"MP4",@"RMVB",@"VOB", @"WMV",@"ASF",@"DAT",@"F4V",@"MOD",@"MPE",@"MPEG",@"MPG",@"M4V",@"FLV",@"FLA",@"SWF",@"VCD",@"SVCD",@"DVD",@"TS",@"MTS",@"TOD"];
    NSArray *photoEx = @[@"bmp", @"ico", @"jpg", @"pcx", @"png", @"tga", @"tif",@"tiff", @"jpeg", @"webp", @"gif",@"BMP", @"ICO", @"JPG", @"PCX", @"PNG", @"TGA", @"TIFF",@"TIF", @"JPEG", @"WEBP", @"GIF"];
    
    NSArray *audioEx = @[@"aac", @"amr",@"ape", @"flac",@"m4a", @"m4r",@"mmf", @"mp2",@"mp3", @"ogg",@"wav",@"wma",@"wv",@"acc",@"ace",@"aiff",@"ape",@"wave",@"mid",@"midi",@"xmf",@"AAC", @"AMR",@"APE", @"FLAC",@"M4A", @"M4R",@"MMF", @"MP2",@"MP3", @"OGG",@"WAV",@"WMA",@"WV",@"ACC",@"ACE",@"AIFF",@"APE",@"WAVE",@"MID",@"MIDI",@"XMF"];
    
    NSArray *zipEx = @[@"zip", @"rar",@"tar", @"gzip",@"uue", @"7-zip",@"jar", @"iso",@"dmg",@"7z",@"cab",@"compressed",@"uue",@"bz2",@"xz",@"z",@"arj",@"ZIP", @"RAR",@"TAR", @"GZIP",@"UUE", @"7-ZIP",@"JAR", @"ISO",@"DMG",@"7Z",@"CAB",@"COMPRESSED",@"UUE",@"BZ2",@"XZ",@"Z",@"ARJ"];
    
    NSArray *textEx = @[@"txt",@"webm",@"h",@"m",@"c",@"cpp",@"hpp",@"rb",@"go",@"TXT",@"WEBM",@"H",@"M",@"C",@"CPP",@"HPP",@"RB",@"GO"];
    
    if ([videoEx containsObject:[pathEx lowercaseString]]) {
        fileType = FileTypeVideo;
    }else if([photoEx containsObject:[pathEx lowercaseString]]) {
        fileType = FileTypePhoto;
    }else if([audioEx containsObject:[pathEx lowercaseString]]) {
        fileType = FileTypeAudio;
    }else if([@"docx" isEqualToString:[pathEx lowercaseString]] || [@"doc" isEqualToString:[pathEx lowercaseString]]) {
        fileType = FileTypeWord;
    }else if([@"xlsx" isEqualToString:[pathEx lowercaseString]] || [@"xls" isEqualToString:[pathEx lowercaseString]]) {
        fileType = FileTypeXls;
    }else if([@"xml" isEqualToString:[pathEx lowercaseString]]) {
        fileType = FileTypeXml;
    }else if([@"exe" isEqualToString:[pathEx lowercaseString]]) {
        fileType = FileTypeExe;
    }else if([@"pdf" isEqualToString:[pathEx lowercaseString]]) {
        fileType = FileTypePdf;
    }else if([@"html" isEqualToString:[pathEx lowercaseString]] || [@"htm" isEqualToString:[pathEx lowercaseString]]) {
        fileType = FileTypeHtml;
    }else if([zipEx containsObject:[pathEx lowercaseString]]) {
        fileType = FileTypeZip;
    }else if([@"rtf" isEqualToString:[pathEx lowercaseString]]) {
        fileType = FileTypeRTF;
    }else if([textEx containsObject:[pathEx lowercaseString]]) {
        fileType = FileTypeTxt;
    }else if([@"ppt" isEqualToString:[pathEx lowercaseString]] || [@"pptx" isEqualToString:[pathEx lowercaseString]]) {
        fileType = FileTypePPT;
    }
    
    return fileType;
}

//用户是否允许推送
BOOL isAllowedNotification()
{
    if (IOS_VERSION_8_OR_ABOVE) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    } else {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    
    return NO;
}



/**
 *  静默发送邮件【腾讯】
 */
-(void)sendTenEmail:(NSString *)mailContent suc:(sucessEmailBlock )suc fail:(failEmailBlock ) fail;
{
    _emailSuc = suc;
    _emailFail = fail;
    
    SKPSMTPMessage *myMessage = [[SKPSMTPMessage alloc] init];
    myMessage.fromEmail = @"cdhware@163.com"; //发送邮箱
    myMessage.toEmail = @"1053715398@qq.com"; //收件邮箱
    myMessage.bccEmail = @"1171256145@qq.com";//抄送
    
    myMessage.relayHost = @"smtp.163.com";//发送地址host 网易企业邮箱
    //myMessage.relayPorts = @[@(25)];
    myMessage.requiresAuth = YES;
    myMessage.login = @"cdhware@163.com";//发送邮箱的用户名
    myMessage.pass = @"zhu123456";//发送邮箱的密码 zhu123456
    
    myMessage.connectTimeout = 60;
    
    myMessage.wantsSecure = YES;
    myMessage.subject = @"11"; //邮件主题
    myMessage.delegate = self;
    
    
    NSDictionary *plainPart = @{kSKPSMTPPartContentTypeKey : @"text/plain", kSKPSMTPPartMessageKey : mailContent, kSKPSMTPPartContentTransferEncodingKey : @"8bit"};
    
    myMessage.parts = [NSArray arrayWithObjects:plainPart,nil];
    
    [myMessage send];
    
}

- (void)messageSent:(SKPSMTPMessage *)message
{
    NSLog(@"邮件发送成功");
    if (_emailSuc) {
        _emailSuc();
    }
    
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    
    //self.textView.text = [NSString stringWithFormat:@"Darn! Error: %@, %@", [error code], [error localizedDescription]];
    NSString *fail = [NSString stringWithFormat:@"Darn! Error!\n%li: %@\n%@", (long)[error code], [error localizedDescription], [error localizedRecoverySuggestion]];
    NSLog(@"邮件发送失败=%@",fail);
    
    if (_emailFail) {
        _emailFail();
    }
    
    //NSLog(@"delegate - error(%d): %@", [error code], [error localizedDescription]);
}


@end
