//
//  UIButton+Extension.m
//  Weizhi
//
//  Created by 易天亮 on 2017/9/4.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

- (void)setVerticalImageAndTitleSpace:(CGFloat)spacing {
    
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -imageSize.height-spacing, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height-spacing, 0, 0, -titleSize.width);
    
}

@end
