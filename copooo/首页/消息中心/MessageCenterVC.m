//
//  MessageCenterVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/29.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "MessageCenterVC.h"
#import "MyMessageCell.h"
#import "SystemMessageCell.h"
#import "SystemMessageDetailVC.h"
#import "SystemMessageDataModel.h"
#import "MyMessageDataModel.h"
#import "UITableView+WFEmpty.h"
#import "CommunityJSVC.h"
@interface MessageCenterVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *myMessageFlagView;
    UIView *systemMeaasgeFlagView;
    NSInteger myMessagePage;
    NSInteger systemMessagePage;

}
@property (nonatomic,strong)UIButton *myMessageBtn;
@property (nonatomic,strong)UIButton *systemMessageBtn;
@property (nonatomic,strong) UIImageView *selectFlagImageView;
@property (nonatomic,strong)NSMutableArray <SystemMessageFrom *> *systemMessageArr;
@property (nonatomic,strong)NSMutableArray <MyMessageFrom *> *myMessageArr;
@end

@implementation MessageCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self setChoseBtn];
    [self.view addSubview:self.myScrollView];
    [self.myScrollView addSubview:self.myMessageTableView];
    [self.myScrollView addSubview:self.systemMessageTableView];
    [MobClick event:@"ifzx_c"];
    myMessagePage = 1;
    systemMessagePage = 1;
    _systemMessageArr = [NSMutableArray array];
    _myMessageArr = [NSMutableArray array];
    WeakSelf
    _myMessageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongSelf
        myMessagePage = 1;
        [strongSelf fetchMyMessageData:1];
    }];
    _myMessageTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        StrongSelf
        myMessagePage++;
        [strongSelf fetchMyMessageData:myMessagePage];
    }];
    
    _systemMessageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongSelf
        systemMessagePage = 1;
        [strongSelf fetchSystemMessageData:1];
    }];
    _systemMessageTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        StrongSelf
        systemMessagePage++;
        [strongSelf fetchSystemMessageData:systemMessagePage];
    }];
    [self fetchMyMessageData:1];
    [self fetchSystemMessageData:1];
    [self fetchUnreadMessageCount];

    // Do any additional setup after loading the view.
}
- (void)fetchUnreadMessageCount{
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/userInfo/unreadMessageCount" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([onceDict[@"rcode"] integerValue] == 0) {
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
            StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
            storage.socialUnread = [NSString stringWithFormat:@"%ld",[onceDict[@"form"][@"socialUnread"] integerValue]];
            storage.systemUnread = [NSString stringWithFormat:@"%ld",[onceDict[@"form"][@"systemUnread"] integerValue] ];
            [NSKeyedArchiver archiveRootObject:storage toFile:file];
            if ([storage.socialUnread isEqualToString:@"0"]) {
                myMessageFlagView.hidden = YES;
            }else{
                myMessageFlagView.hidden = NO;
            }
            if ([storage.systemUnread isEqualToString:@"0"]) {
                systemMeaasgeFlagView.hidden = YES;
            }else{
                systemMeaasgeFlagView.hidden = NO;
            }
        }
        
    } failure:^(NSError *error) {
      
        
    }];

}
- (void)fetchMyMessageData:(NSInteger)page{
    myMessagePage = page;
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId,@"pagesize":@"10",@"page":[NSString stringWithFormat:@"%ld",page]};
    [ZTHttpTool postWithUrl:@"social/v1/personal/userMessage" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        [self.myMessageTableView.mj_header endRefreshing];
        [self.myMessageTableView.mj_footer endRefreshing];
        MyMessageDataModel *data = [MyMessageDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            if (data.form.count>0) {
                if (myMessagePage == 1) {
                    [_myMessageArr removeAllObjects];
                    [_myMessageArr addObjectsFromArray:data.form];
                    [self.myMessageTableView reloadData];
                }else{
                    [_myMessageArr addObjectsFromArray:data.form];
                    NSMutableArray *insertIndexPaths = [NSMutableArray array];
                    for (int ind = 0; ind < data.form.count; ind++) {
                        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow: _myMessageArr.count - data.form.count + ind inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    //重新调用UITableView的方法, 来生成行.
                    [UIView performWithoutAnimation:^{
                        [self.myMessageTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                        [self.myMessageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_myMessageArr.count - data.form.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    }];
                }
            }else{
                if (page>1) {
                    myMessagePage--;
                }
            }
            if (_myMessageArr.count ==0) {
                [self.myMessageTableView addEmptyViewWithImageName:@"暂无消息" title:@"暂无消息"];
                [self.myMessageTableView.emptyView setHidden:NO];
            }else{
                [self.myMessageTableView.emptyView setHidden:YES];
            }
        }else{
            if (myMessagePage >1) {
                myMessagePage--;
            }
        }
        
    } failure:^(NSError *error) {
        if (myMessagePage >1) {
            myMessagePage--;
        }
        [self.myMessageTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"暂无网络连接"];
        [self.myMessageTableView.emptyView setHidden:NO];
        
        [self.myMessageTableView.mj_header endRefreshing];
        [self.myMessageTableView.mj_footer endRefreshing];
    }];
}
- (void)fetchSystemMessageData:(NSInteger)page{
    systemMessagePage = page;
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId,@"pagesize":@"10",@"page":[NSString stringWithFormat:@"%ld",page]};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/systemNotice/myNotice" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        [self.systemMessageTableView.mj_header endRefreshing];
        [self.systemMessageTableView.mj_footer endRefreshing];
        SystemMessageDataModel *data = [SystemMessageDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            if (data.form.count>0) {
                if (systemMessagePage == 1) {
                    [_systemMessageArr removeAllObjects];
                    [_systemMessageArr addObjectsFromArray:data.form];
                    [self.systemMessageTableView reloadData];
                }else{
                    [_systemMessageArr addObjectsFromArray:data.form];
                    NSMutableArray *insertIndexPaths = [NSMutableArray array];
                    for (int ind = 0; ind < data.form.count; ind++) {
                        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow: _systemMessageArr.count - data.form.count + ind inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    //重新调用UITableView的方法, 来生成行.
                    [UIView performWithoutAnimation:^{
                        [self.systemMessageTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                        [self.systemMessageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_systemMessageArr.count - data.form.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    }];
                }
            }else{
                if (page>1) {
                    systemMessagePage--;
                }
            }
            if (_systemMessageArr.count ==0) {
                [self.systemMessageTableView addEmptyViewWithImageName:@"暂无消息" title:@"暂无消息"];
                [self.systemMessageTableView.emptyView setHidden:NO];
            }else{
                [self.systemMessageTableView.emptyView setHidden:YES];
            }
        }else{
            if (systemMessagePage >1) {
                systemMessagePage--;
            }
        }

    } failure:^(NSError *error) {
        if (systemMessagePage >1) {
            systemMessagePage--;
        }
        [self.systemMessageTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"暂无网络连接"];
        [self.systemMessageTableView.emptyView setHidden:NO];
        
        [self.systemMessageTableView.mj_header endRefreshing];
        [self.systemMessageTableView.mj_footer endRefreshing];
    }];
}
- (void)setNav{
    self.isShowNav = YES;
    self.navView.backgroundColor = RGBA(0xf6f6f6, 1);
    _backButton.hidden = NO;
    self.titleLabel.text = @"消息中心";
    self.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.rightImgName = @"全部已读";
    [self.rightButton setTitle:@"全部已读" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
    [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    if (NAVHEIGHT == 88) {
        self.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    }
}
- (void)rightButtonClick:(UIButton *)button{
    [MobClick event:@"ifyd_c"];
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/userInfo/readAll" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([onceDict[@"rcode"] integerValue] == 0) {
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
            StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
            storage.socialUnread = @"0";
            storage.systemUnread = @"0";
            [NSKeyedArchiver archiveRootObject:storage toFile:file];
            if ([storage.socialUnread isEqualToString:@"0"]) {
                myMessageFlagView.hidden = YES;
            }else{
                myMessageFlagView.hidden = NO;
            }
            if ([storage.systemUnread isEqualToString:@"0"]) {
                systemMeaasgeFlagView.hidden = YES;
            }else{
                systemMeaasgeFlagView.hidden = NO;
            }
            [self fetchMyMessageData:1];
            [self fetchSystemMessageData:1];
        }
        
    } failure:^(NSError *error) {
        
        
    }];

}
- (void)setChoseBtn{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, 40)];
    myView.backgroundColor = RGBA(0x4b5971, 1);
    [self.view addSubview:myView];
    CGFloat gap = (SCREENWIDTH - 55*2)/6.0;
    CGFloat btnWidth = (SCREENWIDTH - gap*2)/2.0;
    _myMessageBtn = [[UIButton alloc]initWithFrame:CGRectMake(gap, 0, btnWidth, 40)];
    [_myMessageBtn setTitle:@"我的消息" forState:UIControlStateNormal];
    [_myMessageBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_myMessageBtn setTitleColor:RGBA(0xffffff, 1) forState:UIControlStateNormal];
    [_myMessageBtn addTarget:self action:@selector(messageBtnChoseClick:) forControlEvents:UIControlEventTouchUpInside];

    _systemMessageBtn = [[UIButton alloc]initWithFrame:CGRectMake(gap + btnWidth, 0, btnWidth, 40)];
    [_systemMessageBtn setTitle:@"系统消息" forState:UIControlStateNormal];
    [_systemMessageBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_systemMessageBtn setTitleColor:RGBA(0xc0c0c0, 1) forState:UIControlStateNormal];
    [_systemMessageBtn addTarget:self action:@selector(messageBtnChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:_systemMessageBtn];
    [myView addSubview:_myMessageBtn];

    _selectFlagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _selectFlagImageView.image = [UIImage imageNamed:@"三角形"];
    _selectFlagImageView.center = CGPointMake(gap + btnWidth/2.0, 40-5);
    [myView addSubview:_selectFlagImageView];
    
    myMessageFlagView  = [[UIView alloc]initWithFrame:CGRectMake(gap + btnWidth/2.0 + 55/2.0, 12, 3, 3)];
    myMessageFlagView.layer.cornerRadius = 3/2.0;
    myMessageFlagView.backgroundColor =RGBA(0xfe4b20, 1);
    [myView addSubview:myMessageFlagView];
    
    systemMeaasgeFlagView  = [[UIView alloc]initWithFrame:CGRectMake(gap + btnWidth + btnWidth/2.0 + 55/2.0, 12, 3, 3)];
    systemMeaasgeFlagView.layer.cornerRadius = 3/2.0;
    systemMeaasgeFlagView.backgroundColor =RGBA(0xfe4b20, 1);
    [myView addSubview:systemMeaasgeFlagView];
    
}

