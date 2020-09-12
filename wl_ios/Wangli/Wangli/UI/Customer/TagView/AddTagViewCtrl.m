//
//  AddTagViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/9/7.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "AddTagViewCtrl.h"
#import "TagTableView.h"

@interface AddTagViewCtrl () <TagTableViewDelegate>

@property (nonatomic, strong) TagTableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *fieldView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, assign) BOOL isChange;

@end

@implementation AddTagViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑标签";
    _isChange = NO;
    self.tableView.data0 = self.data0;
    [self setUI];
    [self getHotData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_isChange) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_UPDATE_URL_SUCCESS object:nil];
    }
}

- (void)textFieldChange:(NSNotification *)noti {
    NSString *text = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.btnAdd.enabled = text.length == 0 ? NO : YES;
}

- (void)setUI {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@57);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - networking

- (void)getHotData {
    [[JYUserApi sharedInstance] getLabelPage:0 success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.data removeAllObjects];
        NSError *error = nil;
        self.data = [TagMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        self.tableView.data = self.data;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - TagTableViewDelegate

-(void)tagTableViewDidScrollView:(TagTableView *)tagTableView {
    [self.textField resignFirstResponder];
}

- (void)tagTableView:(TagTableView *)tagTableView didSelectIndexPath:(NSIndexPath *)indexPath {
    [self.textField resignFirstResponder];
    // 已选标签
    if (indexPath.section == 0) {
        TagMo *mo = self.data0[indexPath.row];
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] removeLabelMemberId:TheCustomer.customerMo.id labId:mo.id success:^(id responseObject) {
            [Utils dismissHUD];
            NSError *error = nil;
            self.data0 = [TagMo arrayOfModelsFromDictionaries:responseObject error:&error];
            self.tableView.data0 = self.data0;
            [self.tableView reloadData];
            _isChange = YES;
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
        NSLog(@"已选标签 %@", mo.desp);
    } else if (indexPath.section == 1) {
        // 热门标签
        TagMo *mo = self.data[indexPath.row];
        NSLog(@"热门标签 %@", mo.desp);
        BOOL has = NO;
        for (int i = 0; i < self.data0.count; i++) {
            TagMo *tmpMo = self.data0[i];
            if (tmpMo.id == mo.id) {
                has = YES;
                break;
            }
        }
        if (!has && mo.desp.length != 0) {
            [self addLabelDesp:mo.desp];
        }
    }
}

#pragma mark - event

- (void)btnAddClick:(UIButton *)sender {
    NSString *text = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self addLabelDesp:text];
}

- (void)addLabelDesp:(NSString *)desp {
    [Utils showHUDWithStatus:nil];
    [self.textField resignFirstResponder];
    [[JYUserApi sharedInstance] createLabelMemberId:TheCustomer.customerMo.id desp:desp success:^(id responseObject) {
        [Utils dismissHUD];
        self.textField.text = @"";
        NSError *error = nil;
        self.data0 = [TagMo arrayOfModelsFromDictionaries:responseObject error:&error];
        self.tableView.data0 = self.data0;
        [self.tableView reloadData];
        _isChange = YES;
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];

}

- (void)tableViewHeaderRefreshAction {
    [self getHotData];
}

#pragma mark - lazy

- (TagTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TagTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_B4;
        _tableView.tagDelegate = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
    }
    return _tableView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = COLOR_B4;
        [_topView addSubview:self.fieldView];
        [_topView addSubview:self.btnAdd];
        
        [_fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView).offset(20);
            make.left.equalTo(_topView).offset(15);
            make.height.equalTo(@32);
        }];
        
        [_btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_fieldView);
            make.left.equalTo(_fieldView.mas_right).offset(15);
            make.right.equalTo(_topView.mas_right).offset(-15);
            make.width.equalTo(@30);
            make.height.equalTo(@15);
        }];
    }
    return _topView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"+自定义标签";
        _textField.backgroundColor = COLOR_F4F4F4;
        _textField.font = FONT_F13;
    }
    return _textField;
}

- (UIView *)fieldView {
    if (!_fieldView) {
        _fieldView = [UIView new];
        _fieldView.layer.cornerRadius = 5;
        _fieldView.clipsToBounds = YES;
        _fieldView.backgroundColor = COLOR_F4F4F4;
        [_fieldView addSubview:self.textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_fieldView);
            make.left.equalTo(_fieldView).offset(15);
        }];
    }
    return _fieldView;
}

- (UIButton *)btnAdd {
    if (!_btnAdd) {
        _btnAdd = [[UIButton alloc] init];
        [_btnAdd setTitle:@"添加" forState:UIControlStateNormal];
        _btnAdd.titleLabel.font = FONT_F14;
        [_btnAdd setTitleColor:COLOR_0089D1 forState:UIControlStateNormal];
        [_btnAdd setTitleColor:COLOR_B3 forState:UIControlStateDisabled];
        [_btnAdd addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnAdd.enabled = NO;
    }
    return _btnAdd;
}

- (NSMutableArray<TagMo *> *)data {
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}

- (NSMutableArray<TagMo *> *)data0 {
    if (!_data0) {
        _data0 = [NSMutableArray new];
    }
    return _data0;
}

@end
