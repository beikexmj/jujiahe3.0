//
//  PropertyPaymentHomeCell.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/30.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PropertyPaymentHomeCell.h"

@implementation PropertyPaymentHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tipsBtnClick:(id)sender {
    UIButton *btn = sender;
    if (self.tipsBtnBlock) {
        self.tipsBtnBlock(btn.tag,self);
    }
}
@end
