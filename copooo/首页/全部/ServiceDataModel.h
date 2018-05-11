//
//  ServiceDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/13.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ServiceDataArr;
@interface ServiceDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray <ServiceDataArr *> *form;

@end

@interface ServiceDataArr : NSObject

@property (nonatomic, copy) NSString *areaAddress;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *evaluate;
@property (nonatomic, strong) NSArray *imageThumbUrl;
@property (nonatomic, strong) NSArray *imageUrl;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *ids;


@end
