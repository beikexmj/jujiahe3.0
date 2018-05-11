//
//  LocationUnitDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/2/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChoseUnitDataList;

@interface LocationUnitDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong)ChoseUnitDataList *form;

@end
