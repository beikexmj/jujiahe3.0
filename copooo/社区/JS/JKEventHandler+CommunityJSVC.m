//
//  JKEventHandler+CommunityJSVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/28.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "JKEventHandler+CommunityJSVC.h"
#import "UIView+Extensions.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "CommunityJSVC.h"
@implementation JKEventHandler (CommunityJSVC)
static char tagIdKey;
static char postIdKey;
static char actionSheetKey;
static char publishTypeKey;
static char imageNumKey;
static char imageDataSourceKey;
static char personUserIdKey;
static char personUserTypeKey;
//static char orderTypeKey;
//
////getter
//- (NSString *)orderType {
//    NSString *orderType = objc_getAssociatedObject(self, &orderTypeKey);
//    if (!orderType) {
//        
//        objc_setAssociatedObject(self, &orderTypeKey, orderType, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    }
//    return orderType;
//}
////setter
//- (void)setOrderType:(NSString *)orderType{
//    objc_setAssociatedObject(self, &orderTypeKey, orderType, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//getter
- (NSString *)personUserType {
    NSString *personUserType = objc_getAssociatedObject(self, &personUserTypeKey);
    if (!personUserType) {
        
        objc_setAssociatedObject(self, &personUserTypeKey, personUserType, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return personUserType;
}
//setter
- (void)setPersonUserType:(NSString *)personUserType{
    objc_setAssociatedObject(self, &personUserTypeKey, personUserType, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
//getter
- (NSString *)personUserId {
    NSString *personUserId = objc_getAssociatedObject(self, &personUserIdKey);
    if (!personUserId) {
        
        objc_setAssociatedObject(self, &personUserIdKey, personUserId, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return personUserId;
}
//setter
- (void)setPersonUserId:(NSString *)personUserId{
    objc_setAssociatedObject(self, &personUserIdKey, personUserId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
//getter
- (NSString *)imageNum {
    NSString *imageNum = objc_getAssociatedObject(self, &imageNumKey);
    if (!imageNum) {
        
        objc_setAssociatedObject(self, &imageNumKey, imageNum, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return imageNum;
}
//setter
- (void)setImageNum:(NSString *)imageNum{
    objc_setAssociatedObject(self, &imageNumKey, imageNum, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
//getter
- (NSMutableArray *)imageDataSource {
    NSMutableArray *imageDataSource = objc_getAssociatedObject(self, &imageDataSourceKey);
    if (!imageDataSource) {
        
        objc_setAssociatedObject(self, &imageDataSourceKey, imageDataSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return imageDataSource;
}
//setter
- (void)setImageDataSource:(NSString *)imageDataSource{
    objc_setAssociatedObject(self, &imageDataSourceKey, imageDataSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//getter
- (NSString *)publishType {
    NSString *publishType = objc_getAssociatedObject(self, &publishTypeKey);
    if (!publishType) {
        
        objc_setAssociatedObject(self, &publishTypeKey, publishType, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return publishType;
}
//setter
- (void)setPublishType:(NSString *)publishType{
    objc_setAssociatedObject(self, &publishTypeKey, publishType, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//getter
- (NSString *)postId {
    NSString *postId = objc_getAssociatedObject(self, &postIdKey);
    if (!postId) {
        
        objc_setAssociatedObject(self, &tagIdKey, postId, OBJC_ASSOCIATION_COPY);
    }
    return postId;
}
//setter
- (void)setPostId:(NSString *)postId{
    objc_setAssociatedObject(self, &postIdKey, postId, OBJC_ASSOCIATION_COPY);
}
//getter
- (NSString *)tagId {
    NSString *tagId = objc_getAssociatedObject(self, &tagIdKey);
    if (!tagId) {
        
        objc_setAssociatedObject(self, &tagIdKey, tagId, OBJC_ASSOCIATION_COPY);
    }
    return tagId;
}

//setter
- (void)setTagId:(NSString *)tagId{
    objc_setAssociatedObject(self, &tagIdKey, tagId, OBJC_ASSOCIATION_COPY);
}

//getter
- (UIActionSheet *)actionSheet{
    UIActionSheet *actionSheet = objc_getAssociatedObject(self, &actionSheetKey);
    if (!actionSheet) {
        
        objc_setAssociatedObject(self, &actionSheetKey, actionSheet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return actionSheet;
}

//setter
- (void)setActionSheet:(UIApplication *)actionSheet{
    objc_setAssociatedObject(self, &actionSheetKey, actionSheet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)getCommunityTag:(id)params :(void(^)(id response))callBack{
    NSLog(@"%@",self.tagId);
    NSString * userId = [StorageUserInfromation storageUserInformation].userId;
    NSString *str = [NSString stringWithFormat:@"%@",userId?userId:@""];
    NSString * uuid = [StorageUserInfromation storageUserInformation].uuid;
    NSString *str2 = [NSString stringWithFormat:@"%@",uuid?uuid:@""];
    NSString * access_token = [StorageUserInfromation storageUserInformation].access_token;
    NSString *str3 = [NSString stringWithFormat:@"%@",access_token?access_token:@""];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"tag":self.tagId,@"areaId":[StorageUserInfromation storageUserInformation].choseUnitPropertyId,@"userId":str,@"uuid":str2,@"token":str3}];
//    NSString *str = [NSString stringWithFormat:@"'%@'",self.tagId];
    callBack([DictToJson jsonStringWithDictionary:dict]);
}
- (void)getCommunityPostId:(id)params :(void(^)(id response))callBack{
    NSLog(@"%@",self.postId);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"tag":self.tagId?self.tagId:@"",@"postId":self.postId}];
//    NSString *str = [NSString stringWithFormat:@"'%@'",self.postId];
    callBack([DictToJson jsonStringWithDictionary:dict]);
}
- (void)getUserId:(id)params :(void(^)(id response))callBack{
//    NSLog(@"%@",self.postId);
    NSString * userId = [StorageUserInfromation storageUserInformation].userId;
    NSString * token = [StorageUserInfromation storageUserInformation].access_token;
    NSString * uuid = [StorageUserInfromation storageUserInformation].uuid;
    NSString *str3 = [NSString stringWithFormat:@"%@",uuid?uuid:@""];
    NSString *str2 = [NSString stringWithFormat:@"%@",token?token:@""];
    NSString *str = [NSString stringWithFormat:@"%@",userId?userId:@""];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":str,@"token":str2,@"areaId":[StorageUserInfromation storageUserInformation].choseUnitPropertyId,@"uuid":str3}];
    if ([params count]) {
        [dict setObject:params[@"index"] forKey:@"index"];
        [dict setObject:params[@"postId"] forKey:@"postId"];
    }
//    XMJLog(@"%@",[DictToJson jsonStringWithDictionary:dict]);
    callBack([DictToJson jsonStringWithDictionary:dict]);
}
- (void)getPersonInfo:(id)params :(void(^)(id response))callBack{
    NSString * userId = [StorageUserInfromation storageUserInformation].userId;
    NSString * token = [StorageUserInfromation storageUserInformation].access_token;
    NSString *str2 = [NSString stringWithFormat:@"%@",token?token:@""];
    NSString *str = [NSString stringWithFormat:@"%@",userId?userId:@""];
    NSDictionary *dict = @{@"userId":str,@"token":str2,@"personUserId":self.personUserId?self.personUserId:@"",@"personUserType":self.personUserType?self.personUserType:@""};
    callBack([DictToJson jsonStringWithDictionary:dict]);
}
- (void)getToken:(id)params :(void(^)(id response))callBack{
    NSString * token = [StorageUserInfromation storageUserInformation].access_token;
    NSString *str = [NSString stringWithFormat:@"'%@'",token?token:@""];
    callBack(str);
}
- (void)login:(id)params{
    [[[UIAlertView alloc]initWithTitle:@"未登录或token失效" message:@"确定返回登录界面重新登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            delegate.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:controller];
        });
    }
}
- (void)close:(id)params{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.window.currentViewController.navigationController popViewControllerAnimated:YES];
    }

}
- (void)getPersonUserType:(id)params{
    
}
- (void)selectImage:(id)params{
     NSDictionary *num = params;
    self.imageNum = num[@"length"];
    if (self.imageNum.integerValue == 9) {
        [MBProgressHUD showError:@"最多添加9张图片"];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self callActionSheetFunc];

    });
}
- (void)callActionSheetFunc{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
       self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }else{
       self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:delegate.window.currentViewController.view];
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
                    self.publishType = @"0";
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    self.publishType = @"1";
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
                self.publishType = @"1";
            }
        }
        [self openPhotos];
    }
}

- (void)openPhotos{
    NSInteger num = self.imageNum.integerValue;
    BOOL flag = YES;
    if (self.publishType.integerValue == 1) {
        num = 9;
        flag = NO;
    }else{
        num = 1;
        flag = YES;
    }
    self.imageDataSource = [NSMutableArray array];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:num - self.imageNum.integerValue delegate:self allowPickingVideo:flag];
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    if (self.publishType.integerValue == 1) {
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
            [self.imageDataSource removeLastObject];
            [self.imageDataSource addObjectsFromArray:photos];
            [self addTargetForImage];
        }];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.window.currentViewController presentViewController:imagePickerVc animated:YES completion:^{
            
        }];
    }else{
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate.window.currentViewController presentViewController:picker animated:YES completion:^{
                
            }];
            
        }else{
            //不支持拍照或模拟器系列
        }
    }
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imageDataSource removeLastObject];
    [self.imageDataSource addObject:image];
    [self addTargetForImage];

}

- (void)addTargetForImage{
    NSMutableArray *arr = [NSMutableArray array];
    for (UIImage *image in self.imageDataSource) {
        // 压缩一下图片再传
        NSData *imgData = UIImageJPEGRepresentation(image, 1);
        NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        encodedImageStr = [self removeSpaceAndNewline:encodedImageStr];
        NSData *imgData2 = UIImageJPEGRepresentation(image, 0.001);
        NSString *encodedImageStr2 = [imgData2 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        encodedImageStr2 = [self removeSpaceAndNewline:encodedImageStr2];
        NSDictionary *dict = @{@"originUrl":encodedImageStr,@"compressUrl":encodedImageStr2};
        [arr addObject:dict];
    }
    NSString *jsonStr = [[[DictToJson alloc]init] jsonStringWithArray:arr];
//    XMJLog(@"%@",jsonStr);
    NSString *JSSttr = [NSString stringWithFormat:@"getImage('%@')",jsonStr];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:JSSttr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
//            XMJLog(@"%@",error);
        }];
    });
   

}
// 图片转成base64字符串需要先取出所有空格和换行符
- (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}
- (void)gotoNewActivity:(id)params{
    if (params) {
        CommunityJSVC *webVC = [[CommunityJSVC alloc]init];
        webVC.url = params[@"url"];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.window.currentViewController.navigationController pushViewController:webVC animated:YES];
    }
}
- (void)onEvent:(id)params{
    if ([params count]>1) {
        [MobClick event:params[@"point"] label:params[@"id"]];
    }else if([params count] == 1){
        [MobClick event:params[@"point"]];
        
    }
}
- (void)refreshToken:(id)params{
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    storage.access_token = params[@"access_token"]?params[@"access_token"]:@"";
    storage.refresh_token = params[@"refresh_token"]?params[@"refresh_token"]:@"";
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
    [NSKeyedArchiver archiveRootObject:storage toFile:file];
}
- (void)getRefreshToken:(id)params :(void(^)(id response))callBack{
    NSString * token = [StorageUserInfromation storageUserInformation].refresh_token;
    NSString *str = [NSString stringWithFormat:@"'%@'",token?token:@""];
    callBack(str);
}
- (void)gotoLoginView:(id)params{
    dispatch_async(dispatch_get_main_queue(), ^{
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:controller];
        [MBProgressHUD showError:@"登录已过期或账号已在其他终端登录" toView:controller.view];
    });
}
@end
