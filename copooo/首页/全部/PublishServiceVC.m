//
//  PublishServiceVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/8.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PublishServiceVC.h"
#import "HJInputView.h"
#import "HJTableViewCell.h"
#import "HJPhotoPickerView.h"
#import "TZImagePickerController.h"
#import "HJEditImageViewController.h"
#import "PropertyPaymentHomeVC.h"
#import "ReactiveObjC/ReactiveObjC.h"
//#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "ACMediaModel.h"
#import "ACMediaManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
//#import "FMFileVideoController.h"
#import "TZVideoPlayerController.h"
#import "TZAssetModel.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PropertyServiceTagDataModel.h"
#define IMAGE_SIZE (SCREEN_WIDTH - 60)/4
typedef void(^Result)(NSData *fileData, NSString *fileName);
@interface PublishServiceVC ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSMutableArray *imageArr;//上传的图片数组；
    CGFloat bottomBtnHight;
    NSMutableArray *typeArr;
    NSString *propertyServiceId;//菜单服务类型id,标签id
    NSString *propertyHouseId;//房号id
}
/** 文本输入框*/
@property(nonatomic, strong)    HJInputView *inputV;
/** UITableView*/
@property(nonatomic, strong)    UITableView *tabelV;
/** 选择图片*/
@property(nonatomic, strong)    HJPhotoPickerView *photoPickerV;
/** 图片编辑起*/
@property(nonatomic, strong)    HJEditImageViewController *editVC;
/** 当前选择的图片*/
@property(nonatomic, strong)    NSMutableArray *imageDataSource;
/** 开关评论*/
@property(nonatomic, strong)    UISwitch *commentSwitch;
/**  文字长度*/
@property(nonatomic, strong)    UILabel *textNumLabel;
/**   说明（必填）*/
@property(nonatomic, strong)    UILabel *textInfo;
/**   图片说明（选填） */
@property(nonatomic, strong)    UILabel *picInfo;
/**   图片张数 */
@property(nonatomic, strong)    UILabel *picNum;
/** 线条*/
@property(nonatomic, strong)    UIView *lineView2;
/** 房号选择View*/
@property(nonatomic, strong)    UIView *roomSelectView;
/** 房号*/
@property(nonatomic, strong)    UILabel *houseName;
/** 服务类型View*/
@property(nonatomic, strong)    UIView *serviceTypeOrNumView;
/** 视频asset*/
@property(nonatomic, strong)   id asset;
/** 视频array*/
@property(nonatomic, strong)    NSMutableArray *mediaArray;
/** 图片array*/
@property(nonatomic, strong)    NSMutableArray *photos;
@property(nonatomic, strong)    UIButton *publishBtn;
@property(nonatomic, strong)    NSArray <PropertyServiceTagArr *> *propertyServiceTagArr;
@end

@implementation PublishServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowNav = YES;
    _backButton.hidden = YES;
    self.leftImgName = @"icon_back_gray";
    if (_titleStr) {
        self.titleLabel.text = _titleStr;
    }
    self.navView.backgroundColor = RGBA(0xeeeeee, 1);
    _mediaArray = [NSMutableArray array];
    _photos = [NSMutableArray array];
    typeArr = [NSMutableArray array];
    _propertyServiceTagArr = [NSArray array];
    bottomBtnHight = TABBARHEIGHT;
    [self.view addSubview:self.publishBtn];
    [self.view addSubview:self.roomSelectView];
    [self fetchServiceTag];
    // Do any additional setup after loading the view from its nib.
}
- (void)fetchServiceTag{
    NSDictionary *dict = @{@"userId":[StorageUserInfromation storageUserInformation].userId,@"menuId":_menuId,@"apiv":@"1.0"
                           };
    [ZTHttpTool postWithUrl:@"property/v1/PropertyService/queryServiceTag" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        PropertyServiceTagDataModel *data = [PropertyServiceTagDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            _propertyServiceTagArr = data.form;
            [self viewConfig];
        }
    } failure:^(NSError *error) {
        XMJLog(@"%@",error);
        
    }];
}
- (UIView *)roomSelectView{
    if (!_roomSelectView) {
        _roomSelectView  = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, 50)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, SCREENWIDTH - 35, 30)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = RGBA(0x9c9c9c, 1);
        label.text = @"请选择房号";
        [_roomSelectView addSubview:label];
        _houseName = label;
        
