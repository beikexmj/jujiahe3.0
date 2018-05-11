//
//  MyMessageCell.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/29.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *headerOne;
@property (weak, nonatomic) IBOutlet UIImageView *headerTwo;
@property (weak, nonatomic) IBOutlet UIImageView *headerThree;
@property (weak, nonatomic) IBOutlet UIImageView *headerFour;
@property (weak, nonatomic) IBOutlet UILabel *more;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markWidth;

@end
