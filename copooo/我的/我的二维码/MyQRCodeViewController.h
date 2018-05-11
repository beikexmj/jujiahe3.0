//
//  MyQRCodeViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/12/12.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyQRCodeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;

@property (strong, nonatomic) UIImageView *QRImage;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)shareBtnClick:(id)sender;
@end
