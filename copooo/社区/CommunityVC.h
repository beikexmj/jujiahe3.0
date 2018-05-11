//
//  CommunityVC.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/15.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityVC : BaseViewController
@property (nonatomic,strong)UITableView *myTableView;
- (void)fetchHeaderData;
- (void)fetchList:(NSInteger)pageNum;
@end
