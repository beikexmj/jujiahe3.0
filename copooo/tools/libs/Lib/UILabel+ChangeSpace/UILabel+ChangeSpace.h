//
//  UILabel+ChangeSpace.h
//  Weizhi
//
//  Created by 何月 on 2017/6/23.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(UILabel_ChangeSpace)

/**
 *  改变行间距
 */
- (void)changeLineWithSpace:(float)space;

/**
 *  改变字间距
 */
- (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
- (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
