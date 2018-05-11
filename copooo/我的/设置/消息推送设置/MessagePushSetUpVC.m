//
//  MessagePushSetUpVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/2.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "MessagePushSetUpVC.h"
#import "MeassgePushSetUpCell.h"
#import "MessagePushSetUpDataModel.h"
@interface MessagePushSetUpVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)MessagePushSetUp *data;
@end

@implementation MessagePushSetUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self.view addSubview:self.myTableView];
    [self fetchData];
    // Do any additional setup after loading the view.
}
- (void)setNav{
    self.isShowNav = YES;
    _backButton.hidden = NO;
    self.titleLabel.text = @"消息推送设置";
}
- (void)fetchData{
    [MBProgressHUD showMessage:@""];
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/setting/mysettings" param:dict success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        MessagePushSetUpDataModel *form = [MessagePushSetUpDataModel mj_objectWithKeyValues:str];
        _data = form.form;
        [self.myTableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
    }];
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifierCell = @"MeassgePushSetUpCell";
    MeassgePushSetUpCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifierCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:indentifierCell owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.typeName.text = @[@"活动推送",@"用户消息",@"系统消息"][indexPath.row];
    cell.content.text = @[@"优惠活动、促销商品、限时抢购等精选类容",@"点赞、回复、动态消息提示",@"接收到系统消息推送"][indexPath.row];
    if (_data) {
        switch (indexPath.row) {
            case 0:
            {
                if (_data.pushActivity) {
                    cell.markImg.image = [UIImage imageNamed:@"life_icon_choice"];
                }else{
                    cell.markImg.image = [UIImage imageNamed:@"life_icon_unchoice"];
                }
            }
                break;
            case 1:
            {
                if (_data.pushSocial) {
                    cell.markImg.image = [UIImage imageNamed:@"life_icon_choice"];
                }else{
                    cell.markImg.image = [UIImage imageNamed:@"life_icon_unchoice"];
                }
            }
                break;
            case 2:
            {
                if (_data.pushSystem) {
                    cell.markImg.image = [UIImage imageNamed:@"life_icon_choice"];
                }else{
                    cell.markImg.image = [UIImage imageNamed:@"life_icon_unchoice"];
                }
            }
                break;
            default:
                break;
        }
    }
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self setUpPush:indexPath];
}
- (void)setUpPush:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId,@"type":[NSString stringWithFormat:@"%ld",indexPath.row +1]};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/setting/switch" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary *dict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",dict);
        if ([dict[@"rcode"] integerValue] ==0) {
            if (_data) {
                switch (indexPath.row) {
                    case 0:
                    {
                        _data.pushActivity = !_data.pushActivity;
                    }
                        break;
                    case 1:
                    {
                        _data.pushSocial = !_data.pushSocial;
                    }
                        break;
                    case 2:
                    {
                        _data.pushSystem = !_data.pushSystem;
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
            [self.myTableView reloadData];
            }
            
    } failure:^(NSError *error) {
        
    }];
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
