//
//  DeliveryAddressCell.h
//  copooo
//
//  Created by XiaMingjiang on 2018/2/1.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *choseFlagIcon;
- (IBAction)deleteBtnClick:(id)sender;
- (IBAction)editBtnClick:(id)sender;
@property (nonatomic,strong)void (^deleteBtnBlock)(NSInteger integer);
@property (nonatomic,strong)void (^editBtnBlock)(NSInteger integer);
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end
