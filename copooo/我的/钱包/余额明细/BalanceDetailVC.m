//
//  BalanceDetailVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/1.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "BalanceDetailVC.h"
#import "IntegralDetailTableViewCell.h"
#import "BillingDetailVC.h"
#import "HooDatePicker.h"
#import "BalanceDetailDataModel.h"
#import "UITableView+WFEmpty.h"

@interface BalanceDetailVC ()<UITableViewDelegate,UITableViewDataSource,HooDatePickerDelegate>
@property (nonatomic,strong) UIImageView *headerBackguandImg;
@property (nonatomic,strong) UILabel *balance;
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) HooDatePicker *datePicker;
@property (nonatomic,strong)NSMutableArray <BalanceDetailList *>*dataArr;
@end

@implementation BalanceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    self.balance.text = [StorageUserInfromation storageUserInformation].accountBalance;
    _dataArr = [NSMutableArray array];
    [self.view addSubview:self.myTableView];
    [self datePickerInit];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *selectDate = [dateFormatter stringFromDate:[NSDate date]];
    [self fetchData:selectDate];
    // Do any additional setup after loading the view.
}
- (void)setNav{
    [self.view addSubview:self.headerBackguandImg];
    self.isShowNav = YES;
    self.titleLabel.text = @"余额明细";
    self.titleLabel.textColor = RGBA(0xffffff, 1);
    self.navView.backgroundColor = [UIColor clearColor];
    self.lineView.hidden = YES;
    _backButton.hidden = NO;
    [_backButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    self.rightImgName = @"000000";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年"];
    NSString *selectDate = [dateFormatter stringFromDate:[NSDate date]];
    [self.rightButton setTitle:selectDate forState:UIControlStateNormal];

    [self addSubView];
}
- (void)rightButtonClick:(UIButton *)button{
    [self.datePicker show];
}
-(void)datePickerInit{
    self.datePicker = [[HooDatePicker alloc] initWithSuperView:self.view];
    self.datePicker.delegate = self;
    self.datePicker.datePickerMode = HooDatePickerModeYear;
    self.datePicker.title = @"请选择日期";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:kDateFormatYYYYMMDD];
    NSDate *maxDate = [NSDate date];
    NSDate *minDate = [dateFormatter dateFromString:@"2010-01-01"];
    
    [self.datePicker setDate:[NSDate date] animated:YES];
    self.datePicker.minimumDate = minDate;
    self.datePicker.maximumDate = maxDate;
}
- (void)datePicker:(HooDatePicker *)datePicker didSelectedDate:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *selectDate = [dateFormatter stringFromDate:date];
    [self.rightButton setTitle:[NSString stringWithFormat:@"%@年",selectDate]  forState:UIControlStateNormal];
    NSLog(@"selectDate:%@",selectDate);
    [self fetchData:selectDate];
    
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
    myLabel.text = @"当前余额（元）";
    [self.view addSubview:myLabel];
    
    [self.view addSubview:self.balance];
    
    
}
- (UILabel *)balance{
    if (!_balance) {
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(12 + 100, NAVHEIGHT + 20 + 75/2.0 - 40/2.0 , SCREENWIDTH -  100 - 12*2, 40)];
        myLabel.textColor = RGBA(0xffffff, 1);
        myLabel.font = [UIFont systemFontOfSize:30.0];
        myLabel.textAlignment = NSTextAlignmentRight;
        _balance = myLabel;
    }
    return _balance;
}

-(void)fetchData:(NSString *)year{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"userId":[StorageUserInfromation storageUserInformation].userId,@"apiv":@"1.0",@"year":year};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/balance/detail" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        BalanceDetailDataModel *data = [BalanceDetailDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            [_dataArr removeAllObjects];
            [_dataArr addObjectsFromArray:data.form.list];
            if (_dataArr.count == 0) {
                [self.myTableView addEmptyViewWithImageName:@"暂无记录" title:@"暂无记录"];
                [self.myTableView.emptyView setHidden:NO];
            }else{
                [self.myTableView.emptyView setHidden:YES];
            }
            [self.myTableView reloadData];
        }else{
            [self.myTableView addEmptyViewWithImageName:@"暂无记录" title:@"暂无记录"];
            [self.myTableView.emptyView setHidden:NO];
            [_dataArr removeAllObjects];
            [self.myTableView reloadData];
        }
    } failure:^(NSError *error) {
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
        if (_dataArr.count>0) {
            BalanceDetailList *list = _dataArr[indexPath.section];
            BalanceDetailListForMonthDetail* detail = list.detail[indexPath.row];
            cell.type.text = detail.reason;
            cell.time.text = [NSString stringWithFormat:@"%@/%@/%@",detail.year,detail.month,detail.day];
            cell.num.text = detail.amountStr;
            if (detail.type == 1) {
                cell.symbol.text = @"+";
                [cell.symbol setTextColor:RGBCOLOR(0, 167, 255)];
                [cell.num setTextColor:RGBCOLOR(0, 167, 255)];
            }else{
                cell.symbol.text = @"-";
                [cell.symbol setTextColor:RGBCOLOR(48, 48, 48)];
                [cell.num setTextColor:RGBCOLOR(48, 48, 48)];
    
            }
        }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.numWidth.constant = [cell.num sizeThatFits:CGSizeMake(SCREENWIDTH, 25)].width;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArr.count>0) {
        BalanceDetailList *list = _dataArr[section];
        return list.detail.count;
    }
    return  0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    BillingDetailVC *page =[[BillingDetailVC alloc]init];
//    page.comfromFlag = 1;
////    BalanceDetailList *list = _dataArr[indexPath.section];
////    BalanceDetailListForMonthDetail* detail = list.detail[indexPath.row];
//
//    [self.navigationController pushViewController:page animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    footerView.backgroundColor = RGBA(0xeeeeee, 1);
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    myView.backgroundColor = RGBA(0xffffff, 1);
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(12, 29, SCREENWIDTH -12, 1)];
    lineView.backgroundColor = RGBA(0xeeeeee, 1);
    [myView addSubview:lineView];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 30)];
    dateLabel.textColor = RGBA(0x00a7ff, 1);
    dateLabel.font = [UIFont systemFontOfSize:14.0];
    [myView addSubview:dateLabel];
    dateLabel.text = [NSString stringWithFormat:@"%@月", _dataArr[section].month];
    return myView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
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
