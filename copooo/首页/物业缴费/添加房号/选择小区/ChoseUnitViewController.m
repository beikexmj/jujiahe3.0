//
//  ChoseUnitViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/11/8.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "ChoseUnitViewController.h"
#import "ChoseUnitTableViewCell.h"
#import "ChoseUnitDataModel.h"
#import "LocationUnitDataModel.h"
#import "AppDelegate.h"
#import "BaseTabbarVC.h"
#import "NearByUnitCell.h"
#import <CoreLocation/CoreLocation.h>
#import "JFCityViewController.h"
#import "HomePageVC.h"
@interface ChoseUnitViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,JFCityViewControllerDelegate>
{
    UITableView *subTableView;
     CABasicAnimation* rotationAnimation;
}
@property (nonatomic, strong)NSMutableArray <ChoseUnitDataList *>*myArray;
@property (nonatomic, strong)NSMutableArray <ChoseUnitDataList *>*nearByLocationUnitArr;
@property (nonatomic, strong)NSMutableDictionary *myDict;
@property (nonatomic, strong)NSMutableArray *sectionKeyArry;
@property (nonatomic,strong)ChoseUnitDataList *locationUnitData;

@end

@implementation ChoseUnitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBar.hidden = YES;
    if (kDevice_Is_iPhoneX) {
        _navTitle.font = [UIFont systemFontOfSize:18.0];
        _navHight.constant = 64+24;
    }
    _myDict = [NSMutableDictionary dictionary];
    _myArray  = [NSMutableArray array];
    _nearByLocationUnitArr = [NSMutableArray array];
    _sectionKeyArry = [NSMutableArray array];
    self.myTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.mySearchBar.backgroundImage =[StorageUserInfromation GetImageWithColor:RGBCOLOR(221, 221, 221) andHeight:56.0];
    for(id cc in [self.mySearchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
    _locationView.hidden = YES;
    _locationViewHight.constant = 0;
    
    NSString *title = [NSString stringWithFormat:@" %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"]];
    [_choseCity setTitle:title forState:UIControlStateNormal];
    
    [self fetchData];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"locations"] && _comFromFlag) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"locations"];
        CLLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self fetchLocationCity:location];
       
    }
    if (_comFromFlag) {
        NSData *data2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityLocations"];
        CLLocation *location2 = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
        [self fetchNearByUnit:location2];
    }
 
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = NO;
    rotationAnimation.repeatCount = 0;
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)fetchLocationCity:(CLLocation *)location{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"device":@"1",@"cityOid":[[NSUserDefaults standardUserDefaults] objectForKey:@"cityNumber"],@"apiv":@"1.0",@"latitude":[NSString stringWithFormat:@"%lf",location.coordinate.latitude] ,@"longitude":[NSString stringWithFormat:@"%lf",location.coordinate.longitude]};
    [ZTHttpTool postWithUrl:@"property/v1/propertyArea/queryCurrentLocationList" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        LocationUnitDataModel *unitData = [LocationUnitDataModel mj_objectWithKeyValues:str];
        if (unitData.rcode == 0) {
            _locationUnitData = unitData.form;
            self.locationUnit.text = unitData.form.name;
            self.locationView.hidden = NO;
            self.locationViewHight.constant = 70;
        }else{
            self.locationUnit.text = unitData.msg;
        }

    } failure:^(NSError *error) {
        XMJLog(@"%@",error);
    }];
}
- (void)fetchNearByUnit:(CLLocation *)location{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"device":@"1",@"cityOid":[[NSUserDefaults standardUserDefaults] objectForKey:@"cityNumber"],@"apiv":@"1.0",@"latitude":[NSString stringWithFormat:@"%lf",location.coordinate.latitude] ,@"longitude":[NSString stringWithFormat:@"%lf",location.coordinate.longitude]};
    [ZTHttpTool postWithUrl:@"property/v1/propertyArea/queryLocationList" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        ChoseUnitDataModel *choseUnitData = [ChoseUnitDataModel mj_objectWithKeyValues:str];
        if (choseUnitData.rcode == 0) {
            [_nearByLocationUnitArr removeAllObjects];
            [_nearByLocationUnitArr addObjectsFromArray:choseUnitData.form];
//            if (_nearByLocationUnitArr.count>0) {
                [self buildTableHeaderView];
//            }
        }
        
    } failure:^(NSError *error) {
        XMJLog(@"%@",error);

    }];
}
- (void)buildTableHeaderView{
    CGFloat height = 0;
    if (_nearByLocationUnitArr.count>0) {
        height = 40;
    }
    subTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, _nearByLocationUnitArr.count*44 + height)];
    subTableView.delegate = self;
    subTableView.dataSource = self;
    self.myTableView.tableHeaderView = subTableView;
    subTableView.scrollEnabled = NO;
    [subTableView reloadData];
    
}
-(void)fetchData{
    NSString *token  = [StorageUserInfromation storageUserInformation].token;
    NSString *userId = [StorageUserInfromation storageUserInformation].userId;
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":token?token:@"",@"userId":userId?userId:@"",@"device":@"1",@"cityOid":[[NSUserDefaults standardUserDefaults] objectForKey:@"cityNumber"],@"apiv":@"1.0"};
    
    [ZTHttpTool postWithUrl:@"property/v1/propertyArea/queryAllArea" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        ChoseUnitDataModel *choseUnitData = [ChoseUnitDataModel mj_objectWithKeyValues:str];
        if (choseUnitData.rcode == 0) {
            [_myArray removeAllObjects];
            [_myArray addObjectsFromArray:choseUnitData.form];
            [self rebuildData:_myArray];
            if (_myArray.count ==0) {
                self.myTableView.hidden = YES;
            }else{
                self.myTableView.hidden = NO;
            }
//            [self.myTableView reloadData];
        }else{
            self.myTableView.hidden = YES;
            [MBProgressHUD showError:choseUnitData.msg];
        }
    } failure:^(NSError *error) {
        XMJLog(@"%@",error);
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == subTableView) {
        static NSString *cell = @"NearByUnitCell";
        NearByUnitCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell];
        if (!myCell) {
            myCell = [[[NSBundle mainBundle] loadNibNamed:cell owner:self options:nil] lastObject];
        }
        if (_nearByLocationUnitArr.count>0) {
            ChoseUnitDataList *onceDict = _nearByLocationUnitArr[indexPath.row];
            myCell.unitName.text = onceDict.name;
            myCell.distence.text = [NSString stringWithFormat:@"%@km",onceDict.distance];
        }
        return myCell;
    }
    static NSString *cell = @"ChoseUnitTableViewCell";
    ChoseUnitTableViewCell * myCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (!myCell) {
        myCell = [[[NSBundle mainBundle] loadNibNamed:cell owner:self options:nil] lastObject];
    }
    NSArray * arr = _myDict[_sectionKeyArry[indexPath.section]];
    NSDictionary *dict = arr[indexPath.row];
    ChoseUnitDataList *list = dict.allValues[0];
    myCell.unitName.text = list.name;
    myCell.unitAdress.text = list.address;
    return myCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == subTableView) {
        return _nearByLocationUnitArr.count;
    }
    NSArray * arr = _myDict[_sectionKeyArry[section]];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == subTableView) {
        return 44;
    }
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == subTableView) {
        if (_nearByLocationUnitArr.count == 0) {
            return 0;
        }
    }
    return 40;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == subTableView) {
        return 1;
    }
    return _sectionKeyArry.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.myTableView) {
        return  _sectionKeyArry[section];
    }else{
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == subTableView) {
        if (_nearByLocationUnitArr.count == 0) {
            return nil;
        }
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
        myView.backgroundColor = [UIColor whiteColor];
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 120, 40)];
        myLabel.text = @"附近社区";
        myLabel.font = [UIFont systemFontOfSize:13.0];
        myLabel.textColor = RGBA(0x9c9c9c, 1);
        [myView addSubview:myLabel];
        
        UIView  *lineView = [[UIView alloc]initWithFrame:CGRectMake(8, 39, SCREENWIDTH - 8, 1)];
        lineView.backgroundColor = RGBA(0xeeeeee, 1);
        [myView addSubview:lineView];
        
        return myView;
    }else{
        return nil;
    }
   
}

