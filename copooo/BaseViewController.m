//
//  BaseViewController.m
//  Weizhi
//
//  Created by hy on 17/3/6.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBA(0xffffff, 1);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
}

- (void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void)setIsShowNav:(BOOL)isShowNav
{
    _isShowNav = isShowNav;
    if (isShowNav) {
        [self initBaseNavView];
    }
}


-(void)initBaseNavView
{
    if (_navView) {
        return;
    }
    
    _navView = [[UIView alloc] init];
    _navView.backgroundColor = RGBA(0xf6f6f6, 1);
    _navView.frame = CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT);
    [self.view addSubview:_navView];
    
//    _navGradientView = [[UIView alloc] init];
//    _navGradientView.frame = _navView.bounds;
//    _navGradientView.backgroundColor = [UIColor clearColor];
//    _navGradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [_navView addSubview:_navGradientView];
//
//    _navGradientLayer = [[CAGradientLayer alloc] init];
//    _navGradientLayer.frame = _navGradientView.bounds;
//    _navGradientLayer.colors = @[(id)RGBA(0x0AC3F8, 1).CGColor,(id)RGBA(0x3287DB, 1).CGColor];
//    _navGradientLayer.startPoint = CGPointMake(0, .5);
//    _navGradientLayer.endPoint = CGPointMake(1, .5);
//    [_navGradientView.layer insertSublayer:_navGradientLayer atIndex:0];
    
    
    UIImage *closeImg = [UIImage imageNamed:@"icon_back_gray"];
    width = closeImg.size.width + 30;
    height = NAVHEIGHT - 20;
    ox = 0;
    if (is_iPhone_X) {
        oy = 44;
    }else {
        oy = 20;
    }
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.backgroundColor = [UIColor clearColor];
    _backButton.frame = CGRectMake(ox, oy, width, height);
    [_backButton setImage:closeImg forState:UIControlStateNormal];
    _backButton.userInteractionEnabled = YES;
    _backButton.hidden = YES;
    [_navView addSubview:_backButton];
    [_backButton addTarget:self action:@selector(actionClose) forControlEvents:UIControlEventTouchUpInside];
    
    ox = _backButton.right;
    height = NAVHEIGHT - oy;
    width = SCREENWIDTH - ox * 2;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(ox, oy, width, height);
    _titleLabel.text = @"";
    _titleLabel.textColor = RGBA(0x303030, 1);
    if (NAVHEIGHT == 88) {
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }else{
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_navView addSubview:_titleLabel];
    
    _backButton.center = CGPointMake(_backButton.center.x, _titleLabel.center.y);
    
     _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT-1, SCREENWIDTH, 1)];
    _lineView.backgroundColor = RGBA(0xEEEEEE, 1);
    [_navView addSubview:_lineView];

}

#pragma mark - 右上键
- (void)setRightImgName:(NSString *)rightImgName {
    _rightImgName = rightImgName;
    if (rightImgName.length > 0) {
        [self setupRightButton:rightImgName];
    }
}

- (void)setupRightButton: (NSString *)imgName {
    UIImage *img = [UIImage imageNamed:imgName];
    
    width = img.size.width + 30;
    ox = SCREENWIDTH - width;
    if (is_iPhone_X) {
        oy = 44;
    }else {
        oy = 20;
    }
    height = NAVHEIGHT - oy;
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.backgroundColor = [UIColor clearColor];
    _rightButton.frame = CGRectMake(ox, oy, width, height);
    if (img) {
        [_rightButton setImage:img forState:UIControlStateNormal];
    }else {
        width =  [imgName boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil].size.width;
        
        [_rightButton setTitle:imgName forState:UIControlStateNormal];
        _rightButton.frame = CGRectMake(SCREENWIDTH-width  -16, oy, width, height);
        [_rightButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    }
    
    _rightButton.userInteractionEnabled = YES;
    [_navView addSubview:_rightButton];
    [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rightButtonClick: (UIButton *)button {
    
}


#pragma mark - 左上键
- (void)setLeftImgName:(NSString *)leftImgName {
    _leftImgName = leftImgName;
    if (leftImgName.length > 0) {
        _backButton.hidden = YES;
        [self setupLeftButton:leftImgName];
    }
}

- (void)setupLeftButton: (NSString *)imgName {
    UIImage *img = [UIImage imageNamed:imgName];
    
    width = img.size.width + 30;
    ox = 0;
    if (is_iPhone_X) {
        oy = 44;
    }else {
        oy = 20;
    }
    height = NAVHEIGHT - oy;
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.backgroundColor = [UIColor clearColor];
    _leftButton.frame = CGRectMake(ox, oy, width, height);
    if (img) {
        [_leftButton setImage:img forState:UIControlStateNormal];
    }else {
        [_leftButton setTitle:imgName forState:UIControlStateNormal];
        _leftButton.frame = CGRectMake(16, oy, 35, height);
        [_leftButton.titleLabel setFont:[UIFont fontWithName:@".PingFangSC-Regular" size:16.0f]];
    }
    
    _leftButton.userInteractionEnabled = YES;
    [_navView addSubview:_leftButton];
    [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)leftButtonClick: (UIButton *)button {
    
}


-(void)actionClose
{
    _isClosed = true;
    [self.navigationController popViewControllerAnimated:true];
    
}

-(void)dealloc
{
    XMJLog(@"dealloc");
    _isClosed = true;
}


@end
