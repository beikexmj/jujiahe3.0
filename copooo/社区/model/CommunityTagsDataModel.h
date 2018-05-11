//
//  CommunityTagsDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/2/5.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CommunityTagsArr;
@interface CommunityTagsDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray <CommunityTagsArr *>*form;

@end

@interface CommunityTagsArr : NSObject

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *name;

@end
