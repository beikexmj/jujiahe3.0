//
//  PersonalInformationTableViewCell.m
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PersonalInformationTableViewCell2.h"

@implementation PersonalInformationTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backView.layer.cornerRadius = 5;
    self.contentView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
