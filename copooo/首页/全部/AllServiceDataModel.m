//
//  AllServiceDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/8.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "AllServiceDataModel.h"

@implementation AllServiceDataModel

+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [AllServiceArr class]};
}

@end

@implementation AllServiceArr
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [AllServiceDict class]};
}
@end

@implementation AllServiceDict
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end
