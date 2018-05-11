//
//  PersonalInformationViewController.m
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "PersonalInformationTableViewCell2.h"
#import "ModifyNickNameViewController.h"
#import "ModifyPhoneNumViewController.h"
#import "ModifyEmailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MyQRCodeViewController.h"
#import "HooDatePicker.h"
#import "DeliveryAddressVC.h"
@interface PersonalInformationViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HooDatePickerDelegate>
{
    PersonalInformationTableViewCell2 *sexChoseCell;
    PersonalInformationTableViewCell2 *headerImgCell;
    PersonalInformationTableViewCell2 *birthdayChoseCell;


}
@property (nonatomic,strong)UIActionSheet *actionSheet;
@property (nonatomic,strong)HooDatePicker *datePicker;

@end

@implementation PersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+24;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    [self datePickerInit];
    // Do any additional setup after loading the view from its nib.
}
-(void)datePickerInit{
    self.datePicker = [[HooDatePicker alloc] initWithSuperView:self.view];
    self.datePicker.delegate = self;
    self.datePicker.datePickerMode = HooDatePickerModeDate;
    self.datePicker.title = @"请选择日期";
    NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
    [dateFormatter setDateFormat:kDateFormatYYYYMMDD];
    NSDate *maxDate = [NSDate date];
    NSDate *date = [NSDate date];
    if (![JGIsBlankString isBlankString:[StorageUserInfromation storageUserInformation].birthday ]) {
        date = [dateFormatter dateFromString:[StorageUserInfromation storageUserInformation].birthday];
    }
    NSDate *minDate = [dateFormatter dateFromString:@"1900-01-01"];
    
    [self.datePicker setDate:date animated:YES];
    self.datePicker.minimumDate = minDate;
    self.datePicker.maximumDate = maxDate;
}
- (void)datePicker:(HooDatePicker *)datePicker didSelectedDate:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == HooDatePickerModeDate) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    } else if (datePicker.datePickerMode == HooDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else if (datePicker.datePickerMode == HooDatePickerModeYearAndMonth){
        [dateFormatter setDateFormat:@"yyyy年MM月"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    NSString *selectDate = [dateFormatter stringFromDate:date];
    [self setBirthday:selectDate];
    NSLog(@"selectDate:%@",selectDate);
    
    
}
- (void)setBirthday:(NSString *)birthday{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"passwordType":@"1",@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"birthday":birthday};
    [ZTHttpTool postWithUrl:@"uaa/v1/modify" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD showSuccess:[DictToJson dictionaryWithJsonString:str][@"msg"]];
        if ([[DictToJson dictionaryWithJsonString:str][@"rcode"] integerValue] == 0) {
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
            StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
            storage.birthday = birthday;
            [NSKeyedArchiver archiveRootObject:storage toFile:file];
            birthdayChoseCell.nameStr.text = birthday;
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    

}
-(void)viewWillAppear:(BOOL)animated{
    [self.myTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - tableView 代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"PersonalInformationTableViewCell2";
    PersonalInformationTableViewCell2 * cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:myCell owner:self options:nil] lastObject];
    }
    cell.headerImg.hidden = YES;
    cell.sexChoseView.hidden = YES;
    cell.nameStr.hidden = NO;
    cell.nextImg.hidden = NO;
    cell.headerImgWidth.constant = 44;
    cell.headerImgHeight.constant = 44;
    cell.headerImg.layer.cornerRadius = 0;
   StorageUserInfromation * storage =[StorageUserInfromation storageUserInformation];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.regimentationLabel.text = @"头像";
            cell.headerImg.hidden = NO;
            cell.headerImg.layer.cornerRadius = 22;
            cell.headerImg.layer.masksToBounds = YES;
            cell.headerImg.contentMode = UIViewContentModeScaleAspectFill;
            cell.nameStr.hidden = YES;
            headerImgCell = cell;
            NSString * str = [NSString stringWithFormat:@"%@/%@%@",BASE_URL,@"uaa/v1/getAvatar?userId=",[StorageUserInfromation storageUserInformation].userId];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str] options:NSDataReadingUncached error:nil];
                if (data.length) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        cell.headerImg.image = [UIImage imageWithData:data];
                    });
                }
            });
            
        }else if (indexPath.row == 1) {
            cell.regimentationLabel.text = @"昵称";
            cell.nameStr.text = storage.nickname;
        }else if (indexPath.row == 2){
            birthdayChoseCell = cell;
            cell.regimentationLabel.text = @"生日";
            cell.nameStr.text = storage.birthday;
        }else if (indexPath.row == 3){
            cell.regimentationLabel.text = @"性别";
            cell.nameStr.hidden = YES;
            cell.sexChoseView.hidden = NO;
            sexChoseCell  = cell;
            [cell.menBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.womenBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self sexSet];
        }else if(indexPath.row == 4){
            cell.regimentationLabel.text = @"手机号码";
            cell.nameStr.text = [NSString stringWithFormat:@"%@****%@",[storage.username substringToIndex:3],[storage.username substringFromIndex:7]];
        }else if (indexPath.row == 5){
            cell.regimentationLabel.text = @"邮箱";
            cell.nameStr.text = storage.email;
            
        }
