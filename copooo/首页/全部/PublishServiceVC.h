//
//  PublishServiceVC.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/8.
//  Copyright © 2018年 世纪之光. All rights reserved.
//
/*!
 @abstract 发布类型
 @constant PUBLISH_PHOTOANDTEXT  图文
 @constant PUBLISH_VIDEO  视频
 */
typedef NS_ENUM(NSUInteger, PUBLISH_TYPE) {
    PUBLISH_PHOTOANDTEXT,
    PUBLISH_VIDEO
};
#import <UIKit/UIKit.h>

@interface PublishServiceVC : BaseViewController
@property (nonatomic,copy)NSString *titleStr;
@property (nonatomic,copy)NSString *menuId;
@property (nonatomic,assign)PUBLISH_TYPE publishType;
@property (nonatomic,strong)void (^publichBlock)(void);
@end
