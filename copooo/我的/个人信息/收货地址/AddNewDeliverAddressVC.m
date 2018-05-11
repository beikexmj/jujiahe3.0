//
//  AddNewDeliverAddressVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/1.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "AddNewDeliverAddressVC.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "AddressPickerView.h"

@interface AddNewDeliverAddressVC ()<AddressPickerViewDelegate,UIAlertViewDelegate>
{
    BOOL flag;
}
@property (nonatomic,strong) UITextField *name;
@property (nonatomic,strong) UITextField *phone;
@property (nonatomic,strong) UILabel *area;
@property (nonatomic,strong) UITextView *address;
@property (nonatomic,strong) UIImageView *defaultAddressImgFlag;
@property (nonatomic,strong) UILabel *markLabel;
@property (nonatomic ,strong) AddressPickerView * pickerView;

@end

@implementation AddNewDeliverAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(0xeeeeee, 1);
    flag = NO;
    [self setNav];
    [self addSubView];
   
    [self.view addSubview:self.pickerView];
    if (_deliveryAddress) {
        self.name.text = _deliveryAddress.name;
        self.phone.text = _deliveryAddress.tel;
        self.area.text = _deliveryAddress.location;
        self.address.text = _deliveryAddress.address;
        if (_deliveryAddress.prefer == 0) {
            flag = NO;
        }else{
            flag = YES;
        }
        if (flag) {
            _defaultAddressImgFlag.image = [UIImage imageNamed:@"life_icon_choice"];
        }else{
            _defaultAddressImgFlag.image = [UIImage imageNamed:@"icon_unchoice_gray"];
        }
    }
    WeakSelf
    [self.address.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        StrongSelf
        if (x.length == 0) {
            [strongSelf.address addSubview:strongSelf.markLabel];
        }else{
            [strongSelf.markLabel removeFromSuperview];
        }
    }];
    
    [self.name.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        StrongSelf
        if (x.length > 50) {
            strongSelf.name.text= [x substringToIndex:50];
            [MBProgressHUD showError:@"收货人名称不能超过50位字符"];
        }
    } ];
    [self.phone.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        StrongSelf
        if (x.length > 11) {
            strongSelf.phone.text= [x substringToIndex:11];
            [MBProgressHUD showError:@"联系方式不能超过11位数"];
        }
    } ];
    // Do any additional setup after loading the view.
}
- (void)setNav{
    self.isShowNav = YES;
    _backButton.hidden = YES;
    self.leftImgName = @"icon_back_gray";
    self.titleLabel.text = @"新增收货地址";
    self.rightImgName = @"保存";
    [self.rightButton setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
}
- (void)leftButtonClick:(UIButton *)button{
    if (![JGIsBlankString isBlankString:self.name.text] | ![JGIsBlankString isBlankString:self.phone.text] | ![self.area.text isEqualToString:@"请选择"] | ![JGIsBlankString isBlankString:self.address.text]) {
        [[[UIAlertView alloc]initWithTitle:@"你有未编辑完的信息" message:@"确定退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)rightButtonClick:(UIButton *)button{
    if ([JGIsBlankString isBlankString:self.name.text]) {
        [MBProgressHUD showError:@"请输入收货人名"];
        return;
    }
    if ([JGIsBlankString isBlankString:self.phone.text]) {
        [MBProgressHUD showError:@"请输入联系方式"];
        return;
    }
    if ([self.area.text isEqualToString:@"请选择"]) {
        [MBProgressHUD showError:@"请选择地区"];
        return;
    }
    if ([JGIsBlankString isBlankString:self.address.text]) {
        [MBProgressHUD showError:@"请输入详细地址"];
        return;
    }
    if (self.address.text.length<5) {
        [MBProgressHUD showError:@"详细地址不能少于5个字"];
        return;
    }
    [MBProgressHUD showMessage:@""];
    NSString *url = @"jujiaheuser/v1/shippingAddr/add";
    if (_deliveryAddress) {
        url = @"jujiaheuser/v1/shippingAddr/modify";
    }
    NSDictionary  *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId,@"id":_deliveryAddress.ids?_deliveryAddress.ids:@"",@"name":self.name.text,@"tel":self.phone.text,@"location":self.area.text,@"address":self.address.text,@"prefer":flag?@"1":@"0"};
    [ZTHttpTool postWithUrl:url param:dict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary *onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([onceDict[@"rcode"] integerValue] == 0) {
            [MBProgressHUD showSuccess:onceDict[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        XMJLog(@"%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
    }];
}
- (void)addSubView{
    for (int i = 0; i<3; i++) {
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + i*50, SCREENWIDTH, 50)];
        myView.backgroundColor =RGBA(0xffffff, 1);
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREENWIDTH, 1)];
        lineView.backgroundColor = RGBA(0xeeeeee, 1);
        [myView addSubview:lineView];
        
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 50)];
        typeLabel.textColor = RGBA(0x606060, 1);
        typeLabel.text = @[@"收货人",@"联系方式",@"所在地区"][i];
        typeLabel.font = [UIFont systemFontOfSize:15.0];
        [myView addSubview:typeLabel];
        if (i == 0) {
            [myView addSubview:self.name];
        }else if (i == 1){
            [myView addSubview:self.phone];
        }else if (i == 2){
            [myView addSubview:self.area];
        }
        if (i == 2) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 12 - 6, 25 -5, 6, 10)];
            imageView.image = [UIImage imageNamed:@"icon_more2"];
            [myView addSubview:imageView];
            
            UIButton *areaBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
            [areaBtn addTarget:self action:@selector(areaChoseBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [myView addSubview:areaBtn];
        }
        [self.view addSubview:myView];
    }
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + 3*50, SCREENWIDTH, 100)];
    addressView.backgroundColor =RGBA(0xffffff, 1);

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 99, SCREENWIDTH, 1)];
    lineView.backgroundColor = RGBA(0xeeeeee, 1);
    [addressView addSubview:lineView];
    
    [addressView addSubview:self.address];
    [self.view addSubview:addressView];
    
    UIView *defaultAddressSetView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + 3*50 + 100 +10, SCREENWIDTH, 50)];
    defaultAddressSetView.backgroundColor =RGBA(0xffffff, 1);

    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREENWIDTH, 1)];
    lineView2.backgroundColor = RGBA(0xeeeeee, 1);
    [defaultAddressSetView addSubview:lineView2];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 150, 50)];
    typeLabel.textColor = RGBA(0x606060, 1);
    typeLabel.text = @"设为默认收货地址";
    typeLabel.font = [UIFont systemFontOfSize:15.0];
    [defaultAddressSetView addSubview:typeLabel];
    [defaultAddressSetView addSubview:self.defaultAddressImgFlag];
    
    UIButton *defaultAddressSetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    [defaultAddressSetBtn addTarget:self action:@selector(defaultAddressSetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [defaultAddressSetView addSubview:defaultAddressSetBtn];
    [self.view addSubview:defaultAddressSetView];
}
- (void)defaultAddressSetBtnClick{
    if (!flag) {
        _defaultAddressImgFlag.image = [UIImage imageNamed:@"life_icon_choice"];
    }else{
        _defaultAddressImgFlag.image = [UIImage imageNamed:@"icon_unchoice_gray"];
    }
    flag = !flag;
}
- (void)areaChoseBtnClick{
    [self.phone resignFirstResponder];
    [self.name resignFirstResponder];
    [self.address resignFirstResponder];
    [self.pickerView show];
}
- (AddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc]init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:40 pickerViewHeight:165];
        // 关闭默认支持打开上次的结果
        //        _pickerView.isAutoOpenLast = NO;
    }
    return _pickerView;
}
#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
    NSLog(@"点击了取消按钮");
    [self.pickerView hide];
    
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    self.area.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
    [self.pickerView hide];
}
- (UITextField *)name{
    if (!_name) {
        _name = [[UITextField alloc]initWithFrame:CGRectMake(100 + 12, 0, SCREENWIDTH -  12*2 - 100, 50)];
        _name.font = [UIFont systemFontOfSize:15.0];
        _name.textColor = RGBA(0x303030, 1);
        _name.textAlignment = NSTextAlignmentRight;
    }
    return _name;
}
- (UITextField *)phone{
    if (!_phone) {
        _phone = [[UITextField alloc]initWithFrame:CGRectMake(100 + 12, 0, SCREENWIDTH -  12*2 - 100, 50)];
        _phone.font = [UIFont systemFontOfSize:15.0];
        _phone.textColor = RGBA(0x303030, 1);
        _phone.keyboardType = UIKeyboardTypeNumberPad;
        _phone.textAlignment = NSTextAlignmentRight;
    }
    return _phone;
}
- (UILabel *)area{
    if (!_area) {
        _area = [[UILabel alloc]initWithFrame:CGRectMake(100 + 12, 0, SCREENWIDTH -  12*2 - 100 - 18, 50)];
        _area.font = [UIFont systemFontOfSize:15.0];
        _area.textColor = RGBA(0x9c9c9c, 1);
        _area.textAlignment = NSTextAlignmentRight;
        _area.text = @"请选择";
    }
    return _area;
}
- (UITextView *)address{
    if (!_address) {
        _address = [[UITextView alloc]initWithFrame:CGRectMake(12, 8, SCREENWIDTH - 12*2, 100-12*2)];
        _address.font = [UIFont systemFontOfSize:15.0];
        _address.textColor = RGBA(0x303030, 1);
    }
    return _address;
}
- (UILabel *)markLabel{
    if (!_markLabel) {
        _markLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 8, 250, 21)];
        _markLabel.font = [UIFont systemFontOfSize:15.0];
        _markLabel.textColor = RGBA(0x9c9c9c, 1);
        _markLabel.text = @"请输入详细地址，不少于5个字";
    }
    return _markLabel;
}
- (UIImageView *)defaultAddressImgFlag{
    if (!_defaultAddressImgFlag) {
        _defaultAddressImgFlag = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 12 - 15, 25 -7.5, 15, 15)];
        _defaultAddressImgFlag.image = [UIImage imageNamed:@"icon_unchoice_gray"];
    }
    return _defaultAddressImgFlag;
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
