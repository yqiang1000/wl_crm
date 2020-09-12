//
//  TabMineViewController.m
//  Wangli
//
//  Created by yeqiang on 2018/3/28.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "TabMineViewController.h"
#import "TabMineCell.h"
#import "AttendanceViewCtrl.h"
#import "SuggestionViewCtrl.h"
#import "SettingViewCtrl.h"
#import "MyPlanCompletionViewCtrl.h"
#import "MyFavoriteViewCtrl.h"
#import "OperationIndexMo.h"
#import "AvatorViewCtrl.h"
#import "MainTabBarViewController.h"
#import "TaskViewCtrl.h"
#import "MyScheduleViewCtrl.h"
#import "SignHistoryViewCtrl.h"

@interface TabMineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *imgHeader;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labJob;
@property (nonatomic, strong) UIButton *btnSign;
@property (nonatomic, strong) UILabel *labMoney;
@property (nonatomic, strong) UILabel *labSort;

@property (nonatomic, strong) NSArray *arrImgs;
@property (nonatomic, strong) NSArray *arrText;
@property (nonatomic, strong) OperationIndexMo *operMo;

@end

@implementation TabMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviView.hidden = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setUI];
    [self refreshView];
    [self getSignType];
}

- (void)setUI {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(135+Height_StatusBar));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getOperationInfo];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    MainTabBarViewController *tabVC = (MainTabBarViewController *)self.navigationController.tabBarController;
    [tabVC hidenBtnCreate:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    MainTabBarViewController *tabVC = (MainTabBarViewController *)self.navigationController.tabBarController;
    [tabVC hidenBtnCreate:YES];
}

- (void)getOperationInfo {
    [[JYUserApi sharedInstance] getOperationInfoSuccess:^(id responseObject) {
        self.operMo = [[OperationIndexMo alloc] initWithDictionary:responseObject error:nil];
        [self refreshView];
    } failure:^(NSError *error) {
    }];
}

- (void)getSignType {
    [[JYUserApi sharedInstance] getConfigDicByName:@"sign_record_type" success:^(id responseObject) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        if (jsonData) {
            [[NSUserDefaults standardUserDefaults] setObject:jsonData forKey:SIGN_TYPE_DIC];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)refreshView {
    TheUser.userMo.avatarUrl = self.operMo.url;
    [self.imgHeader sd_setImageWithURL:[NSURL URLWithString:[Utils imgUrlWithKey:self.operMo.url]] placeholderImage:[UIImage imageNamed:@"client_default_avatar"]];
    self.labName.text = self.operMo.operator;
    self.labJob.text = self.operMo.office;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrText.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"tabMineCell";
    TabMineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TabMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setLeftText:self.arrText[indexPath.row]];
    cell.imgHeader.image = [UIImage imageNamed:self.arrImgs[indexPath.row]];
    cell.lineView.hidden = (indexPath.row == self.arrText.count - 1) ? YES : NO;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = COLOR_B0;
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseViewCtrl *vc = nil;
    if (indexPath.row == 0) {
        // 我的签到
        vc = [[SignHistoryViewCtrl alloc] init];
    } else if (indexPath.row == 1) {
        // 任务协作
        vc = [[TaskViewCtrl alloc] init];
    } else if (indexPath.row == 2) {
        // 我的收藏
        vc = [[MyFavoriteViewCtrl alloc] init];
    } else if (indexPath.row == 3) {
        // 意见反馈
        vc = [[SuggestionViewCtrl alloc] init];
    } else if (indexPath.row == 4) {
        // 设置
        vc = [[SettingViewCtrl alloc] init];
    }
    if (vc) {
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - event

- (void)btnSignClick:(UIButton *)sender {
    AttendanceViewCtrl *vc = [[AttendanceViewCtrl alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)btnLoginClick:(UIButton *)sender {
//    JYChatKit *jyChatKit = [JYChatKit shareJYChatKit];
//    [jyChatKit logoutSuccess:^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_LOGOUT_SUCCESS object:nil userInfo:nil];
//    } failure:^(NSString *strMsg) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_LOGOUT_SUCCESS object:nil userInfo:nil];
//    }];
//}

- (void)clickChange:(UIGestureRecognizer *)tap {
    AvatorViewCtrl *vc = [[AvatorViewCtrl alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - setter getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_B0;
//        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185)];
        _topView.backgroundColor = COLOR_C1;
        [_topView addSubview:self.imgHeader];
        [_topView addSubview:self.labName];
        [_topView addSubview:self.labJob];
        [_topView addSubview:self.btnSign];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"m-bg"]];
        [_topView addSubview:imgView];
        [_topView addSubview:self.labSort];
        
        [_imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_topView.mas_bottom).offset(-22);
            make.left.equalTo(_topView).offset(30);
            make.width.height.equalTo(@60.0);
        }];
        
        [_labName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_imgHeader.mas_centerY).offset(-4);
            make.left.equalTo(_imgHeader.mas_right).offset(15);
        }];
        
        [_labJob mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imgHeader.mas_centerY).offset(4);
            make.left.equalTo(_imgHeader.mas_right).offset(15);
        }];
        
        [_btnSign mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_imgHeader);
            make.right.equalTo(_topView).offset(-37.5);
            make.width.equalTo(@55.0);
            make.height.equalTo(@32.0);
        }];
    }
    return _topView;
}

- (UIImageView *)imgHeader {
    if (!_imgHeader) {
        _imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _imgHeader.layer.mask = [Utils drawContentFrame:_imgHeader.bounds corners:UIRectCornerAllCorners cornerRadius:30];
        _imgHeader.backgroundColor = COLOR_B0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickChange:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        _imgHeader.userInteractionEnabled = YES;
        [_imgHeader addGestureRecognizer:tap];

    }
    return _imgHeader;
}

- (UILabel *)labName {
    if (!_labName) {
        _labName = [[UILabel alloc] init];
        _labName.textColor = COLOR_B4;
        _labName.font = FONT_F18;
    }
    return _labName;
}

- (UILabel *)labJob {
    if (!_labJob) {
        _labJob = [[UILabel alloc] init];
        _labJob.textColor = COLOR_B4;
        _labJob.font = FONT_F13;
    }
    return _labJob;
}

- (UIButton *)btnSign {
    if (!_btnSign) {
        _btnSign = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 32)];
        _btnSign.layer.cornerRadius = 4;
        _btnSign.clipsToBounds = YES;
        _btnSign.layer.borderColor = COLOR_B4.CGColor;
        _btnSign.layer.borderWidth = 1;
        [_btnSign setTitleColor:COLOR_B4 forState:UIControlStateNormal];
        _btnSign.titleLabel.font = FONT_F15;
        [_btnSign setTitle:@"签到" forState:UIControlStateNormal];
        [_btnSign addTarget:self action:@selector(btnSignClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSign;
}

- (NSArray *)arrImgs {
    if (!_arrImgs) {
        _arrImgs = @[@"m_sign_in",
                     @"m_receipt",
                     @"m_collect",
                     @"m_feedback",
                     @"m_set"];
    }
    return _arrImgs;
}

- (NSArray *)arrText {
    if (!_arrText) {
        _arrText = @[@"签到记录",
                     @"任务协作",
                     @"我的收藏",
                     @"意见反馈",
                     @"设置"];
    }
    return _arrText;
}

- (OperationIndexMo *)operMo {
    if (!_operMo) {
        _operMo = [[OperationIndexMo alloc] init];
        _operMo.operator = TheUser.userMo.name;
        _operMo.office = STRING(TheUser.userMo.department[@"name"]);
    }
    return _operMo;
}

@end
