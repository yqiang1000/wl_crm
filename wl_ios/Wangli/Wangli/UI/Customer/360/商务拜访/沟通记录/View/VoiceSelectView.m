//
//  VoiceSelectView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/19.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "VoiceSelectView.h"

typedef void(^voiceSelectBlock)(VoiceChangeType type);
typedef void(^voiceCancelBlock)(VoiceSelectView *obj);

@interface VoiceSelectView ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIButton *btnCancel;

@property (nonatomic, copy) voiceSelectBlock selectBlock;
@property (nonatomic, copy) voiceCancelBlock cancelBlcok;

@property (nonatomic, assign) VoiceChangeType index;

@property (nonatomic, strong) NSMutableArray *arrBtns;
@property (nonatomic, strong) NSMutableArray *arrImages;

@end

@implementation VoiceSelectView

- (instancetype)initWithFrame:(CGRect)frame
                   changeType:(VoiceChangeType)changeType
                    itemClick:(void (^)(VoiceChangeType type))selectBlock
                  cancelClick:(void (^)(VoiceSelectView *obj))cancelClick {
    self = [super initWithFrame:frame];
    if (self) {
        _index = changeType;
        _selectBlock = selectBlock;
        _cancelBlcok = cancelClick;
        self.backgroundColor = COLOR_MASK;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.btnCancel];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_bottom);
    }];
    
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.baseView);
        make.height.equalTo(@50.0);
        make.width.equalTo(self.baseView);
        make.bottom.equalTo(self.baseView).offset(-(KMagrinBottom));
    }];
    
    UIButton *btnLast = nil;
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        btn.tag = i+100;
        [btn setBackgroundColor:COLOR_B4];
        [self.baseView addSubview:btn];
        
        UILabel *lab = [UILabel new];
        lab.text = self.titles[i];
        lab.font = FONT_F18;
        lab.textColor = (i == 0 ? COLOR_B1 : COLOR_B2);
        [btn addSubview:lab];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        if (i == 0) {
            imageView.image = [UIImage imageNamed:@"un_check_def"];
        } else {
            imageView.image = [UIImage imageNamed:@"check"];
            UIView *lineView = [Utils getLineView];
            [btn addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0.5);
                make.top.left.right.equalTo(btn);
            }];
        }
        
        if (_index != 0 && _index == i) {
            imageView.image = [UIImage imageNamed:@"checked"];
        }
        
        [btn addSubview:imageView];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.baseView);
            make.width.equalTo(self.baseView);
            make.height.equalTo(@50.0);
            if (btnLast) {
                make.top.equalTo(btnLast.mas_bottom);
            } else {
                make.top.equalTo(self.baseView);
            }
            if (i == self.titles.count-1) {
                make.bottom.equalTo(self.btnCancel.mas_top).offset(-6);
            }
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.left.equalTo(btn).offset(15);
        }];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.right.equalTo(btn).offset(-15);
            make.height.width.equalTo(@23.0);
        }];
        
        btnLast = btn;
        
        [self.arrBtns addObject:btn];
        [self.arrImages addObject:imageView];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    point = [self.baseView.layer convertPoint:point fromLayer:self.layer];
    if (![self.baseView.layer containsPoint:point]) {
        [self btnCancelClick:nil];
    }
}

- (void)showView {
    [self layoutIfNeeded];
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundColor = COLOR_MASK;
        [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)btnClick:(UIButton *)sender {
    //    NSLog(@"%ld", sender.tag -100);
//    _index = sender.tag - 100;
//    if (_index == 0) {
//        return;
//    }
//
//    sender.selected = !sender.selected;
//    for (int i = 1; i < self.arrBtns.count; i++) {
//        UIButton *btn = self.arrBtns[i];
//        UIImageView *imageView = self.arrImages[i];
//        if (i == _index) {
//            btn.selected = YES;
//            imageView.image = [UIImage imageNamed:@"checked"];
//        } else {
//            btn.selected = NO;
//            imageView.image = [UIImage imageNamed:@"check"];
//        }
//    }
//    [self layoutIfNeeded];
}

- (void)btnCancelClick:(UIButton *)sender {
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundColor = [UIColor clearColor];
        [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.mas_bottom);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (sender) {
            if (self.selectBlock) {
                self.selectBlock(_index);
            }
        }
        if (self.cancelBlcok) {
            self.cancelBlcok(self);
        }
    }];
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"录音",
                    @"语音转文字",
                    @"英转中翻译",
                    @"韩转中翻译"];
    }
    return _titles;
}

-(UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
        _baseView.backgroundColor = COLOR_B0;
    }
    return _baseView;
}

- (UIButton *)btnCancel {
    if (!_btnCancel) {
        _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        [_btnCancel setTitle:@"确定" forState:UIControlStateNormal];
        [_btnCancel setTitleColor:COLOR_0095DA forState:UIControlStateNormal];
        [_btnCancel setBackgroundColor:COLOR_B4];
        _btnCancel.titleLabel.font = FONT_F18;
        [_btnCancel addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCancel;
}

- (NSMutableArray *)arrBtns {
    if (!_arrBtns) {
        _arrBtns = [NSMutableArray new];
    }
    return _arrBtns;
}

- (NSMutableArray *)arrImages {
    if (!_arrImages) {
        _arrImages = [NSMutableArray new];
    }
    return _arrImages;
}


@end
