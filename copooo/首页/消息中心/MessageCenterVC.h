//
//  MessageCenterVC.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/29.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterVC : BaseViewController
@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic,strong)UITableView *myMessageTableView;
@property (nonatomic,strong)UITableView *systemMessageTableView;
@end