//        _houseName = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, SCREENWIDTH - 128, 30)];
//        _houseName.font = [UIFont systemFontOfSize:14.0];
//        _houseName.textColor = RGBA(0x606060, 1);
//        _houseName.textAlignment = NSTextAlignmentRight;
//        [_roomSelectView addSubview:_houseName];
        
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
- (void)roomSelectBtnClick{
    PropertyPaymentHomeVC *page = [[PropertyPaymentHomeVC alloc]init];
    page.titleStr = @"选择房号";
    page.propertyHouseChoseBlock = ^(NSString *name, NSString *propertyHouseIds) {
        _houseName.text = name;
        propertyHouseId = propertyHouseIds;
        _houseName.textColor =  RGBA(0x606060, 1);
    };
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
// 为图片添加点击事件
- (void)addTargetForImage{
    for (UIButton * button in _photoPickerV.imageViews) {
        [button addTarget:self action:@selector(addPhotos:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)serviceTypeChoseBtn:(UIButton *)sender{
    for (UIButton *btn in _serviceTypeOrNumView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
            [btn setBackgroundColor:RGBA(0xf2f2f2, 1)];
            btn.layer.borderWidth = 1;
        }
    }
    [sender setTitleColor:RGBA(0xffffff, 1) forState:UIControlStateNormal];
    [sender setBackgroundColor:RGBA(0x00a7ff, 1)];
    sender.layer.borderWidth = 0;
    
    propertyServiceId = _propertyServiceTagArr[sender.tag - 6].ids;
    
}
- (void)viewConfig{
    __weak typeof(self) weakSelf = self;
    
    
    for (PropertyServiceTagArr *dict in _propertyServiceTagArr ) {
        [typeArr addObject:dict.name];
    }
//    typeArr = @[@"设备维护",@"墙面地",@"园区绿化",@"园区保洁",@"其他"];
    
    CGFloat height = 0;
    if (typeArr.count>0) {
        height = 30 + (typeArr.count/3 +(typeArr.count%3 == 0?0:1))*45 + 15 +10;
    }
    _serviceTypeOrNumView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, height)];
    _serviceTypeOrNumView.clipsToBounds = YES;
    UILabel *typeHeader = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 200, 30)];
    typeHeader.font = [UIFont systemFontOfSize:14.0];
    typeHeader.textColor = RGBA(0x9c9c9c, 1);
    typeHeader.text = @"请选择服务类型";
    [_serviceTypeOrNumView addSubview:typeHeader];
    
    UIView *typeLineView = [[UIView alloc]initWithFrame:CGRectMake(12, 30, SCREENWIDTH - 24 , 1)];
    typeLineView.backgroundColor = RGBA(0xeeeeee, 1);
    [_serviceTypeOrNumView addSubview:typeLineView];
    
    UIView *typeLineView2 =  [[UIView alloc]initWithFrame:CGRectMake(0, height-10, SCREENWIDTH, 10)];
    typeLineView2.backgroundColor = RGBA(0xeeeeee, 1);
    [_serviceTypeOrNumView addSubview:typeLineView2];
    CGFloat yy = 45;
    for (int i = 0; i<typeArr.count/3 +(typeArr.count%3 == 0?0:1); i++) {
        for (int j =0; j<3; j++) {
            if (i*3 + (j+1)>typeArr.count) {
                continue;
            }
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12 + (SCREENWIDTH - 80 - 24)/2.0 *j, yy + i*45, 80, 30)];
            btn.tag = i*3 + (j+1) +5;
            [btn setTitle:_propertyServiceTagArr[i*3+j].name forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [btn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
            [btn setBackgroundColor:RGBA(0xf2f2f2, 1)];
            
//            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//            [gradientLayer setBounds:btn.bounds];
//            NSArray *colors = [NSArray arrayWithObjects:
//                               (id)RGBA(0xf2f2f2, 1).CGColor, // top
//                               (id)RGBA(0xf2f2f2, 1).CGColor, // bottom
//                               nil];
//
//            [gradientLayer setPosition:CGPointMake([btn bounds].size.width / 2, [btn bounds].size.height / 2)];
//            [gradientLayer setColors:colors];
//            [btn.layer insertSublayer:gradientLayer atIndex:0];
            btn.layer.cornerRadius = 15.0;
            btn.layer.borderColor = RGBA(0xdddddd, 1).CGColor;
            btn.layer.borderWidth = 1;
            [_serviceTypeOrNumView addSubview:btn];
            [btn addTarget:self action:@selector(serviceTypeChoseBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    // 初始化输入视图 高度 = 150
    _inputV = [[HJInputView alloc]initWithFrame:CGRectMake(0, height, SCREENWIDTH, 150)];
    _inputV.textV.font = [UIFont systemFontOfSize:15.0];
    _inputV.textV.delegate = self;
    
    //文字数量
    _textNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 132, height + 5, 120, 20)];
    _textNumLabel.textAlignment = NSTextAlignmentRight;
    _textNumLabel.font = [UIFont systemFontOfSize:13];
    [_textNumLabel setTextColor:RGBCOLOR(192, 192, 192)];
    _textNumLabel.text = @"0/1000";
    
    //说明（必填）
    _textInfo = [[UILabel alloc]initWithFrame:CGRectMake(12, height + 5, 150, 20)];
    _textInfo.font = [UIFont systemFontOfSize:14];
    [_textInfo setTextColor:RGBCOLOR(192, 192, 192)];
    _textInfo.text = @"说明（必填）";
    
    [[_inputV.textV.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length<=1000;
    }] subscribeNext:^(NSString * _Nullable x) {
        if (x.length) {
            [_inputV.placeholerLabel removeFromSuperview];
            UITextRange *selectedRange = [_inputV.textV markedTextRange];
            NSString * newText = [_inputV.textV textInRange:selectedRange]; //获取高亮部分
            if(newText.length>0)
                return;
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 3;// 字体的行间距
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle};
            _inputV.textV.attributedText = [[NSAttributedString alloc] initWithString:_inputV.textV.text attributes:attributes];
        
        }else{
            [_inputV.textV addSubview:_inputV.placeholerLabel];
        }
        _textNumLabel.text = [NSString stringWithFormat:@"%ld/1000",x.length];
        
    }] ;
    //线条
    _lineView2 = [[UIView alloc]initWithFrame:CGRectMake(14,height + 150, SCREENWIDTH -28, 1)];
    _lineView2.backgroundColor = RGBCOLOR(221, 221, 221);
    
    //图片说明（选填）
    _picInfo = [[UILabel alloc]initWithFrame:CGRectMake(12, height + 155, 150, 20)];
    _picInfo.font = [UIFont systemFontOfSize:14];
    [_picInfo setTextColor:RGBCOLOR(192, 192, 192)];
    _picInfo.text = @"图片说明（选填）";
    //图片张数
    _picNum = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 162,height + 155, 150, 20)];
    _picNum.font = [UIFont systemFontOfSize:14];
    [_picNum setTextColor:RGBCOLOR(192, 192, 192)];
    _picNum.textAlignment = NSTextAlignmentRight;
    _picNum.text = @"0/9张";
    
    // 图片选择视图
    _photoPickerV = [[HJPhotoPickerView alloc]init];
    _photoPickerV.frame = CGRectMake(0,  height + 155 +30, SCREENWIDTH, IMAGE_SIZE +10);
    _photoPickerV.deleteButton.hidden = YES;
    _photoPickerV.videoImageView.hidden = YES;
    _photoPickerV.reloadTableViewBlock = ^{
        [weakSelf.tabelV reloadData];
    };
    _photoPickerV.ACMediaClickDeleteButton = ^{
        [weakSelf.imageDataSource removeAllObjects];
        _asset = nil;
        [weakSelf.imageDataSource addObject:weakSelf.photoPickerV.addImage];
        [weakSelf.photoPickerV setSelectedImages:weakSelf.imageDataSource];
        [weakSelf addTargetForImage];
        [weakSelf.tabelV reloadData];
        
    };
    [self addTargetForImage];
    
    // 初始化图片数组
    _imageDataSource = [NSMutableArray array];
    [_imageDataSource addObject:_photoPickerV.addImage];
    
    // 初始化图片编辑控制器
    self.editVC = [[HJEditImageViewController alloc]init];
    
    _tabelV = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + 50, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - 50 - bottomBtnHight+10) style:UITableViewStylePlain];
    _tabelV.backgroundColor = RGBA(0xeeeeee, 1);
    _tabelV.delegate = self;
    _tabelV.dataSource = self;
