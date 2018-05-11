//
//  NewRoomDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/11/22.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewRoomDataList;

@interface NewRoomDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<NewRoomDataList *> *form;

@end


@interface NewRoomDataList : NSObject

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *propertyAreaId;

@end


