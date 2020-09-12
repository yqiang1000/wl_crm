//
//  RiskTopView.m
//  Wangli
//
//  Created by yeqiang on 2018/7/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RiskTopView.h"
#import "UIButton+ShortCut.h"

@interface RiskTopView ()
{
    UIColor *_colorSelect;
    UIColor *_colorNormal;
    BOOL _canScroll;
    UIView *_lineView;
}
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) UIButton *btnCurrent;

@property (nonatomic, strong) NSArray *imgSelect;
@property (nonatomic, strong) NSArray *imgNormal;

@end

@implementation RiskTopView

- (instancetype)initWithItems:(NSArray *)items
                    imgSelect:(NSArray *)imgSelect
                    imgNormal:(NSArray *)imgNormal
                  colorSelect:(UIColor *)colorSelect
                  colorNormal:(UIColor *)colorNormal {
    self = [super init];
    if (self) {
        _canScroll = YES;
        self.items = [[NSMutableArray alloc] initWithArray:items];
        _colorNormal = colorNormal;
        _colorSelect = colorSelect;
        _imgSelect = imgSelect;
        _imgNormal = imgNormal;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    CGFloat item_W = SCREEN_WIDTH / self.items.count;
    CGFloat item_H = 40;
    
    if (self.items.count != self.btnArray.count) {
        [Utils showToastMessage:@"按钮数量需要和title数量一致"];
        return;
    }
    
    for (int i = 0; i < self.items.count; i++) {
        UIButton *btn = self.btnArray[i];
        btn.frame = CGRectMake(item_W * i, 0, item_W, item_H);
        btn.tag = i+100;
        btn.titleLabel.font = FONT_F14;
        [btn setTitle:self.items[i] forState:UIControlStateNormal];
        [btn setTitleColor:_colorNormal forState:UIControlStateNormal];
        [btn setTitleColor:_colorSelect forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:_imgNormal[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_imgSelect[i]] forState:UIControlStateSelected];
        [btn setBackgroundColor:COLOR_B4];
        [btn imageRightWithTitleFix:8];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.btnCurrent = self.btnArray[0];
    _lineView = [Utils getLineView];
    [self addSubview:_lineView];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    [self addSubview:self.selectView];
    CGFloat x = self.btnCurrent.center.x;
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_lineView.mas_top);
        make.height.equalTo(@3);
        make.width.equalTo(self.btnCurrent);
        make.centerX.equalTo(self.mas_left).offset(x);
    }];
}

#pragma mark - event

- (void)btnClick:(UIButton *)sender {
    _canScroll = YES;
    [self btnAnimation:sender];
}

- (void)btnAnimation:(UIButton *)sender {
//    _btnCurrent.selected = NO;
    _btnCurrent = nil;
    _btnCurrent = sender;
//    _btnCurrent.selected = YES;
    CGFloat x = _btnCurrent.center.x;
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.selectView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_left).offset(x);
        }];
        [self layoutIfNeeded];
    }];
    
    if (_canScroll && _delegate && [_delegate respondsToSelector:@selector(riskTopView:selectIndex:)]) {
        [_delegate riskTopView:self selectIndex:sender.tag-100];
    }
}

- (void)selectIndex:(NSInteger)index {
    if (index >= 0 && index < self.btnArray.count) {
        _canScroll = NO;
        UIButton *btn = self.btnArray[index];
        [self btnAnimation:btn];
    }
}

#pragma mark - public

- (void)updateIndex:(NSInteger)index selected:(BOOL)selected {
    // 根据状态修改某个按钮的是否选中状态，以及图片
    if (index >= 0 && index < self.btnArray.count) {
        UIButton *btn = self.btnArray[index];
        if (selected) {
            [btn setImage:[UIImage imageNamed:_imgSelect[index]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:_imgNormal[index]] forState:UIControlStateSelected];
        } else {
            [btn setImage:[UIImage imageNamed:_imgNormal[index]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:_imgSelect[index]] forState:UIControlStateSelected];
        }
        [btn imageRightWithTitleFix:8];
        btn.selected = selected;
    }
}

- (void)resetNormalState:(NSInteger)index {
    if (index >= 0 && index < self.btnArray.count) {
        UIButton *btn = self.btnArray[index];
        [btn setTitleColor:_colorNormal forState:UIControlStateNormal];
        [btn setTitleColor:_colorSelect forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:_imgNormal[index]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_imgSelect[index]] forState:UIControlStateSelected];
        [btn imageRightWithTitleFix:8];
    }
}

- (void)btn0Select {
    [self.btn0 setTitleColor:_colorSelect forState:UIControlStateNormal];
}

- (void)btn0Normal {
    [self.btn0 setTitleColor:_colorNormal forState:UIControlStateNormal];
}

- (void)updateTitle:(NSString *)title index:(NSInteger)index {
    if (index >= 0 && index < self.btnArray.count) {
        UIButton *btn = self.btnArray[index];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn imageRightWithTitleFix:8];
    }
}

- (void)setLabFont:(UIFont *)labFont {
    if (labFont) {
        for (int i = 0; i < self.items.count; i++) {
            UIButton *btn = [self viewWithTag:i+100];
            btn.titleLabel.font = labFont;
        }
    }
}

- (void)setLineWidth:(CGFloat)lineWidth {
    [self.selectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(lineWidth));
    }];
    [self layoutIfNeeded];
}

- (void)setBgColor:(UIColor *)bgColor {
    if (bgColor) {
        self.backgroundColor = bgColor;
        for (int i = 0; i < self.items.count; i++) {
            UIButton *btn = [self viewWithTag:i+100];
            [btn setBackgroundColor:bgColor];
        }
        
        _lineView.backgroundColor = COLOR_LINE;
    }
}

- (void)setShowLine:(BOOL)showLine {
    _lineView.hidden = !showLine;
}

- (UIButton *)btn0 {
    if (!_btn0) {
        _btn0 = [[UIButton alloc] init];
    }
    return _btn0;
}

- (UIButton *)btn1 {
    if (!_btn1) {
        _btn1 = [[UIButton alloc] init];
    }
    return _btn1;
}

#pragma mark - setter and getter

- (NSMutableArray *)items {
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

- (UIView *)selectView {
    if (!_selectView) {
        _selectView = [[UIView alloc] init];
        _selectView.backgroundColor = _colorSelect;
    }
    return _selectView;
}

- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = [NSMutableArray new];
        [_btnArray addObject:self.btn0];
        [_btnArray addObject:self.btn1];
    }
    return _btnArray;
}
@end
