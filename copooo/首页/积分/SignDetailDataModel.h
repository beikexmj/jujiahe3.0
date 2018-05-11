//
//  SignDeailDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/15.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SignDetailForm;

@interface SignDetailDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) SignDetailForm *form;

@end

@interface SignDetailForm : NSObject

@property (nonatomic, copy)NSString *total;

@property (nonatomic, strong) NSArray *detail;

@property (nonatomic, copy)NSString *continuity;

@end