- (UIScrollView *)myScrollView{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + 40, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - 40)];
        _myScrollView.scrollEnabled = NO;
        _myScrollView.contentSize = CGSizeMake(SCREENWIDTH *2, SCREENHEIGHT - NAVHEIGHT - 40);
    }
    return _myScrollView;
}
- (UITableView *)myMessageTableView{
    if (!_myMessageTableView) {
        _myMessageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - 40) style:UITableViewStylePlain];
        _myMessageTableView.delegate = self;
        _myMessageTableView.dataSource = self;
        _myMessageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myMessageTableView;
}
- (UITableView *)systemMessageTableView{
    if (!_systemMessageTableView) {
        _systemMessageTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - 40) style:UITableViewStylePlain];
        _systemMessageTableView.delegate = self;
        _systemMessageTableView.dataSource = self;
        _systemMessageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _systemMessageTableView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.myMessageTableView) {
        static NSString *myMessageCell = @"MyMessageCell";
        MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:myMessageCell];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:myMessageCell owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headerOne.hidden = YES;
        cell.headerTwo.hidden = YES;
        cell.headerThree.hidden = YES;
        cell.headerFour.hidden = YES;
        cell.more.hidden = YES;
        cell.pic.hidden = YES;
        cell.content.hidden = YES;
        
