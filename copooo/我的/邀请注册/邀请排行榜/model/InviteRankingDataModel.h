//
//  InviteRankingDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/5.
//  Copyright © 2018年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>
@class InviteRankingForm,InviteRankingList;
@interface InviteRankingDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) InviteRankingForm *form;

@end

@interface InviteRankingForm : NSObject

@property (nonatomic, strong) NSArray<InviteRankingList *> *list;

@end

@interface InviteRankingList : NSObject

@property (nonatomic, copy) NSString *inviterId;

@property (nonatomic, copy) NSString *lastInviteDate;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *total;

@end



