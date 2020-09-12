//
//  SwitchView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "SwitchView.h"
#import "UIButton+ShortCut.h"

@interface SwitchView ()

{
    UIColor *_colorSelect;
    UIColor *_colorNormal;
    BOOL _canScroll;
    UIView *_lineView;
    CGFloat _item_W;
    CGFloat _item_H;
    UIFont *_font;
    BOOL _hidenSelectView;
    CGFloat _selectViewWidth;
}

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) NSMutableArray *moArray;
@property (nonatomic, strong) UIButton *btnCurrent;

@property (nonatomic, strong) NSArray *imgSelect;
@property (nonatomic, strong) NSArray *imgNormal;

@end

@implementation SwitchView

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                    imgNormal:(NSArray *)imgNormal
                    imgSelect:(NSArray *)imgSelect {
    self = [super initWithFrame:frame];
    if (self) {
        _colorNormal = COLOR_B2;
        _colorSelect = COLOR_C1;
        _font = FONT_F14;
        _hidenSelectView = NO;
        _titles = [[NSMutableArray alloc] initWithArray:titles];
        _imgNormal = imgNormal;
        _imgSelect = imgSelect;
        _item_W = CGRectGetWidth(self.frame) / self.titles.count;
        _item_H = CGRectGetHeight(self.frame);
        _selectViewWidth = _item_W;
        [self setUI];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles
                     imgNormal:(NSArray *)imgNormal
                     imgSelect:(NSArray *)imgSelect {
    self = [super init];
    if (self) {
        _colorNormal = COLOR_B1;
        _colorSelect = COLOR_C1;
        _font = FONT_F15;
        _hidenSelectView = NO;
        _titles = [[NSMutableArray alloc] initWithArray:titles];
        _imgNormal = imgNormal;
        _imgSelect = imgSelect;
        _item_W = SCREEN_WIDTH / self.titles.count;
        _item_H = 49;
        _selectViewWidth = _item_W;
        [self setUI];
    }
    return self;
}

- (void)updateSelectViewHiden:(BOOL)hiden {
    _hidenSelectView = hiden;
    self.selectView.hidden = _hidenSelectView;
}

- (void)setUI {

    if (self.titles.count != self.imgNormal.count || self.titles.count != self.imgSelect.count) {
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"标题、图片数量需要一致";
        lab.font = FONT_F16;
        lab.textColor = COLOR_C2;
        lab.backgroundColor = COLOR_C3;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.layer.borderColor = COLOR_B1.CGColor;
        lab.layer.borderWidth = 1;
        lab.layer.cornerRadius = 5;
        lab.clipsToBounds = YES;
        [self addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
        return;
    }
    
    for (int i = 0; i < self.titles.count; i++) {
        SwitchMo *mo = [[SwitchMo alloc] init];
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(_item_W * i, 0, _item_W, _item_H);
        btn.tag = i+100;
        btn.titleLabel.font = _font;
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:_colorNormal forState:UIControlStateNormal];
        [btn setTitleColor:_colorSelect forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:_imgNormal[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_imgSelect[i]] forState:UIControlStateSelected];
        [btn setBackgroundColor:COLOR_B4];
        [btn imageRightWithTitleFix:8];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        mo.button = btn;
        mo.tag = i;
        [self.moArray addObject:mo];
    }
    
    _lineView = [Utils getLineView];
    _lineView.hidden = _hidenSelectView;
    [self addSubview:_lineView];

    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - public

- (void)selectIndex:(NSInteger)index {
    if (index >= 0 && index < self.moArray.count) {
        _canScroll = NO;
        SwitchMo *mo = self.moArray[index];
        [self btnAnimation:mo];
    }
}

- (void)updateTitle:(NSString *)title index:(NSInteger)index switchState:(SwitchState)state {
    if (index >= 0 && index < self.moArray.count) {
        for (int i = 0; i < self.moArray.count; i++) {
            SwitchMo *mo = self.moArray[i];
            // 需要更新的按钮根据需要的状态更新
            if (i == index) {
                if (title.length != 0) {
                    [mo.button setTitle:title forState:UIControlStateNormal];
                }
                switch (state) {
                    case SwitchStateNormal: {
                        [mo.button setTitleColor:_colorNormal forState:UIControlStateNormal];
                        [mo.button setImage:[UIImage imageNamed:_imgNormal[index]] forState:UIControlStateNormal];
                    } break;
                    case SwitchStateSelectFirst: {
                        [mo.button setTitleColor:_colorSelect forState:UIControlStateNormal];
                        [mo.button setImage:[UIImage imageNamed:_imgNormal[index]] forState:UIControlStateNormal];
                    } break;
                    case SwitchStateSelectSecond: {
                        [mo.button setTitleColor:_colorSelect forState:UIControlStateNormal];
                        [mo.button setImage:[UIImage imageNamed:_imgSelect[index]] forState:UIControlStateNormal];
                    } break;
                        
                    default:
                        break;
                }
                mo.switchState = state;
                [mo.button imageRightWithTitleFix:8];
            }
            // 其他按钮重置初始状态
            else {
                [mo.button setTitleColor:_colorNormal forState:UIControlStateNormal];
                [mo.button setImage:[UIImage imageNamed:_imgNormal[i]] forState:UIControlStateNormal];
                mo.switchState = SwitchStateNormal;
            }
        }
        [self layoutIfNeeded];
    }
}

- (void)updateTitles:(NSArray *)titles {
    for (UIView *obj in self.subviews) {
        [obj removeFromSuperview];
    }
    [_moArray removeAllObjects];
    _moArray = nil;
    _titles = [[NSMutableArray alloc] initWithArray:titles];
    [self setUI];
}

- (void)updateSelectViewWidth:(CGFloat)width {
    _selectViewWidth = width;
}

- (void)updateFont:(UIFont *)font {
    if ([font isKindOfClass:[UIFont class]]) {
        _font = font;
//        [self updateTitles:self.titles];
    }
}

- (void)updateSelectColor:(UIColor *)color {
    if ([color isKindOfClass:[UIFont class]]) {
        _colorSelect = color;
//        [self updateTitles:self.titles];
    }
}

- (void)updateNormalColor:(UIColor *)color {
    if ([color isKindOfClass:[UIColor class]]) {
        _colorNormal = color;
//        [self updateTitles:self.titles];
    }
}

- (void)refreshView {
    [self updateTitles:self.titles];
}

#pragma mark - event

- (void)btnClick:(UIButton *)sender {
    NSInteger index = sender.tag-100;
    _canScroll = YES;
    if (index >= 0 && index < self.moArray.count) {
        SwitchMo *mo = self.moArray[index];
        [self btnAnimation:mo];
    }
}

- (void)btnAnimation:(SwitchMo *)mo {
    _btnCurrent = nil;
    _btnCurrent = mo.button;
    
    CGFloat x = _btnCurrent.center.x;
    if (!_selectView) {
        [self addSubview:self.selectView];
        [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_lineView.mas_top);
            make.height.equalTo(@3.0);
            make.width.equalTo(@(_selectViewWidth));
            make.centerX.equalTo(self.mas_left).offset(x);
        }];
    } else {
        [UIView animateWithDuration:0.35 animations:^{
            [self.selectView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_left).offset(x);
                make.width.equalTo(@(_selectViewWidth));
            }];
            [self layoutIfNeeded];
        }];
    };
    
    if (_canScroll && _delegate && [_delegate respondsToSelector:@selector(switchView:selectIndex:title:switchState:)]) {
        [_delegate switchView:self selectIndex:mo.tag title:mo.button.titleLabel.text switchState:mo.switchState];
    }
}

#pragma mark - lazy

- (UIView *)selectView {
    if (!_selectView) {
        _selectView = [[UIView alloc] init];
        _selectView.backgroundColor = _colorSelect;
    }
    return _selectView;
}

- (NSMutableArray *)moArray {
    if (!_moArray) {
        _moArray = [NSMutableArray new];
    }
    return _moArray;
}

@end
