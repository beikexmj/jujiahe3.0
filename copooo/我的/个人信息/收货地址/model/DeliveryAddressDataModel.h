//
//  DeliveryAddressDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/2/23.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DeliveryAddressList;


@interface DeliveryAddressDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray <DeliveryAddressList*> *form;

@end

@interface DeliveryAddressList : NSObject

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, assign) NSInteger prefer;

@end
