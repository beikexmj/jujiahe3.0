//
//  HJInputView.m
//  AINursing
//
//  Created by 黄靖 on 16/3/18.
//  Copyright © 2016年 黄靖. All rights reserved.
//

#import "HJInputView.h"
@implementation HJInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI:frame.origin.y];
    }
    return self;
}
- (void)createUI:(CGFloat)y{
    self.frame = CGRectMake(5, y, SCREENWIDTH - 10, 150);
    _textV = [[UITextView alloc]init];
    _textV.frame = CGRectMake(2.5, 20, SCREENWIDTH - 10, 130);
    _textV.font = [UIFont systemFontOfSize:14];
    [self addSubview:_textV];
    
    _placeholerLabel = [[UILabel alloc]init];
    _placeholerLabel.frame = CGRectMake(5, 5, SCREENWIDTH, 22);
    _placeholerLabel.text = @"请在此输入信息...";
    _placeholerLabel.textColor = RGBACOLOR(204, 204, 204, 1.0);
    _placeholerLabel.font = [UIFont systemFontOfSize:14];
    [_textV addSubview:_placeholerLabel];
    
}
@end
