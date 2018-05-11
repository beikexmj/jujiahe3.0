//
//  EmojiForbid.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/28.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmojiForbid : NSObject
+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (BOOL)hasEmoji:(NSString*)string;
+ (BOOL)isNineKeyBoard:(NSString *)string;
@end
