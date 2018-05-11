//
//  NewPropertyRoomNoViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/11/8.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPropertyRoomNoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *village;
@property (weak, nonatomic) IBOutlet UILabel *chargeUnit;
@property (weak, nonatomic) IBOutlet UILabel *technicalSupport;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextStepHeight;
@property (nonatomic,strong)NSString *unitId;
@property (nonatomic,strong)NSString *propertyId;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@property (nonatomic, assign) NSInteger comFromFlag; // == 1注册
@property (weak, nonatomic) IBOutlet UILabel *rightNowLocationMark;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)cityChoseBtnClick:(id)sender;
- (IBAction)villageChoseBtnClick:(id)sender;
- (IBAction)nextStepBtnClick:(id)sender;
@end
