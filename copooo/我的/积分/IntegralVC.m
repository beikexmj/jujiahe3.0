//
//  IntegralVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/2.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "IntegralVC.h"
#import "IntegralDetailTableViewCell.h"
#import "MyPointDetailDataModel.h"
#import "UITableView+WFEmpty.h"
#import "CommunityJSVC.h"
@interface IntegralVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger pageNum;
}
@property (nonatomic,strong) UIImageView *headerBackguandImg;
@property (nonatomic,strong) UILabel *integral;
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray <MyPointDetailList *> *pointArr;
@end

@implementation IntegralVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    self.integral.text = [StorageUserInfromation storageUserInformation].point;
    [self.view addSubview:self.myTableView];
    _pointArr = [NSMutableArray array];
    pageNum = 1;
    [self fetchData:1];
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
- (void)setNav{
    [self.view addSubview:self.headerBackguandImg];
    self.isShowNav = YES;
    self.titleLabel.text = @"合币";
    self.titleLabel.textColor = RGBA(0xffffff, 1);
    self.navView.backgroundColor = [UIColor clearColor];
    self.lineView.hidden = YES;
    _backButton.hidden = NO;
    [_backButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
//    self.rightImgName = @"000000000";
//    NSAttributedString *attrStr =[[NSAttributedString alloc]initWithString:@"合币规则？" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:RGBA(0xffffff, 1)}];
//    [self.rightButton setAttributedTitle:attrStr forState:UIControlStateNormal];
    
    [self addSubView];
}
- (void)rightButtonClick:(UIButton *)button{
    CommunityJSVC *page = [[CommunityJSVC alloc]init];
    page.titleStr = @"积分规则";
    page.url = [NSString stringWithFormat:@"%@%@", BASE_URL,@"/jujiahe/html/pointrule.html"];
    [self.navigationController pushViewController:page animated:YES];
}
- (UIImageView *)headerBackguandImg{
    if (!_headerBackguandImg) {
        _headerBackguandImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT - 64 + 180)];
        _headerBackguandImg.image = [UIImage imageNamed:@"my_integral_bg1"];
    }
    return _headerBackguandImg;
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + 180 - 64, SCREENWIDTH, SCREENHEIGHT - (NAVHEIGHT + 180 - 64)) style:UITableViewStylePlain];
        _myTableView.backgroundColor = RGBA(0xeeeeee, 1);
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}
- (void)addSubView{
    
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + 20, SCREENWIDTH, 75.0)];
    myView.backgroundColor = RGBA(0xffffff, 1);
    myView.alpha = 0.1;
    [self.view addSubview:myView];
    
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, NAVHEIGHT + 20 + 75/2.0 - 40/2.0 , 120, 40)];
    myLabel.textColor = RGBA(0xffffff, 1);
    myLabel.font = [UIFont systemFontOfSize:15.0];
    myLabel.text = @"当前合币";
    [self.view addSubview:myLabel];
    
    [self.view addSubview:self.integral];
    
    
    
}
- (UILabel *)integral{
    if (!_integral) {
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(12 + 100, NAVHEIGHT + 20 + 75/2.0 - 40/2.0 , SCREENWIDTH -  100 - 12*2, 40)];
        myLabel.textColor = RGBA(0xffffff, 1);
        myLabel.font = [UIFont systemFontOfSize:30.0];
        myLabel.textAlignment = NSTextAlignmentRight;
        _integral = myLabel;
    }
    return _integral;
}
- (void)fetchData:(NSInteger)page{
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId,@"page":[NSString stringWithFormat:@"%ld",page],@"pagesize":@"10"};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/point/mypoint/detail" param:dict success:^(id responseObj) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];

        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        MyPointDetailDataModel *data = [MyPointDetailDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            self.integral.text = data.form.point;
            if (page == 1) {
                [_pointArr removeAllObjects];
                [_pointArr addObjectsFromArray:data.form.detail];
                [self.myTableView reloadData];
            }else{
                [_pointArr addObjectsFromArray:data.form.detail];
                NSMutableArray *insertIndexPaths = [NSMutableArray array];
                for (int ind = 0; ind < data.form.detail.count; ind++) {
                    NSIndexPath    *newPath =  [NSIndexPath indexPathForRow: _pointArr.count - data.form.detail.count + ind inSection:0];
                    [insertIndexPaths addObject:newPath];
                }
                //重新调用UITableView的方法, 来生成行.
                [UIView performWithoutAnimation:^{
                    [self.myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                    [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_pointArr.count - data.form.detail.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                }];
            }
            if (_pointArr.count == 0) {
                [self.myTableView addEmptyViewWithImageName:@"暂无合币纪录" title:@"暂无合币"];
                [self.myTableView.emptyView setHidden:NO];
            }else{
                [self.myTableView.emptyView setHidden:YES];
            }
            
        }else{
            if (page>1) {
                pageNum--;
            }
        }
    } failure:^(NSError *error) {
        if (page>1) {
            pageNum--;
        }
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];

        XMJLog(@"%@",error);
        [self.myTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
        [self.myTableView.emptyView setHidden:NO];
    }];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"IntegralDetailTableViewCell";
    IntegralDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myCell owner:self options:nil] lastObject];
    }
    if (_pointArr>0) {
        MyPointDetailList *onceDict = _pointArr[indexPath.row];
        
        cell.type.text = onceDict.reason;
        cell.time.text = [StorageUserInfromation timeStrFromDateString2:onceDict.date];
        if (onceDict.amount.floatValue>0) {
            cell.num.text = onceDict.amount;
            cell.symbol.text = @"+";
        }else{
            cell.num.text = [NSString stringWithFormat:@"%0.0f",-onceDict.amount.floatValue] ;
            cell.symbol.text = @"-";
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.numWidth.constant = [cell.num sizeThatFits:CGSizeMake(SCREEN_WIDTH, 25)].width;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _pointArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
