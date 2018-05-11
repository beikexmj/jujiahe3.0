//
//  MyMessageDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "MyMessageDataModel.h"

@implementation MyMessageDataModel
+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [MyMessageFrom class]};
}

@end

@implementation MyMessageFrom

@end