//    _tabelV.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, CGFLOAT_MIN)];
//    _tabelV.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, CGFLOAT_MIN)];
    _tabelV.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tabelV];
    
    _commentSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    _commentSwitch.center = CGPointMake(SCREENWIDTH - 44, 22);
    _commentSwitch.on = YES;
}

- (void)addPhotos:(UIButton *)button{
    
    
    if ([button.currentBackgroundImage isEqual:_photoPickerV.addImage]) {
        
        if (_publishType == PUBLISH_PHOTOANDTEXT) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册选择", nil];
            [actionSheet showInView:self.view];
        }else if (_publishType == PUBLISH_VIDEO){
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"摄影",@"视频选择", nil];
            [actionSheet showInView:self.view];
        }
        
    }else{
        if (_publishType == PUBLISH_VIDEO) {
            ACMediaModel *onceModel = _mediaArray[0];
            TZAssetModel *model = [TZAssetModel modelWithAsset:onceModel.asset type:TZAssetModelMediaTypeVideo];
            
            TZVideoPlayerController *videoPlayerVc = [[TZVideoPlayerController alloc] init];
            videoPlayerVc.model = model;
            videoPlayerVc.conFromFlag = 1;
            [self.navigationController pushViewController:videoPlayerVc animated:YES];
            
        }else{
            __weak typeof(self) weakSelf = self;
            
            _editVC = [[HJEditImageViewController alloc]init];
            _editVC.currentOffset = (int)button.tag;
            _editVC.reloadBlock = ^(NSMutableArray * images){
                weakSelf.photoPickerV.photoNum = 10;
                [weakSelf.photoPickerV setSelectedImages:images];
                [weakSelf addTargetForImage];
                [weakSelf.tabelV reloadData];
            };
            _editVC.images = _imageDataSource;
            [self.navigationController pushViewController:_editVC animated:YES];
        }
    }
    
}

