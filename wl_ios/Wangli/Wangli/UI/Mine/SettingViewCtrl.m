//
//  SettingViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/27.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "SettingViewCtrl.h"
#import "MyCommonCell.h"
#import "LockSetViewCtrl.h"
#import "AboutViewCtrl.h"
#import "RegistPasswordViewCtrl.h"
#import <SDWebImage/SDWebImage.h>

@interface SettingViewCtrl () <UITableViewDelegate, UITableViewDataSource, MyButtonCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, copy) NSString *cacheStr;

@end

@implementation SettingViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self cacheSize];
}

- (void)cacheSize {
    unsigned long long size = 0;
//    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"CustomFile"].fileSize;
    //fileSize是封装在Category中的。
    
    size += [SDImageCache sharedImageCache].totalDiskSize;   //CustomFile + SDWebImage 缓存
    //设置文件大小格式
    if (size >= pow(10, 9)) {
        self.cacheStr = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
    }else if (size >= pow(10, 6)) {
        self.cacheStr = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
    }else if (size >= pow(10, 3)) {
        self.cacheStr = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
    }else {
        self.cacheStr = [NSString stringWithFormat:@"%lluB", size];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrLeft.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.arrLeft.count-1) {
        return 94;
    }
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
    if (indexPath.row == self.arrLeft.count - 1) {
        static NSString *idStr = @"okCell";
        MyButtonCell*cell = [tableView dequeueReusableCellWithIdentifier:idStr];
        if (!cell) {
            cell = [[MyButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStr];
            cell.cellDelegate = self;
            [cell.btnSave setBackgroundColor:COLOR_C2];
            [cell.btnSave setTitle:self.arrLeft[indexPath.row] forState:UIControlStateNormal];
        }
        return cell;
    }
    
    static NSString *identifier = @"suggestCell";
    MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.labLeft.textColor = COLOR_B1;
        cell.labLeft.font = FONT_F17;
        cell.labRight.textColor = COLOR_B2;
        cell.labRight.font = FONT_F17;
    }
    [cell setLeftText:self.arrLeft[indexPath.row]];
    if (indexPath.row == 2) {
        cell.labRight.text = self.cacheStr;
    }
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
        // app锁屏
        vc = [[LockSetViewCtrl alloc] init];
    } else if (indexPath.row == 1) {
        vc = [[RegistPasswordViewCtrl alloc] init];
    } else if (indexPath.row == 2) {
        if ([_cacheStr isEqualToString:@"0B"]) {
            [Utils showToastMessage:@"无缓存可清除"];
            return;
        }
        // 清除缓存
        [Utils commonDeleteTost:@"提示" msg:@"确定清除缓存吗？" cancelTitle:@"取消" confirmTitle:@"确定" confirm:^{
            [Utils showHUDWithStatus:@"正在清除缓存···"];
            
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [Utils dismissHUD];
                    [Utils showToastMessage:@"清除成功"];
                    // 设置文字
                    [self cacheSize];
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CONTACT_RECENT];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USED_RECETENT];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CLEAN_USED object:nil userInfo:nil];
                });
            }];
        } cancel:^{
            [Utils dismissHUD];
            [Utils showToastMessage:@"清除失败"];
        }];
    }
    else if (indexPath.row == 3) {
        vc = [[AboutViewCtrl alloc] init];
    } else if (indexPath.row == 4) {
        [self checkVersion];
        return;
    }
    if (vc) {
        vc.title = self.arrLeft[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - MyButtonCellDelegate

- (void)cell:(MyButtonCell *)cell btnClick:(UIButton *)sender {
//    [Utils showHUDWithStatus:nil];
//    JYChatKit *jyChatKit = [JYChatKit shareJYChatKit];
//    [jyChatKit logoutSuccess:^{
//        [Utils dismissHUD];
//        [Utils showToastMessage:@"退出登陆成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_LOGOUT_SUCCESS object:nil userInfo:nil];
////        #define NOTIFI_LOGOUT_SUCCESS @"NOTIFICATION_LOGOUT_SUCCESS"
//    } failure:^(NSString *strMsg) {
//        [Utils dismissHUD];
//    }];
}


- (void)checkVersion {
    NSString *version = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *param = @{@"version":STRING(version)};
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] checkVersionParam:param success:^(id responseObject) {
        if (![responseObject[@"remark"] isEqual:[NSNull null]]) {
            [Utils dismissHUD];
            
//                    NSDictionary *responseObject = @{@"remark":@"1",
//                                                     @"message":@"升级测试",
//                                                     @"address":@"https://www.baidu.com"};
            NSInteger remark = [responseObject[@"remark"] integerValue];
            if (remark == 0) {
                [Utils showToastMessage:@"当前版本为最新版本"];
            } else {
                // 1 建议升级
                // 2 强制升级
                NSString *desp = STRING(responseObject[@"desp"]);
                NSString *tost = STRING(responseObject[@"message"]);
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:GET_LANGUAGE_KEY(@"新版本提醒") message:desp.length==0?tost:desp preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action0 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"立即升级") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:VERSION_CHECK_BEGINTIME];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSString *urlStr = STRING(responseObject[@"address"]);
                    if (urlStr.length > 0) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                }];
                [alert addAction:action0];
                
                if (remark == 1) {
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"暂不升级") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:VERSION_CHECK_BEGINTIME];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }];
                    [alert addAction:action1];
                    
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"3日内不再提醒") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSDate *enterBackgroundDate = [NSDate date];
                        [[NSUserDefaults standardUserDefaults] setObject:enterBackgroundDate forKey:VERSION_CHECK_BEGINTIME];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }];
                    [alert addAction:action2];
                }
                
                if ([Utils topViewController].navigationController != nil) {
                    [[Utils topViewController].navigationController presentViewController:alert animated:YES completion:nil];
                }
            }
        }
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
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

- (NSArray *)arrLeft {
    if (!_arrLeft) {
        _arrLeft = @[@"APP锁屏密码",
                     @"修改登录密码",
                     @"清除缓存",
                     @"关于我们",
                     @"版本更新",
                     @"注销"];
    }
    return _arrLeft;
}

@end
