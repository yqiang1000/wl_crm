
//
//  ContactDetailViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/6/7.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ContactDetailViewCtrl.h"
#import "MyCommonCell.h"
#import "NewContactViewCtrl.h"
#import "UIButton+ShortCut.h"
#import "BottomView.h"
#import "ChatViewController.h"
#import "BaseWebViewCtrl.h"

@interface ContactDetailViewCtrl () <UITableViewDelegate, UITableViewDataSource, MyTextFieldCellDelegate>

{
    NSInteger _topCount;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) UITextField *txtField;

@property (nonatomic, strong) NSMutableArray *arrTel;
@property (nonatomic, strong) NSMutableArray *arrValues;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSMutableArray *arrUsed;

@end

@implementation ContactDetailViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    _topCount = 3;
    [self setUI];
    self.title = @"联系人详情";
    
    if (_mo) {
        [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:COLOR_B4 forState:UIControlStateNormal];
    } else {
        self.rightBtn.hidden = YES;
    }
//    [self seaveToLocal];
}

- (void)seaveToLocal {
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CONTACT_RECENT];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    if (_mo) {
        // 查找是否存在 联系人
        [self.arrUsed enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *key = obj[@"key"];
            if ([key isEqualToString:@"1"]) {
                ContactMo *tmpMo = obj[@"value"];
                if (tmpMo.id == _mo.id) {
                    [self.arrUsed removeObject:obj];
                    *stop = YES;
                }
            }
        }];
        
        [self.arrUsed insertObject:@{@"key":@"1",
                                     @"value":_mo} atIndex:0];
    } else {
        // 查找是否存在 操作员
        [self.arrUsed enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *key = obj[@"key"];
            if ([key isEqualToString:@"2"]) {
                JYUserMo *tmpMo = obj[@"value"];
                if (tmpMo.id == _userMo.id) {
                    [self.arrUsed removeObject:obj];
                    *stop = YES;
                }
            }
        }];
        
        [self.arrUsed insertObject:@{@"key":@"2",
                                     @"value":_userMo} atIndex:0];
    }
    
    
    // 防止点击次数过多，一直在保存本地操作
    static BOOL save = YES;
    if (save) {
        save = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *newArr = [NSMutableArray new];
            
            NSInteger total = self.arrUsed.count <= 10 ? self.arrUsed.count : 10;
            for (int i = 0; i < total; i++) {
                NSDictionary *dic = self.arrUsed[i];
                if ([dic[@"key"] isEqualToString:@"1"]) {
                    ContactMo *tmpMo = dic[@"value"];
                    [newArr addObject:@{@"key":@"1",
                                        @"value":[tmpMo toJSONString]}];
                } else {
                    JYUserMo *tmpMo = dic[@"value"];
                    [newArr addObject:@{@"key":@"2",
                                        @"value":[tmpMo toJSONString]}];
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:newArr forKey:CONTACT_RECENT];
            [[NSUserDefaults standardUserDefaults] synchronize];
            save = YES;
        });
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (_mo) {
        [self getContactDetail];
    } else {
        [self getUserDetail];
    }
}

- (void)getContactDetail {
    [[JYUserApi sharedInstance] getContactDetailById:_mo.id success:^(id responseObject) {
        _mo = [[ContactMo alloc] initWithDictionary:responseObject error:nil];
        [_arrTel removeAllObjects];
        _arrTel = nil;
        [_arrValues removeAllObjects];
        _arrValues = nil;
        [self.tableView reloadData];
        [self seaveToLocal];
    } failure:^(NSError *error) {
    }];
}

