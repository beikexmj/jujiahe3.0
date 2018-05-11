//
//  PropertyFeePayDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/20.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PropertyFeePayForm,PropertyFeePayHistory;
@interface PropertyFeePayDataModel : NSObject
@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) PropertyFeePayForm *form;
@end
@interface PropertyFeePayForm : NSObject
@property (nonatomic, copy) NSString *ids;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *propertyAreaName;
@property (nonatomic, copy) NSString *propertyBuildingName;
@property (nonatomic, copy) NSString *propertyFloorName;
@property (nonatomic, copy) NSString *propertyHouseId;
@property (nonatomic, copy) NSString *propertyHouseName;
@property (nonatomic, copy) NSString *propertyUnitName;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *headName;
@property (nonatomic, copy) NSString *headTelphone;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *arrearsPrice;
@property (nonatomic, strong) NSArray <PropertyFeePayHistory *> *history;
@end

@interface PropertyFeePayHistory : NSObject
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *ids;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) NSInteger status;
@end

