//
//  FilterView.m
//  Wangli
//
//  Created by yeqiang on 2018/4/9.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "FilterView.h"
#import "UIButton+ShortCut.h"

@interface FilterView ()
{
    CGFloat _btnWidth;
}

@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, assign) NSInteger selectTag;

@property (nonatomic, strong) UIView *selectLineView;

@end

@implementation FilterView

- (instancetype)initWithTitles:(NSArray *)titles imgsNormal:(NSArray *)imgsNormal imgsSelected:(NSArray *)imgsSelected {
    self = [super init];
    if (self) {
        _titles = titles;
        _imgsNormal = imgsNormal;
        _imgsSelected = imgsSelected;
        _imgWidth = 15;
        _selectTag = 0;
        [self setUI];
    }
    return self;
}

- (void)setImgWidth:(CGFloat)imgWidth {
    _imgWidth = imgWidth;
    [self updateImgWidth];
}

- (void)setUI {
    if (_titles.count == 0) {
        return;
    }
    _btnWidth = SCREEN_WIDTH * 1.0 / _titles.count;
    
    UIView *lineView = [Utils getLineView];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    for (int i = 0; i < _titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_btnWidth*i, 0, _btnWidth, 40)];
        btn.tag = i;
        [btn setTitle:_titles[i]
             forState:UIControlStateNormal];
        btn.titleLabel.font = FONT_F14;
        [btn setTitleColor:COLOR_B2 forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_C1 forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:_imgsNormal[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_imgsSelected[i]] forState:UIControlStateSelected];
        [btn imageRightWithTitleFix:8];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.btnArr addObject:btn];
    }
    
    [self addSubview:self.selectLineView];
    [self.selectLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.width.equalTo(@(_btnWidth));
        make.height.equalTo(@2);
        make.centerX.equalTo(self.mas_left).offset(_btnWidth/2.0);
    }];
}

- (void)updateImgWidth {
    for (UIButton *btn in self.btnArr) {
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_imgWidth, 0, _imgWidth)];
    }
}

- (void)updateTitle:(NSString *)title atIndex:(NSInteger)index {
    if (title.length == 0 || index < 0 || index >= self.btnArr.count) {
        return;
    }
    
    UIButton *btn = [self.btnArr objectAtIndex:index];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn imageRightWithTitleFix:5];
    btn.selected = NO;
}

- (void)changeNormalSelectedIndex:(NSInteger)index isChange:(BOOL)isChange {
    if (index < 0 || index >= self.btnArr.count) {
        return;
    }
    UIButton *btn = [self.btnArr objectAtIndex:index];
    if (isChange) {
        [btn setTitleColor:COLOR_B2 forState:UIControlStateSelected];
        [btn setTitleColor:COLOR_C1 forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_imgsNormal[index]] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:_imgsSelected[index]] forState:UIControlStateNormal];
    } else {
        [btn setTitleColor:COLOR_B2 forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_C1 forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:_imgsNormal[index]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_imgsSelected[index]] forState:UIControlStateSelected];
    }
    [btn imageRightWithTitleFix:5];
}

- (void)resetNormalState {
    for (UIButton *btn in self.btnArr) {
        btn.selected = NO;
    }
    [self layoutIfNeeded];
}

- (void)setFont:(UIFont *)font {
    if (font) {
        for (int i = 0; i < self.btnArr.count; i++) {
            UIButton *btn = [self viewWithTag:i+100];
            btn.titleLabel.font = font;
        }
    }
}

- (void)setLineWidth:(CGFloat)lineWidth {
    [self.selectLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(lineWidth));
    }];
    [self layoutIfNeeded];
}

- (void)setBgColor:(UIColor *)bgColor {
    if (bgColor) {
        self.backgroundColor = bgColor;
        for (int i = 0; i < self.btnArr.count; i++) {
            UIButton *btn = [self viewWithTag:i+100];
            [btn setBackgroundColor:bgColor];
        }
    }
}

- (void)setShowLine:(BOOL)showLine {
    _selectLineView.hidden = !showLine;
}

- (void)btnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(filterView:selectedIndex:selected:)]) {
        
        if (_selectTag != sender.tag) {
            UIButton *btn = self.btnArr[_selectTag];
            btn.selected = NO;
            _selectTag = sender.tag;
        } else {
        }
        sender.selected = !sender.selected;
        [_delegate filterView:self selectedIndex:_selectTag selected:sender.selected];
        
        [UIView animateWithDuration:0.35 animations:^{
            [self.selectLineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_left).offset(sender.center.x);
            }];
            [self layoutIfNeeded];
        }];
    }
}

- (void)selectIndex:(NSInteger)index {
    if (index < self.btnArr.count) {
        UIButton *btn = self.btnArr[index];
        [UIView animateWithDuration:0.35 animations:^{
            [self.selectLineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_left).offset(btn.center.x);
            }];
            [self layoutIfNeeded];
        }];
    }
}

- (NSMutableArray *)btnArr {
    if (!_btnArr) {
        _btnArr = [NSMutableArray new];
    }
    return _btnArr;
}

- (UIView *)selectLineView {
    if (!_selectLineView) {
        _selectLineView = [[UIView alloc] init];
        _selectLineView.backgroundColor = COLOR_C1;
        _selectLineView.hidden = YES;
    }
    return _selectLineView;
}

@end
