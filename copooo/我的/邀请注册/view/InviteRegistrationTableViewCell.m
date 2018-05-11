//
//  InviteRegistrationTableViewCell.m
//  copooo
//
//  Created by XiaMingjiang on 2017/12/13.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "InviteRegistrationTableViewCell.h"

@implementation InviteRegistrationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headerIcon.layer.cornerRadius = 55/2.0;
    _headerIcon.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
