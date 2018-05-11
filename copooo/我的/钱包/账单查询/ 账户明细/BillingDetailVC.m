//
//  BillingDetailVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/1.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "BillingDetailVC.h"

@interface BillingDetailVC ()

@end

@implementation BillingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self addSubView];
    // Do any additional setup after loading the view.
}
- (void)setNav{
    self.isShowNav = YES;
    _backButton.hidden = NO;
    if (_comfromFlag == 1) {
        self.titleLabel.text = @"余额明细";
    }else{
        self.titleLabel.text = @"账户明细";
    }
}
- (void)addSubView{
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + 20, SCREENWIDTH, 40)];
    moneyLabel.textColor = RGBA(0x303030, 1);
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = [UIFont systemFontOfSize:23.0];
    [self.view addSubview:moneyLabel];
    if (_dict.type == 0) {
        moneyLabel.text = [NSString stringWithFormat:@"+%0.2f",_dict.amount.floatValue];
    }else{
        moneyLabel.text = [NSString stringWithFormat:@"-%0.2f",_dict.amount.floatValue];
    }
    
    UILabel *markLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, moneyLabel.y + moneyLabel.height, SCREENWIDTH, 30)];
    markLabel.textColor = RGBA(0x303030, 1);
    markLabel.textAlignment = NSTextAlignmentCenter;
    markLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:markLabel];
    markLabel.text = _dict.state;
    
    CGFloat height = 0;
    
    for (int i = 0; i<5; i++) {
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, markLabel.y + markLabel.height + 20 + height, SCREENWIDTH, 40)];
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 80, 30)];
        typeLabel.textColor = RGBA(0x606060, 1);
        typeLabel.font = [UIFont systemFontOfSize:14.0];
        typeLabel.numberOfLines = 0;
        typeLabel.text = @[@"交易类型",@"支付方式",@"账单编号",@"创建时间",@"支付时间"][i];
        typeLabel.frame = CGRectMake(12, 0, 80, [typeLabel sizeThatFits:CGSizeMake(80, MAXFLOAT)].height+5);

        [myView addSubview:typeLabel];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80+12, 0, SCREENWIDTH - 80 - 12 - 12, 30)];
        nameLabel.textColor = RGBA(0x303030, 1);
        nameLabel.font = [UIFont systemFontOfSize:14.0];
        nameLabel.numberOfLines = 0;
        nameLabel.text = @[_dict.name,_dict.payChannel,_dict.orderId,[StorageUserInfromation timeStrFromDateString3:_dict.createTime],[StorageUserInfromation timeStrFromDateString3:_dict.payTime]][i];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 3; //设置行间距
        paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:nameLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:RGBA(0x303030, 1),NSParagraphStyleAttributeName:paraStyle}];
        nameLabel.attributedText = attrStr;
        
        CGFloat contentHeight = [StorageUserInfromation getStringSizeWith:nameLabel.text withStringFont:14.0 withWidthOrHeight:SCREENWIDTH - 80 - 12 - 12].height+5;
        nameLabel.frame = CGRectMake(80+12, 0, SCREENWIDTH - 80 - 12 - 12, contentHeight);
        myView.frame = CGRectMake(0, markLabel.y + markLabel.height + 20 + height, SCREENWIDTH, height + contentHeight);
        height += contentHeight;
        [myView addSubview:nameLabel];
        [self.view addSubview:myView];
        
    }
    
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
