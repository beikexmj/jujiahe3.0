//
//  ArrearageDetailVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/31.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "ArrearageDetailVC.h"

@interface ArrearageDetailVC ()

@end

@implementation ArrearageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self addSubView];
    // Do any additional setup after loading the view.
}
- (void)setNav{
    self.isShowNav = YES;
    _backButton.hidden = NO;
    self.titleLabel.text = @"欠费详情";
}
- (void)addSubView{
    self.view.backgroundColor = RGBA(0xeeeeee, 1);
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, 2*30+80)];
    topView.backgroundColor = RGBA(0xffffff, 1);

    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 40)];
    money.font = [UIFont systemFontOfSize:30];
    money.textColor = RGBA(0x303030, 1);
    money.textAlignment = NSTextAlignmentCenter;
    money.text = [NSString stringWithFormat:@"%0.2f",_dict.price.floatValue];
;
    [topView addSubview:money];
    
    UILabel *typeName = [[UILabel alloc]initWithFrame:CGRectMake(0, money.y + money.height, SCREENWIDTH, 25)];
    typeName.font = [UIFont systemFontOfSize:14];
    typeName.textColor = RGBA(0x303030, 1);
    typeName.textAlignment = NSTextAlignmentCenter;
    typeName.text = @"欠费金额(元)";
    [topView addSubview:typeName];
    
    for (int i = 0; i<2; i++) {
        UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(12, i*30 + typeName.y +typeName.height + 5, SCREENWIDTH - 12*2, 30)];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH -12*2, 1)];
        lineView.backgroundColor = RGBA(0xeeeeee, 1);
        [subView addSubview:lineView];
        
        UILabel *type = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        type.font = [UIFont systemFontOfSize:13];
        type.textColor = RGBA(0x9c9c9c, 1);
        type.text = @[@"欠费类型",@"生成时间"][i];
        [subView addSubview:type];
        
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(100  , 0, subView.width - 100, 30)];
        name.font = [UIFont systemFontOfSize:13];
        name.textColor = RGBA(0x606060, 1);
        name.textAlignment = NSTextAlignmentRight;
        if (i == 0) {
            name.text = _dict.type;
        }else{
            if (_dict.createTime.length>=3) {
                name.text = [_dict.createTime substringToIndex:_dict.createTime.length - 3];
            }
        }
        [subView addSubview:name];
        [topView addSubview:subView];
    }
    [self.view addSubview:topView];
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.y +topView.height + 10, SCREENWIDTH, 30)];
    detailView.backgroundColor  = RGBA(0xffffff, 1);
    UILabel *type = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 60, 30)];
    type.font = [UIFont systemFontOfSize:13];
    type.textColor = RGBA(0x9c9c9c, 1);
    type.text = @"详情";
    [detailView addSubview:type];
    
    UILabel *nameOne = [[UILabel alloc]initWithFrame:CGRectMake(  50 + 12  , 0, detailView.width - 12*2 - 50, 30)];
    nameOne.font = [UIFont systemFontOfSize:13];
    nameOne.textColor = RGBA(0x606060, 1);
    nameOne.textAlignment = NSTextAlignmentRight;
    nameOne.text = _dict.describe;
    [detailView addSubview:nameOne];
    
    [self.view addSubview:detailView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
