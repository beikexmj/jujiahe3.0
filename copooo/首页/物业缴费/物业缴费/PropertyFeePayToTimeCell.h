//
//  PropertyFeePayToTimeCell.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/30.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyFeePayToTimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondRowHight;
@property (weak, nonatomic) IBOutlet UIView *secondRowView;
@property (weak, nonatomic) IBOutlet UILabel *rechargeAmount;

@property (weak, nonatomic) IBOutlet UILabel *time;
- (IBAction)choseTimeBtnClick:(id)sender;

@property (nonatomic,strong)void(^choseTimeBtnBlock)(void);
@end
