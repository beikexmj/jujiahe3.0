//
//  CommunityCell.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/26.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYLabel.h"

@interface CommunityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet YYLabel *content;
@property (nonatomic,strong) YYLabel *content2;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *commentNum;
@property (weak, nonatomic) IBOutlet UILabel *likeNum;
- (IBAction)moreBtnClick:(id)sender;
- (IBAction)commentBtnClick:(id)sender;
- (IBAction)likeBtnClick:(id)sender;
@property (nonatomic,strong)void(^moreBtnBlock)(NSInteger integer);
@property (nonatomic,strong)void(^commentBtnBlock)(NSInteger integer);
@property (nonatomic,strong)void(^likeBtnBlock)(NSInteger integer ,CommunityCell *cell);
@property (nonatomic,strong)void(^imageViewTapBlock)(NSInteger integer,UIImageView *imageView);
@property (weak, nonatomic) IBOutlet UIView *oneImageView;
@property (weak, nonatomic) IBOutlet UIView *twoImageView;
@property (weak, nonatomic) IBOutlet UIView *threeOrMoreImageView;
@property (weak, nonatomic) IBOutlet UIView *imageFatherView;
@property (weak, nonatomic) IBOutlet UIImageView *picOneInOneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *picOneInTwoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *picTwoInTwoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *picOneInThreeOrMoreImageView;
@property (weak, nonatomic) IBOutlet UIImageView *picTwoInThreeOrMoreImageView;
@property (weak, nonatomic) IBOutlet UIImageView *picThreeInThreeOrMoreImageView;
@property (weak, nonatomic) IBOutlet UIImageView *picFourInThreeOrMoreImageView;
@property (weak, nonatomic) IBOutlet UIImageView *picFiveInThreeOrMoreImageView;
@property (weak, nonatomic) IBOutlet UIImageView *picSixInThreeOrMoreImageView;
@property (weak, nonatomic) IBOutlet UIImageView *picSevenInThreeOrMoreImageView;
@property (weak, nonatomic) IBOutlet UIImageView *picEightInThreeOrMoreImageView;
@property (weak, nonatomic) IBOutlet UIImageView *picNightInThreeOrMoreImageView;
@property (weak, nonatomic) IBOutlet UIView *firstRowInThreeImageView;
@property (weak, nonatomic) IBOutlet UIView *secondRowInThreeImageView;
@property (weak, nonatomic) IBOutlet UIView *thirdRowInThreeImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstRowHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondRowHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdRowHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picOneInOneImageViewToRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewToBottomGap;
@end
