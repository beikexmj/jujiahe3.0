//
//  MissionMineDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/1.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "MissionMineDataModel.h"

@implementation MissionMineDataModel

@end

@implementation MissionMineForm
+ (NSDictionary *)objectClassInArray{
    return @{@"startingMission" : [MissionMineArr class], @"dailyMission":[MissionMineArr class]};
}
@end

@implementation MissionMineArr

@end
