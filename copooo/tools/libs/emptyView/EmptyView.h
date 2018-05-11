//
//  EmptyView.h
//  copooo
//
//  Created by XiaMingjiang on 2018/3/7.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic,strong)void (^freshBlock)(void);
@end
