//
//  BillingDetailVC.h
//  copooo
//
//  Created by XiaMingjiang on 2018/2/1.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillingInquiriesDataModel.h"
@interface BillingDetailVC : BaseViewController
@property (nonatomic,assign)NSInteger comfromFlag;
@property (nonatomic,strong)BillingInquiriesList *dict;
@end
