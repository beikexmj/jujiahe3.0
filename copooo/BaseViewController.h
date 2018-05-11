//
//  BaseViewController.h
//  Weizhi
//
//  Created by hy on 17/3/6.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    CGFloat ox;
    CGFloat oy;
    CGFloat width;
    CGFloat height;
    
    UIView *_navGradientView;
    CAGradientLayer *_navGradientLayer;
    UIButton *_backButton;
    
    BOOL _isClosed;
}

@property(nonatomic,assign)BOOL isShowNav;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)NSString *popClassName;
@property(nonatomic,strong)UIButton *rightButton;
@property(nonatomic,strong)UIButton *leftButton;
/*导航栏 */
@property(strong, nonatomic)UIView *navView;
/*下划线*/
@property(strong, nonatomic)UIView *lineView;

/**传入图片名才会创建导航栏右部控件 */
@property(strong, nonatomic)NSString *rightImgName;
/**子类实现右部控件点击回调 */
- (void)rightButtonClick: (UIButton *)button;

/**传入图片名才会创建导航栏左部控件 */
@property(strong, nonatomic)NSString *leftImgName;
/**子类实现左部控件点击回调 */
- (void)leftButtonClick: (UIButton *)button;

-(void)actionClose;


@end
