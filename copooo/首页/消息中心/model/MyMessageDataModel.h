//
//  MyMessageDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyMessageFrom;

@interface MyMessageDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray <MyMessageFrom *> *form;

@end

@interface MyMessageFrom : NSObject
@property (nonatomic, copy) NSString *postId;
@property (nonatomic, assign) NSInteger comment;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, strong) NSMutableArray *avatar;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *thumb;


@property (nonatomic, assign) NSInteger type;//2带图帖子；1纯文字帖子
@property (nonatomic, assign) BOOL hasUnread;//1未读 0已读

@end
