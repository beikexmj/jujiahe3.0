//
//  TicketCenterViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/8/4.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "TicketCenterViewController.h"
#import "TicketCenterTableViewCell.h"
#import "VoucherListDataModel.h"
#import "UITableView+WFEmpty.h"
@interface TicketCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray <VoucherListList *>*dataArry;
@end

@implementation TicketCenterViewController

- (instancetype)initWithFlag:(NSInteger)flag{
    self = [super init];
    if (self) {
        _flag = flag;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+24;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    _dataArry = [NSMutableArray array];
    

    switch (_flag) {
        case 0:
        {
            [self btnClick:_all];
        }
            break;
        case 1:
        {
            [self btnClick:_waitUse];
            
        }
            break;
        case 2:
        {
            [self btnClick:_areadyUse];
            
        }
            break;
        case 3:
        {
            [self btnClick:_areadyOutOfDate];
            
        }
            break;
        default:
            break;
    }

    // Do any additional setup after loading the view from its nib.
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"TicketCenterTableViewCell";
    TicketCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myCell owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArry.count > 0) {
        VoucherListList *list = _dataArry[indexPath.row];
        cell.title.text = list.describe;
        cell.time.text = list.deadline;
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,list.image];
        [cell.img sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
        cell.time.hidden = NO;
        if (list.status == 0) {
            cell.mark.text = @"未使用";
            [cell.mark setTextColor:RGBCOLOR(0, 167, 255)];
        }else if(list.status == 1){
            cell.mark.text = @"已使用";
            cell.time.hidden = YES;
            [cell.mark setTextColor:RGBCOLOR(156, 156, 156)];
        }else if (list.status == 2){
            cell.mark.text = @"已过期";
            [cell.mark setTextColor:RGBCOLOR(0, 167, 255)];
        }
        
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArry.count;
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

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnClick:(id)sender {
    
    self.allLineView.hidden = YES;
    self.waitUseLineView.hidden = YES;
    self.areadyUseLineView.hidden = YES;
    self.areadyOutOfDateLineView.hidden = YES;

    [self.allLabel setTextColor:RGBCOLOR(96, 96, 96)];
    [self.waitUseLabel setTextColor:RGBCOLOR(96, 96, 96)];
    [self.areadyUseLabel setTextColor:RGBCOLOR(96, 96, 96)];
    [self.areadyOutOfDateLabel setTextColor:RGBCOLOR(96, 96, 96)];
    UIButton *btn = sender;
    NSDictionary *dict;
    if (btn == _all){
        self.allLineView.hidden = NO;
        [self.allLabel setTextColor:RGBCOLOR(0, 167, 255)];
        dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1"};
    }else if(btn == _waitUse) {
        self.waitUseLineView.hidden = NO;
        [self.waitUseLabel setTextColor:RGBCOLOR(0, 167, 255)];
        dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"status":@"0"};

    }else if (btn == _areadyUse){
        self.areadyUseLineView.hidden = NO;
        [self.areadyUseLabel setTextColor:RGBCOLOR(0, 167, 255)];
        dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"status":@"1"};

    }else if (btn == _areadyOutOfDate){
        self.areadyOutOfDateLineView.hidden = NO;
        [self.areadyOutOfDateLabel setTextColor:RGBCOLOR(0, 167, 255)];
        dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"status":@"2"};

    }
    [self fetchData:dict];
}
-(void)fetchData:(NSDictionary *)dict{
    [_dataArry removeAllObjects];
    [MBProgressHUD showMessage:@""];
    [ZTHttpTool postWithUrl:@"voucher/list" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD hideHUD];
        VoucherListDataModel *voucherList = [VoucherListDataModel mj_objectWithKeyValues:str];
        if (voucherList.rcode == 0) {
            NSArray<VoucherListList*> * myArray = voucherList.form.list;
            [_dataArry addObjectsFromArray:myArray];
//            for (UIView * myView in self.myTableView.subviews) {
//                if (self.myTableView.emptyView) {
//                    if ([myView isEqual:self.myTableView.emptyView]) {
//                        [myView removeFromSuperview];
//                    }
//                }
//            }
            if (_dataArry.count == 0) {
                
                [self.myTableView addEmptyViewWithImageName:@"暂无抵扣券" title:@"暂无票券"];
                [self.myTableView.emptyView setHidden:NO];

            }else{
                [self.myTableView.emptyView setHidden:YES];
            }
            [self.myTableView reloadData];
        }else{
            [self.myTableView addEmptyViewWithImageName:@"暂无抵扣券" title:@"暂无票券"];
            [self.myTableView.emptyView setHidden:NO];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
        [self.myTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
        [self.myTableView.emptyView setHidden:NO];
    }];
}

@end
