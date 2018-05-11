//
//  PropertyPaymentHomeVC.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/30.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyPaymentHomeVC : BaseViewController
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSString *comformFlag;// == 1 来自物业选择房号
@property (nonatomic,strong)void(^propertyHouseChoseBlock)(NSString *name,NSString *propertyHouseId);
@end
