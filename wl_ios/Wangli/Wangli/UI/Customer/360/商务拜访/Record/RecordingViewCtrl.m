//
//  RecordingViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/28.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RecordingViewCtrl.h"
#import "RecordHistoryViewCtrl.h"
#import "RecordHelper.h"
#import "ConvertAudioFile.h"
#import "PlayerManager.h"

@interface RecordingViewCtrl () <AVAudioPlayerDelegate, RecordHelperDelegate, ETPlayerDelagate>

@property (nonatomic, strong) UIView *baseView;         // 底部视图
@property (nonatomic, strong) UIView *btnView;          // 取消确定底部
@property (nonatomic, strong) UILabel *labTime;         // 点击录音 & 00:00
@property (nonatomic, strong) UIButton *btnRecord;      // 开始录音
@property (nonatomic, strong) UIButton *btnCancel;      // 取消
@property (nonatomic, strong) UIButton *btnConfirm;     // 确定
@property (nonatomic, strong) UIButton *btnHistory;     // 历史

@property (nonatomic, strong) UIButton *btnStart;       // 暂停 && 播放
@property (nonatomic, assign) BOOL isRecord;            // 是否在录音

@property (nonatomic, assign) NSInteger timeCount;      // 计时
@property (nonatomic, assign) NSInteger playCount;      // 播放计时
@property (nonatomic, strong) NSTimer *timer;           // 计时器
@property (nonatomic, strong) CAShapeLayer *pathLayer;  // 录制动画

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSTimer *playTimer;

@end

@implementation RecordingViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviView.hidden = YES;
    _isRecord = NO;
    _timeCount = 0;
    _playCount = 0;
    [RecordHelper sharedInstance].delegate = self;
    [PlayerManager sharedInstance].delegate = self;
    [self setUI];
    [self configReview];
    [self showView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopTimer];
    [[PlayerManager sharedInstance] stop];
    [[ConvertAudioFile sharedInstance] sendEndRecord];
    [PlayerManager destoryInstance];
    [RecordHelper destoryInstance];
}

- (void)configReview {
    if (!_voiceMo) {
        return;
    }
    self.labTime.text = [Utils getTimeByCount:_voiceMo.extData];
    self.labTime.font = FONT_F14;
    
    [self.labTime mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(15);
    }];
//    [self.baseView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(180+KMagrinBottom));
//        make.bottom.equalTo(self);
//    }];
//    [self.btnStart mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.width.equalTo(@0.0);
//    }];
//    [self.btnHistory mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.width.equalTo(@0.0);
//    }];
    [self.btnRecord mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@80.0);
    }];
//    [self.btnView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@());
//    }];
    
    self.btnRecord.selected = YES;
    self.btnRecord.hidden = NO;
    self.btnStart.hidden = YES;
    self.btnHistory.hidden = YES;
}

#pragma mark - SetUI

- (void)setUI {
    [self.view addSubview:self.baseView];
    [self.baseView addSubview:self.labTime];
    [self.baseView addSubview:self.btnStart];
    [self.baseView addSubview:self.btnHistory];
    [self.baseView addSubview:self.btnRecord];
    [self.baseView addSubview:self.btnView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@0.0);
        make.bottom.equalTo(self.view);
    }];
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(20);
        make.centerX.equalTo(self.baseView);
        make.width.equalTo(@100.0);
    }];
    
    [self.btnStart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labTime.mas_bottom).offset(60);
        make.centerX.equalTo(self.baseView);
        make.width.height.equalTo(@80.0);
    }];

    [self.btnHistory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView.mas_right).offset(-69);
        make.centerY.equalTo(self.btnStart);
        make.width.height.equalTo(@38.0);
    }];
    
    [self.btnRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labTime.mas_bottom).offset(55);
        make.centerX.equalTo(self.baseView);
        make.width.height.equalTo(@0.0);
    }];
    
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView);
        make.height.equalTo(@0.0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.left.right.equalTo(self.baseView);
    }];
}

