//
//  LoginViewController.m
//  Wangli
//
//  Created by yeqiang on 2018/3/28.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "LoginViewController.h"
#import "MyTextView.h"
#import <JSONModel/JSONModel.h>
#import "UIButton+ShortCut.h"
#import "SMSCodeInfo.h"
#import "UIImage+ShortCut.h"

@interface LoginViewController () <MyTextViewDelegate, SMSCodeInfoDelegate>

@property (nonatomic, strong) UIImageView *imgBg;
//@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imgTitle;
@property (nonatomic, strong) UILabel *labForget;

@property (nonatomic, strong) UIButton *btnRemember;
@property (nonatomic, strong) UIButton *btnForget;

@property (nonatomic, strong) MyTextView *phoneView;
@property (nonatomic, strong) MyTextView *passView;

@property (nonatomic, strong) UIButton *btnLogin;

@property (nonatomic, copy) NSString *phoneStr;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviView.hidden = YES;
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.phoneView.txtField.text = [[NSUserDefaults standardUserDefaults] objectForKey:USER_OACODE];
//    self.phoneView.txtField.text = @"guanliyuan";
//    self.passView.txtField.text = @"admin123";// @"XC001940"; //@"WLM16040601";
//    self.btnLogin.enabled = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUI {
    [self.view addSubview:self.imgBg];
//    [self.view addSubview:self.bgView];
    
    [self.view addSubview:self.imgTitle];
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.passView];
    [self.view addSubview:self.btnRemember];
    [self.view addSubview:self.btnLogin];
    [self.view addSubview:self.labForget];
    [self.view addSubview:self.btnForget];
    
    self.labForget.hidden = YES;
    self.btnForget.hidden = YES;
    
    [self.imgBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
//    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.equalTo(self.view);
//    }];
    
    [self.imgTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(110);
        make.centerX.equalTo(self.view);
//        make.height.equalTo(@29.0);
//        make.width.equalTo(@176.0);
    }];
    
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(@55);
        make.top.equalTo(self.imgTitle.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(15);
    }];
    
    [self.passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(@55);
        make.top.equalTo(self.phoneView.mas_bottom);
        make.left.equalTo(self.view).offset(15);
    }];
    
    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(@44);
        make.top.equalTo(self.passView.mas_bottom).offset(45);
        make.left.equalTo(self.view).offset(15);
    }];
    
    [self.btnRemember mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passView.mas_bottom).offset(10);
        make.right.equalTo(self.passView);
        make.height.equalTo(@20);
        make.width.equalTo(@88);
    }];
    
    [self.labForget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnLogin.mas_bottom).offset(15);
        make.right.equalTo(self.btnLogin.mas_centerX).offset(-10);
    }];
    
    [self.btnForget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labForget);
        make.left.equalTo(self.labForget.mas_right).offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
}

#pragma mark - MyTextViewDelegate

- (void)myTextView:(MyTextView *)textView btnRightSelected:(UIButton *)sender {
    if (textView == _passView) {
        
        BOOL isPhone = [Utils isMobileNumber:self.phoneView.txtField.text];
        if (!isPhone) {
            [Utils showToastMessage:@"请输入手机号"];
            return;
        }
        SMSCodeInfo *smsCode = [[SMSCodeInfo alloc] init];
        smsCode.smsCodeInfoDelegate = self;
        [Utils showHUDWithStatus:nil];
        [smsCode getSMSCode:self.phoneView.txtField.text success:^(NSString *code) {
            [Utils dismissHUD];
            smsCode.isCancel = NO;
            [smsCode startCountDown];
        } fail:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:error.userInfo[@"message"]];
        }];
    }
}

