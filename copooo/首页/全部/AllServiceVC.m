//
//  AllServiceVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/7.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "AllServiceVC.h"
#import "XMJButton.h"
#import "AllServiceDataModel.h"
#import "JSBadgeView.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "ServiceVC.h"
#import "PropertyPaymentHomeVC.h"
#import "CallPropertyVC.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "CommunityJSVC.h"
@interface AllServiceVC ()
@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic,strong) NSArray <AllServiceArr*> *myArr;
@end

@implementation AllServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowNav = YES;
    _backButton.hidden = NO;
    //    self.leftImgName = @"icon_back_gray";
    self.titleLabel.text = @"全部";
    self.navView.backgroundColor = RGBA(0xeeeeee, 1);
    [self.view addSubview:self.myScrollView];
    [self rebuildView];
    [self fetchData];
    // Do any additional setup after loading the view.
}
- (UIScrollView *)myScrollView{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT)];
        _myScrollView.showsVerticalScrollIndicator = NO;
    }
    return _myScrollView;
}
- (void)fetchData{
    NSDictionary *dict = @{@"apiv":@"1.0",@"propertyAreaId":@"1c265c5b5a3741cca88ace5dac48a6ef"};
    [ZTHttpTool postWithUrl:@"jujiahe/v1/serviceMenu/infos" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        AllServiceDataModel *data = [AllServiceDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            _myArr = data.form;
            if (_myArr.count>0) {
                [self rebuildView];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)rebuildView{
    CGFloat sectionY = 0;
    for (int i = 0; i<_myArr.count; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, sectionY + 27.5, 3, 20)];
        lineView.backgroundColor = RGBA(0x00a7ff, 1);
        [self.myScrollView addSubview:lineView];
        
        UILabel *typeName = [[UILabel alloc]initWithFrame:CGRectMake(30, sectionY + 25, 150, 25)];
        typeName.font = [UIFont systemFontOfSize:15.0];
        typeName.textColor = RGBA(0x303030, 1);
        typeName.text = _myArr[i].name;
        [self.myScrollView addSubview:typeName];
        CGFloat yy = sectionY + 90;
        for (int j = 0; j<_myArr[i].data.count/3 +(_myArr[i].data.count%3 ==0?0:1); j++) {
            for (int k = 0; k<3; k++) {
                if (j*3 + (k+1)>_myArr[i].data.count) {
                    continue;
                }
                
                UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(30 + k*((SCREENWIDTH - 30*2)/3.0), yy, (SCREENWIDTH - 30*2)/3.0, 130)];
                
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, (SCREENWIDTH - 30*2)/3.0, 20)];
                nameLabel.text = _myArr[i].data[j*3 +k].name;
                nameLabel.font = [UIFont systemFontOfSize:13.0];
                nameLabel.textColor = RGBA(0x606060, 1);
                nameLabel.textAlignment =NSTextAlignmentCenter;
                [myView addSubview:nameLabel];
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(((SCREENWIDTH - 30*2)/3.0 - 55)/2.0, 20, 55, 55)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:_myArr[i].data[j*3 + k].icon] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
                [myView addSubview:imageView];
                
                UIButton  *btn = [[UIButton alloc]initWithFrame:CGRectMake( 0 , 0 , (SCREENWIDTH - 30*2)/3.0, 100)];
//                [btn sd_setImageWithURL:[NSURL URLWithString:_myArr[i].data[j*3 + k].icon] forState:UIControlStateNormal];
                btn.tag = j*3 + (k+1) + i*100;
//                btn.imageEdgeInsets = UIEdgeInsetsMake(-15, 15, 100- ((SCREENWIDTH - 30*2)/3.0 - 30)+15 , 15);
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [myView addSubview:btn];
                
                if (_myArr[i].data[j*3 +k].hot == 1) {
                    JSBadgeView *bage = [[JSBadgeView alloc]initWithParentView:btn alignment:JSBadgeViewAlignmentTopCenter];
                    bage.layer.borderColor = RGBA(0xffffff, 1).CGColor;
                    bage.layer.borderWidth = 1;
                    bage.layer.cornerRadius = 5;
                    bage.layer.masksToBounds = YES;
                    bage.badgeText = @"HOT";
                }
                
                [self.myScrollView addSubview:myView];
            }
            yy = yy + 130;
        }
        sectionY = sectionY + (_myArr[i].data.count/3 +(_myArr[i].data.count%3 ==0?0:1))*130 + 90;
    }
    self.myScrollView.contentSize = CGSizeMake(SCREENWIDTH, sectionY);
}
- (void)btnClick:(UIButton *)btn{
    
    if([[StorageUserInfromation storageUserInformation].userId isEqualToString:@""]){
        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"未登录" message:@"确定跳回登录界面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    NSInteger section = btn.tag/100;
    NSInteger row = btn.tag%100;
    AllServiceDict *dict = _myArr[section].data[row-1];
    NSString *name = dict.name;
    if ([name isEqualToString:@"呼叫物管"]) {
        
    }else if ([name isEqualToString:@"生活缴费"]) {
        
    }else if ([name isEqualToString:@"开水开电"]) {
        
    }else if ([name isEqualToString:@"社区报事"]) {
        
    }else if ([name isEqualToString:@"代收包裹"]) {
        
    }else if ([name isEqualToString:@"物业缴费"]) {
        
    }else if ([name isEqualToString:@"园区保修"]) {
        
    }else if ([name isEqualToString:@"秩序维护"]) {
        
    }else if ([name isEqualToString:@"户内保修"]) {
        
    }else if ([name isEqualToString:@"关于物业"]) {
        
    }else if ([name isEqualToString:@"开门"]) {
        
    }else if ([name isEqualToString:@"缴费大厅"]) {
        
    }else if ([name isEqualToString:@"清洁"]) {
        
    }else if ([name isEqualToString:@"教育"]) {
        
    }else if ([name isEqualToString:@"维护"]) {
        
    }else if ([name isEqualToString:@"代办"]) {
        
    }
    if ([dict.file_type isEqualToString:@"html"]) {
        CommunityJSVC *webVC = [[CommunityJSVC alloc]init];
        NSString *urlStr = dict.url;
        if (![JGIsBlankString isBlankString:urlStr]) {
            webVC.url = dict.url;
            if ([dict.ids isEqualToString:@"0d7147dcdd7b778b1afb539b007ef4e4"]) {
                webVC.url = [NSString stringWithFormat:@"%@?account=%@&mobile=%@",webVC.url,[StorageUserInfromation storageUserInformation].userId,[StorageUserInfromation storageUserInformation].username];//@"http://wxdemo-gj.ynrjkj.com:8181/";//
                XMJLog(@"%@",webVC.url);
            }
            
            [self.navigationController pushViewController:webVC animated:YES];
            return;
        }
    }
    if ([dict.type isEqualToString:@"7"]) {
        PropertyPaymentHomeVC *page = [[PropertyPaymentHomeVC alloc]init];
        [self.navigationController pushViewController:page animated:YES];
        return;
    }else if ([dict.type isEqualToString:@"6"]){
        CallPropertyVC *page = [[CallPropertyVC alloc]init];
        [self.navigationController pushViewController:page animated:YES];
        return;
    }
    if (dict.type.integerValue == 8 | dict.type.integerValue == 9 |dict.type.integerValue == 10 |dict.type.integerValue == 11 |dict.type.integerValue == 12) {
        ServiceVC *page = [[ServiceVC alloc]init];
        page.titleStr = name;
        if (!dict.ids) {
            return;
        }
        page.menuId = dict.ids;
        [self.navigationController pushViewController:page animated:YES];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
    }else{
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:controller];
        
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
