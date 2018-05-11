//
//  SignRecordView.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/1.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "SignRecordView.h"

@implementation SignRecordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self) {
        
        self = [super initWithFrame:frame];
        
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.3;
        [self addSubview:backView];
        
        _myView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 510)];
        _myView.backgroundColor = [UIColor whiteColor];
        _myView.layer.cornerRadius = 25;
        _myView.layer.masksToBounds = YES;
        [self addSubview:_myView];
        
        CGFloat height = [YXCalendarView getMonthTotalHeight:[NSDate date] type:CalendarType_Month];
        _calendar = [[YXCalendarView alloc] initWithFrame:CGRectMake(0, (SCREENWIDTH - 80)/5.0 + 40, [UIScreen mainScreen].bounds.size.width, height) Date:[NSDate date] Type:CalendarType_Month];
        __weak typeof(_calendar) weakCalendar = _calendar;
        _calendar.refreshH = ^(CGFloat viewH) {
            [UIView animateWithDuration:0.3 animations:^{
                weakCalendar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, viewH);
            }];
            
        };
        _calendar.sendSelectDate = ^(NSDate *selDate) {
            NSLog(@"%@",[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM-dd" Date:selDate]);
        };
        [_myView addSubview:_calendar];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 25, SCREENWIDTH - 80, (SCREENWIDTH - 80)/5.0)];
        imageView.image = [UIImage imageNamed:@"my_integral_flag"];
        imageView.center = CGPointMake(SCREENWIDTH/2.0, 55);
        [_myView addSubview:imageView];
        UILabel *dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 30)];
        dayLabel.font = [UIFont systemFontOfSize:16.0];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.textColor = RGBA(0xffffff, 1);
        dayLabel.text = @"本月已连续签到        天";
        dayLabel.center = CGPointMake(SCREENWIDTH/2.0, 55);
        [_myView addSubview:dayLabel];
        _dayNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        _dayNum.font = [UIFont systemFontOfSize:20.0];
        _dayNum.textAlignment = NSTextAlignmentCenter;
        _dayNum.textColor = RGBA(0xffffff, 1);
        _dayNum.center = CGPointMake(SCREENWIDTH/2.0 + 50, 55);
        [_myView addSubview:_dayNum];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 40, 25, 40, 40)];
        [btn setImage:[UIImage imageNamed:@"my_integral_close"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [_myView addSubview:btn];
    }
    
    return self;
}
-(void)btnClick{
    if (self.btnBlock) {
        self.btnBlock();
    }
}
- (void)setDataArry:(NSArray *)dataArray{
    
    NSMutableArray *array2 = [NSMutableArray array];
    static  NSInteger integer = 0;
    
    for (int i = 1; i<=[self getNumberOfDaysInMonth]; i++) {
        if ([dataArray containsObject:[NSString stringWithFormat:@"%d",i]]) {
            integer += 1;
        }else{
            integer = 0;
        }
        
        if (integer == 7 ||integer == 15 || integer == [self getNumberOfDaysInMonth]) {
            NSCalendar* calendar = [NSCalendar currentCalendar];
            
            unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
            NSDateComponents* comp1 = [calendar components:unitFlags fromDate:[NSDate date]];
            NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%d",[comp1 year],[comp1 month],i];
            NSDateFormatter *formate = [[NSDateFormatter alloc] init];
            [formate setDateFormat:@"YYYY-MM-dd"];
            
            NSDate *oncedate = [formate dateFromString:dateStr];
            [array2 addObject:oncedate];
        }
    }
    _calendar.continueSignDateArray = array2;
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in dataArray) {
        NSCalendar* calendar = [NSCalendar currentCalendar];
        
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
        NSDateComponents* comp1 = [calendar components:unitFlags fromDate:[NSDate date]];
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%@",[comp1 year],[comp1 month],str];
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"YYYY-MM-dd"];
        
        NSDate *oncedate = [formate dateFromString:dateStr];
        [array addObject:oncedate];
    }
    _calendar.selectDateArray = array;
    
}
// 获取当月的天数
- (NSInteger)getNumberOfDaysInMonth
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSGregorianCalendar - ios 8
    NSDate * currentDate = [NSDate date];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay  //NSDayCalendarUnit - ios 8
                                   inUnit: NSCalendarUnitMonth //NSMonthCalendarUnit - ios 8
                                  forDate:currentDate];
    return range.length;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.4 animations:^{
        self.myView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 550);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
