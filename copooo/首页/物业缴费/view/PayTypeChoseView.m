//
//  PayTypeChoseView.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/30.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PayTypeChoseView.h"

@implementation PayTypeChoseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.payBtn setBackgroundImage:[UIImage imageNamed:@"home_button1_normal"] forState:UIControlStateNormal];
    [self.payBtn setBackgroundImage:[UIImage imageNamed:@"home_button1_press"] forState:UIControlStateHighlighted];

}
- (IBAction)payBtnClick:(id)sender {
    if (self.payBtnBlock) {
        self.payBtnBlock();
    }
}

- (IBAction)choseBtnClick:(id)sender {
    UIButton *btn = sender;
    if (self.choseBtnBlock) {
        self.choseBtnBlock(btn.tag);
    }
}

- (IBAction)backBtnClick:(id)sender {
  
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 190);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.backBtnBlock) {
            self.backBtnBlock();
        }
    }];
}
@end