- (void)getUserDetail {
    [[JYUserApi sharedInstance] getOperatorDetail:_userMo.id success:^(id responseObject) {
        _userMo = [[JYUserMo alloc] initWithDictionary:responseObject error:nil];
        [_arrTel removeAllObjects];
        _arrTel = nil;
        [_arrValues removeAllObjects];
        _arrValues = nil;
        [self.tableView reloadData];
        [self seaveToLocal];
    } failure:^(NSError *error) {
        
    }];
//    [self.tableView reloadData];
//    [self seaveToLocal];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kDevice_Is_iPhoneX?(44+KMagrinBottom):44));
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//_mo ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_mo) {
        return self.arrLeft.count + self.arrTel.count - 1;
    } else {
        return section == 0 ? (self.arrLeft.count + self.arrTel.count - 1) : 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_mo) {
        if (indexPath.row == self.arrValues.count + self.arrTel.count - 2) {
            static NSString *identifier = @"defaultCell";
            MyDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MyDefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                [cell setLeftText:self.arrLeft[9]];
                cell.labLeft.textColor = COLOR_B3;
            }
            [cell.btnSwitch setOn:[self.arrValues[9] boolValue] animated:YES];
            cell.btnSwitch.enabled = NO;
            return cell;
        }
    }
    
    static NSString *identifier = @"MyTextFieldCell";
    MyTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.cellDelegate = self;
    }
    cell.imgArrow.hidden = YES;
    cell.btnRight.hidden = YES;
    cell.indexPath = indexPath;
    
    if (indexPath.section==1) {
        cell.labLeft.text = @"员工360";
        cell.labLeft.textColor = COLOR_C1;
        return cell;
    }
    
    if (indexPath.row < _topCount) {
        [cell setLeftText:self.arrLeft[indexPath.row]];
        cell.txtRight.placeholder = self.arrRight[indexPath.row];
        ShowTextMo *showTextMo = [Utils showTextRightStr:@"" valueStr:self.arrValues[indexPath.row]];
        cell.txtRight.text = showTextMo.text;
    } else if (indexPath.row >= _topCount && indexPath.row < _topCount+self.arrTel.count) {
        // row从 _topCount(3) 往后 _arrTel.count 个
        cell.labLeft.hidden = indexPath.row == _topCount ? NO : YES;
        cell.btnRight.hidden = YES;
        [cell.btnRight setImage:[UIImage imageNamed:indexPath.row == _topCount ? @"client_add" : @"phone_delete"] forState:UIControlStateNormal];
        [cell setLeftText:self.arrLeft[_topCount]];
        cell.txtRight.placeholder = self.arrRight[_topCount];
        ShowTextMo *showTextMo = [Utils showTextRightStr:@"" valueStr:self.arrTel[indexPath.row - _topCount]];
        cell.txtRight.text = showTextMo.text;
    } else {
        cell.labLeft.hidden = NO;
        cell.btnRight.hidden = YES;
        // row 从 _topCount(3) + _arrTele.count 往后
        NSInteger index = indexPath.row - self.arrTel.count + 1;
        [cell setLeftText:self.arrLeft[index]];
        
        ShowTextMo *showTextMo = [Utils showTextRightStr:@"" valueStr:self.arrValues[index]];
        cell.txtRight.placeholder = self.arrRight[index];
        cell.txtRight.text = showTextMo.text;
    }
    cell.labLeft.textColor = COLOR_B3;
    cell.txtRight.textColor = COLOR_B1;
    [cell.txtRight mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.labLeft.mas_right).offset(44);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_userMo && indexPath.section == 1 && indexPath.row == 0) {
        BaseWebViewCtrl *vc = [[BaseWebViewCtrl alloc] init];
        NSString *urlStr = [NSString stringWithFormat:@"%@id=%ld&name=%@&token=%@", CLERRK_360, (long)_userMo.id, _userMo.name, [Utils token]];
        vc.urlStr = urlStr;
        vc.titleStr = _userMo.name;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_txtField resignFirstResponder];
}

#pragma mark - MyTextFieldCellDelegate

- (void)cell:(MyTextFieldCell *)cell textFieldShouldReturn:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    _txtField = textField;
}

- (void)cell:(MyTextFieldCell *)cell textFieldDidBeginEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    [textField resignFirstResponder];
}

- (void)cell:(MyTextFieldCell *)cell textFieldDidEndEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
}

