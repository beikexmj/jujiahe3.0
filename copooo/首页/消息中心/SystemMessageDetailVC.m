//
//  SystemMessageDetailVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/29.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "SystemMessageDetailVC.h"

@interface SystemMessageDetailVC ()

@end

@implementation SystemMessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowNav = YES;
    self.navView.backgroundColor = RGBA(0xf6f6f6, 1);
    _backButton.hidden = NO;
    self.titleLabel.text = @"缴费消息详情";
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, NAVHEIGHT + 20, SCREENWIDTH - 24, 0)];
    contentLabel.textColor = RGBA(0x303030, 1);
    contentLabel.font = [UIFont systemFontOfSize:14.0];
    contentLabel.numberOfLines = 0;
    contentLabel.text = _dict.content;
    [contentLabel sizeToFit];
    [self.view addSubview:contentLabel];
    
//    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        //        make.edges.equalTo(headerView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
//        make.top.equalTo(self.view).with.offset(NAVHEIGHT +20);
//        make.left.equalTo(self.view).with.offset(12);
//        make.right.equalTo(self.view).with.offset(12);
//    }];
   
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = RGBA(0x9c9c9c, 1);
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).with.offset(10);
        make.right.equalTo(self.view).with.offset(-12);
        make.width.mas_equalTo(@120);
        make.height.mas_equalTo(@20);
    }];
    timeLabel.text = [StorageUserInfromation timeStrFromDateString:_dict.createTime];
    // Do any additional setup after loading the view.
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
