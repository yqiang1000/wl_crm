//
//  LockSetViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "LockSetViewCtrl.h"
#import "LockScreenViewCtrl.h"
#import "MyCommonCell.h"

@interface LockSetViewCtrl () <UITableViewDelegate, UITableViewDataSource, MyDefaultCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isLockEnable;
@property (nonatomic, assign) BOOL isTouchEnable;
@property (nonatomic, strong) UISwitch *btnSwitch;

@end

@implementation LockSetViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isLockEnable = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_LOCK_ENABLE] boolValue];
    _isTouchEnable = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOUCH_ENABLE] boolValue];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 2 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *identifier = @"openCell";
        MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.labLeft.textColor = COLOR_B1;
            cell.labLeft.font = FONT_F17;
        }
        [cell setLeftText:_isLockEnable ? @"关闭锁屏密码" : @"开启锁屏密码"];
        return cell;
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        static NSString *identifier = @"changeCell";
        MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.labLeft.font = FONT_F17;
        }
        cell.labLeft.textColor = _isLockEnable ? COLOR_B1 : COLOR_B3;
        [cell setLeftText:@"更改锁屏密码"];
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        static NSString *idStr = @"touchCell";
        MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:idStr];
        if (!cell) {
            cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStr];
            cell.labLeft.textColor = COLOR_B1;
            cell.labLeft.font = FONT_F17;
            cell.imgArrow.hidden = YES;
            [cell.contentView addSubview:self.btnSwitch];
            [self.btnSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(-15);
                make.centerY.equalTo(cell.contentView);
            }];
            [cell setLeftText:@"开启指纹解锁"];
        }
        [self.btnSwitch setOn:_isTouchEnable animated:NO];
        return cell;
    }
    else if (indexPath.section == 2) {
        static NSString *identifier = @"registCell";
        MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.labLeft.font = FONT_F17;
        }
        cell.labLeft.textColor = COLOR_B1;
        [cell setLeftText:@"修改密码"];
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = COLOR_B0;
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LockScreenViewCtrl *vc = nil;
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (_isLockEnable) {
            if (_isTouchEnable) {
                __weak __typeof(self)weakSelf = self;
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:GET_LANGUAGE_KEY(@"提示") message:GET_LANGUAGE_KEY(@"关闭锁屏功能的同时也会关闭指纹识别功能") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"继续") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    __strong __typeof(weakSelf) strongSelf = weakSelf;
                    // 关闭
                    LockScreenViewCtrl *vc = [[LockScreenViewCtrl alloc] init];
                    vc.sourceType = SourceClose;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }];
                [alert addAction:action1];
                [alert addAction:action2];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                // 关闭
                vc = [[LockScreenViewCtrl alloc] init];
                vc.sourceType = SourceClose;
            }
        } else {
            // 开启
            vc = [[LockScreenViewCtrl alloc] init];
            vc.sourceType = SourceOpen;
        }
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        // 更改
        if (_isLockEnable) {
            vc = [[LockScreenViewCtrl alloc] init];
            vc.sourceType = SourceChange;
        }
    } else if (indexPath.section == 1) {
        
    }
    if (vc) {
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - MyDefaultCellDelegate


- (void)btnSwitchClick:(UISwitch *)sender {
    
    
    //iOS8.0后才支持指纹识别接口
    if (@available(iOS 8.0, *)) {
        if (kDevice_Is_iPhoneX) {
            sender.on = NO;
            [Utils showToastMessage:@"您的设备不支持指纹解锁"];
            return;
        }
    }else {
        sender.on = NO;
        [Utils showToastMessage:@"您的设备不支持指纹解锁"];
        return;
    }

    // 没有锁屏密码
    if (!_isLockEnable) {
        [Utils showToastMessage:@"开启指纹解锁需要先设置锁屏密码"];
        [sender setOn:NO animated:NO];
        return;
    } else {
        // 有锁屏密码
        LockScreenViewCtrl *vc = nil;
        vc = [[LockScreenViewCtrl alloc] init];
        vc.sourceType = _isTouchEnable ? SourceTouchClose : SourceTouchOpen;
        if (vc) {
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - setter getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_B0;
    }
    return _tableView;
}

- (UISwitch *)btnSwitch {
    if (!_btnSwitch) {
        _btnSwitch = [[UISwitch alloc] init];
        [_btnSwitch addTarget:self action:@selector(btnSwitchClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _btnSwitch;
}

@end