- (void)cell:(MyTextFieldCell *)cell btnClick:(UIButton *)sender indexPath:(NSIndexPath *)indexPath {
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    NewContactViewCtrl *vc = [[NewContactViewCtrl alloc] init];
    vc.mo = _mo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnSendMsgClick:(UIButton *)sender {
    if (_userMo) {
        TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
        data.convId = _userMo.timIdentifier;
        data.convType = TIM_C2C;
        data.title = _userMo.name;
        ChatViewController *chat = [[ChatViewController alloc] init];
        chat.conversationData = data;
        chat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chat animated:YES];
    }
}

- (void)btnCallClick:(UIButton *)sender {
    if (self.arrTel.count == 0) {
        [Utils showToastMessage:@"没有手机号"];
        return;
    }
    
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) items:self.arrTel defaultItem:-1 itemClick:^(NSInteger index) {
        
        NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"tel:%@", self.arrTel[index]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    } cancelClick:^(BottomView *obj) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    
    [bottomView show];
}

#pragma mark - setter getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_B0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"暂无",
                      @"暂无",
                      @"暂无",
                      @"暂无",
                      @"暂无",
                      
                      @"暂无",
                      @"暂无",
                      @"暂无",
                      @"暂无",
                      @"重要联系人"];
    }
    return _arrRight;
}

- (NSArray *)arrLeft {
    if (!_arrLeft) {
        if (_mo) {
            _arrLeft = @[@"姓名",
                         @"性别",
                         @"生日",
                         @"手机",
                         @"邮箱",
                         
                         @"地址",
                         @"部门",
                         @"职务",
                         @"客户",
                         @"重要联系人"];
        } else {
            _arrLeft = @[@"姓名",
                         @"性别",
                         @"生日",
                         @"手机",
                         @"邮箱",
                         
                         @"地址",
                         @"部门",
                         @"职务"];
        }
    }
    return _arrLeft;
}

- (NSMutableArray *)arrValues {
    if (!_arrValues) {
        _arrValues = [NSMutableArray new];
        for (int i = 0; i < self.arrLeft.count; i++) {
            [_arrValues addObject:@"demo"];
        }
        
        // 客户联系人
        if (_mo) {
            [_arrValues replaceObjectAtIndex:0 withObject:STRING(_mo.name)];
            [_arrValues replaceObjectAtIndex:1 withObject:STRING(_mo.sex)];
            
            NSArray *arr = [_mo.birthday componentsSeparatedByString:@"T"];
            [_arrValues replaceObjectAtIndex:2 withObject:STRING([arr firstObject])];
            [_arrValues replaceObjectAtIndex:4 withObject:STRING(_mo.email)];
            [_arrValues replaceObjectAtIndex:5 withObject:STRING(_mo.address)];
            [_arrValues replaceObjectAtIndex:6 withObject:STRING(_mo.office[@"name"])];
            [_arrValues replaceObjectAtIndex:7 withObject:STRING(_mo.duty)];
            [_arrValues replaceObjectAtIndex:8 withObject:STRING(_mo.member[@"orgName"])];
            [_arrValues replaceObjectAtIndex:9 withObject:@(_mo.important)];
        }
        else {
            // 操作员
            [_arrValues replaceObjectAtIndex:0 withObject:STRING(_userMo.name)];
            if (_userMo.sex != nil) {
                [_arrValues replaceObjectAtIndex:1 withObject:[_userMo.sex isEqualToString:@"FEMALE"] ? @"女" : @"男"];
            }
            NSArray *arr = [_userMo.birthday componentsSeparatedByString:@"T"];
            [_arrValues replaceObjectAtIndex:2 withObject:STRING([arr firstObject])];
            [_arrValues replaceObjectAtIndex:4 withObject:STRING(_userMo.email)];
            [_arrValues replaceObjectAtIndex:5 withObject:STRING(_userMo.address)];
            [_arrValues replaceObjectAtIndex:6 withObject:STRING(_userMo.department[@"name"])];
            [_arrValues replaceObjectAtIndex:7 withObject:STRING(_userMo.position[@"desp"])];
        }
    }
    return _arrValues;
}

