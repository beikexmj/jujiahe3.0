//
//  DeliveryAddressVC.h
//  copooo
//
//  Created by XiaMingjiang on 2018/2/1.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryAddressVC : BaseViewController
@property (nonatomic,strong)void (^deliverAddressBlock)(NSDictionary *params);
@end
