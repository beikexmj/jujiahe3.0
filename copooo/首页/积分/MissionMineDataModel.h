//
//  MissionMineDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/1.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MissionMineForm,MissionMineArr;

@interface MissionMineDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) MissionMineForm *form;

@end

@interface MissionMineForm : NSObject

@property (nonatomic, strong) NSArray<MissionMineArr*> *startingMission;

@property (nonatomic, strong) NSArray<MissionMineArr*> *dailyMission;

@end

@interface MissionMineArr : NSObject

@property (nonatomic, copy) NSString *missionId;

@property (nonatomic, copy) NSString *missionName;

@property (nonatomic, assign) NSInteger complete;

@property (nonatomic, copy) NSString *missionPoint;

@end


