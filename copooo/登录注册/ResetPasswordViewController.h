//
//  ResetPasswordViewController.h
//  copooo
//
//  Created by 夏明江 on 16/9/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController
- (IBAction)backBtnClick:(id)sender;

- (IBAction)regestBtnClick:(id)sender;
- (IBAction)sendCodeBtnClick:(id)sender;
- (IBAction)passwordVisualBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIView *passwordBackView;
@property (weak, nonatomic) IBOutlet UIView *phoneNumBackView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstraint;
@end
