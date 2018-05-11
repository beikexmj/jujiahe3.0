//
//  NewRoomSecondStepViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/11/8.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewRoomSecondStepViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *unitNo;
@property (weak, nonatomic) IBOutlet UILabel *buildingNo;
@property (weak, nonatomic) IBOutlet UILabel *roomNo;
@property (weak, nonatomic) IBOutlet UILabel *flourNo;
@property (weak, nonatomic) IBOutlet UITextField *tips;

@property (weak, nonatomic) IBOutlet UIButton *addRoomNoBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addRoomNoBtnHeight;
@property (nonatomic,copy)NSString *unitId;
@property (nonatomic,copy)NSString *propertyId;
@property (nonatomic, assign) NSInteger comFromFlag; // == 1注册
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)btnClick:(id)sender;
- (IBAction)addRoomNoBtnClick:(id)sender;
@end
