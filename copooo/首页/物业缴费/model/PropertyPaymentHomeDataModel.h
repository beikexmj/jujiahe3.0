//
//  PropertyPaymentHomeDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/13.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PropertyPaymentHomeArr;

@interface PropertyPaymentHomeDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray <PropertyPaymentHomeArr *> *form;

@end

@interface PropertyPaymentHomeArr : NSObject
@property (nonatomic, copy) NSString *ids;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *propertyHouseName;
@property (nonatomic, copy) NSString *propertyHouseId;
@property (nonatomic, copy) NSString *headName;
@property (nonatomic, copy) NSString *headTelphone;
@property (nonatomic, copy) NSString *propertyFloorName;
@property (nonatomic, copy) NSString *propertyUnitName;
@property (nonatomic, copy) NSString *propertyBuildingName;
@property (nonatomic, copy) NSString *propertyAreaName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *arrearsPrice;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *history;
@end
