//
//  ServiceCell.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/8.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "ServiceCell.h"

@implementation ServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.type.layer.cornerRadius = 3;
    self.type.layer.masksToBounds = YES;
    _firstImg.contentMode = UIViewContentModeScaleAspectFill;
    _secondImg.contentMode = UIViewContentModeScaleAspectFill;
    _thirdImg.contentMode = UIViewContentModeScaleAspectFill;
    _fourImg.contentMode = UIViewContentModeScaleAspectFill;
    _fiveImg.contentMode = UIViewContentModeScaleAspectFill;
    _sixImg.contentMode = UIViewContentModeScaleAspectFill;
    _sevenImg.contentMode = UIViewContentModeScaleAspectFill;
    _eightImg.contentMode = UIViewContentModeScaleAspectFill;
    _nightImg.contentMode = UIViewContentModeScaleAspectFill;

    _firstImg.layer.masksToBounds = YES;
    _secondImg.layer.masksToBounds = YES;
    _thirdImg.layer.masksToBounds = YES;
    _fourImg.layer.masksToBounds = YES;
    _fiveImg.layer.masksToBounds = YES;
    _sixImg.layer.masksToBounds = YES;
    _sevenImg.layer.masksToBounds = YES;
    _eightImg.layer.masksToBounds = YES;
    _nightImg.layer.masksToBounds = YES;

    // Initialization code
}
- (void)tapClick:(UIGestureRecognizer *)tap{
    if (self.imageViewTapBlock) {
        self.imageViewTapBlock(tap.view.tag,(UIImageView *)tap.view);
    }
}
-(void)setTag:(NSInteger)tag{
    for (int i = 0; i<9; i++) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        UIImageView *image = _firstImg;
        switch (i) {
            case 0:
            {
                image = _firstImg;
            }
                break;
            case 1:
            {
                image = _secondImg;
            }
                break;
            case 2:
            {
                image = _thirdImg;
            }
                break;
            case 3:
            {
                image = _fourImg;
            }
                break;
            case 4:
            {
                image = _fiveImg;
            }
                break;
            case 5:
            {
                image = _sixImg;
            }
                break;
            case 6:
            {
                image = _sevenImg;
            }
                break;
            case 7:
            {
                image = _eightImg;
            }
                break;
            case 8:
            {
                image = _nightImg;
            }
                break;
            default:
                break;
        }
        image.tag = i + tag*10;
        image.userInteractionEnabled = YES;
        [image addGestureRecognizer:tap];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)gotoComentBtnClick:(id)sender {
    UIButton *btn = sender;
    if (self.comentBlock) {
        self.comentBlock(btn.tag);
    }
}
@end
