//
//  HPublic.h
//  Weizhi
//
//  Created by hy on 17/2/15.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IOS_VERSION_8_OR_ABOVE  (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)? (YES):(NO))
#define IOS_VERSION_9_OR_ABOVE  (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)? (YES):(NO))
#define IOS_VERSION_10_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)? (YES):(NO))
#define IOS_VERSION_11_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)? (YES):(NO))



#define SCREENHEIGHT       ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT       ([[UIScreen mainScreen] bounds].size.height)

#define is_iPhone_X          ((SCREENHEIGHTVALUE == 812)? (YES):(NO))
#define SCREENHEIGHTVALUE    ([[UIScreen mainScreen] bounds].size.height)
#define SCREENWIDTH          ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_WIDTH          ([[UIScreen mainScreen] bounds].size.width)

//#define SCREENHEIGHT         (is_iPhone_X ? (SCREENHEIGHTVALUE - 34):(SCREENHEIGHTVALUE))

#define ISONIPAD        [[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound
#define NAVHEIGHT            ((SCREENHEIGHTVALUE == 812)? (88.0f):(64.0f))
#define TABBARHEIGHT            ((SCREENHEIGHTVALUE == 812)? (83.0f):(49.0f))

#define WeakSelf __weak typeof(self) weakSelf = self;
#define StrongSelf __strong typeof(self) strongSelf = weakSelf;

#define FrameSelf CGRectMake(ox, oy, width, height)

/**以6s为标准做适配，返回的scale为相应比例 */
#define scaled(value) ([UIScreen mainScreen].bounds.size.width*value/375.0)

typedef enum {
    
    FileTypeUnknown               = 0,
    FileTypePhoto,
    FileTypeVideo,
    FileTypeAudio,
    FileTypePsd,
    FileTypePdf,
    FileTypePPT,
    FileTypeWord,
    FileTypeXls,
    FileTypeXml,
    FileTypeExe,
    FileTypeHtml,
    FileTypeRTF,
    FileTypeTxt,
    FileTypeZip,
    
} FileType;

typedef void(^sucessEmailBlock)();
typedef void(^failEmailBlock)();

@interface HPublic : NSObject

+(instancetype)shareInstance;


#pragma mark 快捷方法
NSInteger StringLength(NSString * _Nullable strtemp);
NSInteger StringConvertToInt(NSString * _Nullable strtemp);
float LikePercent(NSString * _Nullable ori, NSString * _Nullable target);
//BOOL IsNetwork();
/*手机号码验证 MODIFIED BY HELENSONG*/
BOOL IsValidateMobile(NSString * _Nullable mobile);
BOOL IsValidateEmail(NSString * _Nullable email);
void AfterDispatch(double delayInSeconds, dispatch_block_t _Nullable block);
void MainDispatch(dispatch_block_t _Nullable block);
void GlobalDispatch(dispatch_block_t _Nullable block);

CGSize getImgWithSize(CGSize originalSize);

NSString * _Nullable GetUniqueDeviceIdentifier();

#pragma mark 语言
NSString * _Nonnull mylocallang(NSString * _Nullable key);
NSString * _Nullable CurrentLanguage();
NSString * _Nullable CurInputMode();
NSString * _Nullable getCurrentLanguageString();


#pragma mark 时间
NSString * _Nonnull TimeBefore(NSDate * _Nullable date);

#pragma mark 系统
//获取磁盘总容量
unsigned long long getTotalDiskSize();

//获取磁盘剩余容量
unsigned long long getAvailableDiskSize();

//容量转换
NSString * _Nullable fileSizeToString(unsigned long long fileSize);

//获取本机名称
NSString * _Nullable GetPhoneName();

//获取本机型号
NSString * _Nullable GetDevicePlatform();

//对话框
void ShowMsgAlert(NSString * _Nullable title,NSString * _Nullable msg);


//是否是数字
BOOL inputShouldNumber(NSString * _Nullable inputString);
//是否是数字或字母
BOOL inputShouldLetterOrNum(NSString * _Nullable inputString);

//获取自定义缓存地址
NSString * _Nullable getAppDir(NSString * _Nullable inputString);

//正则去除网络标签
NSString * _Nullable filterHtmlwithString(NSString * _Nullable string);

//正则获取HTML <img> 网络标签
NSArray *_Nullable filterHtmlImgWithString(NSString * _Nullable htmlText);

//表情符号的判断
BOOL stringContainsEmoji(NSString *_Nullable string);

/**
 *  mov格式转mp4格式
 */
typedef void (^TansformVedioCompleted)(NSString * _Nullable Mp4FilePath);
typedef void (^TansformVedioFail)();
void movFileTransformToMP4WithSourceUrl(NSURL * _Nullable sourceUrl, TansformVedioCompleted _Nullable comepleteBlock,TansformVedioFail _Nullable failBlock);

#pragma mark 音乐

void PlayEffectSound(NSString * _Nullable sound,NSString * _Nullable type);


#pragma 公共
FileType getFileType(NSString * _Nullable pathEx);

//用户是否允许推送
BOOL isAllowedNotification();


/**
 *  静默发送邮件【腾讯】
 */

-(void)sendTenEmail:(NSString *)mailContent suc:(sucessEmailBlock )suc fail:(failEmailBlock ) fail;


@end