#pragma mark - ETPlayerDelagate

- (void)currentPlayerStatus:(ETPlayerStatus)playerStatus {
    if (playerStatus == ETPlayer_FinishedPlay) {
        [self stopTimer];
        _playCount = 0;
        self.btnRecord.selected = NO;
        self.labTime.text = [Utils getTimeByCount:_timeCount];
        [self setUpAnimationLayerCurrentCount:0 totalCount:_timeCount];
    }
}

#pragma mark - 开始定时器

- (void)startTimer {
    [self stopTimer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 结束定时器

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (_playTimer) {
        [_playTimer invalidate];
        _playTimer = nil;
    }
}

#pragma mark - 录制计时

- (void)timerMethod {
    _timeCount = _timeCount + 1;
    self.labTime.text = [Utils getTimeByCount:_timeCount];
    if (_timeCount >= MAX_RECORD_COUNT) {
        [self stopTimer];
        [Utils showToastMessage:@"达到最大时长"];
        [[RecordHelper sharedInstance] stopRecord];
        [[ConvertAudioFile sharedInstance] sendEndRecord];
        _btnRecord.enabled = NO;
        _btnRecord.selected = NO;
    }
    [self setUpAnimationLayerCurrentCount:_timeCount totalCount:MAX_RECORD_COUNT];
}

//#pragma mark - RecordHelperDelegate
//
//- (void)recordHelperFinishPlay {
//    [self stopTimer];
//    _playCount = 0;
//    [[RecordHelper sharedInstance] playerStop];
//    [[ConvertAudioFile sharedInstance] sendEndRecord];
//    self.btnRecord.selected = NO;
//    self.labTime.text = [Utils getTimeByCount:_timeCount];
//    [self setUpAnimationLayerCurrentCount:0 totalCount:_timeCount];
//
//}

#pragma mark - StartAction

- (void)btnStartClick:(UIButton *)sender {
    if (![[RecordHelper sharedInstance] canRecord]) {
        [Utils showToastMessage:@"请在iPhone的\"设置-隐私-麦克风\"选项中，允许访问你的手机麦克风"];
        return;
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        self.labTime.text = @"00:00";
        self.labTime.font = FONT_F14;
        [self.labTime mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.baseView).offset(15);
        }];
        [self.baseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(180+KMagrinBottom));
            make.bottom.equalTo(self);
        }];
        [self.btnStart mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@0.0);
        }];
        [self.btnHistory mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@0.0);
        }];
        [self.btnRecord mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@80.0);
        }];
        [self.btnView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(KMagrinBottom+44));
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.btnRecord.selected = YES;
        self.btnRecord.hidden = NO;
        self.btnStart.hidden = YES;
        self.btnHistory.hidden = YES;
        _isRecord = YES;
        self.filePath = [[RecordHelper sharedInstance] getCurrentRecordPath];
        [[RecordHelper sharedInstance] startRecord];
        [[ConvertAudioFile sharedInstance] conventToMp3WithCafFilePath:self.filePath mp3FilePath:[RecordHelper sharedInstance].mp3Path sampleRate:ETRECORD_RATE callback:^(BOOL result) {
        }];
        [self startTimer];
    }];
}

#pragma mark - 暂停和播放

- (void)btnRecordClick:(UIButton *)sender {
    if ([RecordHelper sharedInstance].isRecording) {
        [[RecordHelper sharedInstance] stopRecord];
        [[ConvertAudioFile sharedInstance] sendEndRecord];
        _isRecord = NO;
    }
    
    self.btnConfirm.enabled = YES;
    self.btnRecord.selected = !self.btnRecord.selected;
    
    if (_btnRecord.selected) {
        // 播放
        [PlayerManager sharedInstance].voiceUrl = self.filePath;
        [[PlayerManager sharedInstance] startPlay];
        // 初始化播放器
        if (_playTimer == nil) {
            self.playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playTimerCount:) userInfo:nil repeats:YES];
        }
        else [self.playTimer setFireDate:[NSDate distantPast]];
    } else {
        // 暂停
        [[PlayerManager sharedInstance] pause];
        [self stopTimer];
    }
}

