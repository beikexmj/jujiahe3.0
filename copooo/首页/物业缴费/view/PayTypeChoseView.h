//
//  PayTypeChoseView.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/30.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTypeChoseView : UIView
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)payBtnClick:(id)sender;
- (IBAction)choseBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *alyPayImg;
@property (weak, nonatomic) IBOutlet UIImageView *banlancePayImg;
@property (nonatomic,strong)void(^payBtnBlock)(void);
@property (nonatomic,strong)void(^backBtnBlock)(void);

@property (nonatomic,strong)void (^choseBtnBlock)(NSInteger integer);
@end