#pragma mark --------------UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length) {
        [_inputV.placeholerLabel removeFromSuperview];
    }else{
        [_inputV.textV addSubview:_inputV.placeholerLabel];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    if (textView.text.length - range.length + text.length>1000)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark --------------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseID = @"HJTableViewCell";
    static NSString * reuseID1 = @"UITableViewCell";
    
    HJTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    UITableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:reuseID1];
    if (!cell || !cell1) {
        cell = [[HJTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID1];
    }
    
    if (indexPath.section) {
        cell1.textLabel.text = @"开启评论";
        [cell1 addSubview:_commentSwitch];
        return cell1;
    }else{
        [cell addSubview:_serviceTypeOrNumView];
        [cell addSubview:_inputV];
        [cell addSubview:_photoPickerV];
        [cell addSubview:_textNumLabel];
        [cell addSubview:_textInfo];
        [cell addSubview:_picInfo];
        [cell addSubview:_picNum];
        [cell addSubview:_lineView2];
        if (_imageDataSource.count>=2&&_publishType == PUBLISH_VIDEO) {
            _photoPickerV.deleteButton.hidden = NO;
            _photoPickerV.videoImageView.hidden = NO;
        }else{
            _photoPickerV.deleteButton.hidden = YES;
            _photoPickerV.videoImageView.hidden = YES;
            for (UIButton *btn in _photoPickerV.subviews) {
                [[btn viewWithTag:10] setHidden:YES];
                [[btn viewWithTag:20] setHidden:YES];
                
            }
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = _photoPickerV.frame.size.height + _photoPickerV.frame.origin.y + 10;
    if (!indexPath.section) return rowHeight;
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH, CGFLOAT_MIN)];
    myView.backgroundColor = RGBA(0xeeeeee, 1);
    return myView;
}
#pragma mark --------------UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tabelV deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark --------------SystemVCDelegate
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    //    [_inputV.textV becomeFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_inputV.textV resignFirstResponder];
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
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (_publishType == PUBLISH_PHOTOANDTEXT) {//拍照
            [self openCamera];
        }else{//摄影
//            //            [self openCamera];
//            FMFileVideoController *fileVC = [[FMFileVideoController alloc] init];
//
//            UINavigationController *NAV = [[UINavigationController alloc] initWithRootViewController:fileVC];
//            fileVC.reloadBlock = ^(NSURL * url) {
//                [self indicateVideo:url];
//            };
//            [self presentViewController:NAV animated:YES completion:nil];
        }
        
    }else if (buttonIndex == 1){
        if (_publishType == PUBLISH_PHOTOANDTEXT) {//相册
            [self openPhotos];
        }else{//视频选择
            [self openPhotos];
        }
        
    }
}
/** 打开相机 */
- (void)openCamera {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;

    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;

        if (_publishType == PUBLISH_VIDEO) { //录像
            NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            if([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]){
                [MBProgressHUD showError:@"不支持视频录制"];
                return;
            }
            picker.mediaTypes =
            [NSArray arrayWithObject:(NSString *)kUTTypeMovie];         picker.videoQuality = UIImagePickerControllerQualityTypeLow; //录像质量
            picker.videoMaximumDuration = 600.0f; //录像最长时间
        }
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        //不支持拍照或模拟器系列
    }
}

