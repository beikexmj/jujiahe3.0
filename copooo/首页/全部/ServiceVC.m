//
//  ServiceVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/8.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "ServiceVC.h"
#import "ServiceCell.h"
#import "ServiceComentVC.h"
#import "PublishServiceVC.h"
#import "MJRefresh.h"
#import "ServiceDataModel.h"
#import "UITableView+WFEmpty.h"
#import "XLPhotoBrowser.h"
@interface ServiceVC ()<UITableViewDelegate,UITableViewDataSource,XLPhotoBrowserDelegate,XLPhotoBrowserDatasource,UIActionSheetDelegate>
{
    CGFloat bottomBtnHight;
    NSInteger pageNum;
    NSInteger indexPathRow;
    NSInteger totolPicNum;
    NSMutableArray *imageArr;
}
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)NSMutableArray <ServiceDataArr *>*myArr;
@property (nonatomic,strong)NSMutableDictionary * hightDict;

@end

@implementation ServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowNav = YES;
    _backButton.hidden = NO;
    //    self.leftImgName = @"icon_back_gray";
    if (_titleStr) {
        self.titleLabel.text = _titleStr;
    }
    self.navView.backgroundColor = RGBA(0xeeeeee, 1);
    bottomBtnHight = TABBARHEIGHT;
    _myArr = [NSMutableArray array];
    imageArr = [NSMutableArray array];
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.bottomBtn];
    pageNum = 1;
    WeakSelf
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongSelf
        pageNum = 1;
        [strongSelf fetchData:1];
    }];
    _myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        StrongSelf
        pageNum++;
        [strongSelf fetchData:pageNum];
    }];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    pageNum = 1;
    [self fetchData:1];
}
- (void)fetchData:(NSInteger)page{
    NSDictionary *dict = @{@"userId":[StorageUserInfromation storageUserInformation].userId,@"page":[NSString stringWithFormat:@"%ld",page],@"pagesize":@"12",@"menuId":_menuId,@"apiv":@"1.0"};
    [ZTHttpTool postWithUrl:@"property/v1/PropertyService/infos" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        ServiceDataModel *data = [ServiceDataModel mj_objectWithKeyValues:str];

        if (data.rcode == 0) {
            
            if (data.form.count>0) {
                if (pageNum == 1) {
                    [_myArr removeAllObjects];
                    [_hightDict removeAllObjects];
                    [_myArr addObjectsFromArray:data.form];
                    [self.myTableView reloadData];
                }else{
                    [_myArr addObjectsFromArray:data.form];
                    NSMutableArray *insertIndexPaths = [NSMutableArray array];
                    for (int ind = 0; ind < data.form.count; ind++) {
                        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow: _myArr.count - data.form.count + ind inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    //重新调用UITableView的方法, 来生成行.
                    [UIView performWithoutAnimation:^{
                        [self.myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                        [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_myArr.count - data.form.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    }];
                }
            }else{
                if (page>1) {
                    pageNum--;
                }
            }
            if (_myArr.count ==0) {
                [self.myTableView addEmptyViewWithImageName:@"暂无记录" title:@"暂无记录"];
                [self.myTableView.emptyView setHidden:NO];
            }else{
                [self.myTableView.emptyView setHidden:YES];
            }
        }else{
            if (page>1) {
                pageNum--;
            }
            [self.myTableView addEmptyViewWithImageName:@"暂无记录" title:@"暂无记录"];
            [self.myTableView.emptyView setHidden:NO];
        }

    } failure:^(NSError *error) {
        XMJLog(@"%@",error);
        if (page>1) {
            pageNum--;
        }
        [self.myTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"暂无网络连接"];
        [self.myTableView.emptyView setHidden:NO];
        
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];

    }];
    
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - 60 +10) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.backgroundColor = RGBA(0xeeeeee, 1);
        [_myTableView registerNib:[UINib nibWithNibName:@"ServiceCell" bundle:nil] forCellReuseIdentifier:@"ServiceCell"];

        
    }
    return _myTableView;
}
-(UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - bottomBtnHight, SCREENWIDTH, bottomBtnHight)];
        [_bottomBtn setBackgroundImage:[UIImage imageNamed:@"home_button1_normal"] forState:UIControlStateNormal];
        [_bottomBtn setBackgroundImage:[UIImage imageNamed:@"home_button1_press"] forState:UIControlStateHighlighted];
        [_bottomBtn setTitle:[NSString stringWithFormat:@"添加%@", _titleStr] forState:UIControlStateNormal];
        [_bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_bottomBtn setTitleColor:RGBA(0xffffff, 1) forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_bottomBtn addTarget:self action:@selector(addServiceBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}
- (void)addServiceBtn{
    PublishServiceVC *page = [[PublishServiceVC alloc]init];
    page.titleStr = _titleStr;
    page.menuId = _menuId;
    [self.navigationController pushViewController:page animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cell = @"ServiceCell";
    ServiceCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell forIndexPath:indexPath];
    if (!myCell) {
        myCell = [[[NSBundle mainBundle] loadNibNamed:cell owner:self options:nil] lastObject];
    }
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    myCell.comentBtn.tag = indexPath.row;
    myCell.comentBlock = ^(NSInteger integer) {
        ServiceDataArr *onceDict2 = _myArr[integer];
        ServiceComentVC *page = [[ServiceComentVC alloc]init];
        page.myDict = onceDict2;
        [self.navigationController pushViewController:page animated:YES];
    };
    myCell.tag = indexPath.row;
    WeakSelf
    myCell.imageViewTapBlock = ^(NSInteger integer, UIImageView *imageView) {
        ServiceDataArr *onceDict2 = _myArr[integer/10];
        StrongSelf
        [strongSelf clickImage:imageView tag:integer totol:onceDict2.imageUrl.count];
    };
    myCell.firstRowHight.constant = 0;
    myCell.secondRowHight.constant = 0;
    myCell.thirdRowHight.constant = 0;
    myCell.imgViewHight.constant = 0;
    myCell.firstRowView.hidden = YES;
    myCell.secondRowView.hidden = YES;
    myCell.thirdRowView.hidden = YES;
    myCell.firstImg.hidden = YES;
    myCell.secondImg.hidden = YES;
    myCell.thirdImg.hidden = YES;
    myCell.fourImg.hidden = YES;
    myCell.fiveImg.hidden = YES;
    myCell.sixImg.hidden = YES;
    myCell.sevenImg.hidden = YES;
    myCell.eightImg.hidden = YES;
    myCell.nightImg.hidden = YES;

    if (_myArr.count>0) {
        ServiceDataArr *onceDict = _myArr[indexPath.row];
        if (onceDict.time.length>3) {
            myCell.time.text = [onceDict.time substringToIndex:onceDict.time.length - 3];
        }
        UIColor *color;
        if (onceDict.status == 0) {
            myCell.state.text = @"未完成";
            myCell.state.textColor = RGBA(0x00a7ff, 1);
            myCell.type.backgroundColor = RGBA(0x00a7ff, 1);
            myCell.title.textColor = RGBA(0x303030, 1);
            color = RGBA(0x606060, 1);
        }else{
            myCell.state.text = @"已完成";
            myCell.state.textColor = RGBA(0x9c9c9c, 1);
            myCell.type.backgroundColor = RGBA(0x9c9c9c, 1);
            myCell.title.textColor = RGBA(0x9c9c9c, 1);
            color = RGBA(0x9c9c9c, 1);
        }
        if (onceDict.typeName) {
            myCell.type.text = onceDict.typeName;
            myCell.typeWidth.constant = [myCell.type sizeThatFits:CGSizeMake(150, 21)].width + 15;
            
            myCell.titleToLeft.constant = 8;

        }else{
            myCell.type.text = @"";
            myCell.typeWidth.constant = 0;
            myCell.titleToLeft.constant = 0;
        }
        myCell.title.text = onceDict.areaAddress;
        if (![onceDict.content isEqualToString:@""]) {
            myCell.content.text = onceDict.content;
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineSpacing = 3; //设置行间距
            paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:myCell.content.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:paraStyle}];
            myCell.content.attributedText = attrStr;
            
            CGFloat contentHeight = [StorageUserInfromation getStringSizeWith:onceDict.content withStringFont:15.0 withWidthOrHeight:SCREENWIDTH-24].height +10;
            myCell.contentHight.constant = contentHeight;
        }else{
            myCell.contentHight.constant = 0;

        }
        if (onceDict.level == 0) {
            myCell.gotoComentView.hidden = NO;
            myCell.comentStarView.hidden = YES;
            myCell.botomViewHight.constant = 40;
        }else{
            myCell.gotoComentView.hidden = YES;
            myCell.comentStarView.hidden = NO;
            if (onceDict.level == 1) {
                myCell.comentState.text = @"【不满意】";
                myCell.starView.constant = 21 + 8;
            }else if (onceDict.level == 2){
                myCell.comentState.text = @"【一般】";
                myCell.starView.constant = 21 + 8 + 21 + 4;
            }else if (onceDict.level == 3){
                myCell.comentState.text = @"【满意】";
                myCell.starView.constant = 80;
            }
            if (onceDict.evaluate&&(![onceDict.evaluate isEqualToString:@""])) {
                myCell.comentContent.text = onceDict.evaluate;
                NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
                paraStyle.lineSpacing = 3; //设置行间距
                paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:myCell.comentContent.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName:RGBA(0x9c9c9c, 1),NSParagraphStyleAttributeName:paraStyle}];
                myCell.comentContent.attributedText = attrStr;
                
                CGFloat contentHeight = [StorageUserInfromation getStringSizeWith:onceDict.evaluate withStringFont:13.0 withWidthOrHeight:SCREENWIDTH-24].height +3;
                myCell.botomViewHight.constant = contentHeight + 40;
                
            }else{
                myCell.botomViewHight.constant = 40;
            }
        }
        NSInteger num = onceDict.imageUrl.count;
        
        switch (num) {
            case 9:
            {
                myCell.nightImg.hidden = NO;
                [myCell.nightImg sd_setImageWithURL:[NSURL URLWithString:onceDict.imageUrl[8]] placeholderImage:[UIImage imageNamed:@"icon_默认"]];
            }
            case 8:
            {
                myCell.eightImg.hidden = NO;
                [myCell.eightImg sd_setImageWithURL:[NSURL URLWithString:onceDict.imageUrl[7]] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
            }
            case 7:
            {
                myCell.thirdRowHight.constant = (SCREENWIDTH - 12*2 - 5*2)/3.0 + 5;
                myCell.thirdRowView.hidden = NO;
                myCell.sevenImg.hidden = NO;
                [myCell.sevenImg sd_setImageWithURL:[NSURL URLWithString:onceDict.imageUrl[6]] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
            }
            case 6:
            {
                myCell.sixImg.hidden = NO;
                [myCell.sixImg sd_setImageWithURL:[NSURL URLWithString:onceDict.imageUrl[5]] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
            }
            case 5:
            {
                myCell.fiveImg.hidden = NO;
                [myCell.fiveImg sd_setImageWithURL:[NSURL URLWithString:onceDict.imageUrl[4]] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
            }
            case 4:
            {
                myCell.secondRowHight.constant = (SCREENWIDTH - 12*2 - 5*2)/3.0 + 5;
                myCell.secondRowView.hidden = NO;
                myCell.fourImg.hidden = NO;
                [myCell.fourImg sd_setImageWithURL:[NSURL URLWithString:onceDict.imageUrl[3]] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
            }
            case 3:
            {
                myCell.thirdImg.hidden = NO;
                [myCell.thirdImg sd_setImageWithURL:[NSURL URLWithString:onceDict.imageUrl[2]] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
            }
            case 2:
            {
                myCell.secondImg.hidden = NO;
                [myCell.secondImg sd_setImageWithURL:[NSURL URLWithString:onceDict.imageUrl[1]] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
            }
            case 1:
            {
                myCell.firstRowView.hidden = NO;
                myCell.firstRowHight.constant = (SCREENWIDTH - 12*2 - 5*2)/3.0;
                myCell.firstImg.hidden  = NO;
                [myCell.firstImg sd_setImageWithURL:[NSURL URLWithString:onceDict.imageUrl[0]] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
            }
                break;
            case 0:
            {
                
            }
                break;
                
            default:
                break;
        }
    
        myCell.imgViewHight.constant = myCell.firstRowHight.constant + myCell.secondRowHight.constant + myCell.thirdRowHight.constant;
    
        
    }
    return myCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSNumber* cellHeightNumber = [_hightDict objectForKey:@(indexPath.row)];
    CGFloat cellHeight;
    if (cellHeightNumber) {//判断是否缓存了该cell的高度
        cellHeight = [cellHeightNumber floatValue];
        return cellHeight;
    }
    CGFloat f = 75 + 8 + 8 + 40 + 10;
    if (_myArr.count>0) {
        ServiceDataArr *onceDict = _myArr[indexPath.row];
        NSInteger integer = onceDict.imageUrl.count;
        if (integer == 0) {
        }else if (integer == 1){
            f += (SCREENWIDTH - 12*2 - 5*2)/3.0;
        }else if (integer == 2){
            f += (SCREENWIDTH - 12*2 - 5*2)/3.0;
        }else if (integer == 3){
            f += (SCREENWIDTH - 12*2 - 5*2)/3.0;
        }else if (integer == 4 | integer ==5 | integer == 6){
            f += ((SCREENWIDTH - 12*2 - 5*2)/3.0) *2 +5;
        }else if (integer > 6){
            f += ((SCREENWIDTH - 12*2 - 5*2)/3.0) *3 +5*2;
        }
        if (![onceDict.content isEqualToString:@""]) {
            CGFloat contentHeight = [StorageUserInfromation getStringSizeWith:onceDict.content withStringFont:15.0 withWidthOrHeight:SCREENWIDTH-24].height +10;
            f += contentHeight;
        }
        if (onceDict.evaluate&&(![onceDict.evaluate isEqualToString:@""])) {
            CGFloat comentHeight = [StorageUserInfromation getStringSizeWith:onceDict.evaluate withStringFont:13.0 withWidthOrHeight:SCREENWIDTH-24].height +3;
            f  +=comentHeight;
        }
        
    }else {
        f = 0;
    }
    [_hightDict setObject:[NSNumber numberWithFloat:f] forKey:@(indexPath.row)];
    return f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myArr.count;
    
}


/**
 *  浏览图片
 *
 */
- (void)clickImage:(UIImageView *)image tag:(NSInteger)integer totol:(NSInteger)sum
{
    NSInteger tag = integer%10;
    indexPathRow = integer/10;
    totolPicNum = sum;
    ServiceDataArr *onceList = _myArr[indexPathRow];
    imageArr = [NSMutableArray arrayWithArray:onceList.imageUrl];
    // 快速创建并进入浏览模式
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:tag imageCount:imageArr.count datasource:self];
    
//    // 设置长按手势弹出的地步ActionSheet数据,不实现此方法则没有长按手势
//    [browser setActionSheetWithTitle:@"这是一个类似微信/微博的图片浏览器组件" delegate:self cancelButtonTitle:nil deleteButtonTitle:nil otherButtonTitles:@"发送给朋友",@"保存图片",@"投诉",nil];
    
    // 自定义pageControl的一些属性
    browser.pageDotColor = [UIColor lightGrayColor]; ///< 此属性针对动画样式的pagecontrol无效
    browser.currentPageDotColor = [UIColor whiteColor];
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;///< 修改底部pagecontrol的样式为系统样式,默认是弹性动画的样式
}
#pragma mark    -   XLPhotoBrowserDatasource

- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    if (totolPicNum == 4) {
        if (index>=2) {
            index -= 1;
        }
        return  [NSURL URLWithString:imageArr[index]];
    }
    return  [NSURL URLWithString:imageArr[index]];
}
- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return browser.sourceImageView.image;
}
- (UIImageView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexPathRow inSection:0];
    ServiceCell *myCell = [_myTableView cellForRowAtIndexPath:indexPath];
    UIImageView *img = myCell.firstImg;
    switch (index) {
        case 0:
            {
                img = myCell.firstImg;
            }
            break;
        case 1:
        {
            img = myCell.secondImg;

        }
            break;
        case 2:
        {
            img = myCell.thirdImg;

        }
            break;
        case 3:
        {
            img = myCell.fourImg;

        }
            break;
        case 4:
        {
            img = myCell.fiveImg;

        }
            break;
        case 5:
        {
            img = myCell.sixImg;

        }
            break;
        case 6:
        {
            img = myCell.sevenImg;

        }
            break;
        case 7:
        {
            img = myCell.eightImg;

        }
            break;
        case 8:
        {
            img = myCell.nightImg;

        }
            break;
            
        default:
            break;
    }
    return img;
}
- (void)showActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报", @"不喜欢", nil];
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://取消
        {
            
        }
            break;
        case 1://举报
        {
            
        }
            break;
        case 2://不喜欢
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
