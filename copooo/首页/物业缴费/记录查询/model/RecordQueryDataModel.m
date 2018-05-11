//
//  RecordQueryDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/21.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "RecordQueryDataModel.h"

@implementation RecordQueryDataModel
+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [RecordQueryForm class]};
}
@end

@implementation RecordQueryForm

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}

@end
