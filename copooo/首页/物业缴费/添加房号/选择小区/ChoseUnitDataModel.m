//
//  ChoseUnitDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2017/11/22.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "ChoseUnitDataModel.h"

@implementation ChoseUnitDataModel
+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [ChoseUnitDataList class]};
}
@end

@implementation ChoseUnitDataList
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}

@end
