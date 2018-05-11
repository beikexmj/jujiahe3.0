//
//  voucherListDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/15.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VoucherListForm,VoucherListList;

@interface VoucherListDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) VoucherListForm *form;

@end

@interface VoucherListForm : NSObject

@property (nonatomic, strong) NSArray<VoucherListList *> *list;

@end

@interface VoucherListList : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy)NSString *describe;

@property (nonatomic, copy)NSString *source;

@property (nonatomic, assign)NSInteger use;

@property (nonatomic, assign)NSInteger status;

@property (nonatomic, copy)NSString *deadline;

@property (nonatomic, copy)NSString *createTime;

@property (nonatomic, copy)NSString *useTime;

@property (nonatomic, copy)NSString *ids;

@property (nonatomic, copy)NSString *image;



@end

