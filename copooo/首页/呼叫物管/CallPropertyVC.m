//
//  CallPropertyVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/20.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "CallPropertyVC.h"
#import "CallPropertyDataModel.h"
@interface CallPropertyVC ()
{
    UIScrollView *myscrollView;
}
@property (nonatomic,strong)CallPropertyForm *data;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic,strong)UIImageView *headerBackguandImg;


@end

@implementation CallPropertyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowNav = YES;
    self.navView.backgroundColor = [UIColor clearColor];
    self.lineView.hidden = YES;

//    self.isShowNav = YES;
//    _backButton.hidden = NO;
//    self.titleLabel.text = @"呼叫物管";
    myscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [self fetchData];
    // Do any additional setup after loading the view.
}
- (UIImageView *)headerBackguandImg{
    if (!_headerBackguandImg) {
        _headerBackguandImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT - 64 + 150)];
        _headerBackguandImg.image = [UIImage imageNamed:@"my_bg2"];
    }
    return _headerBackguandImg;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        CGFloat titleLabelH = 44;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelW = 60;
        CGFloat titleLabelY = NAVHEIGHT - 44;
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        [_backBtn setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)fetchData{
    NSDictionary *dict = @{@"apiv":@"1.0",@"propertyAreaId":[StorageUserInfromation storageUserInformation].choseUnitPropertyId};
    [ZTHttpTool postWithUrl:@"property/v1/propertyArea/queryPropertyAreaTelList" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        CallPropertyDataModel *data = [CallPropertyDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            _data = data.form;
            [self rebuildInterface];
        }
    } failure:^(NSError *error) {
        XMJLog(@"%@",error);
        [self.view  addSubview:self.backBtn];
    }];
}
- (void)rebuildInterface{
    
    [self.view addSubview:myscrollView];
    [self.view addSubview:self.backBtn];
    [myscrollView addSubview:self.headerBackguandImg];
    
    UIImageView *headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2.0 - 30, NAVHEIGHT - 20, 60, 60)];
    [headerImg sd_setImageWithURL:[NSURL URLWithString:_data.icon] placeholderImage:[UIImage imageNamed:@"icon_默认"]  options:SDWebImageAllowInvalidSSLCertificates];
    headerImg.layer.cornerRadius = 30;
    headerImg.layer.masksToBounds = YES;
    [myscrollView addSubview:headerImg];
    
    UILabel *propertyName = [[UILabel alloc]initWithFrame:CGRectMake(0, NAVHEIGHT -20 +60 + 10, SCREENWIDTH, 21)];
    propertyName.textColor = RGBA(0xffffff, 1);
    propertyName.font = [UIFont systemFontOfSize:15.0];
    propertyName.textAlignment = NSTextAlignmentCenter;
    propertyName.text = _data.propertyName;
    [myscrollView addSubview:propertyName];
    
    CGFloat height = NAVHEIGHT - 64 + 150 + 60;
    
    for (int i = 0;i< _data.data.count; i++) {
        CallPropertyData *dict = _data.data[i];
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, height + 150*i, SCREENWIDTH, 150)];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 21)];
        nameLabel.textColor = RGBA(0x303030, 1);
        nameLabel.font = [UIFont systemFontOfSize:16.0];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = dict.name;
        [myView addSubview:nameLabel];
        
        UILabel *phoneCall = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, SCREENWIDTH, 21)];
        phoneCall.textColor = RGBA(0x606060, 1);
        phoneCall.font = [UIFont systemFontOfSize:15.0];
        phoneCall.textAlignment = NSTextAlignmentCenter;
        phoneCall.text = [NSString stringWithFormat:@"联系电话：%@",dict.tel];
        [myView addSubview:phoneCall];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH/2.0 - 15, 70, 30, 30)];
        [btn setImage:[UIImage imageNamed:@"电话-(1)"] forState:UIControlStateNormal];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(brnClick:) forControlEvents:UIControlEventTouchUpInside];
        [myView addSubview:btn];
        [myscrollView addSubview:myView];
    }
    myscrollView.contentSize = CGSizeMake(SCREENWIDTH, height + _data.data.count * 150);
}
- (void)brnClick:(UIButton *)btn{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_data.data[btn.tag].tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
