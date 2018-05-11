//
//  ModifyPhoneNumViewController.h
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPhoneNumViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
- (IBAction)getIdentifyingCodeBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *identifyingCode;
@property (weak, nonatomic) IBOutlet UIButton *identifyingCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;
- (IBAction)comfirmBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;
@property (nonatomic,strong)NSString *phoneNumstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@end
