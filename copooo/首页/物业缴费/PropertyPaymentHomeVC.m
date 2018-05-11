//
//  PropertyPaymentHomeVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/30.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PropertyPaymentHomeVC.h"
#import "PropertypaymentHomeCell.h"
#import "NewPropertyRoomNoViewController.h"
#import "PropertyPaymentVC.h"
#import "PropertyPaymentHomeDataModel.h"
#import "NSString+ZF.h"
#import "InputAlert.h"
@interface PropertyPaymentHomeVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *noPropertyCardView;
    CGFloat bottomBtnHight;
}
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)NSMutableArray <PropertyPaymentHomeArr *>* myArr;

@end

@implementation PropertyPaymentHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    bottomBtnHight = TABBARHEIGHT;
    [self addNoPropertyCardView];
    self.view.backgroundColor = RGBA(0xeeeeee, 1);
    [self.view addSubview:self.bottomBtn];
    [self.view addSubview:self.myTableView];
    // Do any additionalsetup after loading the view.
}
- (void)setNav{
    self.isShowNav = YES;
    _backButton.hidden = NO;
    self.navView.backgroundColor = RGBA(0xf6f6f6, 1);
    if (_titleStr) {
        self.titleLabel.text = _titleStr;
    }else{
        self.titleLabel.text = @"物业缴费";
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _myArr = [NSMutableArray array];
    [self fetchData];

}
- (void)fetchData{
    [_myArr removeAllObjects];
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId};
    [ZTHttpTool postWithUrl:@"property/v1/propertyCard/queryRoomCardList" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        PropertyPaymentHomeDataModel *data = [PropertyPaymentHomeDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            [_myArr addObjectsFromArray:data.form];
            if (_myArr.count>0) {
                self.myTableView.hidden = NO;
                [self.myTableView reloadData];
            }else{
                self.myTableView.hidden = YES;
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)addNoPropertyCardView{
    noPropertyCardView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH,SCREENHEIGHT - NAVHEIGHT - bottomBtnHight)];
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 30*2, (SCREENWIDTH - 30*2)*(237/311.0))];
    img.image = [UIImage imageNamed:@"home_pic_暂无房卡"];
    img.center = CGPointMake(SCREENWIDTH/2.0, (SCREENHEIGHT - NAVHEIGHT - bottomBtnHight)/2.0);
    [noPropertyCardView addSubview:img];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    label.text = @"暂无房卡";
    label.font = [UIFont systemFontOfSize:18.0];
    label.textColor = RGBA(0x00a7ff, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(SCREENWIDTH/2.0, img.center.y + img.height/2.0);
    [noPropertyCardView addSubview:label];
    [self.view addSubview:noPropertyCardView];
}
-(UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - bottomBtnHight, SCREENWIDTH, bottomBtnHight)];
        [_bottomBtn setBackgroundImage:[UIImage imageNamed:@"home_button1_normal"] forState:UIControlStateNormal];
        [_bottomBtn setBackgroundImage:[UIImage imageNamed:@"home_button1_press"] forState:UIControlStateHighlighted];
    
        [_bottomBtn setTitle:@"添加房号" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:RGBA(0xffffff, 1) forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];

        [_bottomBtn setImage:[UIImage imageNamed:@"home_icon_add_house"] forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(addPropertyNoBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}
- (void)addPropertyNoBtn{
    NewPropertyRoomNoViewController *page = [[NewPropertyRoomNoViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - bottomBtnHight) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.backgroundColor = RGBA(0xeeeeee, 1);
    }
    return _myTableView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentiFier =@"PropertyPaymentHomeCell";
    PropertyPaymentHomeCell * myCell = [tableView dequeueReusableCellWithIdentifier:cellIndentiFier];
    if (!myCell) {
        myCell = [[[NSBundle mainBundle] loadNibNamed:cellIndentiFier owner:self options:nil] lastObject];
    }
    if (_myArr.count>0) {
        PropertyPaymentHomeArr *dict = _myArr[indexPath.row];
        NSString * str = dict.headName;
        if (dict.headName.length == 2) {
            str = [dict.headName replaceStringWithAsterisk:1 length: dict.headName.length-1];
        }else if (dict.headName.length > 2){
            str = [dict.headName replaceStringWithAsterisk:1 length: dict.headName.length-2];
        }
        myCell.headName.text = str;
        myCell.tel.text = dict.headTelphone;
        myCell.propertyUnitName.text = [NSString stringWithFormat:@"单元：%@",dict.propertyUnitName] ;
        myCell.propertyFloorName.text = [NSString stringWithFormat:@"楼层：%@",dict.propertyFloorName];
        myCell.propertyHouseName.text = [NSString stringWithFormat:@"户号：%@",dict.propertyHouseName];
        myCell.propertyBuildingName.text = [NSString stringWithFormat:@"楼栋：%@",dict.propertyBuildingName];
        myCell.address.text = dict.address;
        myCell.tips.text = dict.remarks;
    }
    myCell.tipsBtn.tag = indexPath.row;
    myCell.tipsBtnBlock = ^(NSInteger integer,PropertyPaymentHomeCell * cell) {
        [self reWhiteTips:integer cell:cell];
    };
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return myCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 169;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PropertyPaymentHomeArr *dict = _myArr[indexPath.row];

    if (_titleStr) {
        if ([_titleStr isEqualToString:@"选择房号"]) {
            NSString *name = [NSString stringWithFormat:@"%@%@%@%@ 层%@",dict.propertyAreaName,dict.propertyBuildingName,dict.propertyUnitName,dict.propertyFloorName,dict.propertyHouseName];
            if (self.propertyHouseChoseBlock) {
                self.propertyHouseChoseBlock(name, dict.propertyHouseId);
                [self.navigationController popViewControllerAnimated:YES];
                return;
                
            }
        }
    }
    PropertyPaymentVC *page = [[PropertyPaymentVC alloc]init];
    page.propertyHouseId = dict.propertyHouseId;
    [self.navigationController pushViewController:page animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    PropertyPaymentHomeArr *dict = _myArr[indexPath.row];
    [self deleteRoomNo:dict.ids index:indexPath];
    
}
- (void)deleteRoomNo:(NSString *)ids index:(NSIndexPath *)indexPath{
    NSDictionary * dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId,@"propertyCardId":ids};
    [ZTHttpTool postWithUrl:@"property/v1/propertyCard/deletePropertCard" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([onceDict[@"rcode"] integerValue] == 0) {
                //删除数据，和删除动画
                [self.myArr removeObjectAtIndex:indexPath.row];
                [_myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSError *error) {
        XMJLog(@"%@",error);
    }];
}
- (void)reWhiteTips:(NSInteger)integer cell:(PropertyPaymentHomeCell *)cell{
    WeakSelf
    [[InputAlert share] openWithTitle:@"修改备注" content:cell.tips.text placeString:@"请输入你的备注内容" keyboardType:UIKeyboardTypeDefault completion:^(NSString *text) {
        StrongSelf
//        if (StringLength(text) <= 0) {
//            [MBProgressHUD showError:@"备注内容不能为空"];
//            return ;
//        }
//        if (StringLength(text) > 5) {
//            [MBProgressHUD showError:@"最多输入5个字"];
//            return ;
//        }
        [strongSelf requestReWhiteTips:integer text:text cell:cell];
        cell.tips.text = text;
    }];
    
}
- (void)requestReWhiteTips:(NSInteger)integer text:(NSString *)text cell:(PropertyPaymentHomeCell *)cell{
    PropertyPaymentHomeArr *dict = _myArr[integer];
    [MBProgressHUD showMessage:@""];
    NSDictionary *dict2 = @{@"apiv":@"1.0",@"remarks":text,@"propertyCardId":dict.ids};
    [ZTHttpTool postWithUrl:@"property/v1/propertyCard/updateRoomCard" param:dict2 success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        [MBProgressHUD hideHUD];
        if ([onceDict[@"rcode"] integerValue] == 0) {
            cell.tips.text = text;
            dict.remarks = text;
        }else{
            [MBProgressHUD showError:@"修改失败"];
        }
    } failure:^(NSError *error) {
        XMJLog(@"%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];

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

@end
