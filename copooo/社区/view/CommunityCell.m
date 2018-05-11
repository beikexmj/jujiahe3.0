//
//  CommunityCell.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/26.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "CommunityCell.h"

@implementation CommunityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headerIcon.layer.cornerRadius = 25;
    _headerIcon.layer.masksToBounds = YES;
    self.headerIcon.contentMode = UIViewContentModeScaleAspectFill;
    _picOneInThreeOrMoreImageView.contentMode = UIViewContentModeScaleAspectFill;
    _picTwoInThreeOrMoreImageView.contentMode = UIViewContentModeScaleAspectFill;
    _picThreeInThreeOrMoreImageView.contentMode = UIViewContentModeScaleAspectFill;
    _picFourInThreeOrMoreImageView.contentMode = UIViewContentModeScaleAspectFill;
    _picFiveInThreeOrMoreImageView.contentMode = UIViewContentModeScaleAspectFill;
    _picSixInThreeOrMoreImageView.contentMode = UIViewContentModeScaleAspectFill;
    _picSevenInThreeOrMoreImageView.contentMode = UIViewContentModeScaleAspectFill;
    _picEightInThreeOrMoreImageView.contentMode = UIViewContentModeScaleAspectFill;
    _picNightInThreeOrMoreImageView.contentMode = UIViewContentModeScaleAspectFill;
    _picOneInTwoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _picTwoInTwoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _picOneInOneImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _picOneInThreeOrMoreImageView.layer.masksToBounds = YES;
    _picTwoInThreeOrMoreImageView.layer.masksToBounds = YES;
    _picThreeInThreeOrMoreImageView.layer.masksToBounds = YES;
    _picFourInThreeOrMoreImageView.layer.masksToBounds = YES;
    _picFiveInThreeOrMoreImageView.layer.masksToBounds = YES;
    _picSixInThreeOrMoreImageView.layer.masksToBounds = YES;
    _picSevenInThreeOrMoreImageView.layer.masksToBounds = YES;
    _picEightInThreeOrMoreImageView.layer.masksToBounds = YES;
    _picNightInThreeOrMoreImageView.layer.masksToBounds = YES;
    _picOneInTwoImageView.layer.masksToBounds = YES;
    _picTwoInTwoImageView.layer.masksToBounds = YES;
    _picOneInOneImageView.layer.masksToBounds = YES;
    
    self.content2 = [YYLabel new];
    self.content2.frame = CGRectMake(12, 79, SCREENWIDTH - 24,0);
    self.content2.numberOfLines = 0;
    self.content2.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:self.content2];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
//    _headerIcon.tag = 100;
//    _headerIcon.userInteractionEnabled = YES;
//    [_headerIcon addGestureRecognizer:tap];

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
        UIImageView *image = _picOneInThreeOrMoreImageView;
        switch (i) {
            case 0:
            {
                image = _picOneInThreeOrMoreImageView;
            }
                break;
            case 1:
            {
                image = _picTwoInThreeOrMoreImageView;
            }
                break;
            case 2:
            {
                image = _picThreeInThreeOrMoreImageView;
            }
                break;
            case 3:
            {
                image = _picFourInThreeOrMoreImageView;
            }
                break;
            case 4:
            {
                image = _picFiveInThreeOrMoreImageView;
            }
                break;
            case 5:
            {
                image = _picSixInThreeOrMoreImageView;
            }
                break;
            case 6:
            {
                image = _picSevenInThreeOrMoreImageView;
            }
                break;
            case 7:
            {
                image = _picEightInThreeOrMoreImageView;
            }
                break;
            case 8:
            {
                image = _picNightInThreeOrMoreImageView;
            }
                break;
            default:
                break;
        }
        image.tag = i + tag*10 + 1;
        image.userInteractionEnabled = YES;
        [image addGestureRecognizer:tap];
    }
    for (int i = 0; i<2; i++) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        UIImageView *image = _picOneInTwoImageView;
        switch (i) {
            case 0:
            {
                image = _picOneInTwoImageView;
            }
                break;
            case 1:
            {
                image = _picTwoInTwoImageView;
            }
                break;
                
            default:
                break;
        }
        image.tag = i + tag*10 + 1;
        image.userInteractionEnabled = YES;
        [image addGestureRecognizer:tap];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    UIImageView *image = _picOneInOneImageView;
    image.tag = 0 + tag*10 + 1;
    image.userInteractionEnabled = YES;
    [image addGestureRecognizer:tap];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)moreBtnClick:(id)sender {
    UIButton *btn = sender;
    if (self.moreBtnBlock) {
        self.moreBtnBlock(btn.tag);
    }
}
- (IBAction)commentBtnClick:(id)sender {
    UIButton *btn = sender;
    if (self.commentBtnBlock) {
        self.commentBtnBlock(btn.tag);
    }
}

- (IBAction)likeBtnClick:(id)sender {
    UIButton *btn = sender;
    if (self.likeBtnBlock) {
        self.likeBtnBlock(btn.tag,self);
    }
}
@end
