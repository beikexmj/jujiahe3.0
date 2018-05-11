//
//  BillingInquiriesVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/1.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "BillingInquiriesVC.h"
#import "HooDatePicker.h"
#import "IntegralDetailTableViewCell.h"
#import "BillingDetailVC.h"
#import "BillingInquiriesDataModel.h"
#import "UITableView+WFEmpty.h"

@interface BillingInquiriesVC ()<HooDatePickerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UILabel *billTime;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) HooDatePicker *datePicker;
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray <BillingInquiriesList *> *dataArr;
@end

@implementation BillingInquiriesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self addHeader];
    [self.view addSubview:self.myTableView];
    _dataArr = [NSMutableArray array];
    [self datePickerInit];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *selectDate = [dateFormatter stringFromDate:[NSDate date]];
    [self fecthData:selectDate];
    // Do any additional setup after loading the view.
}
- (void)setNav{
    self.isShowNav = YES;
    _backButton.hidden = NO;
    self.titleLabel.text = @"账单查询";
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + 40, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - 40) style:UITableViewStylePlain];
        _myTableView.backgroundColor = RGBA(0xeeeeee, 1);
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}
- (void)addHeader{
    UIView * myView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, 40)];
    myView.backgroundColor = RGBA(0x4b5971, 1);
    [self.view addSubview:myView];
    [myView addSubview:self.billTime];
    [myView addSubview:self.selectBtn];
}
-(void)datePickerInit{
    self.datePicker = [[HooDatePicker alloc] initWithSuperView:self.view];
    self.datePicker.delegate = self;
    self.datePicker.datePickerMode = HooDatePickerModeYearAndMonth;
    self.datePicker.title = @"请选择日期";
    NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
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
    
    if (datePicker.datePickerMode == HooDatePickerModeDate) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    } else if (datePicker.datePickerMode == HooDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else if (datePicker.datePickerMode == HooDatePickerModeYearAndMonth){
        [dateFormatter setDateFormat:@"yyyy年MM月"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    NSString *selectDate = [dateFormatter stringFromDate:date];
    _billTime.text = selectDate;
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setLocale:[NSLocale currentLocale]];
    [dateFormatter2 setDateFormat:@"yyyy-MM"];
    NSString *selectDate2 = [dateFormatter2 stringFromDate:date];
    [self fecthData:selectDate2];
    NSLog(@"selectDate:%@",selectDate);
    
    
}
- (UILabel *)billTime{
    if (!_billTime) {
        _billTime = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 150, 40)];
        _billTime.textColor = RGBA(0xffffff, 1);
        _billTime.font = [UIFont systemFontOfSize:15.0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy年MM月"];
        NSString *selectDate = [dateFormatter stringFromDate:[NSDate date]];
        _billTime.text = selectDate;
    }
    return _billTime;
}
- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 50, 0, 50, 40)];
        [_selectBtn setImage:[UIImage imageNamed:@"my_icon_calendar"] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}
- (void)selectBtnClick{
    [self.datePicker show];
}

- (void)fecthData:(NSString *)dateStr{
    [_dataArr removeAllObjects];
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId,@"mon":dateStr};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/balance/mybills" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        BillingInquiriesDataModel *data = [BillingInquiriesDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
           
            [_dataArr addObjectsFromArray:data.form];
            if (_dataArr.count == 0) {
                [self.myTableView addEmptyViewWithImageName:@"暂无账单" title:@"暂无账单"];
                [self.myTableView.emptyView setHidden:NO];
            }else{
                [self.myTableView.emptyView setHidden:YES];
            }
            [self.myTableView reloadData];
        }else{
            
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
        BillingInquiriesList *list = _dataArr[indexPath.row];
        cell.type.text = list.name;
        cell.time.text = [StorageUserInfromation timeStrFromDateString3:list.payTime];
        if (list.amount.floatValue>0) {
            cell.num.text = [NSString stringWithFormat:@"%0.2f",list.amount.floatValue];
        }else{
            cell.num.text = [NSString stringWithFormat:@"%0.2f",list.amount.floatValue];
        }
        
        if (list.type == 0) {
            cell.symbol.text = @"";
            [cell.symbol setTextColor:RGBCOLOR(48, 48, 48)];
            [cell.num setTextColor:RGBCOLOR(48, 48, 48)];
        }else if(list.type == 1){
            cell.symbol.text = @"-";
            [cell.symbol setTextColor:RGBCOLOR(48, 48, 48)];
            [cell.num setTextColor:RGBCOLOR(48, 48, 48)];

        }else if (list.type == 2){
            cell.symbol.text = @"+";
            [cell.symbol setTextColor:RGBCOLOR(0, 167, 255)];
            [cell.num setTextColor:RGBCOLOR(0, 167, 255)];
        }else if (list.type == 3){
            cell.symbol.text = @"";
            [cell.symbol setTextColor:RGBCOLOR(156, 156, 156)];
            [cell.num setTextColor:RGBCOLOR(156, 156, 156)];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.numWidth.constant = [cell.num sizeThatFits:CGSizeMake(SCREEN_WIDTH, 25)].width;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    BalanceDetailDataList *list = _dataArry[section];
    return  _dataArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BillingDetailVC *page =[[BillingDetailVC alloc]init];
    BillingInquiriesList *list = _dataArr[indexPath.row];
    page.dict = list;
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
