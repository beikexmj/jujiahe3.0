//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * 🌟🌟🌟 新建SDCycleScrollView交流QQ群：185534916 🌟🌟🌟
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 * 另（我的自动布局库SDAutoLayout）：
 *  一行代码搞定自动布局！支持Cell和Tableview高度自适应，Label和ScrollView内容自适应，致力于
 *  做最简单易用的AutoLayout库。
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 * GitHub：https://github.com/gsdios/SDAutoLayout
 *********************************************************************************
 
 */


#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"

@implementation SDCollectionViewCell
{
    __weak UILabel *_titleLabel;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTitleLabel];
        [self addSubview:self.dailyWord];
        [self addSubview:self.day];
        [self addSubview:self.week];
        [self addSubview:self.month];
    }
    
    return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setupTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    [self.contentView addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
    if (_titleLabel.hidden) {
        _titleLabel.hidden = NO;
    }
}

-(void)setTitleLabelTextAlignment:(NSTextAlignment)titleLabelTextAlignment
{
    _titleLabelTextAlignment = titleLabelTextAlignment;
    _titleLabel.textAlignment = titleLabelTextAlignment;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.onlyDisplayText) {
        _titleLabel.frame = self.bounds;
    } else {
        _imageView.frame = self.bounds;
        CGFloat titleLabelW = self.sd_width;
        CGFloat titleLabelH = _titleLabelHeight;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelY = self.sd_height - titleLabelH;
        _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    }
}
- (UILabel *)dailyWord{
    if (!_dailyWord) {
        CGFloat titleLabelH = 40;
        CGFloat titleLabelX = 15;
        CGFloat titleLabelW = self.sd_width - titleLabelX*2;
        CGFloat titleLabelY = self.sd_height - titleLabelH/2.0 - 20;
        _dailyWord = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        _dailyWord.numberOfLines = 1;
        _dailyWord.font = [UIFont systemFontOfSize:14.0];
        _dailyWord.textColor = [UIColor whiteColor];
        //阴影颜色
        _dailyWord.shadowColor = RGBA(0x000000, 0.3);
        //阴影偏移  x，y为正表示向右下偏移
        _dailyWord.shadowOffset = CGSizeMake(1, 1);
    }
    return _dailyWord;
}
- (UILabel *)day{
    if (!_day) {
        CGFloat titleLabelH = 60;
        CGFloat titleLabelX = 15;
        CGFloat titleLabelW = titleLabelH + 5;
        CGFloat titleLabelY = self.sd_height - titleLabelH - 15 - 20;
        _day = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        _day.font = [UIFont systemFontOfSize:45.0];
        _day.textColor = [UIColor whiteColor];
        //阴影颜色
        _day.shadowColor = RGBA(0x000000, 0.2);
        //阴影偏移  x，y为正表示向右下偏移
        _day.shadowOffset = CGSizeMake(1, 1);
    }
    return _day;
}
- (UILabel *)week{
    if (!_week) {
        CGFloat titleLabelH = 30;
        CGFloat titleLabelX = 15 + 60;
        CGFloat titleLabelW = 100;
        CGFloat titleLabelY = self.sd_height - titleLabelH - 15 - 20 - 30 +5;
        _week = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        _week.font = [UIFont systemFontOfSize:15.0];
        _week.textColor = [UIColor whiteColor];
        //阴影颜色
        _week.shadowColor = RGBA(0x000000, 0.3);
        //阴影偏移  x，y为正表示向右下偏移
        _week.shadowOffset = CGSizeMake(1, 1);
    }
    return _week;
}
- (UILabel *)month{
    if (!_month) {
        CGFloat titleLabelH = 25;
        CGFloat titleLabelX = 15 + 60;
        CGFloat titleLabelW = 100;
        CGFloat titleLabelY = self.sd_height - titleLabelH - 15 - 20 - 10;
        _month = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        _month.font = [UIFont systemFontOfSize:19.0];
        _month.textColor = [UIColor whiteColor];
        //阴影颜色
        _month.shadowColor = RGBA(0x000000, 0.3);
        //阴影偏移  x，y为正表示向右下偏移
        _month.shadowOffset = CGSizeMake(1, 1);
    }
    return _month;
}
@end
