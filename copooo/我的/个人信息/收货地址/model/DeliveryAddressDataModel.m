//
//  DeliveryAddressDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/23.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "DeliveryAddressDataModel.h"

@implementation DeliveryAddressDataModel
+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [DeliveryAddressList class]};
}
@end

@implementation DeliveryAddressList
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end
