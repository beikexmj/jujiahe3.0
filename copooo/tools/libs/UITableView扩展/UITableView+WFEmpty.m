//
//  UITableView+WFEmpty.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/18.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "UITableView+WFEmpty.h"
#import <objc/runtime.h>
static char UITableViewEmptyView;

@implementation UITableView (WFEmpty)

@dynamic emptyView;

- (UIView *)emptyView
{
    return objc_getAssociatedObject(self, &UITableViewEmptyView);
}

- (void)setEmptyView:(UIView *)emptyView
{
    [self willChangeValueForKey:@"HJEmptyView"];
    objc_setAssociatedObject(self, &UITableViewEmptyView,
                             emptyView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"HJEmptyView"];
}


-(void)addEmptyViewWithImageName:(NSString*)imageName title1:(NSString*)title1 title2:(NSString*)title2
{
    if (self.emptyView){
        [self.emptyView removeFromSuperview];
    }
    {
        CGRect frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT);
        UIImage* image = [UIImage imageNamed:imageName];
        NSString* text = title1;
        
        UIView* noMessageView = [[UIView alloc] initWithFrame:frame];
        noMessageView.backgroundColor = RGBCOLOR(255, 255, 255);
        
        UIImageView *carImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-image.size.width)/2, 140, image.size.width, image.size.height)];
        [carImageView setImage:image];
        [noMessageView addSubview:carImageView];
        
        UILabel *noInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, frame.size.width, 20)];
        noInfoLabel.textAlignment = NSTextAlignmentCenter;
        noInfoLabel.textColor = RGBCOLOR(96, 96, 96);
        noInfoLabel.text = text;
        noInfoLabel.backgroundColor = [UIColor clearColor];
        noInfoLabel.font = [UIFont systemFontOfSize:20];
        [noMessageView addSubview:noInfoLabel];
        
        UILabel *noInfoLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 340, frame.size.width, 20)];
        noInfoLabel2.textAlignment = NSTextAlignmentCenter;
        noInfoLabel2.textColor = RGBCOLOR(156, 156, 156);
        noInfoLabel2.text = title2;
        noInfoLabel2.backgroundColor = [UIColor clearColor];
        noInfoLabel2.font = [UIFont systemFontOfSize:15];
        [noMessageView addSubview:noInfoLabel2];
        
        [self addSubview:noMessageView];
        
        self.emptyView = noMessageView;
    }
    
}
-(void)addEmptyViewWithImageName:(NSString*)imageName title:(NSString*)title {
    if (self.emptyView){
        [self.emptyView removeFromSuperview];
    }
    {
        CGRect frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT);
        UIImage* image = [UIImage imageNamed:imageName];
        NSString* text = title;
        
        UIView* noMessageView = [[UIView alloc] initWithFrame:frame];
        noMessageView.backgroundColor = RGBCOLOR(255, 255, 255);
        
        UIImageView *carImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-image.size.width)/2, 140, image.size.width, image.size.height)];
        [carImageView setImage:image];
        [noMessageView addSubview:carImageView];
        
        UILabel *noInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, frame.size.width, 20)];
        noInfoLabel.textAlignment = NSTextAlignmentCenter;
        noInfoLabel.textColor = RGBCOLOR(156, 156, 156);
        noInfoLabel.text = text;
        noInfoLabel.backgroundColor = [UIColor clearColor];
        noInfoLabel.font = [UIFont systemFontOfSize:15];
        [noMessageView addSubview:noInfoLabel];
        
        [self addSubview:noMessageView];
        
        self.emptyView = noMessageView;
    }
    
}
@end
