//
//  MessagePushSetUpDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/28.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MessagePushSetUp;
@interface MessagePushSetUpDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) MessagePushSetUp *form;

@end

@interface MessagePushSetUp : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) BOOL pushActivity;

@property (nonatomic, assign) BOOL pushSocial;

@property (nonatomic, assign) BOOL pushSystem;

@end