//        // 创建 NSMutableAttributedString
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:cell.content.text attributes:@{NSForegroundColorAttributeName:RGBA(0x303030, 1)}];
//        // 添加文字颜色
//        [attrStr addAttribute:NSForegroundColorAttributeName
//                        value:RGBA(0x00a7ff, 1)
//                        range:NSMakeRange(0, 6)];
//        cell.content.attributedText = attrStr;
        cell.markLabel.backgroundColor = RGBA(0xffffff, 1);
        cell.markLabel.textColor = RGBA(0xc0c0c0, 1);

        if (_myMessageArr.count) {
            MyMessageFrom *onceDict = _myMessageArr[indexPath.row];
            cell.time.text = [StorageUserInfromation timeStrFromDateString:onceDict.timestamp];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSString *str in onceDict.avatar) {
                if ([str isKindOfClass:[NSNull class]]) {
                    [arr addObject:@""];
                }else{
                    [arr addObject:str];
                }
            }
            onceDict.avatar = arr;
            if (onceDict.comment == 1) {
                cell.markLabel.text = @"1条消息";
                cell.markLabel.backgroundColor = RGBA(0xfe4b20, 1);
                cell.markLabel.textColor = RGBA(0xffffff, 1);
                cell.headerOne.hidden = NO;
                [cell.headerOne sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[0]?onceDict.avatar[0]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
            }else if (onceDict.comment == 2){
                cell.markLabel.text = @"2条消息";
                cell.markLabel.backgroundColor = RGBA(0xfe4b20, 1);
                cell.markLabel.textColor = RGBA(0xffffff, 1);
                cell.headerOne.hidden = NO;
                cell.headerTwo.hidden = NO;
                [cell.headerOne sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[0]?onceDict.avatar[0]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
                [cell.headerTwo sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[1]?onceDict.avatar[1]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];

            }else if (onceDict.comment == 3){
                cell.markLabel.text = @"3条消息";
                cell.markLabel.backgroundColor = RGBA(0xfe4b20, 1);
                cell.markLabel.textColor = RGBA(0xffffff, 1);
                cell.headerOne.hidden = NO;
                cell.headerTwo.hidden = NO;
                cell.headerThree.hidden = NO;
                [cell.headerOne sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[0]?onceDict.avatar[0]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
                [cell.headerTwo sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[1]?onceDict.avatar[1]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
                [cell.headerThree sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[2]?onceDict.avatar[2]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];

            }else if (onceDict.comment  == 4){
                cell.markLabel.text = @"4条消息";
                cell.markLabel.backgroundColor = RGBA(0xfe4b20, 1);
                cell.markLabel.textColor = RGBA(0xffffff, 1);
                cell.headerOne.hidden = NO;
                cell.headerTwo.hidden = NO;
                cell.headerThree.hidden = NO;
                cell.headerFour.hidden = NO;
                [cell.headerOne sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[0]?onceDict.avatar[0]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
                [cell.headerTwo sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[1]?onceDict.avatar[1]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
                [cell.headerThree sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[2]?onceDict.avatar[2]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
                [cell.headerFour sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[3]?onceDict.avatar[3]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];

            }else{
                cell.markLabel.text = [NSString stringWithFormat:@"%ld条消息",onceDict.comment];
                cell.markLabel.backgroundColor = RGBA(0xfe4b20, 1);
                cell.markLabel.textColor = RGBA(0xffffff, 1);
                cell.headerOne.hidden = NO;
                cell.headerTwo.hidden = NO;
                cell.headerThree.hidden = NO;
                cell.headerFour.hidden = NO;
                cell.more.hidden = NO;
                [cell.headerOne sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[0]?onceDict.avatar[0]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
                [cell.headerTwo sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[1]?onceDict.avatar[1]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
                [cell.headerThree sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[2]?onceDict.avatar[2]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
                [cell.headerFour sd_setImageWithURL:[NSURL URLWithString:onceDict.avatar[3]?onceDict.avatar[3]:@""] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];

            }
            if (!onceDict.hasUnread) {
                cell.markLabel.text = @"已读";
                cell.markLabel.backgroundColor = RGBA(0xffffff, 1);
                cell.markLabel.textColor = RGBA(0xc0c0c0, 1);
            }else{
                CGFloat width =  [cell.markLabel sizeThatFits:CGSizeMake(MAXFLOAT, 17)].width + 5;
                cell.markWidth.constant = width;
            }
            if (onceDict.type == 2) {
                cell.pic.hidden = NO;
                [cell.pic sd_setImageWithURL:[NSURL URLWithString:onceDict.thumb] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
            }else if (onceDict.type == 1){
                cell.content.hidden = NO;
                cell.content.text = [NSString stringWithFormat:@"#%@#%@",onceDict.tag,onceDict.content];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:cell.content.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:RGBA(0x303030, 1)}];
                [attrStr addAttribute:NSForegroundColorAttributeName value:RGBA(0x00a7ff, 1) range:NSMakeRange(0, onceDict.tag.length+2)];
                cell.content.attributedText = attrStr;
            }
        }
 
        return cell;
    }else{
        static NSString *systemMessageCell = @"SystemMessageCell";
        SystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:systemMessageCell];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:systemMessageCell owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.mark.backgroundColor = RGBA(0xffffff, 1);
        cell.mark.textColor = RGBA(0xc0c0c0, 1);
        if (_systemMessageArr.count) {
            SystemMessageFrom *onceDict = _systemMessageArr[indexPath.row];
            if ([onceDict.userId isEqualToString:@"<null>"]|(!onceDict.userId)) {
                cell.mark.text = onceDict.noticeType;
                cell.mark.backgroundColor = RGBA(0x00a7ff, 1);
                cell.mark.textColor = RGBA(0xffffff, 1);
            }else{
                cell.mark.text = @"已读";
            }
            CGFloat width =  [cell.mark sizeThatFits:CGSizeMake(MAXFLOAT, 17)].width + 5;
            cell.markWidth.constant = width;
            cell.time.text = [StorageUserInfromation timeStrFromDateString:onceDict.createTime];
            cell.content.text = onceDict.content;
        }
        
        return cell;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.myMessageTableView) {
        return _myMessageArr.count;
    }
    return _systemMessageArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.myMessageTableView) {
        return 75.0;
    }
    return 75.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.myMessageTableView) {
        MyMessageFrom *dict = _myMessageArr[indexPath.row];

        [self hasReadOrDeleteMyMessage:dict.postId operation:@"1" index:indexPath];
        CommunityJSVC *webVC = [[CommunityJSVC alloc]init];
        webVC.url = [NSString stringWithFormat:@"%@#!/tieziDetail",BASE_H5_URL];
        webVC.titleStr = dict.tag;
        webVC.postId = dict.postId;
        webVC.tagId = dict.tag;
        [self.navigationController pushViewController:webVC animated:YES];
    }else  if (tableView == self.systemMessageTableView) {
        SystemMessageDetailVC *page = [[SystemMessageDetailVC alloc]init];
        SystemMessageFrom *dict = _systemMessageArr[indexPath.row];
        [self hasReadOrDeleteSystemMessage:dict.ids operation:@"1" index:indexPath];
        page.dict = dict;
        [self.navigationController pushViewController:page animated:YES];
    }
}
- (void)hasReadOrDeleteMyMessage:(NSString *)postId operation:(NSString *)operation index:(NSIndexPath *)index{
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId,@"postId":postId,@"operation":operation};
    [ZTHttpTool postWithUrl:@"social/v1/personal/operation" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([onceDict[@"rcode"] integerValue] == 0) {
            [self fetchUnreadMessageCount];
            if ([operation isEqualToString:@"1"]) {
                MyMessageFrom *dict = _myMessageArr[index.row];
                dict.hasUnread = 0;
                [_myMessageArr replaceObjectAtIndex:index.row withObject:dict];
                [self.myMessageTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                //删除数据，和删除动画
                [self.myMessageArr removeObjectAtIndex:index.row];
                [_myMessageTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
            }
           
            
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)hasReadOrDeleteSystemMessage:(NSString *)noticeId operation:(NSString *)operation index:(NSIndexPath *)index {
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId,@"noticeId":noticeId,@"operation":operation};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/systemNotice/operation" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([onceDict[@"rcode"] integerValue] == 0) {
            [self fetchUnreadMessageCount];
            if ([operation isEqualToString:@"1"]) {
                SystemMessageFrom *dict = _systemMessageArr[index.row];
                dict.userId = [StorageUserInfromation storageUserInformation].userId;
                [_systemMessageArr replaceObjectAtIndex:index.row withObject:dict];
                [self.systemMessageTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                //删除数据，和删除动画
                [self.systemMessageArr removeObjectAtIndex:index.row];
                [_systemMessageTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
            }
          
            
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)messageBtnChoseClick:(UIButton *)btn{
    CGFloat gap = (SCREENWIDTH - 55*2)/6.0;
    CGFloat btnWidth = (SCREENWIDTH - gap*2)/2.0;
    if (btn == _systemMessageBtn) {
        [_systemMessageBtn setTitleColor:RGBA(0xffffff, 1) forState:UIControlStateNormal];
        [_myMessageBtn setTitleColor:RGBA(0xc0c0c0, 1) forState:UIControlStateNormal];
        _selectFlagImageView.center = CGPointMake(gap + btnWidth + btnWidth/2.0, 40-5);
        self.myScrollView.contentOffset = CGPointMake(SCREENWIDTH, 0);
        [MobClick event:@"ifxt_c"];
    }else{
        [_myMessageBtn setTitleColor:RGBA(0xffffff, 1) forState:UIControlStateNormal];
        [_systemMessageBtn setTitleColor:RGBA(0xc0c0c0, 1) forState:UIControlStateNormal];
        _selectFlagImageView.center = CGPointMake(gap + btnWidth/2.0, 40-5);
        self.myScrollView.contentOffset = CGPointMake(0, 0);
        [MobClick event:@"mifmy_c"];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    if (tableView == _myMessageTableView) {
        MyMessageFrom *dict = _myMessageArr[indexPath.row];
        [self hasReadOrDeleteMyMessage:dict.postId operation:@"2" index:indexPath];
    }else if (tableView == _systemMessageTableView){
        SystemMessageFrom *dict = _systemMessageArr[indexPath.row];
        [self hasReadOrDeleteSystemMessage:dict.ids operation:@"2" index:indexPath];
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
