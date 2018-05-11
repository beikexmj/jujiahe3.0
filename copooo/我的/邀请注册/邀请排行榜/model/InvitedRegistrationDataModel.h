//
//  InvitedRegistrationDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/5.
//  Copyright © 2018年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>
@class InvitedRegistrationForm,InvitedRegistrationList;
@interface InvitedRegistrationDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) InvitedRegistrationForm *form;

@end

@interface InvitedRegistrationForm : NSObject

@property (nonatomic, strong) NSArray<InvitedRegistrationList *> *list;
@property (nonatomic, copy) NSString *count;
@end

@interface InvitedRegistrationList : NSObject

@property (nonatomic, copy) NSString *invitationDate;

@property (nonatomic, copy) NSString *inviteeId;

@property (nonatomic, copy) NSString *username;

@end