#pragma mark - UIImagePickerController Delegate

///拍照、选视频图片、录像 后的回调（这种方式选择视频时，会自动压缩，但是很耗时间）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *image = info[UIImagePickerControllerEditedImage];
        //压缩图片
        NSData *fileData = UIImageJPEGRepresentation(image, 1.0);
        image = [UIImage imageWithData:fileData];
        //        //保存图片至相册
        //        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        [_imageDataSource removeLastObject];
        [_imageDataSource addObjectsFromArray:@[image]];
        [_imageDataSource addObject:_photoPickerV.addImage];
        self.photoPickerV.photoNum = 10;
        [self.photoPickerV setSelectedImages:_imageDataSource];
        
       NSMutableArray *arr = [NSMutableArray arrayWithArray:_imageDataSource];
        BOOL flag = [arr.lastObject isEqual:self.photoPickerV.addImage];
        if (flag) {
            [arr removeLastObject];
        }
        _picNum.text = [NSString stringWithFormat:@"%ld/9张",arr.count];

        [self addTargetForImage];
        [self.tabelV reloadData];
        
    }else{
        
        
        
        //        NSData *videoData = [NSData dataWithContentsOfURL:url];
        //视频上传
        
        
    }
    
    //todo: 后面有具体处理方法
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)indicateVideo:(NSURL *)url{
    
    //保存视频至相册（异步线程）
    NSString *urlStr = [url path];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    });
    
}

