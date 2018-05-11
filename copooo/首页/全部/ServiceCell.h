//
//  ServiceCell.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/8.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIView *firstRowView;
@property (weak, nonatomic) IBOutlet UIView *secondRowView;
@property (weak, nonatomic) IBOutlet UIView *thirdRowView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondImg;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImg;
@property (weak, nonatomic) IBOutlet UIImageView *fourImg;
@property (weak, nonatomic) IBOutlet UIImageView *fiveImg;
@property (weak, nonatomic) IBOutlet UIImageView *sixImg;
@property (weak, nonatomic) IBOutlet UIImageView *sevenImg;
@property (weak, nonatomic) IBOutlet UIImageView *eightImg;
@property (weak, nonatomic) IBOutlet UIImageView *nightImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstRowHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondRowHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdRowHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToLeft;
@property (weak, nonatomic) IBOutlet UILabel *comentState;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starView;
@property (weak, nonatomic) IBOutlet UILabel *comentContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botomViewHight;

@property (weak, nonatomic) IBOutlet UIButton *comentBtn;
@property (weak, nonatomic) IBOutlet UIView *gotoComentView;
@property (weak, nonatomic) IBOutlet UIView *comentStarView;
- (IBAction)gotoComentBtnClick:(id)sender;
@property (nonatomic,strong)void (^comentBlock)(NSInteger integer);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeWidth;
@property (nonatomic,strong)void(^imageViewTapBlock)(NSInteger integer,UIImageView *imageView);
@property (weak, nonatomic) IBOutlet UIView *imgFatherView;
@end
