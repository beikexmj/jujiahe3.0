//
//  SignSuccessView.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/1.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "SignSuccessView.h"

@implementation SignSuccessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.3;
    [self addSubview:backView];
    
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 80, SCREENWIDTH - 80)];
    myView.center = CGPointMake(SCREENWIDTH/2.0, SCREENHEIGHT/2.0);
    [self addSubview:myView];
    
    UIImageView  *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 80, SCREENWIDTH - 80)];
    imageView.image = [UIImage imageNamed:@"my_integral签到成功"];
    [myView addSubview:imageView];
    
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    myLabel.font = [UIFont systemFontOfSize:18.0];
    myLabel.textColor = RGBA(0xf83030, 1);
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.text = @"合币";
    myLabel.center = CGPointMake((SCREENWIDTH - 80)/2.0, (SCREENWIDTH - 80)/2.0 + 15);
    
    _integral = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    _integral.font = [UIFont systemFontOfSize:40.0];
    _integral.textColor = RGBA(0xf83030, 1);
    _integral.textAlignment = NSTextAlignmentCenter;
    _integral.center = CGPointMake((SCREENWIDTH - 80)/2.0, (SCREENWIDTH - 80)/2.0 - 20);
    [myView addSubview:myLabel];
    [myView addSubview:_integral];
    return self;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}
@end