#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    
}

#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSURL *url = [NSURL URLWithString:videoPath];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];;
        PHAsset *asset = fetchResult.lastObject;
        
        [_imageDataSource removeLastObject];
        [_imageDataSource addObjectsFromArray:@[[self getThumbnailImage:videoPath]]];
        [_imageDataSource addObject:_photoPickerV.addImage];
        self.photoPickerV.photoNum = 2;
        _asset = [asset copy];
        [self.photoPickerV setSelectedImages:_imageDataSource];
        [self addTargetForImage];
        [self.tabelV reloadData];
        
        
        
        
        [[ACMediaManager manager] getVideoPathFromURL:url PHAsset:asset enableSave:NO completion:^(NSString *name, UIImage *screenshot, id pathData) {
            
            ACMediaModel *model = [[ACMediaModel alloc] init];
            model.name = name;
            model.uploadType = pathData;
            model.image = [self getThumbnailImage:videoPath];
            model.isVideo = YES;
            model.asset = asset;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.mediaArray addObject:model];
                
            });
            
            
        }];
        NSLog(@"视频保存成功.");
    }
}
//获取该视频的封面图
-(UIImage *)getThumbnailImage:(NSString *)videoPath {
    if (videoPath) {
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath: videoPath] options:nil];
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        // 设定缩略图的方向
        // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的
        gen.appliesPreferredTrackTransform = YES;
        // 设置图片的最大size(分辨率)
        gen.maximumSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
        CMTime time = CMTimeMakeWithSeconds(0.1, 60); //取第0秒，一秒钟600帧
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        if (error) {
            UIImage *placeHoldImg = [UIImage imageNamed:@"posters_default_horizontal"];
            return placeHoldImg;
        }
        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        return thumb;
    } else {
        UIImage *placeHoldImg = [UIImage imageNamed:@"posters_default_horizontal"];
        return placeHoldImg;
    }
}
- (void)openPhotos {
    
    NSInteger num;
    BOOL flag = YES;
    if (_publishType == PUBLISH_PHOTOANDTEXT) {
        num = 10;
        flag = NO;
    }else{
        num = 2;
        flag = YES;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:num - _imageDataSource.count delegate:self allowPickingVideo:flag];
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    if (_publishType == PUBLISH_PHOTOANDTEXT) {
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
            [_imageDataSource removeLastObject];
            [_imageDataSource addObjectsFromArray:photos];
            [_imageDataSource addObject:_photoPickerV.addImage];
            self.photoPickerV.photoNum = 10;
            [self.photoPickerV setSelectedImages:_imageDataSource];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:_imageDataSource];
            BOOL flag = [arr.lastObject isEqual:self.photoPickerV.addImage];
            if (flag) {
                [arr removeLastObject];
            }
            _picNum.text = [NSString stringWithFormat:@"%ld/9张",arr.count];
            [self addTargetForImage];
            [self.tabelV reloadData];
            
            
        }];
    }else{
        [self.mediaArray removeAllObjects];
        [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
            [_imageDataSource removeLastObject];
            [_imageDataSource addObjectsFromArray:@[coverImage]];
            [_imageDataSource addObject:_photoPickerV.addImage];
            self.photoPickerV.photoNum = 2;
            _asset = [asset copy];
            [self.photoPickerV setSelectedImages:_imageDataSource];
            [self addTargetForImage];
            [self.tabelV reloadData];
            
            [[ACMediaManager manager] getMediaInfoFromAsset:asset completion:^(NSString *name, id pathData) {
                ACMediaModel *model = [[ACMediaModel alloc] init];
                model.name = name;
                model.uploadType = pathData;
                model.image = coverImage;
                model.isVideo = YES;
                model.asset = asset;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.mediaArray addObject:model];
                    
                });
            }];
        }];
    }
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
    
    
}
-(void)leftButtonClick:(UIButton *)button{
    if (_asset||_imageDataSource.count>1||![JGIsBlankString isBlankString: _inputV.textV.text]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"你有未发布的内容" message:@"确认离开？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)pulishBtnClick:(id)sender {
    _publishBtn.enabled = NO;
    imageArr = [NSMutableArray arrayWithArray:_imageDataSource];
    BOOL flag = [imageArr.lastObject isEqual:self.photoPickerV.addImage];
    if (flag) {
        [imageArr removeLastObject];
    }
    if (imageArr.count>0) {
        if (_publishType == PUBLISH_PHOTOANDTEXT) {
            [self publishImage];
        }else{
            [self publishVedio];
        }
    }else{
        [self publishText:nil];
    }
}
#pragma mark 发布图片
- (void)publishImage{
    NSMutableArray *myArr = [NSMutableArray array];
    [myArr addObject:imageArr];
    NSMutableArray *subArr =[NSMutableArray array];
    for (int i = 1; i<=imageArr.count; i++) {
        [subArr addObject:@"file"];
    }
    [myArr addObject:subArr];
    [MBProgressHUD showMessage:@"图片上传中..."];
    [ZTHttpTool postWithImageUrl:@"fileserver/v1/upload/image" param:@{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"sourceApp":@"property"} postImageArr:myArr mimeType:@"image/png" success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        XMJLog(@"%@",onceDict);
        if ([onceDict[@"rocde"] integerValue] == 0) {
            NSDictionary *comeBackDict = onceDict[@"form"];
            [self publishText:comeBackDict];
        }else{
            _publishBtn.enabled = YES;
            
            [MBProgressHUD showError:onceDict[@"rocde"]];
        }
    } failure:^(NSError *error) {
        _publishBtn.enabled = YES;
        
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
        
    }];
}
#pragma mark 发布文字（适用于图片发布）
- (void)publishText:(NSDictionary *)onceDict{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[StorageUserInfromation storageUserInformation].userId forKey:@"userId"];
    [dict setValue:@"1.0" forKey:@"apiv"];

    if (!propertyHouseId) {
        [MBProgressHUD showError:@"请选择房号"];
        _publishBtn.enabled = YES;
        return;
    }
    [dict setValue:propertyHouseId forKey:@"propertyHouseId"];
    [dict setValue:_menuId forKey:@"menuId"];

    if (_propertyServiceTagArr.count != 0) {
        if (!propertyServiceId) {
            [MBProgressHUD showError:@"请选择服务类型"];
            _publishBtn.enabled = YES;
            return;
        }else{
            [dict setValue:propertyServiceId forKey:@"propertyServiceId"];

        }
    }
    if (onceDict) {
        [dict  setValue:[DictToJson jsonStringWithDictionary:onceDict] forKey:@"imageJson"];
        [dict addEntriesFromDictionary:onceDict];
//        [dict setValue:@"2" forKey:@"type"];
        
    }else{
        if ([JGIsBlankString isBlankString:_inputV.textV.text]) {
            [MBProgressHUD showError:@"内容不能为空"];
            _publishBtn.enabled = YES;
            return;
        }
//        [dict setValue:@"1" forKey:@"type"];
    }
    [dict setValue:_inputV.textV.text forKey:@"content"];
    
    [ZTHttpTool postWithUrl:@"property/v1/PropertyService/publish" param:dict success:^(id responseObj) {
        _publishBtn.enabled = YES;
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary *dict = [DictToJson dictionaryWithJsonString:str];
        XMJLog(@"%@",dict);
        if ([dict[@"rcode"] integerValue] == 0) {
            if (self.publichBlock) {
                self.publichBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:dict[@"rocde"]];
        }
    } failure:^(NSError *error) {
        XMJLog(@"%@",error)
        _publishBtn.enabled = YES;
        
        [MBProgressHUD showError:@"网络异常"];
        
    }];
}
#pragma mark 发布文字（适用于视频发布）
- (void)publishTextWithVideo:(NSDictionary *)videoDict{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[StorageUserInfromation storageUserInformation].userId forKey:@"userId"];
    
    if (videoDict) {
        [dict addEntriesFromDictionary:videoDict];
        [dict setValue:@"3" forKey:@"type"];
        
    }else{
        if ([JGIsBlankString isBlankString:_inputV.textV.text]) {
            [MBProgressHUD showError:@"内容不能为空"];
            _publishBtn.enabled = YES;
            return;
        }
        [dict setValue:@"1" forKey:@"type"];
    }
    [dict setValue:_inputV.textV.text forKey:@"content"];
    
    [dict setValue:_commentSwitch.on?@"y":@"n" forKey:@"replyable"];
    [ZTHttpTool postWithUrl:@"social/post/addPost" param:dict success:^(id responseObj) {
        _publishBtn.enabled = YES;
        NSLog(@"%@",responseObj);
        NSLog(@"responseObj==%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSDictionary *dict = [DictToJson dictionaryWithJsonString:str];
        if ([dict[@"rcode"] integerValue] == 0) {
            self.publichBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:dict[@"rocde"]];
        }
    } failure:^(NSError *error) {
        _publishBtn.enabled = YES;
        [MBProgressHUD showError:@"网络异常"];
        
    }];
}
#pragma mark 发布视频
- (void)publishVedio{
    if (_asset) {
        
        PHAsset *phAsset =  _asset;
        if (phAsset.mediaType == PHAssetMediaTypeVideo) {
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            
            PHImageManager *manager = [PHImageManager defaultManager];
            [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                
                CMTime   time = [urlAsset duration];
                int seconds = ceil(time.value/time.timescale);
                NSLog(@"seconds ===  %d",seconds);
                
                // 主线程执行：
                dispatch_async(dispatch_get_main_queue(), ^{
                    // something
                    [self publishVedioNext];
                    
                });
                
                
            }];
        }else{
            _publishBtn.enabled = YES;
        }
    }else{
        _publishBtn.enabled = YES;
    }
}

