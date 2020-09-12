//
//  TrendsSegmentView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsSegmentView.h"
#import "ZJScrollSegmentView.h"

@interface TrendsSegmentView ()
{
    CGFloat _seg_H;
    CGFloat _seg_W;
    BOOL _showBtn;
}

@property (nonatomic, strong) ZJScrollSegmentView *segmentView;

@end

@implementation TrendsSegmentView

- (instancetype)initWithFrame:(CGRect)frame showBtn:(BOOL)showBtn {
    self = [super initWithFrame:frame];
    if (self) {
        _showBtn = showBtn;
        _seg_H = CGRectGetHeight(frame);
        _seg_W = CGRectGetWidth(frame);
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.segmentView];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.right.equalTo(self).offset(_showBtn?-_seg_H:0);
    }];
    
    if (_showBtn) {
        [self addSubview:self.btnArrow];
        [self.btnArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.width.equalTo(@(_seg_H));
        }];
    }
}

- (void)refreshTitles:(NSMutableArray *)titles {
    if (_titles != titles) {
        _titles = titles;
    }
    [self.segmentView reloadTitlesWithNewTitles:_titles];
    [self layoutIfNeeded];
}

- (void)selectIndex:(NSInteger)index {
    if (index >= 0 && index < self.titles.count) {
        [self.segmentView setSelectedIndex:index animated:YES enBlock:nil];
    }
}

- (void)btnClick:(UIButton *)sender {
    self.btnArrow.selected = !self.btnArrow.selected;
    if (_trendsSegmentViewDelegate && [_trendsSegmentViewDelegate respondsToSelector:@selector(trendsSegmentView:didClick:)]) {
        [_trendsSegmentViewDelegate trendsSegmentView:self didClick:sender];
    }
}

- (void)resetBtnStateNormal {
    self.btnArrow.selected = YES;
    [self btnClick:self.btnArrow];
}

#pragma mark - lazy

- (ZJScrollSegmentView *)segmentView {
    if (!_segmentView) {
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
        // 缩放标题
        style.scaleTitle = YES;
        // 颜色渐变
        style.gradualChangeTitleColor = YES;
        style.normalTitleColor = COLOR_B1;
        style.selectedTitleColor = COLOR_C1;
        style.titleFont = FONT_F13;
        style.titleMargin = 25;
        style.segmentHeight = _seg_H;
        style.showLine = YES;
        style.scrollLineColor = COLOR_C1;
        style.autoAdjustTitlesWidth = YES;
        __weak typeof(self) weakSelf = self;
        _segmentView = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, 0 , _showBtn?_seg_W-_seg_H:_seg_W, style.segmentHeight) segmentStyle:style delegate:nil titles:self.titles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf.trendsSegmentViewDelegate && [strongSelf.trendsSegmentViewDelegate respondsToSelector:@selector(trendsSegmentView:didSelectIndex:title:)]) {
                [strongSelf.trendsSegmentViewDelegate trendsSegmentView:strongSelf didSelectIndex:index title:strongSelf.titles[index]];
            }
            
//            strongSelf.currentTag = index;
//            [strongSelf scrollToCenter];
        }];
        _segmentView.backgroundColor = COLOR_B4;
        UIView *lineView = [Utils getLineView];
        [_segmentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_segmentView);
            make.height.equalTo(@0.5);
        }];
    }
    return _segmentView;
}

- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray new];
    }
    return _titles;
}

- (UIButton *)btnArrow {
    if (!_btnArrow) {
        _btnArrow = [[UIButton alloc] init];
        [_btnArrow setImage:[UIImage imageNamed:@"client_down_n"] forState:UIControlStateNormal];
        [_btnArrow setImage:[UIImage imageNamed:@"drop_down_s"] forState:UIControlStateSelected];
        [_btnArrow addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnArrow.backgroundColor = COLOR_B4;
        UIView *lineView = [Utils getLineView];
        [_btnArrow addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_btnArrow);
            make.left.equalTo(_btnArrow);
            make.height.equalTo(@20.0);
            make.width.equalTo(@0.5);
        }];
    }
    return _btnArrow;
}


@end