- (void)playTimerCount:(NSTimer *)timer {
    _playCount++;
    if (_playCount > _timeCount) {
        [self stopTimer];
        _playCount = 0;
        [[PlayerManager sharedInstance] stop];
        [[ConvertAudioFile sharedInstance] sendEndRecord];
        self.btnRecord.selected = NO;
        self.labTime.text = [Utils getTimeByCount:_timeCount];
        [self setUpAnimationLayerCurrentCount:0 totalCount:_timeCount];
        return;
    }
    self.labTime.text = [Utils getTimeByCount:_playCount];
    [self setUpAnimationLayerCurrentCount:_playCount totalCount:_timeCount];
}

#pragma mark - 取消录音

- (void)btnCancelClick:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定取消该录音？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self hidenView];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [[Utils topViewController] presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 确定

- (void)btnConfirmClick:(UIButton *)sender {
    [[PlayerManager sharedInstance] pause];
    [self stopTimer];
    // 处理录制结果
    if (_delegate && [_delegate respondsToSelector:@selector(recordingViewCtrlConfirmAction:fileName:mp3Path:count:)]) {
        [_delegate recordingViewCtrlConfirmAction:self fileName:[RecordHelper sharedInstance].fileName mp3Path:[RecordHelper sharedInstance].mp3Path count:_timeCount];
        [self hidenView];
    }
}

#pragma mark - 选择历史记录

- (void)btnHistoryClick:(UIButton *)sender {
    RecordHistoryViewCtrl *vc = [[RecordHistoryViewCtrl alloc] init];
    [[Utils topViewController].navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 弹出动画

- (void)showView {
    [self.view layoutIfNeeded];
    self.view.backgroundColor = COLOR_CLEAR;
    [UIView animateWithDuration:0.35 animations:^{
        self.view.backgroundColor = COLOR_MASK;
        [self.baseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(148+KMagrinBottom));
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (_voiceMo) {
            self.filePath = _voiceMo.url;
            [PlayerManager sharedInstance].voiceUrl = self.filePath;
            _timeCount = _voiceMo.extData;
            [self btnRecordClick:self.btnRecord];
        }
    }];
}

#pragma mark - 隐藏动画

- (void)hidenView {
    [UIView animateWithDuration:0.35 animations:^{
        self.view.backgroundColor = [UIColor clearColor];
        [self.baseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.0);
        }];
        
        [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.0);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [[RecordHelper sharedInstance] releaseResource];
        [[PlayerManager sharedInstance] resetPlayer];
        if (_delegate && [_delegate respondsToSelector:@selector(recordingViewCtrlwDismiss:)]) {
            [_delegate recordingViewCtrlwDismiss:self];
        }
    }];
}

#pragma mark - 点击灰色区域

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
    point = [self.baseView.layer convertPoint:point fromLayer:self.view.layer];
    if (![self.baseView.layer containsPoint:point]) {
        if (_voiceMo) {
            [self hidenView];
        }
        if (!_isRecord && ![PlayerManager sharedInstance].isPlaying) [self hidenView];
    }
}

#pragma mark - 录制以及播放动画

-(void)setUpAnimationLayerCurrentCount:(NSInteger)currentCount totalCount:(NSInteger)totalCount {
    if (totalCount == 0) {
        totalCount = 1;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:self.btnRecord.center radius:40 startAngle:-M_PI_2 endAngle:-M_PI_2+ (2*M_PI*currentCount*1.0/totalCount) clockwise:YES];
    //参数依次是：圆心坐标，半径，开始弧度，结束弧度   画线方向：yes为顺时针，no为逆时针
    if (self.pathLayer == nil) {
        self.pathLayer = [CAShapeLayer layer];
        _pathLayer.strokeColor = COLOR_15A4F1.CGColor;//画线颜色
        _pathLayer.fillColor = [[UIColor clearColor] CGColor];//填充颜色
        _pathLayer.lineJoin = kCALineCapRound;
        _pathLayer.lineWidth = 3.0f;
        [self.baseView.layer addSublayer:_pathLayer];
    }
    _pathLayer.path = path.CGPath;
}

