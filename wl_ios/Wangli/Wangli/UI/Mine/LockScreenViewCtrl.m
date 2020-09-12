//
//  LockScreenViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/27.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "LockScreenViewCtrl.h"
#import <JhtVerificationCodeView/JhtVerificationCodeView.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface LockScreenViewCtrl ()

@property (nonatomic, strong) JhtVerificationCodeView *verView;
@property (nonatomic, strong) UILabel *labText;
@property (nonatomic, strong) UIButton *btnTouch;
@property (nonatomic, assign) NSInteger maxLenght;

@property (nonatomic, copy) NSString *oldPwd;
@property (nonatomic, copy) NSString *firstPwd;
@property (nonatomic, copy) NSString *secondPwd;

@property (nonatomic, assign) BOOL isLockEnable;
@property (nonatomic, assign) BOOL isTouchEnable;

@property (nonatomic, assign) NSInteger wrongCount; //错误次数

@end

@implementation LockScreenViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"APP锁屏密码";
    
    [self config];
    
    // 设置锁屏
    [self setUI];
    [self refreshView:_lockState];
    [self.verView Jht_BecomeFirstResponder];
    
    __weak __typeof(self)weakSelf = self;
    _verView.editBlcok = ^(NSString *text) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (text.length == strongSelf.maxLenght) {
            LockState state = [strongSelf dealWithPsd:text];
            [strongSelf refreshView:state];
        }
        NSLog(@"输入的验证码为：%@", text);
    };
    if (kDevice_Is_iPhoneX) {
        self.btnTouch.hidden = YES;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)config {
    _maxLenght = 4;
    _isLockEnable = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_LOCK_ENABLE] boolValue];
    _isTouchEnable = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOUCH_ENABLE] boolValue];
    _wrongCount = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_WRONG_COUNT] integerValue];
    if (_sourceType == SourceOpen) {
        _lockState = LockStateFirst;
    } else if (_sourceType == SourceClose) {
        _lockState = LockStateOld;
    } else if (_sourceType == SourceChange) {
        _lockState = LockStateOld;
    } else if (_sourceType == SourceTouchOpen) {
        _lockState = LockStateOld;
    } else if (_sourceType == SourceTouchClose) {
        _lockState = LockStateOld;
    }
}

- (void)setUI {
    
    UIImageView *imgLock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"m_lock_screen"]];
    [self.view addSubview:imgLock];
    
    [self.view addSubview:self.verView];
    [self.view addSubview:self.labText];
    [self.view addSubview:self.btnTouch];
    
    [imgLock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.naviView.mas_bottom).offset(80);
        make.width.equalTo(@25);
        make.height.equalTo(@31);
    }];
    
    [self.verView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(imgLock.mas_bottom).offset(65);
        make.width.equalTo(@(SCREEN_WIDTH-50));
        make.height.equalTo(@50);
    }];
    
    [self.labText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.verView.mas_bottom).offset(35);
    }];
    
    [self.btnTouch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.labText).offset(30);
        make.height.equalTo(@40);
        make.left.equalTo(self.view).offset(15);
    }];
}

- (LockState)dealWithPsd:(NSString *)text {
    // 设置密码
    if (_lockState == LockStateOld) {
        // 验证密码
        _oldPwd = text;
        if ([_oldPwd isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:APP_LOCK_PASS]]) {
            return LockStateFirst;
        } else {
            [Utils showToastMessage:@"密码不正确，请重新输入"];
            self.wrongCount = self.wrongCount + 1;
            return LockStateOld;
        }
    } else if (_lockState == LockStateFirst) {
        _firstPwd = text;
        return LockStateSecond;
    } else if (_lockState == LockStateSecond) {
        _secondPwd = text;
        if ([_firstPwd isEqualToString:_secondPwd]) {
            return LockStateSuccess;
        } else {
            [Utils showToastMessage:@"两次锁屏密码不一致，请重新输入"];
            [self.verView changeAllAlreadyInputTextColorWithColor:COLOR_B2 hasShakeAndClear:YES];
            return LockStateFirst;
        }
    } else {
        return LockStateOld;
    }
}

