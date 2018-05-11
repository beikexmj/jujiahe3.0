//
//  NewPropertyRoomNoViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/11/8.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "NewPropertyRoomNoViewController.h"
#import "JFLocation.h"
#import "JFAreaDataManager.h"
#import "ChoseUnitViewController.h"
#import "NewRoomSecondStepViewController.h"
#import "LocationUnitDataModel.h"
#import "ChoseUnitDataModel.h"
#import <CoreLocation/CoreLocation.h>
@class ChoseUnitDataList;
#define KCURRENTCITYINFODEFAULTS [NSUserDefaults standardUserDefaults]

@interface NewPropertyRoomNoViewController ()<JFLocationDelegate>
{

}
/** 城市定位管理器*/
@property (nonatomic, strong) JFLocation *locationManager;
/** 城市数据管理器*/
@property (nonatomic, strong) JFAreaDataManager *manager;
@end

@implementation NewPropertyRoomNoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navTitle.font = [UIFont systemFontOfSize:18.0];
        _navHight.constant = 64+22;
    }
    [self.nextStepBtn setBackgroundImage:[UIImage imageNamed:@"button1_normal"] forState:UIControlStateNormal];
    [self.nextStepBtn setBackgroundImage:[UIImage imageNamed:@"button1_press"] forState:UIControlStateHighlighted];
    self.nextStepHeight.constant = (SCREENWIDTH -60)*1/8.0;
    self.rightNowLocationMark.text = @"";

    self.locationManager = [[JFLocation alloc] init];
    _locationManager.delegate = self;
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)cityChoseBtnClick:(id)sender {
}

- (IBAction)villageChoseBtnClick:(id)sender {
    ChoseUnitViewController *page = [[ChoseUnitViewController alloc]init];
    __weak typeof(self) weakSelf = self;

    page.unitChoseBlock = ^(NSString *unitName,NSString *ids,NSString *propertyId,NSString *propertyName,NSInteger isInput) {
        weakSelf.village.text = unitName;
        _rightNowLocationMark.text = @"";
        _unitId = ids;
        _propertyId = propertyId;
        if (isInput) {
            _chargeUnit.text = [NSString stringWithFormat:@"收费单位：%@",propertyName];
            [self.nextStepBtn setBackgroundImage:[UIImage imageNamed:@"button1_normal"] forState:UIControlStateNormal];
            [self.nextStepBtn setBackgroundImage:[UIImage imageNamed:@"button1_press"] forState:UIControlStateHighlighted];
            self.nextStepBtn.enabled = YES;
        }else{
            _chargeUnit.text = @"温馨提示：该小区暂未接入物管费在线缴纳业务";
            [self.nextStepBtn setBackgroundImage:[UIImage imageNamed:@"button1_un"] forState:UIControlStateNormal];
            [self.nextStepBtn setBackgroundImage:[UIImage imageNamed:@"button1_un"] forState:UIControlStateHighlighted];
            self.nextStepBtn.enabled = NO;
        }
        _chargeUnit.hidden = NO;
        _technicalSupport.hidden = NO;
//        [self fetchPropertyName];
    };
    [self.navigationController pushViewController:page animated:YES];
}
- (void)fetchPropertyName{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"propertyAreaId":_unitId,@"device":@"1"};
    
    [ZTHttpTool postWithUrl:@"jujiahe/property/getPropertyName" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        NSDictionary * dict = [DictToJson dictionaryWithJsonString:str];
        if ([dict[@"rcode"] integerValue] == 0) {
            _chargeUnit.text = [NSString stringWithFormat:@"物业公司：%@",dict[@"form"]];
            _chargeUnit.hidden = NO;
            _technicalSupport.hidden = NO;
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (IBAction)nextStepBtnClick:(id)sender {
    if (!_unitId) {
        [MBProgressHUD showError:@"请选择小区"];
        return;
    }
    NewRoomSecondStepViewController *page = [[NewRoomSecondStepViewController alloc]init];
    page.unitId = _unitId;
    page.comFromFlag = _comFromFlag;
    page.propertyId = _propertyId;
    [self.navigationController pushViewController:page animated:YES];
    
}
#pragma mark - JFCityViewControllerDelegate

- (void)cityName:(NSString *)name {
    _cityName.text = @"重庆市";
}

#pragma mark --- JFLocationDelegate
//定位中...
- (void)locating {
    NSLog(@"定位中...");
}

//定位成功
- (void)currentLocation:(NSDictionary *)locationDictionary {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"locations"]) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"locations"];
        CLLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self fetchLocationCity:location];
    }
}
- (void)fetchLocationCity:(CLLocation *)location{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"device":@"1",@"cityOid":[[NSUserDefaults standardUserDefaults] objectForKey:@"cityNumber"],@"apiv":@"1.0",@"latitude":[NSString stringWithFormat:@"%lf",location.coordinate.latitude] ,@"longitude":[NSString stringWithFormat:@"%lf",location.coordinate.longitude]};
    [ZTHttpTool postWithUrl:@"jujiahe/v1/propertyArea/queryCurrentLocationList" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        LocationUnitDataModel *unitData = [LocationUnitDataModel mj_objectWithKeyValues:str];
        if (unitData.rcode == 0) {
            ChoseUnitDataList *onceDict = unitData.form;
            _village.text = onceDict.name;
            _rightNowLocationMark.text = @"(当前定位)";
            _chargeUnit.hidden = NO;
            _technicalSupport.hidden = NO;
            _unitId = unitData.form.ids;
            _propertyId = unitData.form.propertyId;
            [self fetchPropertyName];
        }else{
        }
        
    } failure:^(NSError *error) {
        
    }];
}
/// 拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message {
    NSLog(@"%@",message);
}

/// 定位失败
- (void)locateFailure:(NSString *)message {
    NSLog(@"%@",message);
}

@end