- (NSMutableArray *)arrTel {
    if (!_arrTel) {
        _arrTel = [[NSMutableArray alloc] init];
        if (_mo) {
            if (_mo.phoneOne) [_arrTel addObject:STRING(_mo.phoneOne)];
            if (_mo.phoneTwo) [_arrTel addObject:STRING(_mo.phoneTwo)];
            if (_mo.phoneThree) [_arrTel addObject:STRING(_mo.phoneThree)];
            if (_mo.phoneFour) [_arrTel addObject:STRING(_mo.phoneFour)];
        } else if (_userMo) {
            if (_userMo.telOne) [_arrTel addObject:STRING(_userMo.telOne)];
            if (_userMo.telTwo) [_arrTel addObject:STRING(_userMo.telTwo)];
            if (_userMo.telThree) [_arrTel addObject:STRING(_userMo.telThree)];
        }
    }
    return _arrTel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = COLOR_B4;
        
        UIView *lineView = [Utils getLineView];
        [_bottomView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomView);
            make.centerX.equalTo(_bottomView);
            make.width.equalTo(@0.5);
            make.height.equalTo(@44);
        }];
        
        UIButton *btnSendMsg = [[UIButton alloc] init];
        [btnSendMsg setImage:[UIImage imageNamed:@"send_message"] forState:UIControlStateNormal];
        [btnSendMsg setTitle:@"发消息" forState:UIControlStateNormal];
        [btnSendMsg setTitleColor:COLOR_C1 forState:UIControlStateNormal];
        
        [btnSendMsg setImage:[UIImage imageNamed:@"send_message_n"] forState:UIControlStateSelected];
        [btnSendMsg setTitleColor:COLOR_B2 forState:UIControlStateSelected];
        [btnSendMsg setTitleColor:COLOR_B2 forState:UIControlStateHighlighted];
        
        [btnSendMsg setImage:[UIImage imageNamed:@"send_message_n"] forState:UIControlStateDisabled];
        [btnSendMsg setTitleColor:COLOR_B2 forState:UIControlStateDisabled];
        [btnSendMsg imageLeftWithTitleFix:10];
        
        [btnSendMsg addTarget:self action:@selector(btnSendMsgClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btnSendMsg];
        [btnSendMsg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(_bottomView);
            make.height.equalTo(lineView);
            make.right.equalTo(lineView.mas_left);
        }];
        
        UIButton *btnCall = [[UIButton alloc] init];
        [btnCall setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
        [btnCall setTitle:@"打电话" forState:UIControlStateNormal];
        [btnCall setTitleColor:COLOR_C1 forState:UIControlStateNormal];
        
        [btnCall setImage:[UIImage imageNamed:@"phone_n"] forState:UIControlStateSelected];
        [btnCall setTitleColor:COLOR_B2 forState:UIControlStateSelected];
        [btnCall setTitleColor:COLOR_B2 forState:UIControlStateHighlighted];
        [btnCall imageLeftWithTitleFix:10];
        [btnCall addTarget:self action:@selector(btnCallClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btnCall];
        [btnCall mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(_bottomView);
            make.height.equalTo(btnSendMsg);
            make.left.equalTo(lineView.mas_right);
        }];
        
        if (_mo) {
            btnSendMsg.enabled = NO;
        }
//        if ([_userMo.userId isEqualToString:[JYChatKit shareJYChatKit].host.userId]) {
//            btnSendMsg.enabled = NO;
//            btnCall.enabled = NO;
//        }
        
    }
    return _bottomView;
}


- (NSMutableArray *)arrUsed {
    if (!_arrUsed) {
        _arrUsed = [[NSMutableArray alloc] initWithCapacity:8];
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:CONTACT_RECENT];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            // 联系人
            if ([dic[@"key"] isEqualToString:@"1"]) {
                ContactMo *mo = [[ContactMo alloc] initWithString:dic[@"value"] error:nil];
                [_arrUsed addObject:@{@"key":@"1",
                                      @"value":mo}];
            } else {
                // 操作员
                JYUserMo *mo = [[JYUserMo alloc] initWithString:dic[@"value"] error:nil];
                [_arrUsed addObject:@{@"key":@"2",
                                      @"value":mo}];
            }
        }
    }
    return _arrUsed;
}


@end
