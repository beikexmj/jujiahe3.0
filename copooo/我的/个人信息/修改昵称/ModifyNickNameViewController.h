//
//  ModifyNickNameViewController.h
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyNickNameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nickName;

- (IBAction)backBtnlick:(id)sender;
- (IBAction)comfirmBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;
-(instancetype)init:(NSString*)str;
@property (nonatomic,strong)NSString *myStr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@end
