//
//  voucherListDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/15.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "VoucherListDataModel.h"

@implementation VoucherListDataModel

@end
@implementation VoucherListForm

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [VoucherListList class]};
}

@end

@implementation VoucherListList
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}

@end
