//
//  PropertyServiceTagDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/13.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PropertyServiceTagArr;
@interface PropertyServiceTagDataModel : NSObject
@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray <PropertyServiceTagArr *> *form;

@end

@interface PropertyServiceTagArr : NSObject

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *name;

@end
