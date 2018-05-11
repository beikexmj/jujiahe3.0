//
//  HomePageDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "HomePageDataModel.h"

@implementation HomePageDataModel

@end

@implementation HomePageForm
+ (NSDictionary *)objectClassInArray{
    return @{@"broadcast_data" : [Broadcast_dataArr class],@"menu_data":[Menu_dataArr class],@"template_data":[Template_dataArr class]};
}
@end

@implementation Advertisement_data

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [Advertisement_dataArr class]};
}

@end

@implementation Advertisement_dataArr

@end

@implementation Broadcast_dataArr

@end

@implementation Daily_word_data
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end

@implementation Menu_dataArr
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end

@implementation Template_dataArr
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end

@implementation Activity_form
+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [Activity_formArr class]};
}
@end

@implementation Activity_formArr

@end

@implementation NeighborhoodForm
+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [NeighborhoodFormArr class]};
}
@end

@implementation NeighborhoodFormArr
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end
