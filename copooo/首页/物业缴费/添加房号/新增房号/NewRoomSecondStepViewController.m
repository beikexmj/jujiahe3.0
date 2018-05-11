//
//  NewRoomSecondStepViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/11/8.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "NewRoomSecondStepViewController.h"
#import "NewRoomDataModel.h"
#import "XXTextField.h"
@interface NewRoomSecondStepViewController ()
{
    NSString *buildingId;
    NSString *unitIds;
    NSString *roomId;
    NSString *flourId;
    XXInputView *inputView;
}
@property (nonatomic,strong)NSMutableArray <NewRoomDataList *>*buildingArr;
@property (nonatomic,strong)NSMutableArray <NewRoomDataList *>*unitArr;
@property (nonatomic,strong)NSMutableArray <NewRoomDataList *>*roomArr;
@property (nonatomic,strong)NSMutableArray <NewRoomDataList *>*flourArr;


@end

@implementation NewRoomSecondStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navTitle.font = [UIFont systemFontOfSize:18.0];
        _navHight.constant = 64+22;
    }
    _buildingArr = [NSMutableArray array];
    _unitArr = [NSMutableArray array];
    _roomArr = [NSMutableArray array];
    _flourArr = [NSMutableArray array];
    [self.addRoomNoBtn setBackgroundImage:[UIImage imageNamed:@"button1_normal"] forState:UIControlStateNormal];
    [self.addRoomNoBtn setBackgroundImage:[UIImage imageNamed:@"button1_press"] forState:UIControlStateHighlighted];
    self.addRoomNoBtnHeight.constant = (SCREENWIDTH -60)*1/8.0;
    
    // Do any additional setup after loading the view from its nib.
}
- (void)addBuilding{
    [ZTHttpTool postWithUrl:@"property/v1/select/queryPropertyBuilding" param:@{@"userId":[StorageUserInfromation storageUserInformation].userId,@"propertyAreaId":_unitId} success:^(id responseObj) {
        [_buildingArr removeAllObjects];
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        NewRoomDataModel *newRoomData = [NewRoomDataModel mj_objectWithKeyValues:str];
        if (newRoomData.rcode == 0) {
            [_buildingArr addObjectsFromArray:newRoomData.form];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)addUint:(NSString *)str{
    [ZTHttpTool postWithUrl:@"property/v1/select/queryPropertyUnit" param:@{@"userId":[StorageUserInfromation storageUserInformation].userId,@"propertyBuildingId":str} success:^(id responseObj) {
        [_unitArr removeAllObjects];
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        NewRoomDataModel *newRoomData = [NewRoomDataModel mj_objectWithKeyValues:str];
        if (newRoomData.rcode == 0) {
            [_unitArr addObjectsFromArray:newRoomData.form];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)addRoom:(NSString *)str{
    [ZTHttpTool postWithUrl:@"property/v1/select/queryPropertyHouse" param:@{@"userId":[StorageUserInfromation storageUserInformation].userId,@"propertyFloorId":str} success:^(id responseObj) {
        [_roomArr removeAllObjects];
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        NewRoomDataModel *newRoomData = [NewRoomDataModel mj_objectWithKeyValues:str];
        if (newRoomData.rcode == 0) {
            [_roomArr addObjectsFromArray:newRoomData.form];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)addFlour:(NSString *)str{
    [ZTHttpTool postWithUrl:@"property/v1/select/queryPropertyFloor" param:@{@"userId":[StorageUserInfromation storageUserInformation].userId,@"propertyUnitId":str} success:^(id responseObj) {
        [_flourArr removeAllObjects];
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        NewRoomDataModel *newRoomData = [NewRoomDataModel mj_objectWithKeyValues:str];
        if (newRoomData.rcode == 0) {
            [_flourArr addObjectsFromArray:newRoomData.form];
        }
    } failure:^(NSError *error) {
        
    }];
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
    if (inputView) {
        [inputView hide];
    }
    UIButton *btn = sender;
    switch (btn.tag) {
        case 10:
            {
                [MBProgressHUD showMessage:@""];

                [ZTHttpTool sendGroupPostRequest:^{
                    [self addBuilding];
                } success:^{
                    if (_buildingArr.count == 0) {
                        [MBProgressHUD hideHUD];

                        [MBProgressHUD showError:@"暂无楼栋"];
                        return ;
                    }
                    inputView = [[XXInputView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200) mode:XXPickerViewModeDataSourceForColumn dataSource:_buildingArr];
                    inputView.hideSeparator = YES;
                    __weak typeof(buildingId) weakBuildingId = buildingId;
                    WeakSelf
                    inputView.completeBlock = ^(NSString *dateString,NSString *ids){
                        NSLog(@"selected data : %@", dateString);
                        StrongSelf
                        if (weakBuildingId) {
                            if (![ids isEqualToString:weakBuildingId]) {
                                strongSelf.buildingNo.text = dateString;
                                buildingId = ids;
                                strongSelf.unitNo.text = @"请选择";
                                unitIds = nil;
                                strongSelf.roomNo.text = @"请选择";
                                roomId = nil;
                                strongSelf.flourNo.text = @"请选择";
                                flourId = nil;
                            }
                        }else{
                            strongSelf.buildingNo.text = dateString;
                            buildingId = ids;
                        }
                        
                        
                    };
                    
                    [self.view addSubview:inputView];
                    [inputView show];
                    [MBProgressHUD hideHUD];

                } failure:^(NSArray *errorArray) {
                    [MBProgressHUD hideHUD];
                }];

            }
            break;
        case 20:
        {
            if (!buildingId) {
                [MBProgressHUD showError:@"请选择楼栋"];
                break;
            }
            [MBProgressHUD showMessage:@""];

            [ZTHttpTool sendGroupPostRequest:^{
                [self addUint:buildingId];
            } success:^{
                if (_unitArr.count == 0) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"暂无单元"];
                    return ;
                }
                inputView = [[XXInputView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200) mode:XXPickerViewModeDataSourceForColumn dataSource:_unitArr];
                inputView.hideSeparator = YES;
                __weak typeof(unitIds) weakUnitIds = unitIds;
                WeakSelf
                inputView.completeBlock = ^(NSString *dateString,NSString *ids){
                    NSLog(@"selected data : %@", dateString);
                   StrongSelf
                    if (weakUnitIds) {
                        if (![ids isEqualToString:weakUnitIds]) {
                            strongSelf.unitNo.text = dateString;
                            unitIds = ids;
                            strongSelf.roomNo.text = @"请选择";
                            roomId = nil;
                            strongSelf.flourNo.text = @"请选择";
                            flourId = nil;
                            
                        }
                    }else{
                        strongSelf.unitNo.text = dateString;
                        unitIds = ids;
                    }
                };
                
                [self.view addSubview:inputView];
                [inputView show];
                [MBProgressHUD hideHUD];
                
            } failure:^(NSArray *errorArray) {
                [MBProgressHUD hideHUD];
            }];

        }
            break;
        case 30:
        {
            if (!unitIds) {
                [MBProgressHUD showError:@"请选择单元"];
                break;
            }
            [MBProgressHUD showMessage:@""];
            
            [ZTHttpTool sendGroupPostRequest:^{
                [self addFlour:unitIds];
            } success:^{
                if (_flourArr.count == 0) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"暂无楼层"];
                    return ;
                }
                inputView = [[XXInputView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200) mode:XXPickerViewModeDataSourceForColumn dataSource:_flourArr];
                inputView.hideSeparator = YES;
                __weak typeof(flourId) weakFlourId = flourId;
                WeakSelf
                inputView.completeBlock = ^(NSString *dateString,NSString *ids){
                    NSLog(@"selected data : %@", dateString);
                    StrongSelf
                    if (weakFlourId) {
                        if (![ids isEqualToString:weakFlourId]) {
                            strongSelf.flourNo.text = dateString;
                            flourId = ids;
                            strongSelf.roomNo.text = @"请选择";
                            roomId = nil;
                            
                        }
                    }else{
                        strongSelf.flourNo.text = dateString;
                        flourId = ids;
                    }
                };
                
                [self.view addSubview:inputView];
                [inputView show];
                [MBProgressHUD hideHUD];
                
            } failure:^(NSArray *errorArray) {
                [MBProgressHUD hideHUD];
            }];
        }
           
            break;
        case 40:
        {
            if (!flourId) {
                [MBProgressHUD showError:@"请选择楼层"];
                break;
            }
            [MBProgressHUD showMessage:@""];
            
            [ZTHttpTool sendGroupPostRequest:^{
                [self addRoom:flourId];
            } success:^{
                if (_roomArr.count == 0) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"暂无户号"];
                    return ;
                }
                inputView = [[XXInputView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200) mode:XXPickerViewModeDataSourceForColumn dataSource:_roomArr];
                inputView.hideSeparator = YES;
                WeakSelf
                inputView.completeBlock = ^(NSString *dateString,NSString *ids){
                    StrongSelf
                    NSLog(@"selected data : %@", dateString);
                    strongSelf.roomNo.text = dateString;
                    roomId = ids;
                };
                
                [self.view addSubview:inputView];
                [inputView show];
                [MBProgressHUD hideHUD];
                
            } failure:^(NSArray *errorArray) {
                [MBProgressHUD hideHUD];
            }];
        }
            break;
        default:
            break;
    }
}

- (IBAction)addRoomNoBtnClick:(id)sender {
    if (roomId) {
        [ZTHttpTool postWithUrl:@"property/v1/propertyCard/addRoomCard" param:@{@"userId":[StorageUserInfromation storageUserInformation].userId,@"apiv":@"1.0",@"propertyHouseId":roomId,@"remarks":self.tips.text} success:^(id responseObj) {
            NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
            NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
            NSDictionary * dict = [DictToJson dictionaryWithJsonString:str];
            if ([dict[@"rcode"] integerValue] == 0) {
//                if (![[NSUserDefaults standardUserDefaults] valueForKey:@"roomNo"]) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"freshRoomNo" object:nil];
//                }
                [self.navigationController popToViewController:[self.navigationController viewControllers][self.navigationController.viewControllers.count - 3] animated:YES];
            }else{
                [MBProgressHUD showError:dict[@"msg"]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络异常"];

        }];
    }else{
        [MBProgressHUD showError:@"请完善选择"];
    }
}
@end
