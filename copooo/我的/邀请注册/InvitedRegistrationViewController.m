//
//  InvitedRegistrationViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/12/13.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "InvitedRegistrationViewController.h"
#import "InviteRegistrationTableViewCell.h"
#import "InviteRegistrationRankViewController.h"
#import "InvitedRegistrationDataModel.h"
#import "MJRefresh.h"
#import "UITableView+WFEmpty.h"

@interface InvitedRegistrationViewController ()
{
    NSInteger _page;
}
@property (nonatomic,strong)NSMutableArray <InvitedRegistrationList *> *myArr;
@end

@implementation InvitedRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kDevice_Is_iPhoneX) {
        _navHight.constant = 64+24;
        _navTitle.font = [UIFont systemFontOfSize:18.0];
    }
    _page = 0;
    _myArr = [NSMutableArray array];
    [self fetchData:_page];
    
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self fetchData:_page];
        //Call this Block When enter the refresh status automatically
    }];    // Do any additional setup after loading the view from its nib.
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"InviteRegistrationTableViewCell";
    InviteRegistrationTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (!myCell) {
        myCell = [[[NSBundle mainBundle] loadNibNamed:cell owner:self options:nil] lastObject];
    }
    [myCell.headerIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@",BASE_URL,@"uaa/v1/getAvatar?userId=",_myArr[indexPath.row].inviteeId]] placeholderImage:[UIImage imageNamed:@"per_head"] options:SDWebImageAllowInvalidSSLCertificates];
    myCell.phoneNum.text = [NSString stringWithFormat:@"%@****%@",[_myArr[indexPath.row].username substringToIndex:3],[_myArr[indexPath.row].username substringFromIndex:7]];
    myCell.time.text =  [StorageUserInfromation timeStrFromDateString:_myArr[indexPath.row].invitationDate];
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return myCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _myArr.count;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fetchData:(NSInteger)page{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"token":[StorageUserInfromation storageUserInformation].token,@"userId":[StorageUserInfromation storageUserInformation].userId,@"device":@"1",@"page":[NSString stringWithFormat:@"%ld",page],@"pagesize":@"10"};
    
    [ZTHttpTool postWithUrl:@"inviteeList" param:dict success:^(id responseObj) {
        NSLog(@"%@",[responseObj mj_JSONObject]);
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",str);
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        [MBProgressHUD hideHUD];
        InvitedRegistrationDataModel *invitedRegistration = [InvitedRegistrationDataModel mj_objectWithKeyValues:str];
        if (invitedRegistration.rcode == 0) {
            if (invitedRegistration.form.list.count ==0 && page >0) {
                _page--;
                [MBProgressHUD showError:@"没有更多数据"];
            }
            _inviteNum.text = invitedRegistration.form.count;
            [_myArr addObjectsFromArray:invitedRegistration.form.list];
            if (_myArr.count == 0) {
                [self.myTableView addEmptyViewWithImageName:@"暂无邀请对象" title:@"暂无有效邀请人"];
                self.myTableView.emptyView.hidden = NO;
            }else{
                self.myTableView.emptyView.hidden = YES;

            }
            [self dataWithSuface];
        }else{
            [MBProgressHUD showError:invitedRegistration.msg];
        }
        if (page>0) {
            [self.myTableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
        if (page>0) {
            _page--;
            [self.myTableView.mj_footer endRefreshing];
        }
        [self.myTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
        self.myTableView.emptyView.hidden = NO;
        
    }];
}
- (void)dataWithSuface{
    [self.myTableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rankBtnClick:(id)sender {
    InviteRegistrationRankViewController *page = [[InviteRegistrationRankViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
@end