- (void)myTextView:(MyTextView *)textView textChanged:(UITextField *)sender {
    if (textView == _phoneView) {
        textView.btnRight.hidden = sender.text.length == 0 ? YES : NO;
        if (sender.text.length >= 20) {
            sender.text = [sender.text substringToIndex:20];
        }
    }
    else if (textView == _passView) {
        if (sender.text.length >= 20) {
            sender.text = [sender.text substringToIndex:20];
        }
    }
    
    BOOL isPhone = [Utils isMobileNumber:self.phoneView.txtField.text] || [Utils isMobileNumber:self.phoneStr];
    self.btnLogin.enabled = isPhone && _passView.txtField.text.length >= 1;
}

#pragma mark - SMSCodeInfoDelegate

- (void)smsCodeInfo:(SMSCodeInfo *)codeInfo timeValue:(int)value {
    self.passView.btnRight.enabled = value == 0 ? YES : NO;
    if (value == 0) {
        [self.passView.btnRight setTitle:@"获取验证码" forState:UIControlStateNormal];
    } else {
        [self.passView.btnRight setTitle:[NSString stringWithFormat:@"重新发送%ds", value] forState:UIControlStateDisabled];
    }
}

#pragma mark - event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.passView.txtField resignFirstResponder];
    [self.phoneView.txtField resignFirstResponder];
}

- (void)btnLoginClick:(UIButton *)sender {
    NSString *userId = [self.phoneView.txtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (userId.length == 0) {
        [Utils showToastMessage:@"用户名不能为空"];
        return;
    }
    NSString *password = [self.passView.txtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (password.length == 0) {
        [Utils showToastMessage:@"密码不能为空"];
        return;
    }
    [self.passView.txtField resignFirstResponder];
    [self.phoneView.txtField resignFirstResponder];
    
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] login:userId smsCode:password success:^(id responseObject) {
        [Utils dismissHUD];
        JYUserMo *userMo = [[JYUserMo alloc] initWithDictionary:responseObject[@"operator"] error:nil];
        userMo.id_token = responseObject[@"id_token"];
        userMo.tim_signature = responseObject[@"tim_signature"];
        TheUser.userMo = userMo;
        TheUser.isLogin = YES;
        [[NSUserDefaults standardUserDefaults] setObject:userMo.tim_signature forKey:USER_SIGN];
        [[NSUserDefaults standardUserDefaults] setObject:[userMo toJSONString] forKey:USER_INFO];
        [[NSUserDefaults standardUserDefaults] setObject:userMo.id_token forKey:APP_TOKEN];
        [[NSUserDefaults standardUserDefaults] setObject:STRING(userMo.oaCode) forKey:USER_OACODE];
        [[NSUserDefaults standardUserDefaults] setObject:STRING(userMo.department[@"name"]) forKey:USER_OFFICENAME];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_WRONG_COUNT];
        
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_ID] isEqualToString:[NSString stringWithFormat:@"%ld",userMo.id]]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", userMo.id] forKey:CURRENT_USER_ID];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:CONTACT_RECENT];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:USED_RECETENT];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_LOGIN_SUCCESS object:nil userInfo:nil];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:error.userInfo[@"message"]];
    }];
}

#pragma mark - setter getter

- (UIImageView *)imgBg {
    if (!_imgBg) {
        _imgBg = [UIImageView new];
        _imgBg.image = [UIImage imageNamed:@"login_bg"];
    }
    return _imgBg;
}

//- (UIView *)bgView {
//    if (!_bgView) {
//        _bgView = [[UIView alloc] init];
//        _bgView.backgroundColor = COLOR_MASK;
//    }
//    return _bgView;
//}

