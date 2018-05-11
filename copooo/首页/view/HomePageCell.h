//
//  HomePageCell.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPagedFlowView.h"
#import "CCPScrollView.h"
#import "HomePageDataModel.h"
#import "YYLabel.h"
@interface HomePageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *flowView;
@property (weak, nonatomic) IBOutlet UIView *neighborhoodInteractionView;
@property (weak, nonatomic) IBOutlet UIView *dailySurpriseView;
@property (weak, nonatomic) IBOutlet UIView *propertyView;
@property (weak, nonatomic) IBOutlet UIView *xmjScrollView;
@property (weak, nonatomic) IBOutlet UIView *alertView;


- (IBAction)dailySurpriseBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewHeight;
@property (weak, nonatomic) IBOutlet UIView *propertySubView;

- (IBAction)seebroadCarstBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *neighborhoodSubTitle;
@property (weak, nonatomic) IBOutlet UIImageView *neighborhoodPicFlagOne;
@property (weak, nonatomic) IBOutlet UIImageView *neighborhoodheaderImgOne;
@property (weak, nonatomic) IBOutlet YYLabel *neighborhoodContentOne;
@property (weak, nonatomic) IBOutlet UIImageView *neighborhoodPicFlagTwo;
@property (weak, nonatomic) IBOutlet UIImageView *neighborhoodheaderImgTwo;
@property (weak, nonatomic) IBOutlet YYLabel *neighborhoodContentTwo;
@property (weak, nonatomic) IBOutlet UIImageView *neighborhoodPicFlagThree;
@property (weak, nonatomic) IBOutlet UIImageView *neighborhoodheaderImgThree;
@property (weak, nonatomic) IBOutlet YYLabel *neighborhoodContentThree;

@property (strong, nonatomic) YYLabel *neighborhoodContentOne2;
@property (strong, nonatomic) YYLabel *neighborhoodContentTwo2;
@property (strong, nonatomic) YYLabel *neighborhoodContentThree2;



- (IBAction)seeNeighborhoodBtnClick:(id)sender;

@property (nonatomic,strong)void (^seeNeighborhoodBtnBlock)(NSInteger integer);

@property (nonatomic,strong)void (^seeNeighborhoodHeaderTapBlock)(NSInteger integer);



@property (nonatomic,strong)void (^dailySurpriseBtnBlock)(NSInteger integer,NSInteger cellTag);
@property (nonatomic,strong)void (^btnClickBlock)(NSInteger integer);
@property (nonatomic,strong)void (^seebroadCarstBtnClickBlock)(void);

@property (nonatomic,strong)NSArray <Menu_dataArr *>*menu_datAarr;
@property (weak, nonatomic) IBOutlet UILabel *dailySurpriseName;
@property (weak, nonatomic) IBOutlet UIView *contentViewOne;
@property (weak, nonatomic) IBOutlet UIView *contentViewTwo;
@property (weak, nonatomic) IBOutlet UIView *contentViewThree;

@property (weak, nonatomic) IBOutlet UICollectionView *dailySurpriseCollectionView;
@property (nonatomic, strong)NSArray <Activity_formArr *> *myArr;
/**
 *  轮播图
 */
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;
/**
 *  滚动通知
 */
@property (nonatomic, strong) CCPScrollView *ccpScrollView;
@end
