//
//  TicketCenterViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/4.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketCenterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *all;
@property (weak, nonatomic) IBOutlet UIButton *waitUse;
@property (weak, nonatomic) IBOutlet UIButton *areadyUse;
@property (weak, nonatomic) IBOutlet UIButton *areadyOutOfDate;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)btnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UIView *allLineView;
@property (weak, nonatomic) IBOutlet UILabel *waitUseLabel;
@property (weak, nonatomic) IBOutlet UIView *waitUseLineView;
@property (weak, nonatomic) IBOutlet UILabel *areadyUseLabel;
@property (weak, nonatomic) IBOutlet UIView *areadyUseLineView;
@property (weak, nonatomic) IBOutlet UILabel *areadyOutOfDateLabel;
@property (weak, nonatomic) IBOutlet UIView *areadyOutOfDateLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (nonatomic,assign)NSInteger flag;
- (instancetype)initWithFlag:(NSInteger)flag;
@end