- (void)publishVedioNext{
    [self getVideoFromPHAsset:_asset Complete:^(NSData *fileData, NSString *fileName) {
        [MBProgressHUD showMessage:@"视频上传中..."];
        
        if (fileData) {
            [ZTHttpTool postWithVideoUrl:@"fileserver/upload/video" param:@{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"sourceApp":@"social"} postData:fileData name:@"file" mimeType:@"video/mp4" success:^(id responseObj) {
                [MBProgressHUD hideHUD];
                NSLog(@"responseObj==%@",[responseObj mj_JSONObject]);
                NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
                NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
                NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
                if ([onceDict[@"rocde"] integerValue] == 0) {
                    NSDictionary *onceDict2 = onceDict[@"form"];
                    [self publishTextWithVideo:onceDict2];
                }else{
                    _publishBtn.enabled = YES;
                    [MBProgressHUD showError:onceDict[@"msg"]];
                }
            } failure:^(NSError *error) {
                _publishBtn.enabled = YES;
                NSLog(@"%@",error);
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络异常"];
                
            }];
        }else{
            _publishBtn.enabled = YES;
        }
    }];
}

- (void)getVideoFromPHAsset:(PHAsset *)asset Complete:(Result)result {
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    
    for (PHAssetResource *assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
            assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    NSString *fileName = @"tempAssetVideo.mov";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }
    
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 result(nil, nil);
                                                             } else {
                                                                 
                                                                 NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:PATH_MOVIE_FILE]];
                                                                 result(data, fileName);
                                                             }
                                                             [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE  error:nil];
                                                         }];
    } else {
        result(nil, nil);
    }
}
@end

