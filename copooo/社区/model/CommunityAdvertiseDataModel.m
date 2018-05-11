//
//  CommunityAdvertiseDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/5.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "CommunityAdvertiseDataModel.h"

@implementation CommunityAdvertiseDataModel

@end

@implementation CommunityAdvertiseForm

+ (NSDictionary *)objectClassInArray{
    return @{@"community_data" : [Community_data class]};
}
@end

@implementation Community_data
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end
