//
//  MyIntegralCell.h
//  copooo
//
//  Created by XiaMingjiang on 2018/2/28.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyIntegralCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *integralNum;
@property (weak, nonatomic) IBOutlet UIButton *markBtn;
- (IBAction)markBtnClick:(id)sender;
@property (nonatomic,strong)void (^markBtnBlock)(NSInteger integer);
@end
