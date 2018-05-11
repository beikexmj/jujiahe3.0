//
//  BalanceDetailDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/2/23.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BalanceDetailForm,BalanceDetailList,BalanceDetailListForMonthDetail;

@interface BalanceDetailDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) BalanceDetailForm *form;

@end

@interface BalanceDetailForm : NSObject

@property (nonatomic,strong) NSArray *years;

@property (nonatomic, copy) NSString *current;

@property (nonatomic,strong) NSArray <BalanceDetailList*>*list;

@end

@interface BalanceDetailList : NSObject

@property (nonatomic, copy) NSString *month;

@property (nonatomic,strong) NSArray <BalanceDetailListForMonthDetail*>*detail;

@end

@interface BalanceDetailListForMonthDetail : NSObject

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *amountStr;

@property (nonatomic, copy) NSString *year;

@property (nonatomic, copy) NSString *month;

@property (nonatomic, copy) NSString *day;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *reason;

@end
