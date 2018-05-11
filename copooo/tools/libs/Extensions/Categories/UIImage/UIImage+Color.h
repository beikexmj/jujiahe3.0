//
//  UIImage+Color.h
//  WhichBank
//
//  Created by libokun on 15/9/6.
//  Copyright (c) 2015年 lettai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

@end
