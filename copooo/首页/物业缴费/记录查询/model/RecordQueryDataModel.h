//
//  RecordQueryDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/21.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RecordQueryForm;

@interface RecordQueryDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray <RecordQueryForm*> *form;

@end

@interface RecordQueryForm : NSObject

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *ids;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *payMode;
@property (nonatomic, copy) NSString *payTime;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *type;

@end
