//
//  registDataModle.h
//  copooo
//
//  Created by 夏明江 on 16/9/2.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Form;
@interface registDataModle : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) Form *form;

@end
@interface Form : NSObject

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, copy) NSString *accountBalance;

@property (nonatomic, copy) NSString *point;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *invitationCode;

@property (nonatomic, copy) NSString *invitationLink;

@property (nonatomic, copy) NSString *payPasswordSet;

@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, copy) NSString *socialUnread;

@property (nonatomic, copy) NSString *systemUnread;

@property (nonatomic, copy) NSString *countShippingSend;

@property (nonatomic, copy) NSString *countShipping;

@property (nonatomic, copy) NSString *countPaying;


@end

