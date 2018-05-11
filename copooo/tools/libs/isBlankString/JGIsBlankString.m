//
//  JGIsBlankString.m
//  NDP_eHome
//
//  Created by 钟亮 on 16/2/20.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGIsBlankString.h"

@implementation JGIsBlankString
//判断输入是否为空格
+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}

@end
