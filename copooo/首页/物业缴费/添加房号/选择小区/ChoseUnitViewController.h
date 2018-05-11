//
//  ChoseUnitViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/11/8.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoseUnitViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong)void (^unitChoseBlock)(NSString *unitName,NSString *ids,NSString *propertyId,NSString *propertyName,NSInteger isInput);
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@property (weak, nonatomic) IBOutlet UILabel *locationUnit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationViewHight;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UIButton *choseCity;
@property (nonatomic,assign) NSInteger comFromFlag;// == 1 来自JFCity； == 2 首页; == 0  其他；
- (IBAction)backBtnClick:(id)sender;
- (IBAction)rightBtnClick:(id)sender;
- (IBAction)freshBtnClick:(id)sender;
- (IBAction)choseLoationUnitBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *freshBtn;
@end
