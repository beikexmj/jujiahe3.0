//
//  EmptyView.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/7.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    UIImage *image = [UIImage imageNamed:@"暂无网络连接"];
    NSString *text = @"网络异常，点击重试";
    
    UIView* noMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, SCREENHEIGHT - NAVHEIGHT)];
    noMessageView.backgroundColor = RGBCOLOR(255, 255, 255);
    UIImageView *carImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-image.size.width)/2, 140, image.size.width, image.size.height)];
    carImageView.center = CGPointMake(SCREENWIDTH/2.0, 140+image.size.height/2.0);
    [carImageView setImage:image];
    [noMessageView addSubview:carImageView];
    
    UILabel *noInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(carImageView.frame) + 20 , SCREENWIDTH, 20)];
    noInfoLabel.textAlignment = NSTextAlignmentCenter;
    noInfoLabel.textColor = RGBCOLOR(156, 156, 156);
    noInfoLabel.text = text;
    noInfoLabel.backgroundColor = [UIColor clearColor];
    noInfoLabel.font = [UIFont systemFontOfSize:15];
    [noMessageView addSubview:noInfoLabel];
    
    [self addSubview:noMessageView];
    
    UITapGestureRecognizer *recongizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
    noMessageView.userInteractionEnabled = YES;
    [noMessageView addGestureRecognizer:recongizer];

    return self;
}


- (void)action:(UIGestureRecognizer *)tap{
    if (self.freshBlock) {
        self.freshBlock();
    }
    [self removeFromSuperview];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    XMJLog(@"(%f,%f)",point.x,point.y);
    // 1.判断当前控件能否接收事件
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
    if (point.y<0) {
        return nil;
    }
    return self;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.freshBlock) {
        self.freshBlock();
    }
    [self removeFromSuperview];
}
@end
