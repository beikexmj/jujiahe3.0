//
//  DeliveryAddressVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/1.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "DeliveryAddressVC.h"
#import "DeliveryAddressCell.h"
#import "AddNewDeliverAddressVC.h"
#import "DeliveryAddressDataModel.h"
#import "UITableView+WFEmpty.h"
#import "MJRefresh.h"
@interface DeliveryAddressVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    CGFloat bottomBtnHight;
    DeliveryAddressList *deleteDict;
}
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong) NSMutableArray <DeliveryAddressList *> *dataArr;

@end

@implementation DeliveryAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    bottomBtnHight = 60;
    [self setNav];
    [self.view addSubview:self.myTableView];
    [self addBottomBtn];
    _dataArr = [NSMutableArray array];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchData];
}
- (void)setNav{
    self.isShowNav = YES;
    _backButton.hidden = NO;
    self.titleLabel.text = @"收货地址";
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - 50) style:UITableViewStylePlain];
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        WeakSelf
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            StrongSelf
            [strongSelf fetchData];
        }];
    }
    return _myTableView;
}
- (void)addBottomBtn{
    [self.view addSubview:self.bottomBtn];
}
-(UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - bottomBtnHight, SCREENWIDTH, bottomBtnHight)];
        [_bottomBtn setBackgroundImage:[UIImage imageNamed:@"home_button1_normal"] forState:UIControlStateNormal];
        [_bottomBtn setBackgroundImage:[UIImage imageNamed:@"home_button1_press"] forState:UIControlStateHighlighted];
        
        [_bottomBtn setTitle:@" 添加收货地址" forState:UIControlStateNormal];
        [_bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_bottomBtn setTitleColor:RGBA(0xffffff, 1) forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_bottomBtn addTarget:self action:@selector(addDeliveryAddressBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (void)fetchData{
    NSDictionary  *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/shippingAddr/list" param:dict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        [self.myTableView.mj_header endRefreshing];
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary *onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        DeliveryAddressDataModel *data = [DeliveryAddressDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            [_dataArr removeAllObjects];
            [_dataArr addObjectsFromArray:data.form];
            if (_dataArr.count == 0) {
                [self.myTableView addEmptyViewWithImageName:@"暂无抵扣券" title:@"暂无收货地址"];
                [self.myTableView.emptyView setHidden:NO];
            }else{
                [self.myTableView.emptyView setHidden:YES];
            }
            [self.myTableView reloadData];
        }else{
            [self.myTableView addEmptyViewWithImageName:@"暂无抵扣券" title:@"暂无收货地址"];
            [self.myTableView.emptyView setHidden:NO];
            [_dataArr removeAllObjects];
            [self.myTableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.myTableView.mj_header endRefreshing];
        XMJLog(@"%@",error);
        [self.myTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
        [self.myTableView.emptyView setHidden:NO];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifierCell = @"DeliveryAddressCell";
    DeliveryAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifierCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:indentifierCell owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArr.count>0) {
        DeliveryAddressList *onceDict = _dataArr[indexPath.row];
        cell.address.text = [NSString stringWithFormat:@"%@%@",onceDict.location,onceDict.address];
        if (onceDict.prefer == 1) {
            cell.choseFlagIcon.image = [UIImage imageNamed:@"life_icon_choice"];
            cell.addressLabel.textColor = RGBA(0x00a7ff, 1);
        }else{
            cell.choseFlagIcon.image = [UIImage imageNamed:@"icon_unchoice_gray"];
            cell.addressLabel.textColor = RGBA(0x606060, 1);
        }
        cell.name.text = onceDict.name;
        cell.phone.text  = onceDict.tel;
    }
    cell.deleteBtn.tag = indexPath.row;
    cell.editBtn.tag = indexPath.row;
    cell.editBtnBlock = ^(NSInteger integer) {
        AddNewDeliverAddressVC *page = [[AddNewDeliverAddressVC alloc]init];
        page.deliveryAddress = _dataArr[integer];
        [self.navigationController pushViewController:page animated:YES];
    };
    cell.deleteBtnBlock = ^(NSInteger integer) {
        deleteDict = _dataArr[integer];
        [self deleteDeliveryAddress];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeliveryAddressList *onceDict = _dataArr[indexPath.row];
    NSDictionary *dict = @{@"name":onceDict.name,@"address":[NSString stringWithFormat:@"%@%@",onceDict.location,onceDict.address],@"id":onceDict.ids,@"tel":onceDict.tel};
    if (self.deliverAddressBlock) {
        self.deliverAddressBlock(dict);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)deleteDeliveryAddress{
    
    [[[UIAlertView alloc]initWithTitle:@"确定删除？" message:@"" delegate:self cancelButtonTitle:@ "取消" otherButtonTitles:@"确定", nil] show];
    
   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSDictionary *dict = @{@"apiv":@"1.0",@"id":deleteDict.ids};
        [ZTHttpTool postWithUrl:@"jujiaheuser/v1/shippingAddr/delete" param:dict success:^(id responseObj) {
            NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
            NSDictionary *onceDict = [DictToJson dictionaryWithJsonString:str];
            NSLog(@"%@",onceDict);
            if ([onceDict[@"rcode"] integerValue] == 0) {
                [_dataArr removeObject:deleteDict];
                [self.myTableView reloadData];
            }else{
                [MBProgressHUD showError:onceDict[@"msg"]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络异常"];
            
        }];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArr.count>0) {
        DeliveryAddressList *onceDict = _dataArr[indexPath.row];
        NSString *address = [NSString stringWithFormat:@"%@%@",onceDict.location,onceDict.address];
        CGFloat  height = [StorageUserInfromation heightForString:address andWidth:SCREENWIDTH - 24 addFont:14];
        if (height>30) {
            return 125;
        }else{
            return 105;
        }
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (void)addDeliveryAddressBtn{
    AddNewDeliverAddressVC *page = [[AddNewDeliverAddressVC alloc]init];
    [self.navigationController pushViewController:page animated:YES];
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
