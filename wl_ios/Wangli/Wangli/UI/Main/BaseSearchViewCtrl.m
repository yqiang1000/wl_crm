
//
//  BaseSearchViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/6/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseSearchViewCtrl.h"
#import "SearchTopView.h"
#import <iflyMSC/IFlyMSC.h>
#import "SearchTableView.h"
#import "SwitchUrlViewCtrl.h"

@interface BaseSearchViewCtrl () <IFlyRecognizerViewDelegate, SearchTopViewDelegate, UITableViewDelegate, UITableViewDataSource, SearchTableViewDelegate>

// 讯飞相关
@property (nonatomic, strong) IFlyRecognizerView *iFlyRecognizerView;
@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) UIButton *btnCancel;
// 搜索
@property (nonatomic, strong) SearchTableView *searchTableView;
@property (nonatomic, strong) NSMutableArray *hotTags;
@property (nonatomic, strong) TagMo *tagMo;
@property (nonatomic, copy) NSString *searchText;

@end

@implementation BaseSearchViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_B4;
    _page = 0;
    self.totalElements = @"0";
    [self setUI];
    if (_showIFly) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view addSubview:self.iFlyRecognizerView];
        });
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.searchView.searchTxtField becomeFirstResponder];
        });
    }
    self.tableView.hidden = YES;
    self.searchTableView.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchTableView reloadData];
    });
    [self.searchView.searchTxtField addTarget:self action:@selector(searchFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (self.searchStyle.type == SearchCustomer) {
        self.searchTableView.isHidenHot = NO;
        [self getHotData];
    }
}

- (void)getHotData {
    [[JYUserApi sharedInstance] getLabelPage:0 success:^(id responseObject) {
        NSError *error = nil;
        self.hotTags = [TagMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        NSMutableArray *arr = [NSMutableArray new];
        for (TagMo *tmpMo in self.hotTags) {
            [arr addObject:STRING(tmpMo.desp)];
        }
        self.searchTableView.hotData = arr;
        [self.searchTableView reloadData];
    } failure:^(NSError *error) {
    }];
}

- (void)setUI {
    [self.naviView addSubview:self.searchView];
    [self.naviView addSubview:self.btnCancel];
    [self.view addSubview:self.searchTableView];
    [self.view addSubview:self.tableView];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviView).offset(15);
        make.bottom.equalTo(self.naviView).offset(-8);
        make.height.equalTo(@28);
        make.right.equalTo(self.btnCancel.mas_left);
    }];
    
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchView);
        make.right.equalTo(self.naviView);
        make.width.equalTo(@55);
        make.height.equalTo(@28);
    }];
    
    [self.searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - network

//- (void)searchCustomerList:(NSString *)text {
//    // 搜索客户
//    [self.arrData addObject:[[CustomerMo alloc] init]];
//    [self.tableView reloadData];
//}

#pragma mark - SearchTopViewDelegate

- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)searchTopView:(SearchTopView *)searchTopView textFieldShouldReturn:(UITextField *)textField {
    if (self.searchView.searchTxtField.text.length == 0) {
        [Utils showToastMessage:GET_LANGUAGE_KEY(@"搜索内容不能为空")];
        self.tableView.hidden = YES;
        self.searchTableView.hidden = NO;
        return;
    }
    _searchKey = self.searchView.searchTxtField.text;
    [self searchKeyword:NO];
}

- (void)searchTopViewVoiceClick:(SearchTopView *)searchTopView {
    [self.searchView.searchTxtField resignFirstResponder];
    [self.view addSubview:self.iFlyRecognizerView];
}

#pragma mark - IFlyRecognizerViewDelegate

- (void)onResult:(NSArray *)resultArray isLast:(BOOL) isLast {
    NSString *result = @"";
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        result = [result stringByAppendingString:key];
    }
    self.searchView.searchTxtField.text = result;
    [self releaseIFly];
    [self searchTopView:self.searchView textFieldShouldReturn:self.searchView.searchTxtField];
//    [self.searchView.searchTxtField becomeFirstResponder];
}

- (void)onError: (IFlySpeechError *) error {
    if (error.errorCode == 0 ) {
    }else {
        [Utils showToastMessage:error.errorDesc];
    }
    [self releaseIFly];
}

- (void)releaseIFly {
    [_iFlyRecognizerView cancel];
    [_iFlyRecognizerView removeFromSuperview];
    _iFlyRecognizerView = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchView.searchTxtField resignFirstResponder];
}

#pragma mark - SearchTableViewDelegate

