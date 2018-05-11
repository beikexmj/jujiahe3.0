//
//  CallPropertyDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CallPropertyForm,CallPropertyData;

@interface CallPropertyDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) CallPropertyForm *form;

@end

@interface CallPropertyForm : NSObject

@property (nonatomic, strong) NSArray <CallPropertyData *>* data;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *propertyAreaName;

@property (nonatomic, copy) NSString *propertyName;

@end

@interface CallPropertyData : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *tel;

@end
