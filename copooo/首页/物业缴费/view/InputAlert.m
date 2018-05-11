//
//  InputAlert.m
//  Nyanko
//
//  Created by 赵勇 on 30/09/2017.
//  Copyright © 2017 何月. All rights reserved.
//

#import "InputAlert.h"

@interface InputAlertContent : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) void(^completionBlock)(NSString *text);
@property (nonatomic, copy) void(^cancelBlock)(void);

@end

@implementation InputAlertContent

- (instancetype)init {
	self = [super init];
	if (self) {
		self.backgroundColor = UIColor.whiteColor;
		self.layer.cornerRadius = 5.f;
		self.clipsToBounds = YES;

		
		_titleLabel = [[UILabel alloc] init];
		_titleLabel.textColor = UIColor.whiteColor;
		_titleLabel.backgroundColor = RGBA(0x00a7ff, 1.f);
		_titleLabel.font = [UIFont systemFontOfSize:17.f];
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_titleLabel];
		[_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.top.right.mas_equalTo(0);
			make.height.equalTo(@44);
		}];
		
		UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
		[confirmButton setTitleColor:RGBA(0x00a7ff, 1.f) forState:UIControlStateNormal];
		[confirmButton setTitle:@"确定" forState:UIControlStateNormal];
		[confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
		confirmButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
		[self addSubview:confirmButton];
		[confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.bottom.equalTo(self);
			make.height.equalTo(@44);
		}];
		
		UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
		[cancelButton setTitleColor:RGBA(0x999999, 1.f) forState:UIControlStateNormal];
		[cancelButton setTitle:@"取消" forState:UIControlStateNormal];
		[cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
		cancelButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
		[self addSubview:cancelButton];
		[cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.bottom.equalTo(self);
			make.right.equalTo(confirmButton.mas_left);
			make.width.height.equalTo(confirmButton);
		}];
		
		UIView *hLine = [[UIView alloc] init];
		hLine.backgroundColor = RGBA(0xf5f5f5, 1.f);
		[self addSubview:hLine];
		[hLine mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.equalTo(self);
			make.bottom.equalTo(cancelButton.mas_top);
			make.height.equalTo(@1.f);
		}];
		
		UIView *vLine = [[UIView alloc] init];
		vLine.backgroundColor = RGBA(0xf5f5f5, 1.f);
		[self addSubview:vLine];
		[vLine mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.bottom.equalTo(cancelButton);
			make.left.equalTo(cancelButton.mas_right);
			make.width.equalTo(@1.f);
		}];
		
		_textField = [[UITextField alloc] init];
		_textField.layer.cornerRadius = 2.f;
		_textField.backgroundColor = RGBA(0xf5f5f5, 1.f);
		_textField.font = [UIFont systemFontOfSize:17.f];
		_textField.textColor = RGBA(0x999999, 1);
		_textField.placeholder = @"请输入文字";
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
		[self addSubview:_textField];
		[_textField mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(25);
			make.right.equalTo(self).offset(-25);
			make.top.equalTo(_titleLabel.mas_bottom).offset(36.f);
			make.bottom.equalTo(cancelButton.mas_top).offset(-36.f);
		}];
		
	}
	return self;
}

- (void)confirmAction {
	if (_completionBlock) {
		_completionBlock(_textField.text);
	}
}

- (void)cancelAction {
	if (_cancelBlock) {
		_cancelBlock();
	}
}
- (void)textFieldDidChange:(UITextField *)textField{
    
    //限制文本的输入长度不得大于10个字符长度
    if ( [InputAlert share].lengthNum != 0 && textField.text.length >= [InputAlert share].lengthNum ){
        
        //截取文本字符长度为length的内容
        textField.text = [textField.text substringToIndex:[InputAlert share].lengthNum];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
//    if (stringContainsEmoji(string)) {
//        //[textField deleteBackward];
//        return false;
//    }
        if ([InputAlert share].lengthNum != 0) {
            if (textField.text.length <= [InputAlert share].lengthNum ){
                //返回值为YES的时候,文本框可以进行编辑
                return YES;
            }else{
                //当返回NO的时候,文本框内的内容不会在再改变,甚至不能进行删除
                return NO;
            }
        }
    return true;
}

@end


//不带文本输入框提示
@interface InputAlertContentLab : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, copy) void(^clickSureCompletionBlock)(void);
@end

@implementation InputAlertContentLab
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 5.f;
        self.clipsToBounds = YES;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.backgroundColor = RGBA(0x00a7ff, 1.f);
        _titleLabel.font = [UIFont systemFontOfSize:17.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.equalTo(@44);
        }];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [confirmButton setTitleColor:RGBA(0x00a7ff, 1.f) forState:UIControlStateNormal];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [self addSubview:confirmButton];
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.left.equalTo(self);
            make.height.equalTo(@44);
        }];
        
        UIView *hLine = [[UIView alloc] init];
        hLine.backgroundColor = RGBA(0xf5f5f5, 1.f);
        [self addSubview:hLine];
        [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(confirmButton.mas_top);
            make.height.equalTo(@1.f);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = UIColor.blackColor;
        _contentLabel.font = [UIFont systemFontOfSize:16.f];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(40);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.equalTo(@88);
        }];
    }
    return self;
}

- (void)confirmAction {
    if (_clickSureCompletionBlock) {
        _clickSureCompletionBlock();
    }
}
@end



