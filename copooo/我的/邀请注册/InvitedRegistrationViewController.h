//
//  InvitedRegistrationViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/12/13.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitedRegistrationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *inviteNum;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)rankBtnClick:(id)sender;
@end
