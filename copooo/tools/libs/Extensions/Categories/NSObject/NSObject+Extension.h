//
//  NSObject+Extension.h
//  Weizhi
//
//  Created by 易天亮 on 2017/8/8.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)


/**
 中文首字母排序分组

 @param arr 需要排序分组的数组
 @param selector 排序标准
 @return 排序后的数组
 */
+ (NSMutableArray *)collationSortObjectsAccordingTo:(NSArray *)arr selector:(SEL)selector;


/**
 中文首字母排序索引

 @param arr 需要排序的数组
 @param selector 排序标准
 @return 索引数组
 */
+ (NSMutableArray *)collationIndexAccordingTo:(NSArray *)arr selector:(SEL)selector;


@end
