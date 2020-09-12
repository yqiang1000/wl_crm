

//
//  TouchLoginViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/28.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TouchLoginViewCtrl.h"
#import <JhtVerificationCodeView/JhtVerificationCodeView.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface TouchLoginViewCtrl ()

@property (nonatomic, strong) JhtVerificationCodeView *verView;

@property (nonatomic, strong) UILabel *labText;
@property (nonatomic, strong) UIButton *btnTouch;
@property (nonatomic, strong) UIButton *btnForgot;
@property (nonatomic, strong) UIButton *btnReLogin;
@property (nonatomic, assign) NSInteger maxLenght;

@property (nonatomic, copy) NSString *oldPwd;

@property (nonatomic, assign) BOOL isLockEnable;
@property (nonatomic, assign) BOOL isTouchEnable;

@property (nonatomic, assign) NSInteger wrongCount; //错误次数

@end

@implementation TouchLoginViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviView.hidden = YES;

    [self config];
    
    // 设置锁屏
    [self setUI];
    [self.verView Jht_BecomeFirstResponder];
    
    __weak __typeof(self)weakSelf = self;
    _verView.editBlcok = ^(NSString *text) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (text.length == strongSelf.maxLenght) {
            [strongSelf dealWithPsd:text];
        }
        NSLog(@"输入的验证码为：%@", text);
    };
    
    [self btnTouchClick:self.btnTouch];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)config {
    _maxLenght = 4;
    _isLockEnable = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_LOCK_ENABLE] boolValue];
    _isTouchEnable = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOUCH_ENABLE] boolValue];
    _wrongCount = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_WRONG_COUNT] integerValue];
}

- (void)setUI {
    
    UILabel *labTop  = [UILabel new];
    labTop.font = FONT_F17;
    labTop.textColor = COLOR_B1;
    labTop.text = @"使用指纹或输入密码";
    
    [self.view addSubview:labTop];
    [self.view addSubview:self.verView];
    [self.view addSubview:self.labText];
    [self.view addSubview:self.btnTouch];
    [self.view addSubview:self.btnForgot];
    [self.view addSubview:self.btnReLogin];
    UIView *lineView = [Utils getLineView];
    [self.view addSubview:lineView];
    
    [labTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(110);
    }];
    
    [self.verView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(labTop.mas_bottom).offset(100);
        make.width.equalTo(@170);
        make.height.equalTo(@50);
    }];
    
    [self.labText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.verView.mas_bottom).offset(30);
    }];
    
    [self.btnTouch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.verView.mas_bottom).offset(100);
        make.height.equalTo(@44);
        make.width.equalTo(@280);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@1);
        make.height.equalTo(@14);
        make.bottom.equalTo(self.view).offset(-Height_TabBar);
    }];
    
    [self.btnForgot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.right.equalTo(lineView.mas_left).offset(-20);
        make.height.equalTo(@15);
    }];
    
    [self.btnReLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.left.equalTo(lineView.mas_right).offset(20);
    }];
}

- (void)dealWithPsd:(NSString *)text {
    // 验证密码
    if ([text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:APP_LOCK_PASS]]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_WRONG_COUNT];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_TOUCH_LOGIN_SUCCESS object:nil];
    } else {
        [Utils showToastMessage:@"密码不正确，请重新输入"];
        self.wrongCount = self.wrongCount + 1;
        [self refreshView];
    }
}

- (void)refreshView {
    self.labText.hidden = _wrongCount == 0 ? YES : NO;
    self.labText.text = [NSString stringWithFormat:@"密码错误，还可以输入:%ld次",5-_wrongCount];
    [self.verView changeAllAlreadyInputTextColorWithColor:nil hasShakeAndClear:YES];
    // 记录错误次数
    [[NSUserDefaults standardUserDefaults] setObject:@(_wrongCount) forKey:USER_WRONG_COUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (_wrongCount == 5) {
        [Utils showToastMessage:@"密码输入错误次数过多，请重新登录"];
        [self.verView Jht_ResignFirstResponder];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_LOGOUT_SUCCESS object:nil userInfo:nil];
    }
}

#pragma mark - event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.verView Jht_ResignFirstResponder];
}

