//
//  InviteRegistrationRankViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/12/13.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteRegistrationRankViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *firstHeaderIcon;
@property (weak, nonatomic) IBOutlet UILabel *firstNickName;
@property (weak, nonatomic) IBOutlet UILabel *firstNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNum;
@property (weak, nonatomic) IBOutlet UIImageView *secondHeaderIcon;
@property (weak, nonatomic) IBOutlet UILabel *secondNickName;
@property (weak, nonatomic) IBOutlet UILabel *secondNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondNum;
@property (weak, nonatomic) IBOutlet UIImageView *thirdHeaderIcon;
@property (weak, nonatomic) IBOutlet UILabel *thirdNickName;
@property (weak, nonatomic) IBOutlet UILabel *thirdNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdNum;
@property (weak, nonatomic) IBOutlet UIView *conerView;

- (IBAction)rankRuleBtnClick:(id)sender;
@end
