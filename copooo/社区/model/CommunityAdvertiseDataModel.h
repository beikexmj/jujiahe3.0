//
//  CommunityAdvertiseDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/2/5.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommunityAdvertiseForm,Community_data,Advertisement_data;

@interface CommunityAdvertiseDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) CommunityAdvertiseForm *form;

@end


@interface CommunityAdvertiseForm : NSObject

@property (nonatomic, strong) Advertisement_data *advertisement_data;
@property (nonatomic, strong) NSArray <Community_data *>*community_data;

@end

@interface Community_data : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *file_type;

@end