//设置右侧索引的标题，这里返回的是一个数组哦！
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.myTableView) {
        return _sectionKeyArry;
    }else{
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChoseUnitDataList *list;
    if (tableView == self.myTableView) {
        NSArray * arr = _myDict[_sectionKeyArry[indexPath.section]];
        NSDictionary *dict = arr[indexPath.row];
        list = dict.allValues[0];
    }else{
        list = _nearByLocationUnitArr[indexPath.row];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:list.ids forKey:@"choseUnitPropertyId"];
    [[NSUserDefaults standardUserDefaults] setObject:list.name forKey:@"choseUnitName"];

    
    if (_comFromFlag != 1) {
        if (self.unitChoseBlock) {
            self.unitChoseBlock(list.name, list.ids, list.propertyId,list.propertyName,list.isInput);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    if (!storage.userId) {
        storage.userId = @"";
        storage.token = @"";
        storage.access_token = @"";
        storage.nickname = @"";
        storage.sex = @"-1";
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BaseTabbarVC *tabBarController = [BaseTabbarVC Shareinstance];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tabBarController];
    nav.fd_fullscreenPopGestureRecognizer.enabled = true;
    nav.fd_prefersNavigationBarHidden = true;
    nav.fd_interactivePopDisabled = true;
    nav.fd_viewControllerBasedNavigationBarAppearanceEnabled = false;
    [nav setNavigationBarHidden:YES animated:YES];
    tabBarController.selectedIndex = 0;
    delegate.window.rootViewController = nav;
    HomePageVC *page = (HomePageVC *)tabBarController.viewControllers[0];
    if (page) {
        [page fetchData2];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    if (![searchBar.text isEqualToString:@""]) {
        self.mySearchBar.text = @"";
        [searchBar resignFirstResponder];
        [self rebuildData:_myArray];
        self.myTableView.tableHeaderView = subTableView;
        [MobClick event:@"ssq_c"];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSMutableArray * array = [NSMutableArray array];
    if (![searchText isEqualToString:@""]) {
        if (_myArray.count>0) {
            for (ChoseUnitDataList *list in _myArray) {
                if ([list.name rangeOfString:searchText].location !=NSNotFound) {
                    [array addObject:list];
                }
            }
            [self rebuildData:array];
            self.myTableView.tableHeaderView = nil;
        }
    }else{
        [self rebuildData:_myArray];
        self.myTableView.tableHeaderView = subTableView;
        [MobClick event:@"ssq_c"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)rebuildData:(NSArray *)array{
    if (array.count>0) {
        [_myDict removeAllObjects];
        NSString *str = @"";
        NSMutableArray *circleArr = [NSMutableArray array];
        NSMutableDictionary *onceDict = [NSMutableDictionary dictionary];
        for (ChoseUnitDataList *onceList in array) {
            NSDictionary * dict;
            if (onceList.inputcode) {
                dict = @{onceList.inputcode:onceList};
            }else{
                onceList.inputcode = @"#";
                dict = @{@"#":onceList};
            }
            
          NSString  *str2 = [onceList.inputcode substringToIndex:1].uppercaseString;
            NSInteger flag = 0;
            for (NSString * str in onceDict.allKeys) {
                if ([str isEqualToString:str2]) {
                    [circleArr addObjectsFromArray:onceDict[str]];
                    [circleArr addObject:dict];
                    [onceDict setValue:[ circleArr copy] forKey:str];
                    [circleArr removeAllObjects];
                    flag = 1;
                    break;
                }
            }
            str = str2;
            if (flag == 0) {
                [circleArr addObject:dict];
                [onceDict setValue:[circleArr copy] forKey:str];
                [circleArr removeAllObjects];
            }
            
        }
        for (NSInteger i = 0; i<[onceDict allKeys].count;i++) {
          NSArray *myArr = onceDict.allValues[i];
            NSMutableArray *onceKeyArr = [NSMutableArray array];
            for (NSDictionary *dict in myArr) {
                [onceKeyArr addObject:dict.allKeys[0]];
            }
            NSArray *keyArr = [onceKeyArr sortedArrayUsingSelector:@selector(compare:)];
            NSMutableArray *onceArr = [NSMutableArray array];
            for (int j = 0;j<keyArr.count;j++){
                NSString * str = keyArr[j];
                for (NSDictionary *dict in myArr) {
                    for (NSString * key in dict.allKeys) {
                        if ([key isEqualToString:str]) {
                            [onceArr addObject:dict];
                        }
                    }
                }
            }
            [_myDict setValue:onceArr forKey:onceDict.allKeys[i]];
        }
        
        
        [_sectionKeyArry removeAllObjects];
        [_sectionKeyArry addObjectsFromArray: [[_myDict allKeys] sortedArrayUsingSelector:@selector(compare:)]];
        
    }else{
        [_myDict removeAllObjects];
        [_sectionKeyArry removeAllObjects];
    }
    [self.myTableView reloadData];
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

- (IBAction)rightBtnClick:(id)sender {
    [MobClick event:@"ccs_c"];
    JFCityViewController *page = [[JFCityViewController alloc]init];
    page.delegate = self;
    page.comFromFlag = @"1";
    [self.navigationController pushViewController:page animated:YES];
}

- (IBAction)freshBtnClick:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"locations"]) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"locations"];
        CLLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [_freshBtn.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        [self fetchLocationCity:location];
    }
}

- (IBAction)choseLoationUnitBtnClick:(id)sender {
    
    if ([_locationUnit.text isEqualToString:@"定位失败"]) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_locationUnitData.ids forKey:@"choseUnitPropertyId"];
    [[NSUserDefaults standardUserDefaults] setObject:_locationUnitData.name forKey:@"choseUnitName"];

    if (_comFromFlag != 1) {
        if (self.unitChoseBlock) {
            self.unitChoseBlock(_locationUnitData.name, _locationUnitData.ids, _locationUnitData.propertyId,_locationUnitData.propertyName,_locationUnitData.isInput);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    if (!storage.userId) {
        storage.userId = @"";
        storage.token = @"";
        storage.access_token = @"";
        storage.nickname = @"";
        storage.sex = @"-1";
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BaseTabbarVC *tabBarController = [BaseTabbarVC Shareinstance];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tabBarController];
    nav.fd_fullscreenPopGestureRecognizer.enabled = true;
    nav.fd_prefersNavigationBarHidden = true;
    nav.fd_interactivePopDisabled = true;
    nav.fd_viewControllerBasedNavigationBarAppearanceEnabled = false;
    [nav setNavigationBarHidden:YES animated:YES];
    tabBarController.selectedIndex = 0;
    delegate.window.rootViewController = nav;
    HomePageVC *page = (HomePageVC *)tabBarController.viewControllers[0];
    if (page) {
        [page fetchData2];
    }
}
- (void)cityName:(NSString *)name {
    NSString *title = [NSString stringWithFormat:@" %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"]];
    [_choseCity setTitle:title forState:UIControlStateNormal];
    [self fetchData];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"locations"] && _comFromFlag) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"locations"];
        CLLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self fetchLocationCity:location];
        NSData *data2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityLocations"];
        CLLocation *location2 = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
        [self fetchNearByUnit:location2];
    }
}
@end
