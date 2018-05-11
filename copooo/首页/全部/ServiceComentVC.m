//
//  ServiceComentVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/8.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "ServiceComentVC.h"
#import "ServiceComentView.h"
#import "ReactiveObjC/ReactiveObjC.h"

@interface ServiceComentVC ()
{
    CGFloat bottomBtnHight;
    ServiceComentView *myView;
    NSString *comentStar;
}
@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic,strong)UIButton *bottomBtn;
@end

@implementation ServiceComentVC

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
    [self.view addSubview:self.myScrollView];
    [self.view addSubview:self.bottomBtn];
    [self initView];
    // Do any additional setup after loading the view.
}
- (UIScrollView *)myScrollView{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - bottomBtnHight)];
        _myScrollView.showsVerticalScrollIndicator = NO;
    }
    return _myScrollView;
}
-(UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - bottomBtnHight, SCREENWIDTH, bottomBtnHight)];
        [_bottomBtn setBackgroundImage:[UIImage imageNamed:@"home_button1_normal"] forState:UIControlStateNormal];
        [_bottomBtn setBackgroundImage:[UIImage imageNamed:@"home_button1_press"] forState:UIControlStateHighlighted];
        [_bottomBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_bottomBtn setTitleColor:RGBA(0xffffff, 1) forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_bottomBtn addTarget:self action:@selector(submitBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}
- (void)submitBtn{
    if (!comentStar) {
        [MBProgressHUD showError:@"请选择星级"];
        return;
    }
    NSDictionary *dict = @{@"userId":[StorageUserInfromation storageUserInformation].userId,@"dataId":_myDict.ids,@"content":myView.coment.text,@"level":comentStar,@"apiv":@"1.0"};
    [ZTHttpTool postWithUrl:@"property/v1/PropertyService/evaluate" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([onceDict[@"rcode"] integerValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:onceDict[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];

    }];
}
- (void)initView{
    
    myView = [[[NSBundle mainBundle] loadNibNamed:@"ServiceComentView" owner:self options:nil] lastObject];
    if (_myDict.typeName) {
        myView.type.text = _myDict.typeName;
        myView.typeWidth.constant = [myView.type sizeThatFits:CGSizeMake(150, 21)].width + 15;
        myView.titleToLeft.constant = 8;
        myView.type.layer.cornerRadius = 3;
        myView.type.layer.masksToBounds = YES;
    }else{
        myView.type.text = @"";
        myView.typeWidth.constant = 0;
        myView.titleToLeft.constant = 0;
    }
    myView.title.text = _myDict.areaAddress;
    myView.content.text = _myDict.content;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 3; //设置行间距
    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:myView.content.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:RGBA(0x606060, 1),NSParagraphStyleAttributeName:paraStyle}];
    myView.content.attributedText = attrStr;
    
    CGFloat contentHeight = [StorageUserInfromation getStringSizeWith:_myDict.content withStringFont:14.0 withWidthOrHeight:SCREENWIDTH-24].height +10;
    myView.contentHight.constant = contentHeight;
    
    CGFloat hight = 49 + contentHeight + 10 + 330;
    myView.frame = CGRectMake(0, 0, SCREENWIDTH, hight);
    [[myView.coment.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length<=100;
    }] subscribeNext:^(NSString * _Nullable x) {
        myView.num.text = [NSString stringWithFormat:@"%ld/100",x.length];
    }] ;
    myView.comentStarBlock = ^(NSInteger integer) {
        switch (integer) {
            case 10:
            {
                comentStar = @"3";
            }
                break;
            case 20:
            {
                comentStar = @"2";
            }
                break;
            case 30:
            {
                comentStar = @"1";
            }
                break;
            default:
                break;
        }
    };
    [self.myScrollView addSubview:myView];
    self.myScrollView.contentSize = CGSizeMake(SCREENWIDTH, hight);
    
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