/** 点击热门 */
- (void)searchTableView:(SearchTableView *)tableView didSelectedHot:(NSString *)hotStr index:(NSInteger)index indexPath:(NSIndexPath *)indexPath {
    if (self.searchStyle.type == SearchCustomer) {
        if (indexPath.section == 0) {
            // 历史
            _searchKey = hotStr;
            [self searchKeyword:NO];
        } else if (indexPath.section == 1) {
            // 热门
            _searchKey = hotStr;
            _tagMo = self.hotTags[index];
            [self searchKeyword:YES];
        }
    } else {
        _searchKey = hotStr;
        [self searchKeyword:NO];
    }
}

/** 点击记录 */
- (void)searchTableView:(SearchTableView *)tableView didSelectedHistory:(NSString *)historyStr index:(NSInteger)index {
    _searchKey = historyStr;
    [self searchKeyword:NO];
}

/** 滑动事件（隐藏键盘） */
- (void)searchTableViewDidScroll:(SearchTableView *)tableView {
    [self.searchView.searchTxtField resignFirstResponder];
}

#pragma mark - event

- (void)btnCancelClick:(UIButton *)sender {
    [self.searchView.searchTxtField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchKeyword:(BOOL)isTag {
    
    if ([_searchKey isEqualToString:@"H5跳转测试"]) {
        SwitchUrlViewCtrl *vc = [[SwitchUrlViewCtrl alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    self.tableView.hidden = NO;
    self.searchTableView.hidden = YES;
    if (isTag) {
        _searchText = [NSString stringWithFormat:@"LABELSEARCH_%ld", (long)self.tagMo.id];
    } else {
        _searchText = _searchKey;
        [self.searchTableView insertSearchKey:_searchKey];
    }
    self.searchView.searchTxtField.text = _searchKey;
    [Utils showHUDWithStatus:nil];
    [self.searchView.searchTxtField resignFirstResponder];
    _page = 0;
    [self searchPage:_page searchKey:_searchText];
    [self.searchTableView reloadData];
    [self.tableView reloadData];
}

-(void)searchFieldChange:(id)sender{
    self.tableView.hidden = YES;
    self.searchTableView.hidden = NO;
    UITextField* target=(UITextField*)sender;
    _searchKey = target.text;
    if (_searchKey.length == 0) {
        [self.arrData removeAllObjects];
        [self.tableView reloadData];
        return;
    }
}

// 子类实现
- (void)searchPage:(NSInteger)page searchKey:(NSString *)searchKey {
    
}

- (void)tableViewHeaderRefreshAction {
    _page = 0;
    [self searchPage:_page searchKey:_searchText];
}

- (void)tableViewFooterRefreshAction {
    [self searchPage:_page+1 searchKey:_searchText];
}

#pragma mark - setter getter

- (IFlyRecognizerView *)iFlyRecognizerView {
    if (!_iFlyRecognizerView) {
        _iFlyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
        _iFlyRecognizerView.delegate = self;
        //扩展参数
        [_iFlyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        //设置听写模式
        [_iFlyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        //设置最长录音时间
        [_iFlyRecognizerView setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlyRecognizerView setParameter:@"1800" forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlyRecognizerView setParameter:@"1800" forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        //设置采样率，推荐使用16K
        [_iFlyRecognizerView setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        //设置语言 && 只能设置一种语言
        [_iFlyRecognizerView setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
        //设置方言
        [_iFlyRecognizerView setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];
        //设置是否返回标点符号
        [_iFlyRecognizerView setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
        //设置数据返回格式
        [_iFlyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
        //启动识别服务
        [_iFlyRecognizerView start];
    }
    return _iFlyRecognizerView;
}

- (UIButton *)btnCancel {
    if (!_btnCancel) {
        _btnCancel = [[UIButton alloc] init];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        _btnCancel.titleLabel.font = FONT_F16;
        [_btnCancel addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCancel;
}

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:YES];
        _searchView.delegate = self;
        _searchView.searchTxtField.placeholder = self.searchStyle.placeholdStr;
    }
    return _searchView;
}

-(UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = COLOR_B0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = KMagrinBottom;
    }
    return _tableView;
}

- (SearchTableView *)searchTableView {
    if (!_searchTableView) {
        _searchTableView = [[SearchTableView alloc] initWithFrame:CGRectZero];
        _searchTableView.searchTableViewDelegate = self;
        _searchTableView.searchStyle = self.searchStyle;
    }
    return _searchTableView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (NSMutableArray *)hotTags {
    if (!_hotTags) {
        _hotTags = [NSMutableArray new];
    }
    return _hotTags;
}

- (void)setSearchStyle:(SearchStyle *)searchStyle {
    _searchStyle = searchStyle;
    self.searchTableView.searchStyle = _searchStyle;
}

@end
