//
//  AllServiceDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/8.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AllServiceArr,AllServiceDict;
@interface AllServiceDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray <AllServiceArr *> *form;

@end

@interface AllServiceArr : NSObject

@property (nonatomic,strong) NSArray <AllServiceDict *> *data;

@property (nonatomic, copy) NSString *name;

@end

@interface AllServiceDict : NSObject

@property (nonatomic, copy) NSString *file_type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) NSInteger hot;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *ids;


@end
