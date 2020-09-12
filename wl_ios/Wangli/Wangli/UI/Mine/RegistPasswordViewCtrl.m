//
//  RegistPasswordViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/1/25.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "RegistPasswordViewCtrl.h"

@interface RegistPasswordViewCtrl () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *oldField;
@property (nonatomic, strong) UITextField *oneField;
@property (nonatomic, strong) UITextField *twoField;
@property (nonatomic, strong) UIButton *btnOK;

@end

@implementation RegistPasswordViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI {
    [self.view addSubview:self.oldField];
    [self.view addSubview:self.oneField];
    [self.view addSubview:self.twoField];
    [self.view addSubview:self.btnOK];

    [self.oldField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom).offset(30);
        make.height.equalTo(@44.0);
        make.left.equalTo(self.view).offset(15);
        make.centerX.equalTo(self.view);
    }];

    [self.oneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oldField.mas_bottom).offset(15);
        make.height.width.equalTo(self.oldField);
        make.centerX.equalTo(self.oldField);
    }];
    
    [self.twoField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oneField.mas_bottom).offset(15);
        make.height.width.equalTo(self.oldField);
        make.centerX.equalTo(self.oldField);
    }];

    [self.btnOK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.twoField.mas_bottom).offset(40);
        make.height.width.equalTo(self.oldField);
        make.centerX.equalTo(self.oldField);
    }];
    
    UILabel *lab = [UILabel new];
    lab.text = @"*修改成功后，请重新登录";
    lab.textColor = COLOR_B2;
    lab.font = FONT_F13;
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnOK.mas_bottom).offset(20);
        make.left.right.equalTo(self.btnOK);
    }];
}

- (void)btnOKClick:(UIButton *)sender {
    if ([_oldField.text containsString:@" "]||
        [_oneField.text containsString:@" "]||
        [_twoField.text containsString:@" "]) {
        [Utils showToastMessage:@"密码不允许包含空格"];
        return;
    }
    
    if (_oneField.text.length < 6 ||
        _twoField.text.length < 6) {
        [Utils showToastMessage:@"密码长度不能少于6位"];
        return;
    }
    
    if (![_oneField.text isEqualToString:_twoField.text]) {
        [Utils showToastMessage:@"两次新密码输入不一致，请重新输入"];
        _twoField.text = @"";
        return;
    }
    
    if ([_oneField.text isEqualToString:_oldField.text]) {
        [Utils showToastMessage:@"新密码和旧密码一样！"];
        return;
    }
    
    
    NSDictionary *param = @{@"oldPwd":STRING(_oldField.text),
                            @"newPwd":STRING(_oneField.text)};
    [Utils showHUDWithStatus:@"修改中..."];
    [[JYUserApi sharedInstance] updatePasswordParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"修改成功，请重新登录"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self logout];
        });
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)logout {
//    [Utils showHUDWithStatus:nil];
//    JYChatKit *jyChatKit = [JYChatKit shareJYChatKit];
//    [jyChatKit logoutSuccess:^{
//        [Utils dismissHUD];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_LOGOUT_SUCCESS object:nil userInfo:nil];
//    } failure:^(NSString *strMsg) {
//        [Utils dismissHUD];
//    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_oldField resignFirstResponder];
    [_oneField resignFirstResponder];
    [_twoField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text containsString:@" "]) {
        [Utils showToastMessage:@"密码不允许包含空格"];
        return NO;
    }
    
    if ([_oldField isFirstResponder]) {
        [_oneField becomeFirstResponder];
    } else if([_oneField isFirstResponder]) {
        [_twoField becomeFirstResponder];
    } else if ([_twoField isFirstResponder]) {
        if (self.oldField.text.length != 0 &&
            self.oneField.text.length != 0 &&
            self.twoField.text.length != 0) {
            [self btnOKClick:self.btnOK];
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text containsString:@" "])
        [Utils showToastMessage:@"密码不允许包含空格"];
    if (_twoField.text.length != 0 &&
        _oneField.text.length != 0 &&
        _oldField.text.length != 0) {
        self.btnOK.enabled = YES;
    } else {
        self.btnOK.enabled = NO;
    }
}

#pragma mark - lazy

- (UIButton *)btnOK {
    if (!_btnOK) {
        _btnOK = [[UIButton alloc] init];
        _btnOK.titleLabel.font = FONT_F18;
        [_btnOK setBackgroundColor:COLOR_C1];
        [_btnOK setTitle:@"确认" forState:UIControlStateNormal];
        [_btnOK setTitleColor:COLOR_B4 forState:UIControlStateNormal];
        [_btnOK addTarget:self action:@selector(btnOKClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnOK.layer.cornerRadius = 4;
        _btnOK.clipsToBounds = YES;
        _btnOK.enabled = NO;
    }
    return _btnOK;
}

- (UITextField *)oldField {
    if (!_oldField) {
        _oldField = [self setupNewField];
        _oldField.placeholder = @"请输入旧密码";
        _oldField.returnKeyType = UIReturnKeyNext;
    }
    return _oldField;
}

- (UITextField *)oneField {
    if (!_oneField) {
        _oneField = [self setupNewField];
        _oneField.placeholder = @"请输入新密码";
        _oneField.returnKeyType = UIReturnKeyNext;
    }
    return _oneField;
}

- (UITextField *)twoField {
    if (!_twoField) {
        _twoField = [self setupNewField];
        _twoField.placeholder = @"请再次输入新密码";
        _twoField.returnKeyType = UIReturnKeyDone;
    }
    return _twoField;
}

- (UITextField *)setupNewField {
    UITextField *field = [UITextField new];
    field.backgroundColor = COLOR_B4;
    field.layer.cornerRadius = 4;
    field.layer.borderColor = COLOR_B2.CGColor;
    field.layer.borderWidth = 0.5;
    field.clipsToBounds = YES;
    field.font = FONT_F15;
    field.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    field.leftViewMode = UITextFieldViewModeAlways;
    field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    field.secureTextEntry = YES;
    field.delegate = self;
    return field;
}


@end
