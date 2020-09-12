//
//  TopTabBarView.m
//  Wangli
//
//  Created by yeqiang on 2018/4/9.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "TopTabBarView.h"

@interface TopTabBarView ()
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

@end

@implementation TopTabBarView

- (instancetype)initWithItems:(NSArray *)items colorSelect:(UIColor *)colorSelect colorNormal:(UIColor *)colorNormal {
    self = [super init];
    if (self) {
        _canScroll = YES;
        //        self.backgroundColor = COLOR_B7;
        self.items = [[NSMutableArray alloc] initWithArray:items];
        _colorNormal = colorNormal;
        _colorSelect = colorSelect;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    CGFloat item_W = SCREEN_WIDTH / self.items.count;
    CGFloat item_H = 40;
    
    [_btnArray removeAllObjects];
    _btnArray = nil;
    
    for (int i = 0; i < self.items.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(item_W * i, 0, item_W, item_H)];
        btn.tag = i+100;
        btn.titleLabel.font = SYSTEM_FONT(13);
        [btn setTitle:self.items[i] forState:UIControlStateNormal];
        [btn setTitleColor:_colorSelect forState:UIControlStateSelected];
        [btn setTitleColor:_colorNormal forState:UIControlStateNormal];
        [btn setBackgroundColor:COLOR_B4];
        if (i == 0) {
            _btnCurrent = btn;
            btn.selected = YES;
        }
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArray addObject:btn];
    }
    
    _lineView = [Utils getLineView];
    [self addSubview:_lineView];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    [self addSubview:self.selectView];
    UIButton *button = self.btnArray.firstObject;
    CGFloat x = button.center.x;
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_lineView.mas_top);
        make.height.equalTo(@3);
        make.width.equalTo(@98);
        make.centerX.equalTo(self.mas_left).offset(x);
    }];
}

#pragma mark - event

- (void)btnClick:(UIButton *)sender {
    _canScroll = YES;
    [self btnAnimation:sender];
}

- (void)btnAnimation:(UIButton *)sender {
    
    if (sender == _btnCurrent) {
        return;
    }
    _btnCurrent.selected = NO;
    _btnCurrent = nil;
    _btnCurrent = sender;
    _btnCurrent.selected = YES;
    CGFloat x = _btnCurrent.center.x;
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.selectView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_left).offset(x);
        }];
        [self layoutIfNeeded];
    }];
    
    if (_canScroll && _delegate && [_delegate respondsToSelector:@selector(topTabBarView:selectIndex:)]) {
        [_delegate topTabBarView:self selectIndex:sender.tag-100];
    }
}

- (void)selectIndex:(NSInteger)index {
    if (index < self.btnArray.count) {
        _canScroll = NO;
        UIButton *btn = self.btnArray[index];
        [self btnAnimation:btn];
    }
}

#pragma mark - public

- (void)updateTitle:(NSArray *)items {
    if (items.count == self.items.count) {
        for (int i = 0; i < self.items.count; i++) {
            UIButton *btn = [self viewWithTag:i+100];
            [btn setTitle:items[i] forState:UIControlStateNormal];
        }
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
    }
    return _btnArray;
}


@end
