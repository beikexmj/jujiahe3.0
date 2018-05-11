//
//  CircleDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/11/16.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CircleDataForm,CircleDataList;
@interface CircleDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) CircleDataForm *form;

@end

@interface CircleDataForm : NSObject
@property (nonatomic, assign) NSInteger unread;

@property (nonatomic, strong) NSArray<CircleDataList *> *list;

@end

@interface CircleDataList : NSObject

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *userType;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *replyable;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *postId;

@property (nonatomic, copy) NSString *commentCount;

@property (nonatomic, copy) NSString *thumbUpCount;

@property (nonatomic, strong) NSArray *picUrls;

@property (nonatomic, strong) NSArray *thumbPicUrls;

@property (nonatomic, copy) NSString *videoUrl;

@property (nonatomic, copy) NSString *thumbVideoUrl;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, assign) NSInteger anon;

@property (nonatomic, assign) BOOL thumbUp;

@end