#pragma mark - 初始化

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180+KMagrinBottom)];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.mask = [Utils drawContentFrame:_baseView.bounds corners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:10];
    }
    return _baseView;
}

- (UIButton *)btnStart {
    if (!_btnStart) {
        _btnStart = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_btnStart setTitleColor:COLOR_0095DA forState:UIControlStateNormal];
        [_btnStart setImage:[UIImage imageNamed:@"sound_recording_def"] forState:UIControlStateNormal];
        [_btnStart addTarget:self action:@selector(btnStartClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnRecord.hidden = NO;
    }
    return _btnStart;
}

- (UIButton *)btnRecord {
    if (!_btnRecord) {
        _btnRecord = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_btnRecord setTitleColor:COLOR_0095DA forState:UIControlStateNormal];
        [_btnRecord setImage:[UIImage imageNamed:@"recording"] forState:UIControlStateSelected];
        [_btnRecord setImage:[UIImage imageNamed:@"stop_recording"] forState:UIControlStateNormal];
        [_btnRecord addTarget:self action:@selector(btnRecordClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnRecord.hidden = YES;
    }
    return _btnRecord;
}

- (UIButton *)btnCancel {
    if (!_btnCancel) {
        _btnCancel = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel setTitleColor:COLOR_15A4F1 forState:UIControlStateNormal];
        [_btnCancel setBackgroundColor:COLOR_B4];
        _btnCancel.titleLabel.font = FONT_F15;
        [_btnCancel addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCancel;
}

- (UIButton *)btnConfirm {
    if (!_btnConfirm) {
        _btnConfirm = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
        [_btnConfirm setTitleColor:COLOR_B3 forState:UIControlStateNormal];
        [_btnConfirm setBackgroundColor:COLOR_B4];
        _btnConfirm.titleLabel.font = FONT_F15;
        [_btnConfirm addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnConfirm;
}

- (UIButton *)btnHistory {
    if (!_btnHistory) {
        _btnHistory = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnHistory setImage:[UIImage imageNamed:@"voice_recording"] forState:UIControlStateNormal];
        [_btnHistory setBackgroundColor:COLOR_B4];
        [_btnHistory addTarget:self action:@selector(btnHistoryClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnHistory;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [UILabel new];
        _labTime.font = FONT_F14;
        _labTime.textColor = COLOR_B1;
        _labTime.textAlignment = NSTextAlignmentCenter;
        _labTime.text = @"点击录音";
    }
    return _labTime;
}

- (UIView *)btnView {
    if (!_btnView) {
        _btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KMagrinBottom+44)];
        _btnView.backgroundColor = COLOR_B4;
        [_btnView addSubview:self.btnCancel];
        [_btnView addSubview:self.btnConfirm];
        UIView *topLine = [Utils getLineView];
        UIView *midLine = [Utils getLineView];
        [_btnView addSubview:topLine];
        [_btnView addSubview:midLine];
        
        
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_btnView);
            make.height.equalTo(@0.5);
        }];
        
        [_btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topLine.mas_bottom);
            make.left.equalTo(_btnView);
            make.height.equalTo(@44.0);
        }];
        
        [_btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topLine.mas_bottom);
            make.left.equalTo(_btnCancel.mas_right);
            make.right.equalTo(_btnView);
            make.height.width.equalTo(_btnCancel);
        }];
        
        [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_btnView);
            make.centerY.equalTo(_btnCancel);
            make.top.equalTo(_btnCancel.mas_centerY).offset(-10);
            make.width.equalTo(@0.5);
        }];
    }
    return _btnView;
}

@end
