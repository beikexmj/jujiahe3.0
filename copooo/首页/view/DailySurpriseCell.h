//
//  DailySurpriseCell.h
//  copooo
//
//  Created by XiaMingjiang on 2018/4/16.
//  Copyright © 2018年 XiaMingjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailySurpriseCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *realPrice;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *hotFlag;

@end
