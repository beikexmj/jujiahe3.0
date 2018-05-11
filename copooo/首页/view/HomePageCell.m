//
//  HomePageCell.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "HomePageCell.h"
#import "JSBadgeView.h"
#import "DailySurpriseCell.h"
#import "CommunityJSVC.h"
#import "UIView+Extensions.h"

@interface HomePageCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation HomePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUIWithFlowView];
    [self setupUIWithPropertyView];
    [_dailySurpriseCollectionView registerNib:[UINib nibWithNibName:@"DailySurpriseCell" bundle:nil] forCellWithReuseIdentifier:@"DailySurpriseCell"];
    _dailySurpriseCollectionView.scrollEnabled = YES;
    _myArr = [NSArray array];
    self.neighborhoodheaderImgOne.layer.cornerRadius = 20;
    self.neighborhoodheaderImgOne.layer.masksToBounds = YES;
    self.neighborhoodheaderImgOne.userInteractionEnabled = YES;
    self.neighborhoodheaderImgOne.tag = 1;
    self.neighborhoodheaderImgOne.contentMode = UIViewContentModeScaleAspectFill;

    self.neighborhoodheaderImgTwo.layer.cornerRadius = 20;
    self.neighborhoodheaderImgTwo.layer.masksToBounds = YES;
    self.neighborhoodheaderImgTwo.userInteractionEnabled = YES;
    self.neighborhoodheaderImgTwo.tag = 2;
    self.neighborhoodheaderImgTwo.contentMode = UIViewContentModeScaleAspectFill;

    self.neighborhoodheaderImgThree.layer.cornerRadius = 20;
    self.neighborhoodheaderImgThree.layer.masksToBounds = YES;
    self.neighborhoodheaderImgThree.userInteractionEnabled = YES;
    self.neighborhoodheaderImgThree.tag = 3;
    self.neighborhoodheaderImgThree.contentMode = UIViewContentModeScaleAspectFill;

    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTap:)];
    [self.neighborhoodheaderImgOne addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTap:)];
    [self.neighborhoodheaderImgTwo addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTap:)];
    [self.neighborhoodheaderImgThree addGestureRecognizer:tap3];
//    self.neighborhoodContentOne.editable = NO;
//    self.neighborhoodContentTwo.editable = NO;
//    self.neighborhoodContentThree.editable = NO;
////    self.neighborhoodContentOne.scrollEnabled = NO;
////    self.neighborhoodContentTwo.scrollEnabled = NO;
////    self.neighborhoodContentThree.scrollEnabled = NO;
//    self.neighborhoodContentOne.selectable=YES;
//    self.neighborhoodContentTwo.selectable=YES;
//    self.neighborhoodContentThree.selectable=YES;
    self.neighborhoodContentOne2 = [YYLabel new];
    self.neighborhoodContentOne2.frame = CGRectMake(68, 8, SCREENWIDTH - 106, 40);
    self.neighborhoodContentOne2.numberOfLines = 2;
    self.neighborhoodContentOne2.font = [UIFont systemFontOfSize:15.0];
    [self.contentViewOne addSubview:self.neighborhoodContentOne2];
    self.neighborhoodContentTwo2 = [YYLabel new];
    self.neighborhoodContentTwo2.frame = CGRectMake(68, 8, SCREENWIDTH - 106, 40);
    self.neighborhoodContentTwo2.numberOfLines = 2;
    self.neighborhoodContentTwo2.font = [UIFont systemFontOfSize:15.0];
    [self.contentViewTwo addSubview:self.neighborhoodContentTwo2];
    self.neighborhoodContentThree2 = [YYLabel new];
    self.neighborhoodContentThree2.frame = CGRectMake(68, 8, SCREENWIDTH - 106,40);
    self.neighborhoodContentThree2.numberOfLines = 2;
    self.neighborhoodContentThree2.font = [UIFont systemFontOfSize:15.0];
    [self.contentViewThree addSubview:self.neighborhoodContentThree2];
    self.neighborhoodContentOne2.userInteractionEnabled  = YES;
    self.neighborhoodContentTwo2.userInteractionEnabled  = YES;
    self.neighborhoodContentThree2.userInteractionEnabled  = YES;
    self.neighborhoodContentTwo.hidden = YES;
    self.neighborhoodContentTwo.hidden = YES;
    self.neighborhoodContentThree.hidden = YES;
    self.neighborhoodContentOne2.preferredMaxLayoutWidth = SCREENWIDTH - 106; //设置最大的宽度
    self.neighborhoodContentTwo2.preferredMaxLayoutWidth = SCREENWIDTH - 106; //设置最大的宽度
    self.neighborhoodContentThree2.preferredMaxLayoutWidth = SCREENWIDTH - 106; //设置最大的宽度
    // Initialization code
}
- (void)setupUIWithFlowView {
    
    
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
    pageFlowView.backgroundColor = [UIColor whiteColor];
//    pageFlowView.delegate = self;
//    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.8;
    pageFlowView.isOpenAutoScroll = YES;
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 24, SCREENWIDTH, 8)];
    pageFlowView.pageControl = pageControl;
    [pageFlowView addSubview:pageControl];
    
    
    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为NewPagedFlowView的容器View,才会显示正常,如下
     *****************************/
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
    [bottomScrollView addSubview:pageFlowView];
    [_flowView addSubview:bottomScrollView];
    
    [bottomScrollView addSubview:pageFlowView];
    
    self.pageFlowView = pageFlowView;
    
}
- (void)setupUIWithPropertyView{
    _alertView.layer.cornerRadius = 5;
    _alertView.layer.borderColor = RGBA(0xdddddd, 1).CGColor;
    _alertView.layer.borderWidth = 1;
    _alertView.layer.masksToBounds = YES;
    _ccpScrollView = [[CCPScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 115, 35)];
    _ccpScrollView.titleFont = 13;
    _ccpScrollView.titleColor = RGBA(0x303030, 1);
    _ccpScrollView.BGColor = [UIColor clearColor];
    [self.xmjScrollView addSubview:_ccpScrollView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setMenu_datAarr:(NSArray<Menu_dataArr *> *)menu_datAarr{
    for (UIView *view in self.propertySubView.subviews) {
        [view removeFromSuperview];
    }
    _menu_datAarr = menu_datAarr;
    int i = 0;
    CGFloat width = SCREENWIDTH/menu_datAarr.count;
    CGFloat hight = 90;
    CGFloat imgWith = 55*(SCREENWIDTH/375.0)>55?55:55*(SCREENWIDTH/375.0);
    CGFloat imgHight = imgWith;
    for (Menu_dataArr *onceDict in menu_datAarr) {
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(width*i, 0, width, hight)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width-imgWith)/2.0, 10, imgWith, imgHight)];
        [myView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:onceDict.icon] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, hight - 21, width, 21)];
        myLabel.font = [UIFont systemFontOfSize:12];
        myLabel.textColor =RGBA(0x606060, 1);
        myLabel.textAlignment = NSTextAlignmentCenter;
        myLabel.text = onceDict.name;
        [myView addSubview:myLabel];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, hight)];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [myView addSubview:btn];
        
        if (onceDict.hot == 1) {
            JSBadgeView *bage = [[JSBadgeView alloc]initWithParentView:btn alignment:JSBadgeViewAlignmentBottomRight];
            bage.layer.borderColor = RGBA(0xffffff, 1).CGColor;
            bage.layer.borderWidth = 1;
            bage.layer.cornerRadius = 5;
            bage.layer.masksToBounds = YES;
            bage.badgeText = @"HOT";
        }
        
        [_propertySubView addSubview:myView];
        
        
        i++;
    }
}
- (void)btnClick:(UIButton *)btn{
    if (self.btnClickBlock) {
        self.btnClickBlock(btn.tag);
    }
}
- (IBAction)dailySurpriseBtnClick:(id)sender {
    UIButton *btn = sender;
    if (self.dailySurpriseBtnBlock) {
        self.dailySurpriseBtnBlock(btn.tag,self.tag);
    }
}
- (IBAction)dailSurpriseBtnClick:(id)sender {
}

