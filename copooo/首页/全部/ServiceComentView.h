//
//  ServiceComentView.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/8.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceComentView : UIView
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UITextView *coment;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIView *threeStarView;
@property (weak, nonatomic) IBOutlet UIView *twoStarView;
@property (weak, nonatomic) IBOutlet UIView *oneStarView;
- (IBAction)comentStarBtnClick:(id)sender;
@property (nonatomic,strong)void (^comentStarBlock)(NSInteger integer);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToLeft;

@end
