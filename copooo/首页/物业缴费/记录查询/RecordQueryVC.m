//
//  RecordQueryVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/31.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "RecordQueryVC.h"
#import "RecordQueryCell.h"
#import "RechargeDetailVC.h"
#import "ArrearageDetailVC.h"
#import "RecordQueryDataModel.h"
#import "UITableView+WFEmpty.h"

@interface RecordQueryVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger pageNum;
}
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)NSMutableArray <RecordQueryForm *> *myArr;
@end

@implementation RecordQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self.view addSubview:self.myTableView];
    _myArr = [NSMutableArray array];
    pageNum = 1;
    WeakSelf
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageNum++;
        StrongSelf
        [strongSelf fetchData:pageNum];
    }];
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        StrongSelf
        [strongSelf fetchData:pageNum];
    }];
    [self fetchData:1];
    // Do any additional setup after loading the view.
}
- (void)setNav{
    self.isShowNav = YES;
    _backButton.hidden = NO;
    self.titleLabel.text = @"查看详情";
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT) style:UITableViewStylePlain];
        _myTableView.backgroundColor = RGBA(0xeeeeee, 1);
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}
- (void)fetchData:(NSInteger)page{
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId,@"propertyHouseId":_propertyHouseId,@"page":[NSString stringWithFormat:@"%ld",page],@"pagesize":@"10"};
    [ZTHttpTool postWithUrl:@"property/v1/propertyCard/queryPropertyPayRecord" param:dict success:^(id responseObj) {
        if (page == 1) {
            [self.myTableView.mj_header endRefreshing];
        }else{
            [self.myTableView.mj_footer endRefreshing];
        }
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary *dict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",dict);
        RecordQueryDataModel *data = [RecordQueryDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            if (data.form.count>0) {
                if (page == 1) {
                    [_myArr removeAllObjects];
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
                if (pageNum>1) {
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
        if (page == 1) {
            [self.myTableView.mj_header endRefreshing];
        }else{
            pageNum--;
            [self.myTableView.mj_footer endRefreshing];
        }
        [self.myTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"暂无网络连接"];
        [self.myTableView.emptyView setHidden:NO];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifierCell = @"RecordQueryCell";
    RecordQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifierCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:indentifierCell owner:self options:nil] lastObject];
    }
    if (_myArr.count) {
        RecordQueryForm *onceDict = _myArr[indexPath.row];
        cell.type.text = onceDict.name;
        if (onceDict.status == 0) {
            cell.money.text = [NSString stringWithFormat:@"%0.2f",onceDict.price.floatValue];
        }else{
            cell.money.text = [NSString stringWithFormat:@"%@%0.2f",@"+",onceDict.price.floatValue];

        }
        if (onceDict.payTime.length>=3) {
             cell.time.text =[onceDict.payTime substringToIndex:onceDict.payTime.length - 3];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _myArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordQueryForm *onceDict = _myArr[indexPath.row];
    if (onceDict.status == 1) {
        RechargeDetailVC *page = [[RechargeDetailVC alloc]init];
        page.dict = onceDict;
        [self.navigationController pushViewController:page animated:YES];
    }else{
        ArrearageDetailVC *page = [[ArrearageDetailVC alloc]init];
        page.dict = onceDict;
        [self.navigationController pushViewController:page animated:YES];
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
