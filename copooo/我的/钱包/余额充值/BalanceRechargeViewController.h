//
//  BalanceRechargeViewController.h
//  HomeElectricTreasure
//
//  Created by 夏明江 on 16/8/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceRechargeViewController : UIViewController<UITextFieldDelegate>
/**
 *  @author 夏明江, 16-08-19 10:08:36
 *
 *  返回按钮
 *
 *  @param sender
 */
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *balance;//余额
@property (weak, nonatomic) IBOutlet UIImageView *weichatSelectOrNotImage;//微信选择标记
@property (weak, nonatomic) IBOutlet UIImageView *zhifubaoSelectOrNotImage;//支付宝选择标记
/**
 *  @author 夏明江, 16-08-19 10:08:06
 *
 *  支付方式选择
 *
 *  @param sender tag ＝ 10 微信支付；tag＝20支付宝支付。
 */
- (IBAction)selectTypeBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *tenYuan;//10元
@property (weak, nonatomic) IBOutlet UIButton *thirtyYuan;//30元
@property (weak, nonatomic) IBOutlet UIButton *fiftyYuan;//50元
@property (weak, nonatomic) IBOutlet UIButton *oneHundredYuan;//100元
@property (weak, nonatomic) IBOutlet UIButton *fiftyHundredYuan;//500元
@property (weak, nonatomic) IBOutlet UIButton *thirtyHundredYuan;//300元
@property (weak, nonatomic) IBOutlet UITextField *otherMoney;//其它金额输入
@property (weak, nonatomic) IBOutlet UIButton *payMoney;//确认支付按钮

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIView *scrollSubView;
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UIView *moneyView;
@property (weak, nonatomic) IBOutlet UIView *restMoneyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subviewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payMoneyBtnToBottom;
@property (assign, nonatomic) NSInteger comfromFlag;//1来自电费缴纳(预付费) 2后付费
@property (assign, nonatomic) CGFloat rechargeValue;//应该缴纳费用
@property (weak, nonatomic) IBOutlet UIView *wedxinPayView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weixinpayHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payViewHeight;
@property (nonatomic, strong) NSString *accountNo;//账单


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyViewConstrantHeight;
@property (weak, nonatomic) IBOutlet UILabel *moneyChoseLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyChoseLabelConstrant;
@property (weak, nonatomic) IBOutlet UIView *moneyChoseView;
@property (weak, nonatomic) IBOutlet UIView *moneyChoseViewTwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyChoseViewConstrant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyChoseViewTwoConstrant;

@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;

/**
 *  @author 夏明江, 16-08-19 10:08:40
 *
 *  确认支付
 *
 *  @param sender
 */
- (IBAction)payMoneyBtnClick:(id)sender;
/**
 *  @author 夏明江, 16-08-19 10:08:44
 *
 *  金额选择
 *
 *  @param sender
 */
- (IBAction)moneyChooseBtnClick:(id)sender;

@end
