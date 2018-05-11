//
//  CommunityTagsDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/5.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "CommunityTagsDataModel.h"

@implementation CommunityTagsDataModel
+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [CommunityTagsArr class]};
}
@end

@implementation CommunityTagsArr
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}

@end