- (IBAction)seebroadCarstBtnClick:(id)sender {
    if (self.seebroadCarstBtnClickBlock) {
        self.seebroadCarstBtnClickBlock();
    }
}
- (IBAction)seeNeighborhoodBtnClick:(id)sender {
    UIButton *btn = sender;
    if (self.seeNeighborhoodBtnBlock) {
        self.seeNeighborhoodBtnBlock(btn.tag);
    }
}
- (void)headerTap:(UIGestureRecognizer *)tap{
    NSInteger integer = tap.view.tag;
    if (self.seeNeighborhoodHeaderTapBlock) {
        self.seeNeighborhoodHeaderTapBlock(integer);
    }
}
- (void)setMyArr:(NSArray<Activity_formArr *> *)myArr{
    _myArr = myArr;
    [_dailySurpriseCollectionView reloadData];
    
}
#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _myArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DailySurpriseCell *cell = [_dailySurpriseCollectionView dequeueReusableCellWithReuseIdentifier:@"DailySurpriseCell" forIndexPath:indexPath];
    [cell.pic sd_setImageWithURL:[NSURL URLWithString:_myArr[indexPath.row].icon] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
    cell.name.text = _myArr[indexPath.row].name;
    if (_myArr[indexPath.row].is_main == 1) {
        cell.hotFlag.hidden = NO;
    }else{
        cell.hotFlag.hidden = YES;
    }
    cell.realPrice.text = [NSString stringWithFormat:@"¥%@",_myArr[indexPath.row].activity_price];
    cell.price.text = [NSString stringWithFormat:@"¥%@",_myArr[indexPath.row].price];
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSFontAttributeName:[UIFont systemFontOfSize:13.0],NSForegroundColorAttributeName:RGBA(0x9c9c9c, 1)};
    cell.price.attributedText = [[NSMutableAttributedString alloc]initWithString:cell.price.text attributes:attribtDic];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [MobClick event:@"lsjx_c" label:[NSString stringWithFormat:@"%@",_myArr[indexPath.row].goodsId]];
    NSString  *url = [NSString stringWithFormat:@"%@#!/lifeDetail",BASE_H5_URL];
    CommunityJSVC * page = [[CommunityJSVC alloc]init];
    page.url = url;
    page.goodsId = _myArr[indexPath.row].goodsId;
    
    [self.window.currentViewController.navigationController pushViewController:page animated:YES];
}
#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(SCREENWIDTH - 45)/2.0 - 10,165};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

@end