//        else if (indexPath.row == 6){
//            cell.regimentationLabel.text = @"我的二维码";
//            cell.headerImgWidth.constant = 15;
//            cell.headerImgHeight.constant = 15;
//            cell.headerImg.hidden = NO;
//            cell.nameStr.hidden = YES;
//            cell.headerImg.image = [UIImage imageNamed:@"per_二维码1"];
//        }
        else if (indexPath.row == 6){
            cell.regimentationLabel.text = @"我的邀请码";
            cell.nameStr.text = storage.invitationCode;
            cell.nextImg.hidden = YES;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.regimentationLabel.text = @"收货地址";
            cell.nameStr.text = @"";

        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 60;
    }
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self callActionSheetFunc];
        }else if (indexPath.row == 1) {
            PersonalInformationTableViewCell2 * cell = [tableView cellForRowAtIndexPath:indexPath];
            ModifyNickNameViewController *page = [[ModifyNickNameViewController alloc]init:cell.nameStr.text];
            [self.navigationController pushViewController:page animated:YES];
        }else if (indexPath.row == 2){
            [self choseBirthday];
        }else if (indexPath.row == 3){
            
        }else if (indexPath.row == 4){
            ModifyPhoneNumViewController *page = [[ModifyPhoneNumViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }else if (indexPath.row == 5){
            ModifyEmailViewController *page = [[ModifyEmailViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }
//        else if (indexPath.row == 6){
//            MyQRCodeViewController * page = [[MyQRCodeViewController alloc]init];
//            [self.navigationController pushViewController:page animated:YES];
//        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            DeliveryAddressVC *page = [[DeliveryAddressVC alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    footerView.backgroundColor = RGBA(0xeeeeee, 1);
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (void)choseBirthday{
    [self.datePicker show];
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)sexBtnClick:(UIButton *)btn{
    sexChoseCell.menImg.image = [UIImage imageNamed:@"per_massage_circle1"];
    sexChoseCell.womenImg.image = [UIImage imageNamed:@"per_massage_circle1"];
    [sexChoseCell.menLabel setTextColor:RGBCOLOR(96, 96, 96)];
    [sexChoseCell.womenLabel setTextColor:RGBCOLOR(96, 96, 96)];

    switch (btn.tag) {
        case 10:
        {
            sexChoseCell.menImg.image = [UIImage imageNamed:@"my_circle_choice"];
            sexChoseCell.womenImg.image = [UIImage imageNamed:@"my_circle_unchoice"];
            [sexChoseCell.menLabel setTextColor:RGBCOLOR(0, 167, 255)];
            [StorageUserInfromation storageUserInformation].sex = @"0";
            [self userSexModify:@"0"];
        }
            break;
        case 20:
        {
            sexChoseCell.womenImg.image = [UIImage imageNamed:@"my_circle_choice"];
            sexChoseCell.menImg.image = [UIImage imageNamed:@"my_circle_unchoice"];

            [sexChoseCell.womenLabel setTextColor:RGBCOLOR(0, 167, 255)];
            [StorageUserInfromation storageUserInformation].sex = @"1";
            [self userSexModify:@"1"];
        }
            break;
        default:
            break;
    }
    
    
}

- (void)userSexModify:(NSString *)sexFlagStr{
    [MBProgressHUD showMessage:@"修改中..."];
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"sex":sexFlagStr};
    
    [ZTHttpTool postWithUrl:@"uaa/v1/modify" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary *dict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",dict);
        if ([dict[@"rcode"] integerValue] ==0) {
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
            StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
            storage.sex = sexFlagStr;
            [NSKeyedArchiver archiveRootObject:storage toFile:file];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReplaceSex" object:nil];

        }
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
        
    }];

}

- (void)headerImgTapClick:(UIGestureRecognizer *)tap{
    [self callActionSheetFunc];
}

- (void)callActionSheetFunc{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }else{
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    return;
            }
        }
        else {
            if (buttonIndex == 1) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self resetImg:image];
}
- (void)resetImg:(UIImage*)image{
    [MBProgressHUD showMessage:@"头像上传中..."];
    NSDictionary *dict = @{@"userId":[StorageUserInfromation storageUserInformation].userId};
    [ZTHttpTool postWithImageUrl:@"uaa/v1/upload/avatar" param:dict postImageArr:@[@[image],@[@"file"]] mimeType:@"image/png" success:^(id responseObj) {
        NSLog(@"responseObj==%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        headerImgCell.headerImg.image = image;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReplaceHeaderImg" object:nil];
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        NSLog(@"error==%@",error);
        [MBProgressHUD hideHUD];
    }];
}

- (void)sexSet{
    if ([StorageUserInfromation storageUserInformation].sex.integerValue == -1) {
        sexChoseCell.menImg.image = [UIImage imageNamed:@"my_circle_unchoice"];
        sexChoseCell.womenImg.image = [UIImage imageNamed:@"my_circle_unchoice"];
        [sexChoseCell.menLabel setTextColor:RGBCOLOR(96, 96, 96)];
        [sexChoseCell.womenLabel setTextColor:RGBCOLOR(96, 96, 96)];
    }else if ([StorageUserInfromation storageUserInformation].sex.integerValue == 0){
        sexChoseCell.womenImg.image = [UIImage imageNamed:@"my_circle_unchoice"];
        [sexChoseCell.womenLabel setTextColor:RGBCOLOR(96, 96, 96)];
        sexChoseCell.menImg.image = [UIImage imageNamed:@"my_circle_choice"];
        [sexChoseCell.menLabel setTextColor:RGBCOLOR(0, 167, 255)];
    }else{
        sexChoseCell.menImg.image = [UIImage imageNamed:@"my_circle_unchoice"];
        [sexChoseCell.menLabel setTextColor:RGBCOLOR(96, 96, 96)];
        sexChoseCell.womenImg.image = [UIImage imageNamed:@"my_circle_choice"];
        [sexChoseCell.womenLabel setTextColor:RGBCOLOR(0, 167, 255)];
    }
}

@end
