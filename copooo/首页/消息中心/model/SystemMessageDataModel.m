//
//  SystemMessageDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "SystemMessageDataModel.h"

@implementation SystemMessageDataModel

+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [SystemMessageFrom class]};
}

@end

@implementation SystemMessageFrom

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end
