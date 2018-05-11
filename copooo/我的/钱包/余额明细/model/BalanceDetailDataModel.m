//
//  BalanceDetailDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/23.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "BalanceDetailDataModel.h"

@implementation BalanceDetailDataModel

@end

@implementation BalanceDetailForm
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [BalanceDetailList class]};
}
@end

@implementation BalanceDetailList
+ (NSDictionary *)objectClassInArray{
    return @{@"detail" : [BalanceDetailListForMonthDetail class]};
}
@end

@implementation BalanceDetailListForMonthDetail

@end
