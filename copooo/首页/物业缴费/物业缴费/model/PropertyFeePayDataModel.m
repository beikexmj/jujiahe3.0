//
//  PropertyFeePayDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/20.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PropertyFeePayDataModel.h"

@implementation PropertyFeePayDataModel

@end
@implementation PropertyFeePayForm
+ (NSDictionary *)objectClassInArray{
    return @{@"history" : [PropertyFeePayHistory class]};
}
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}

@end
@implementation PropertyFeePayHistory
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}

@end
