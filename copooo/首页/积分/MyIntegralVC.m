//
//  MyIntegralVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/28.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "MyIntegralVC.h"
#import "MyIntegralCell.h"
#import "IntegralVC.h"
#import "SignRecordView.h"
#import "SignSuccessView.h"
#import "MissionMineDataModel.h"
#import "SignDetailDataModel.h"
#import "PropertyPaymentHomeVC.h"
#import "CommunityJSVC.h"
#import "PersonalInformationViewController.h"
#import "BaseTabbarVC.h"
@interface MyIntegralVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) UILabel *integral;
@property (nonatomic,strong) UILabel *integralName;
@property (nonatomic,strong) SignRecordView *signRecordView;
@property (nonatomic,strong) MissionMineForm *missionMine;
@property (nonatomic,strong) SignDetailForm *signDetailData;

@end

@implementation MyIntegralVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self.view addSubview:self.myTableView];
    [self addTableHeaderView];
    [self fetchIntegral];
    [self sign];
//    [self fetchMissionMine];
    [self fetchSignDetail];

    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchMissionMine];
    [self fetchIntegral];

}
- (void)setNav{
    self.isShowNav = YES;
    self.titleLabel.text = @"合币";
//    self.titleLabel.textColor = RGBA(0xffffff, 1);
    self.navView.backgroundColor = [UIColor clearColor];
    self.lineView.hidden = YES;
    _backButton.hidden = NO;
    [_backButton setImage:[UIImage imageNamed:@"icon_back_gray"] forState:UIControlStateNormal];
    
}
- (void)addTableHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
    UIView *subView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 110)];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 110)];
    imageView.image = [UIImage imageNamed:@"my_integral_bac1"];
    [subView1 addSubview:imageView];
    [subView1 addSubview:self.integral];
    [subView1 addSubview:self.integralName];
    [headerView addSubview:subView1];
    
    UIView *subView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 110, SCREENWIDTH, 90)];
    subView2.backgroundColor = [UIColor whiteColor];
    NSArray *imageArr = @[@"my_integral_list",@"my_integral_record",@"my_integral_rules"];
    NSArray *nameArr = @[@"合币账单",@"签到记录",@"合币规则"];
    for (int i = 0; i<3; i++) {
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0 + i*SCREENWIDTH/3.0, 0, SCREENWIDTH/3.0, 90)];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 90 - 35,SCREENWIDTH/3.0, 20)];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textColor = RGBA(0x303030, 1);
        label.text = nameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        [myView addSubview:label];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH/3.0, 90)];
        btn.tag = i;
        btn.imageEdgeInsets = UIEdgeInsetsMake(-15.0, 0, 0, 0);
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [myView addSubview:btn];
        [subView2 addSubview:myView];
    }
    [headerView addSubview:subView2];
    self.myTableView.tableHeaderView = headerView;
}
- (void)btnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
            {
                IntegralVC *page = [[IntegralVC alloc]init];
                [self.navigationController pushViewController:page animated:YES];
            }
            break;
        case 1:
        {
            [self showSignView];
        }
            break;
        case 2:
        {
            CommunityJSVC *page = [[CommunityJSVC alloc]init];
            page.titleStr = @"合币规则";
            page.url = [NSString stringWithFormat:@"%@%@", BASE_H5_URL,@"#!/moneyRule"];
            [self.navigationController pushViewController:page animated:YES];
        }
            break;
        case 3:
        {
           
        }
            break;
            
        default:
            break;
    }
}
- (void)showSignView{
    _signRecordView = [[SignRecordView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _signRecordView.backgroundColor = [UIColor clearColor];
    if (_signDetailData) {
        _signRecordView.dayNum.text = _signDetailData.continuity;
        [_signRecordView setDataArry:_signDetailData.detail];
    }
    WeakSelf
    _signRecordView.btnBlock = ^{
        StrongSelf
        [UIView animateWithDuration:0.4 animations:^{
            strongSelf.signRecordView.myView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 510);
        } completion:^(BOOL finished) {
            [strongSelf.signRecordView removeFromSuperview];
        }];
    };
    [self.view addSubview:_signRecordView];
    
    [UIView animateWithDuration:0.4 animations:^{
        _signRecordView.myView.frame = CGRectMake(0, SCREENHEIGHT-485, SCREENWIDTH, 510);
    }];
}
- (void)sign{
    
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId,@"username":[StorageUserInfromation storageUserInformation].username};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/sign/action" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([onceDict[@"rcode"] integerValue] == 0) {
            [self fetchIntegral];
            [self fetchMissionMine];
            [self fetchSignDetail];
            if (![onceDict[@"form"][@"point"] isEqual:[NSNull null]]) {
                [self showSuccessView:[onceDict[@"form"][@"point"] stringValue]];

            }else{
                [self showSuccessView:@"5"];
            }
            
        }else{
//            [[[UIAlertView alloc]initWithTitle:@"签到失败" message:@"网络不稳定，请稍后再试。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新签到", nil] show];
        }
    } failure:^(NSError *error) {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"网络不稳定，请稍后再试。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新签到", nil] show];
    }];
    
}
- (void)fetchIntegral{
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/point/mypoint" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([onceDict[@"rcode"] integerValue] == 0) {
            if (![onceDict[@"form"][@"point"] isEqual:[NSNull null]]) {
                NSString *str2 = [onceDict[@"form"][@"point"] stringValue];
                self.integral.text = str2?str2:@"";
            }
           
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)showSuccessView:(NSString *)integral{
    SignSuccessView *page = [[SignSuccessView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    page.integral.text = integral;
    [self.view addSubview:page];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else{
        [self sign];
    }
}

- (void)fetchMissionMine{
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/mission/mine" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        MissionMineDataModel *data = [MissionMineDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            _missionMine = data.form;
            [self.myTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)fetchSignDetail{
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/sign/signDetail" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        SignDetailDataModel *data = [SignDetailDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            _signDetailData = data.form;
        }
    } failure:^(NSError *error) {
        
    }];
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
- (UILabel *)integral{
    if (!_integral) {
        _integral = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
        _integral.font = [UIFont systemFontOfSize:35.0];
        _integral.textColor = RGBA(0xffffff, 1);
        _integral.textAlignment = NSTextAlignmentCenter;
        _integral.center = CGPointMake(SCREENWIDTH/2.0, 110/2.0 - 15.0);
    }
    return _integral;
}
- (UILabel *)integralName{
    if (!_integralName) {
        _integralName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
        _integralName.font = [UIFont systemFontOfSize:15.0];
        _integralName.textColor = RGBA(0xffffff, 1);
        _integralName.textAlignment = NSTextAlignmentCenter;
        _integralName.text = @"当前合币";
        _integralName.center = CGPointMake(SCREENWIDTH/2.0, 110/2.0 + 20.0);
    }
    return _integralName;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"MyIntegralCell";
    MyIntegralCell * cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myCell owner:self options:nil] lastObject];
    }
    cell.markBtn.tag = indexPath.row  + indexPath.section *10;

    if (_missionMine) {
        NSInteger integer;
        if (indexPath.section == 0) {
            cell.name.text = _missionMine.startingMission[indexPath.row].missionName;
            integer = _missionMine.startingMission[indexPath.row].complete;
            cell.integralNum.text = [NSString stringWithFormat:@"%@合币",_missionMine.startingMission[indexPath.row].missionPoint];
        }else{
            cell.name.text = _missionMine.dailyMission[indexPath.row].missionName;
            integer = _missionMine.dailyMission[indexPath.row].complete;
            cell.integralNum.text = [NSString stringWithFormat:@"%@合币",_missionMine.dailyMission[indexPath.row].missionPoint];
        }
        if (integer == 0) {
            [cell.markBtn setBackgroundColor:RGBA(0x00a7ff, 1)];
            [cell.markBtn setTitle:@"去完成" forState:UIControlStateNormal];
            cell.userInteractionEnabled = YES;
        }else{
            [cell.markBtn setBackgroundColor:RGBA(0x9c9c9c, 1)];
            [cell.markBtn setTitle:@"已完成" forState:UIControlStateNormal];
            cell.userInteractionEnabled = NO;

        }
        
    }
    WeakSelf
    cell.markBtnBlock = ^(NSInteger integer) {
        StrongSelf
        NSInteger section = integer/10;
        NSInteger row = integer%10;
        MissionMineArr *arr;
        if (section == 0) {
            arr = _missionMine.startingMission[row];
        }else{
            arr = _missionMine.dailyMission[row];
        }
        if ([arr.missionName isEqualToString:@"首次登陆居家合"]) {
            
        }else if([arr.missionName isEqualToString:@"首次点赞"]){
            [strongSelf gotoCommunityPage];
        }else if([arr.missionName isEqualToString:@"首次评论"]){
            [strongSelf gotoCommunityPage];
        }else if([arr.missionName isEqualToString:@"首次在平台缴费"]){
            PropertyPaymentHomeVC  *page = [[PropertyPaymentHomeVC alloc]init];
            [strongSelf.navigationController pushViewController:page animated:YES];
        } else if([arr.missionName isEqualToString:@"今日签到"]){
            [strongSelf sign];
        } else if([arr.missionName isEqualToString:@"分享每日一言"]){
            BaseTabbarVC *baseTabbarVC = strongSelf.navigationController.viewControllers[0];
            baseTabbarVC.selectedIndex = 0;
            [strongSelf.navigationController popViewControllerAnimated:YES];
        } else if([arr.missionName isEqualToString:@"社区发帖"]){
            CommunityJSVC *webVC = [[CommunityJSVC alloc]init];
            webVC.url = [NSString stringWithFormat:@"%@#!/post",BASE_H5_URL];
            webVC.titleStr = @"发帖";
            webVC.userId = [StorageUserInfromation storageUserInformation].userId;
            [strongSelf.navigationController pushViewController:webVC animated:YES];
        } else if([arr.missionName isEqualToString:@"阅读任意"]){
            [strongSelf gotoCommunityPage];
        }else if([arr.missionName isEqualToString:@"邀请注册"]){
            PersonalInformationViewController *page = [[PersonalInformationViewController alloc]init];
            [strongSelf.navigationController pushViewController:page animated:YES];
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.numWidth.constant = [cell.num sizeThatFits:CGSizeMake(SCREEN_WIDTH, 25)].width;
    return cell;
}
- (void)gotoCommunityPage{
    BaseTabbarVC *baseTabbarVC = self.navigationController.viewControllers[0];
    baseTabbarVC.selectedIndex = 1;
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_missionMine) {
        if (section == 0) {
            return _missionMine.startingMission.count;
        }
        return _missionMine.dailyMission.count;
    }
    return  0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_missionMine) {
        return 2;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    myView.backgroundColor = RGBA(0xeeeeee, 1);
    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, 9, SCREENWIDTH, 30)];
    subView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 7.5, 15, 15)];
    imageView.image = [UIImage imageNamed:@[@"my_integral_icon_new",@"my_integral_icon_mission"][section]];
    [subView addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 150, 30)];
    nameLabel.font = [UIFont systemFontOfSize:13.0];
    nameLabel.textColor = RGBA(0x00a7ff, 1);
    nameLabel.text = @[@"新手任务",@"日常任务"][section];
    [subView addSubview:nameLabel];
    [myView addSubview:subView];
    
    return myView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
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