- (UIButton *)btnLogin {
    if (!_btnLogin) {
        _btnLogin = [[UIButton alloc] init];
        [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
        [_btnLogin setTitleColor:COLOR_B4 forState:UIControlStateNormal];
        [_btnLogin setTitleColor:COLOR_CECECE forState:UIControlStateSelected];
        [_btnLogin setTitleColor:COLOR_B4 forState:UIControlStateDisabled];
        [_btnLogin setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0 green:137.0/255 blue:209.0/255 alpha:0.8]] forState:UIControlStateNormal];
        [_btnLogin setBackgroundImage:[UIImage imageWithColor:COLOR_B3] forState:UIControlStateDisabled];
        _btnLogin.layer.cornerRadius = 4;
        _btnLogin.clipsToBounds = YES;
        _btnLogin.enabled = NO;
        _btnLogin.titleLabel.font = FONT_F15;
        [_btnLogin addTarget:self action:@selector(btnLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLogin;
}

- (UIImageView *)imgTitle {
    if (!_imgTitle) {
        _imgTitle = [[UIImageView alloc] init];
//        _imgTitle.backgroundColor = [UIColor colorWithRed:0 green:129.0/255 blue:209.0/255 alpha:0.8];
        _imgTitle.image = [UIImage imageNamed:@"login_logo"];
    }
    return _imgTitle;
}

- (UIButton *)btnRemember {
    if (!_btnRemember) {
        _btnRemember = [[UIButton alloc] init];
        [_btnRemember setTitle:@"记住密码" forState:UIControlStateNormal];
        [_btnRemember setBackgroundColor:COLOR_C1];
        [_btnRemember setTitleColor:COLOR_B3 forState:UIControlStateNormal];
        _btnRemember.hidden = YES;
        _btnRemember.titleLabel.font = FONT_F15;
    }
    return _btnRemember;
}

- (UIButton *)btnForget {
    if (!_btnForget) {
        _btnForget = [[UIButton alloc] init];
        [_btnForget setTitle:@"联系管理员" forState:UIControlStateNormal];
        [_btnForget setTitleColor:COLOR_B4 forState:UIControlStateNormal];
        [_btnForget setImage:[UIImage imageNamed:@"login_contactnumber"] forState:UIControlStateNormal];
        _btnForget.titleLabel.font = FONT_F15;
        [_btnForget imageLeftWithTitleFix:5];
    }
    return _btnForget;
}

- (UILabel *)labForget {
    if (!_labForget) {
        _labForget = [[UILabel alloc] init];
        _labForget.text = @"忘记密码？";
        _labForget.textColor = COLOR_CECECE;
        _labForget.font = FONT_F15;
    }
    return _labForget;
}

- (MyTextView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[MyTextView alloc] init];//UIKeyboardTypeNumberPad
        [_phoneView setupViewWithLeftImage:[UIImage imageNamed:@"login_username"] placeholder:@"用户名" returnType:UIReturnKeyNext keyboardType:UIKeyboardTypeDefault btnType:MyBtnTypeDefault];
        _phoneView.txtField.returnKeyType = UIReturnKeyNext;
        [_phoneView.btnRight setBackgroundImage:[UIImage imageNamed:@"ic_ls_empty_default"] forState:UIControlStateNormal];
        [_phoneView.btnRight setBackgroundImage:[UIImage imageNamed:@"ic_ls_empty_default"] forState:UIControlStateHighlighted];
        _phoneView.btnRight.hidden = YES;
        _phoneView.delegate = self;
        _phoneView.txtField.enabled = YES;
        _phoneView.backgroundColor = COLOR_CLEAR;
    }
    return _phoneView;
}

- (MyTextView *)passView {
    if (!_passView) {
        _passView = [[MyTextView alloc] init];
        [_passView setupViewWithLeftImage:[UIImage imageNamed:@"login_password"] placeholder:@"密码" returnType:UIReturnKeyDone keyboardType:UIKeyboardTypeNumbersAndPunctuation btnType:MyBtnTypeDefault];
        _passView.txtField.returnKeyType = UIReturnKeyDone;
        _passView.txtField.secureTextEntry = YES;
        [_passView.btnRight setImage:[UIImage imageNamed:@"ic_ls_invisible_default"] forState:UIControlStateNormal];
        [_passView.btnRight setImage:[UIImage imageNamed:@"ic_ls_visible_default"] forState:UIControlStateSelected];
//        _passView.txtField.secureTextEntry = YES;
        _passView.delegate = self;
        _passView.backgroundColor = COLOR_CLEAR;
    }
    return _passView;
}


@end
