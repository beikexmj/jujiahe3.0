//
//  ServiceComentView.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/8.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "ServiceComentView.h"

@implementation ServiceComentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)comentStarBtnClick:(id)sender {
    _oneStarView.hidden = NO;
    _twoStarView.hidden = NO;
    _threeStarView.hidden = NO;

    UIButton *btn = sender;
    switch (btn.tag) {
        case 10:
        {
            _threeStarView.hidden = YES;
        }
        break;
        case 20:
        {
            _twoStarView.hidden = YES;
        }
            break;
        case 30:
        {
            _oneStarView.hidden = YES;
        }
            break;
        default:
            break;
    }
    if (self.comentStarBlock) {
        self.comentStarBlock(btn.tag);
    }
}
@end
