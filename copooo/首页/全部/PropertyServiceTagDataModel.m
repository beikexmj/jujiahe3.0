//
//  PropertyServiceTagDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/13.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PropertyServiceTagDataModel.h"

@implementation PropertyServiceTagDataModel

+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [PropertyServiceTagArr class]};
}

@end

@implementation PropertyServiceTagArr
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end
