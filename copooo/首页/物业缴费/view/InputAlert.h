//
//  InputAlert.h
//  Nyanko
//
//  Created by 赵勇 on 30/09/2017.
//  Copyright © 2017 何月. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputAlert : UIView

@property (assign, nonatomic) NSInteger lengthNum;
+ (instancetype)share;

- (void)openWithTitle:(NSString *)title placeString:(NSString *)placeString keyboardType:(UIKeyboardType )keyboardType completion:(void(^)(NSString *text))completionBlock;
- (void)openWithTitle:(NSString *)title content:(NSString *)content placeString:(NSString *)placeString keyboardType:(UIKeyboardType )keyboardType completion:(void (^)(NSString *))completionBlock;

- (void)openWithTitle:(NSString *)title content:(NSString *)content   completion:(void (^)(void))clickSureCompletionBlock;
@end
