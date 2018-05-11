//
//  ServiceDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/13.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "ServiceDataModel.h"

@implementation ServiceDataModel
+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [ServiceDataArr class]};
}

@end

@implementation ServiceDataArr
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end
