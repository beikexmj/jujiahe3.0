//
//  SignRecordView.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/1.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCalendarView.h"

@interface SignRecordView : UIView
@property (nonatomic,strong)YXCalendarView *calendar;
@property (nonatomic,strong)UILabel *dayNum;
@property (nonatomic,strong)UIView *myView;
@property (nonatomic,strong)void (^btnBlock)(void);
- (void)setDataArry:(NSArray *)dataArray;

@end