- (void)refreshView:(LockState)state {
    
    _lockState = state;
    switch (_lockState) {
        case LockStateOld:
        {
            if (_wrongCount == 0) {
                self.labText.textColor = COLOR_B3;
                self.labText.text = @"请输入旧锁屏密码";
            } else {
                self.labText.textColor = COLOR_C2;
                self.labText.text = [NSString stringWithFormat:@"密码不正确，请重新输入 剩余尝试次数:%ld",5-_wrongCount];
                [self.verView changeAllAlreadyInputTextColorWithColor:COLOR_B2 hasShakeAndClear:YES];
            }
            // 记录错误次数
            [[NSUserDefaults standardUserDefaults] setObject:@(_wrongCount) forKey:USER_WRONG_COUNT];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (_wrongCount == 5) {
                [Utils showToastMessage:@"密码输入错误次数过多，请重新登录"];
                [self.verView Jht_ResignFirstResponder];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_LOGOUT_SUCCESS object:nil userInfo:nil];
            }
        }
            break;
        case LockStateFirst:
        {
            self.labText.textColor = COLOR_B3;
            _wrongCount = 0;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_WRONG_COUNT];
            self.labText.text = @"请输入新锁屏密码";
            if (_sourceType == SourceOpen) {
                self.labText.text = @"请输入锁屏密码";
            } else if (_sourceType == SourceClose) {
                [Utils showToastMessage:@"关闭成功"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_LOCK_ENABLE];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_TOUCH_ENABLE];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:APP_LOCK_PASS];
                [[NSUserDefaults standardUserDefaults] synchronize];
                TheUser.isTouchEnable = NO;
                [self.navigationController popViewControllerAnimated:YES];
            } else if (_sourceType == SourceTouchOpen) {
                self.labText.text = @"密码验证成功";
                _lockState = LockStateOld;
                [self.verView Jht_ResignFirstResponder];
                [self evaluateAuthenticate];
            } else if (_sourceType == SourceTouchClose) {
                self.labText.text = @"指纹解锁取消成功";
                _lockState = LockStateOld;
                [Utils showToastMessage:@"指纹解锁取消成功"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_TOUCH_ENABLE];
                [[NSUserDefaults standardUserDefaults] synchronize];
                TheUser.isTouchEnable = NO;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case LockStateSecond:
        {
            self.labText.text = @"请再次输入锁屏密码";
        }
            break;
        case LockStateSuccess:
        {
            NSString *tostStr = @"设置成功";
            if (_sourceType == SourceOpen) {
            } else if (_sourceType == SourceChange) {
                tostStr = @"修改成功";
            }
            self.labText.text = tostStr;
            [Utils showToastMessage:tostStr];
            TheUser.isLockEnable = YES;
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:USER_LOCK_ENABLE];
            [[NSUserDefaults standardUserDefaults] setObject:STRING(_secondPwd) forKey:APP_LOCK_PASS];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.verView Jht_ResignFirstResponder];
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
                    [Utils showToastMessage:@"设置成功"];
                    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:USER_TOUCH_ENABLE];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    TheUser.isTouchEnable = YES;
                    [self.navigationController popViewControllerAnimated:YES];
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
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Utils showToastMessage:@"用户取消"];
                            [self.navigationController popViewControllerAnimated:YES];
                        });
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
        _labText.font = FONT_F13;
        _labText.textColor = COLOR_B3;
    }
    return _labText;
}

- (JhtVerificationCodeView *)verView {
    if (!_verView) {
        _verView = [[JhtVerificationCodeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, 50)];
        _verView.codeViewType = VerificationCodeViewType_Secret;
        _verView.total = _maxLenght;
        _verView.hasUnderLine = YES;
        _verView.isFlashing_NoInput = YES;
        _verView.isClearWhenInputFull = YES;
        _verView.textFont = [UIFont boldSystemFontOfSize:21];
        _verView.boderColor = COLOR_B2;
    }
    return _verView;
}

@end
