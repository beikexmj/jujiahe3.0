//
//  UITableView+WFEmpty.h
//  copooo
//
//  Created by XiaMingjiang on 2017/8/18.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (WFEmpty)
@property (nonatomic, strong, readonly) UIView *emptyView;

-(void)addEmptyViewWithImageName:(NSString*)imageName title:(NSString*)title;
-(void)addEmptyViewWithImageName:(NSString*)imageName title1:(NSString*)title1 title2:(NSString*)title2;
@end