- (void)btnTouchClick:(UIButton *)sender {
    [self.verView Jht_ResignFirstResponder];
    //iOS8.0后才支持指纹识别接口
    if (@available(iOS 8.0, *)) {
        if (!kDevice_Is_iPhoneX && _isTouchEnable) {
            self.btnTouch.hidden = NO;
            [self evaluateAuthenticate];
        } else {
            self.btnTouch.hidden = YES;
        }
    }else {
        [Utils showToastMessage:@"您的设备不支持指纹解锁"];
    }
}

- (void)btnForgotClick:(UIButton *)sender {
    [self.verView Jht_ResignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_LOGOUT_SUCCESS object:nil userInfo:nil];
}

- (void)btnReLoginClick:(UIButton *)sender {
    [self.verView Jht_ResignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_LOGOUT_SUCCESS object:nil userInfo:nil];
}

- (void)evaluateAuthenticate
{
    //创建LAContext
    LAContext* context = [[LAContext alloc] init];
    NSError* error = nil;
    NSString* result = @"请验证已有指纹";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_TOUCH_LOGIN_SUCCESS object:nil];
                });
            }
            else
            {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        //系统取消授权，如其他APP切入
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        //授权失败
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        //系统未设置密码
                        break;
                    }
                    case LAErrorTouchIDNotAvailable:
                    {
                        //设备Touch ID不可用，例如未打开
                        break;
                    }
                    case LAErrorTouchIDNotEnrolled:
                    {
                        //设备Touch ID不可用，用户未录入
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            [self.verView Jht_BecomeFirstResponder];
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        //不支持指纹识别，LOG出错误详情
        NSLog(@"不支持指纹识别");
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                [Utils showToastMessage:@"系统无法识别您的指纹，需要重新解锁您的iPhone"];
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
}

#pragma mark - setter getter

- (UILabel *)labText {
    if (!_labText) {
        _labText = [UILabel new];
        _labText.font = FONT_F14;
        _labText.textColor = COLOR_C2;
    }
    return _labText;
}

- (UIButton *)btnTouch {
    if (!_btnTouch) {
        _btnTouch = [[UIButton alloc] init];
        _btnTouch.titleLabel.font = FONT_F17;
        [_btnTouch setTitleColor:COLOR_B4 forState:UIControlStateNormal];
        [_btnTouch setBackgroundColor:COLOR_0089D1];
        [_btnTouch addTarget:self action:@selector(btnTouchClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnTouch setTitle:@"指纹解锁" forState:UIControlStateNormal];
        _btnTouch.layer.cornerRadius = 5;
        _btnTouch.clipsToBounds = YES;
    }
    return _btnTouch;
}

- (UIButton *)btnForgot {
    if (!_btnForgot) {
        _btnForgot = [[UIButton alloc] init];
        _btnForgot.titleLabel.font = FONT_F15;
        [_btnForgot setTitleColor:COLOR_0089D1 forState:UIControlStateNormal];
        [_btnForgot addTarget:self action:@selector(btnForgotClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnForgot setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_btnForgot sizeToFit];
    }
    return _btnForgot;
}

- (UIButton *)btnReLogin {
    if (!_btnReLogin) {
        _btnReLogin = [[UIButton alloc] init];
        _btnReLogin.titleLabel.font = FONT_F15;
        [_btnReLogin setTitleColor:COLOR_0089D1 forState:UIControlStateNormal];
        [_btnReLogin addTarget:self action:@selector(btnReLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnReLogin setTitle:@"重新登录" forState:UIControlStateNormal];
        [_btnReLogin sizeToFit];
    }
    return _btnReLogin;
}

- (JhtVerificationCodeView *)verView {
    if (!_verView) {
        _verView = [[JhtVerificationCodeView alloc] initWithFrame:CGRectMake(0, 0, 170, 50)];
        _verView.codeViewType = VerificationCodeViewType_Secret;
        _verView.total = _maxLenght;
        _verView.hasUnderLine = YES;
        _verView.isFlashing_NoInput = YES;
        _verView.isClearWhenInputFull = YES;
        _verView.textFont = [UIFont boldSystemFontOfSize:16];
        _verView.boderColor = COLOR_B2;
    }
    return _verView;
}

@end
