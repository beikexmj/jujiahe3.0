//
//  CommunityHeaderView.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/26.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "CommunityHeaderView.h"

@implementation CommunityHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithCount:(NSInteger)count activityFlag:(BOOL)flag2{
    if (!communityHeaderView) {
        communityHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"CommunityHeaderView" owner:self options:nil] lastObject];
        communityHeaderView.recommendAdvHight.constant = SCREENWIDTH*(8/15.0);
        if (flag2) {
            communityHeaderView.activeAndServiceHight.constant = (SCREENWIDTH - 12*2-10)/2.0 *(4/9.0) + 10*2 +10;
        }else{
            communityHeaderView.activeAndServiceHight.constant = 0;

        }
        if (count>0) {
            communityHeaderView.firstRowMarkHightForNeighborhoodInteraction.constant = ((SCREENWIDTH - 12*2 -15*3)/4.0) *(33/82.0);
            if (count>4){
                communityHeaderView.secondRowMarkHightForNeighborhoodInteraction.constant = ((SCREENWIDTH - 12*2 -15*3)/4.0) *(33/82.0);
            }else{
                communityHeaderView.secondRowMarkHightForNeighborhoodInteraction.constant = 0;
                communityHeaderView.secondRowViewForNeighborhoodInteraction.hidden = YES;
            }
            communityHeaderView.neighborhoodInteractionHight.constant = 40 + communityHeaderView.secondRowMarkHightForNeighborhoodInteraction.constant +  communityHeaderView.firstRowMarkHightForNeighborhoodInteraction.constant + 10;
        }else{
            communityHeaderView.firstRowMarkHightForNeighborhoodInteraction.constant = 0;
            communityHeaderView.firstRowViewForNeighborhoodInteraction.hidden = YES;

            communityHeaderView.secondRowMarkHightForNeighborhoodInteraction.constant = 0;
            communityHeaderView.neighborhoodInteractionHight.constant = 0;
            communityHeaderView.linliHeaderView.hidden = YES;
            communityHeaderView.linliHeaderViewHigth.constant = 0;
        }
        
        
        communityHeaderView.frame = CGRectMake(0, 0, SCREENWIDTH, communityHeaderView.recommendAdvHight.constant + communityHeaderView.activeAndServiceHight.constant + communityHeaderView.neighborhoodInteractionHight.constant);
        
    }
    return communityHeaderView;
}
- (IBAction)neighborhoodInteractionBtnClick:(id)sender {
    UIButton *btn = sender;
    if (self.neighborhoodInteractionBtnBlock) {
        self.neighborhoodInteractionBtnBlock(btn.tag);
    }
}
@end
