//
//  CommunityHeaderView.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/26.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityHeaderView : UIView
{
    CommunityHeaderView *communityHeaderView;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recommendAdvHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activeAndServiceHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *neighborhoodInteractionHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstRowMarkHightForNeighborhoodInteraction;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondRowMarkHightForNeighborhoodInteraction;
@property (weak, nonatomic) IBOutlet UIView *recommendAdvView;
@property (weak, nonatomic) IBOutlet UIImageView *activeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *serviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *neighborhoodInteractionTitle;
@property (weak, nonatomic) IBOutlet UIView *firstRowViewForNeighborhoodInteraction;
@property (weak, nonatomic) IBOutlet UIView *secondRowViewForNeighborhoodInteraction;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixBtn;
@property (weak, nonatomic) IBOutlet UIButton *sevenBtn;
@property (weak, nonatomic) IBOutlet UIButton *eightBtn;
- (IBAction)neighborhoodInteractionBtnClick:(id)sender;
@property (nonatomic,strong)void (^neighborhoodInteractionBtnBlock)(NSInteger integer);
- (instancetype)initWithCount:(NSInteger)count activityFlag:(BOOL)flag2;
@property (weak, nonatomic) IBOutlet UIView *linliHeaderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linliHeaderViewHigth;

@end
