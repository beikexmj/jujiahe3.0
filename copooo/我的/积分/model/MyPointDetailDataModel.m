//
//  MyPointDetailDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/14.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "MyPointDetailDataModel.h"

@implementation MyPointDetailDataModel

@end
@implementation MyPointDetailForm

+ (NSDictionary *)objectClassInArray{
    return @{@"detail" : [MyPointDetailList class]};
}

@end


@implementation MyPointDetailList
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end
