//
//  FeedBackVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/2.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FeedBackVC.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "EmojiForbid.h"
@interface FeedBackVC ()<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic,strong) UITextField *feedBackTitle;
@property (nonatomic,strong) UITextView *content;
@property (nonatomic,strong) UILabel *markLabel;
@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self addSubView];
    WeakSelf
    [self.content.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        StrongSelf
        if (x.length == 0) {
            [strongSelf.content addSubview:strongSelf.markLabel];
        }else{
            [strongSelf.markLabel removeFromSuperview];
        }
    }];
    // Do any additional setup after loading the view.
}
#pragma mark -------UITextViewDelegate
-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView isFirstResponder]) {
        
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            return NO;
        }
        
        //判断键盘是不是九宫格键盘
        if ([EmojiForbid isNineKeyBoard:text] ){
            return YES;
        }else{
            if ([EmojiForbid hasEmoji:text] || [EmojiForbid stringContainsEmoji:text]){
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark -----UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isFirstResponder]) {
        
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            return NO;
        }
        
        //判断键盘是不是九宫格键盘
        if ([EmojiForbid isNineKeyBoard:string] ){
            return YES;
        }else{
            if ([EmojiForbid hasEmoji:string] || [EmojiForbid stringContainsEmoji:string]){
                return NO;
            }
        }
    }
    return YES;
}

- (void)setNav{
    self.isShowNav = YES;
    self.titleLabel.text = @"意见反馈";
    _backButton.hidden = NO;
    self.rightImgName = @"提交";
    [self.rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
}
-  (void)rightButtonClick:(UIButton *)button{
    if ([JGIsBlankString isBlankString:self.feedBackTitle.text]) {
        [MBProgressHUD showError:@"请输入反馈的标题"];
        return;
    }
    if ([JGIsBlankString isBlankString:self.content.text]) {
        [MBProgressHUD showError:@"请输入反馈的内容"];
        return;
    }
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId,@"content":self.content.text,@"title":self.feedBackTitle.text};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/setting/addFeedback" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary *onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([onceDict[@"rocde"] integerValue] == 0) {
            [MBProgressHUD showSuccess:@"反馈成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"反馈失败"];
        }
    } failure:^(NSError *error) {
        XMJLog(@"%@",error);
        [MBProgressHUD showError:@"网络异常"];

    }];
}
- (void)addSubView{
    for (int i = 0; i<2; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,NAVHEIGHT + i*50, SCREENWIDTH, 10)];
        lineView.backgroundColor = RGBA(0xeeeeee, 1);
        [self.view addSubview:lineView];
        
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, lineView.y +10, SCREENWIDTH, i == 0?40:240)];
        if (i==0){
            [myView addSubview:self.feedBackTitle];
        }else{
            [myView addSubview:self.content];
        }
        [self.view addSubview:myView];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,NAVHEIGHT + 300, SCREENWIDTH, 10)];
    lineView.backgroundColor = RGBA(0xeeeeee, 1);
    [self.view addSubview:lineView];
}
- (UITextField *)feedBackTitle{
    if (!_feedBackTitle) {
        _feedBackTitle = [[UITextField alloc]initWithFrame:CGRectMake(12, 5, SCREENWIDTH - 12*2, 30)];
        _feedBackTitle.delegate = self;
        _feedBackTitle.textColor =RGBA(0x303030, 1);
        _feedBackTitle.font = [UIFont systemFontOfSize:15.0];
        _feedBackTitle.placeholder = @"请输入您想反馈内容等主题";
    }
    return  _feedBackTitle;
}
- (UITextView *)content{
    if (!_content) {
        _content = [[UITextView alloc]initWithFrame:CGRectMake(12, 8, SCREENWIDTH - 12*2, 200)];
        _content.delegate = self;
        _content.textColor = RGBA(0x303030, 1);
        _content.font = [UIFont systemFontOfSize:15.0];
        [_content addSubview:self.markLabel];
    }
    return _content;
}
- (UILabel *)markLabel{
    if (!_markLabel) {
        _markLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 8, 250, 21)];
        _markLabel.font = [UIFont systemFontOfSize:15.0];
        _markLabel.textColor = RGBA(0x9c9c9c, 1);
        _markLabel.text = @"(必填)请输入您想发布的内容......";
    }
    return _markLabel;
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
