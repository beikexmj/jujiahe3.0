//
//  CircleDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2017/11/16.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "CircleDataModel.h"

@implementation CircleDataModel

@end

@implementation CircleDataForm

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [CircleDataList class]};
}
@end

@implementation CircleDataList
+ (NSDictionary *)objectClassInArray{
    return @{@"picUrls" : [NSArray class],@"thumbPicUrls":[NSArray class]};
}
@end
