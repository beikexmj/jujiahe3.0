//
//  ModifyEmailViewController.h
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyEmailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailAdress;
@property (weak, nonatomic) IBOutlet UITextField *identifyingCode;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;
- (IBAction)comfirmBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *emailView;
- (IBAction)getIndentidfyCodeBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;

@end
