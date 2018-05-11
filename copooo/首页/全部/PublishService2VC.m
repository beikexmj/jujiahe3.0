//
//  PublishService2VC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/9.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PublishService2VC.h"
#import "PropertyPaymentHomeVC.h"

@interface PublishService2VC ()
{
    CGFloat bottomBtnHight;

}
/** 房号选择View*/
@property(nonatomic, strong)    UIView *roomSelectView;

@property(nonatomic, strong)    UIButton *publishBtn;

@property(nonatomic, strong)    UIScrollView *myScrollView;
@end

@implementation PublishService2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowNav = YES;
    _backButton.hidden = NO;
    //    self.leftImgName = @"icon_back_gray";
    if (_titleStr) {
        self.titleLabel.text = _titleStr;
    }
    self.navView.backgroundColor = RGBA(0xeeeeee, 1);
    bottomBtnHight = TABBARHEIGHT;
    self.view.backgroundColor = RGBA(0xeeeeee, 1);
    [self.view addSubview:self.publishBtn];
    [self.view addSubview:self.roomSelectView];
    [self.view addSubview:self.myScrollView];
    [self initSubView];
    // Do any additional setup after loading the view.
}
- (UIScrollView *)myScrollView{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + 50, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - bottomBtnHight - 50)];
        _myScrollView.showsVerticalScrollIndicator = NO;
    }
    return _myScrollView;
}
- (UIView *)roomSelectView{
    if (!_roomSelectView) {
        _roomSelectView  = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, 50)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, 120, 30)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = RGBA(0x9c9c9c, 1);
        label.text = @"请选择房号";
        [_roomSelectView addSubview:label];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 8 - 12, 12, 8, 16)];
        image.image = [UIImage imageNamed:@"icon_more2"];
        [_roomSelectView addSubview:image];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 1)];
        lineView.backgroundColor =RGBA(0xdbdbdb, 1);
        [_roomSelectView addSubview:lineView];
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 10)];
        lineView2.backgroundColor = RGBA(0xeeeeee, 1);
        [_roomSelectView addSubview:lineView2];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
        [btn addTarget:self action:@selector(roomSelectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_roomSelectView addSubview:btn];
        
    }
    return _roomSelectView;
}
- (void)initSubView{
    UIView *myView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 135)];
}
- (void)roomSelectBtnClick{
    PropertyPaymentHomeVC *page = [[PropertyPaymentHomeVC alloc]init];
    page.titleStr = @"选择房号";
    [self.navigationController pushViewController:page animated:YES];
}
-(UIButton *)publishBtn{
    if (!_publishBtn) {
        _publishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - bottomBtnHight, SCREENWIDTH, bottomBtnHight)];
        [_publishBtn setBackgroundImage:[UIImage imageNamed:@"home_button1_normal"] forState:UIControlStateNormal];
        [_publishBtn setBackgroundImage:[UIImage imageNamed:@"home_button1_press"] forState:UIControlStateHighlighted];
        [_publishBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_publishBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_publishBtn setTitleColor:RGBA(0xffffff, 1) forState:UIControlStateNormal];
        [_publishBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_publishBtn addTarget:self action:@selector(pulishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBtn;
}
- (void)pulishBtnClick:(UIButton *)btn{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[StorageUserInfromation storageUserInformation].userId forKey:@"userId"];
    
//    if (onceDict) {
//        [dict addEntriesFromDictionary:onceDict];
//        [dict setValue:@"2" forKey:@"type"];
//
//    }else{
//        if ([JGIsBlankString isBlankString:_inputV.textV.text]) {
//            [MBProgressHUD showError:@"内容不能为空"];
//            _publishBtn.enabled = YES;
//            return;
//        }
//        [dict setValue:@"1" forKey:@"type"];
//    }
//    [dict setValue:_inputV.textV.text forKey:@"content"];
    
    [ZTHttpTool postWithUrl:@"social/post/addPost" param:dict success:^(id responseObj) {
        _publishBtn.enabled = YES;
        
        NSLog(@"%@",responseObj);
        NSLog(@"responseObj==%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSDictionary *dict = [DictToJson dictionaryWithJsonString:str];
        if ([dict[@"rcode"] integerValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:dict[@"rocde"]];
        }
    } failure:^(NSError *error) {
        _publishBtn.enabled = YES;
        
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
