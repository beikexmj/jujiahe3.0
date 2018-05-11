//
//  BillingInquiriesDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/2/23.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BillingInquiriesList;

@interface BillingInquiriesDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray <BillingInquiriesList*>*form;

@end

@interface BillingInquiriesList : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *billDate;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) NSString *payChannel;

@property (nonatomic, copy) NSString *payTime;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, assign) NSInteger type;

@end