@interface InputAlert ()

@property (nonatomic, strong) InputAlertContent *alertView;
@property (nonatomic, strong) InputAlertContentLab *onlyClickView;
@property (nonatomic, copy) void(^completionBlock)(NSString *text);
@property (nonatomic, copy) void(^clickSureCompletionBlock)(void);
@end

static InputAlert *inputAlertInstance = nil;

@implementation InputAlert

+ (instancetype)share {
	static dispatch_once_t once;
	
	dispatch_once(&once, ^{
		inputAlertInstance = [[InputAlert alloc] init];
	});
	
	return inputAlertInstance;
}

- (void)dealloc {
	[NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)init {
	self = [super init];
	if (self) {
		[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
	}
	return self;
}

- (void)keyboardFrameChanged:(NSNotification *)notification {
	CGFloat y = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
	if (CGRectGetMaxY(self.alertView.frame) + 20 > y) {
		CGFloat delta = CGRectGetMaxY(self.alertView.frame) + 20 - y;
		[UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			self.alertView.transform = CGAffineTransformMakeTranslation(0, -delta);
		} completion:nil];
	}
}

- (void)setAlertView:(InputAlertContent *)alertView {
	_alertView = alertView;
	[self addSubview:alertView];
	WeakSelf
	alertView.completionBlock = ^(NSString *text) {
		StrongSelf
		strongSelf.completionBlock(text);
		[strongSelf hide];
	};
	alertView.cancelBlock = ^{
		StrongSelf
		[strongSelf hide];
	};
}
- (void)setOnlyClickView:(InputAlertContentLab *)onlyClickView{
    _onlyClickView = onlyClickView;
    [self addSubview:onlyClickView];
    WeakSelf
    onlyClickView.clickSureCompletionBlock = ^() {
        StrongSelf
        strongSelf.clickSureCompletionBlock();
        [strongSelf hideContentLab];
    };
}

- (void)openWithTitle:(NSString *)title placeString:(NSString *)placeString keyboardType:(UIKeyboardType )keyboardType completion:(void (^)(NSString *))completionBlock {
	_completionBlock = completionBlock;
	UIView *aView = UIApplication.sharedApplication.keyWindow;
	self.frame = aView.bounds;
	[aView addSubview:self];

	self.alertView = [[InputAlertContent alloc] init];
	self.alertView.size = CGSizeMake(aView.bounds.size.width * 0.8, 200.f);
	self.alertView.center = self.center;
	self.alertView.titleLabel.text = title;
    
    self.alertView.textField.keyboardType = keyboardType;
    self.alertView.textField.placeholder = placeString;
	
	self.alertView.transform = CGAffineTransformMakeScale(0.3, 0.3);
	self.alertView.alpha = 0;
	self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
	
	[UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
		self.alertView.transform = CGAffineTransformIdentity;
		self.alertView.alpha = 1.f;
	} completion:nil];
}

- (void)hide {
	self.alertView.transform = CGAffineTransformIdentity;
	[UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
		self.alertView.transform = CGAffineTransformMakeScale(0.3, 0.3);
		self.alertView.alpha = 0.f;
	} completion:^(BOOL finished) {
		[self.alertView removeFromSuperview];
		self.alertView = nil;
		[self removeFromSuperview];
	}];
}
- (void)hideContentLab {
    self.onlyClickView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.onlyClickView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        self.onlyClickView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.onlyClickView removeFromSuperview];
        self.onlyClickView = nil;
        [self removeFromSuperview];
    }];
}
- (void)openWithTitle:(NSString *)title content:(NSString *)content placeString:(NSString *)placeString keyboardType:(UIKeyboardType )keyboardType completion:(void (^)(NSString *))completionBlock {
    _completionBlock = completionBlock;
    UIView *aView = UIApplication.sharedApplication.keyWindow;
    self.frame = aView.bounds;
    [aView addSubview:self];
    
    self.alertView = [[InputAlertContent alloc] init];
    self.alertView.size = CGSizeMake(aView.bounds.size.width * 0.8, 200.f);
    self.alertView.center = self.center;
    self.alertView.titleLabel.text = title;
    if (content) {
        self.alertView.textField.text = content;
    }
    
    self.alertView.textField.keyboardType = keyboardType;
    self.alertView.textField.placeholder = placeString;
    
    self.alertView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    self.alertView.alpha = 0;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.alertView.transform = CGAffineTransformIdentity;
        self.alertView.alpha = 1.f;
    } completion:nil];
}

- (void)openWithTitle:(NSString *)title content:(NSString *)content   completion:(void (^)(void))clickSureCompletionBlock {
    _clickSureCompletionBlock = clickSureCompletionBlock;
    UIView *aView = UIApplication.sharedApplication.keyWindow;
    self.frame = aView.bounds;
    [aView addSubview:self];
    
    self.onlyClickView = [[InputAlertContentLab alloc] init];
    self.onlyClickView.size = CGSizeMake(aView.bounds.size.width * 0.8, 180.f);
    self.onlyClickView.center = self.center;
    self.onlyClickView.titleLabel.text = title;
    self.onlyClickView.contentLabel.text = content;
    self.onlyClickView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    self.onlyClickView.alpha = 0;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.onlyClickView.transform = CGAffineTransformIdentity;
        self.onlyClickView.alpha = 1.f;
    } completion:nil];
}

@end
