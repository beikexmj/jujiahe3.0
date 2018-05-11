//
//  HomePageVC.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/15.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageVC : BaseViewController<UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *dailyWord;

@property (nonatomic, strong) UILabel *day;

@property (nonatomic, strong) UILabel *month;

@property (nonatomic, strong) UILabel *week;

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UIButton *backBtn;
- (void)fetchData2;
@end
