//
//  PropertyPaymentHomeDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/13.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PropertyPaymentHomeDataModel.h"

@implementation PropertyPaymentHomeDataModel
+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [PropertyPaymentHomeArr class]};
}
@end

@implementation PropertyPaymentHomeArr

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}

@end
