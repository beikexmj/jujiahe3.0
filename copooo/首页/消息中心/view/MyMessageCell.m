//
//  MyMessageCell.m
//  copooo
//
//  Create/Users/xiamingjiang/Desktop/xmat平台d by XiaMingjiang on 2018/1/29.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "MyMessageCell.h"

@implementation MyMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.markLabel.layer.cornerRadius = 5;
    self.markLabel.layer.masksToBounds = YES;
    self.headerOne.layer.cornerRadius = 35/2.0;
    self.headerTwo.layer.cornerRadius = 35/2.0;
    self.headerThree.layer.cornerRadius = 35/2.0;
    self.headerFour.layer.cornerRadius = 35/2.0;
    self.headerOne.layer.masksToBounds = YES;
    self.headerTwo.layer.masksToBounds = YES;
    self.headerThree.layer.masksToBounds = YES;
    self.headerFour.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
