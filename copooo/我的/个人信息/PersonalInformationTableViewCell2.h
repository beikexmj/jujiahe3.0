//
//  PersonalInformationTableViewCell.h
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalInformationTableViewCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *regimentationLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameStr;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewToLeft;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *nextImg;
@property (weak, nonatomic) IBOutlet UIView *sexChoseView;
@property (weak, nonatomic) IBOutlet UIButton *menBtn;
@property (weak, nonatomic) IBOutlet UIButton *womenBtn;
@property (weak, nonatomic) IBOutlet UILabel *menLabel;
@property (weak, nonatomic) IBOutlet UIImageView *menImg;
@property (weak, nonatomic) IBOutlet UILabel *womenLabel;
@property (weak, nonatomic) IBOutlet UIImageView *womenImg;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImgWidth;

@end
