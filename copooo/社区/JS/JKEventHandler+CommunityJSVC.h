//
//  JKEventHandler+CommunityJSVC.h
//  copooo
//
//  Created by XiaMingjiang on 2018/2/28.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JKWKWebViewHandler/JKWKWebViewHandler.h>
#import "TZImagePickerController.h"

@interface JKEventHandler (CommunityJSVC)<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, copy) NSString  *tagId;
@property (nonatomic, copy) NSString  *postId;
@property (nonatomic, strong) UIActionSheet  *actionSheet;
@property (nonatomic,copy) NSString *publishType;
@property (nonatomic,copy) NSString *imageNum;
@property (nonatomic, copy)NSString *personUserId;
@property (nonatomic, copy)NSString *personUserType;
//@property (nonatomic,copy)NSString *orderType;

/** 当前选择的图片*/
@property(nonatomic, strong) NSMutableArray *imageDataSource;

- (void)getCommunityTag:(id)params :(void(^)(id response))callBack;

- (void)getCommunityPostId:(id)params :(void(^)(id response))callBack;

- (void)getPersonInfo:(id)params :(void(^)(id response))callBack;

- (void)getUserId:(id)params :(void(^)(id response))callBack;

- (void)getToken:(id)params :(void(^)(id response))callBack;

- (void)login:(id)params;

- (void)selectImage:(id)params;

- (void)close:(id)params;

- (void)getPersonUserType:(id)params;

- (void)onEvent:(id)params;

- (void)gotoNewActivity:(id)params;

- (void)refreshToken:(id)params;

- (void)getRefreshToken:(id)params :(void(^)(id response))callBack;

- (void)gotoLoginView:(id)params;
@end
