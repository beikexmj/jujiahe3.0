//
//  DeliveryAddressCell.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/1.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "DeliveryAddressCell.h"

@implementation DeliveryAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)deleteBtnClick:(id)sender {
    UIButton *btn = sender;
    if (self.deleteBtnBlock) {
        self.deleteBtnBlock(btn.tag);
    }
}

- (IBAction)editBtnClick:(id)sender {
    UIButton *btn = sender;
    if (self.editBtnBlock) {
        self.editBtnBlock(btn.tag);
    }
}
@end
