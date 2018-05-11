//
//  SystemMessageDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SystemMessageFrom;

@interface SystemMessageDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray <SystemMessageFrom *> *form;

@end

@interface SystemMessageFrom : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *ids;
@property (nonatomic, copy) NSString *operation;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *noticeType;

@end
