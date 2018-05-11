//
//  PropertyPaymentHomeCell.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/30.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyPaymentHomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headName;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *propertyBuildingName;
@property (weak, nonatomic) IBOutlet UILabel *propertyFloorName;
@property (weak, nonatomic) IBOutlet UILabel *propertyUnitName;
@property (weak, nonatomic) IBOutlet UILabel *propertyHouseName;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (weak, nonatomic) IBOutlet UIButton *tipsBtn;
- (IBAction)tipsBtnClick:(id)sender;
@property (nonatomic,strong)void (^tipsBtnBlock)(NSInteger integer, PropertyPaymentHomeCell *cell);
@end
