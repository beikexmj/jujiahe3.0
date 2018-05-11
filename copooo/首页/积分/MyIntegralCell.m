//
//  MyIntegralCell.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/28.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "MyIntegralCell.h"

@implementation MyIntegralCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.markBtn.layer.cornerRadius = 5;
    self.markBtn.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)markBtnClick:(id)sender {
    UIButton *btn = sender;
    if (self.markBtnBlock) {
        self.markBtnBlock(btn.tag);
    }
}
@end
