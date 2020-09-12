//
//  BottomView.m
//  Wangli
//
//  Created by yeqiang on 2018/5/3.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "BottomView.h"

#import "BottomView.h"

typedef void(^ItemClickBlock)(NSInteger index);
typedef void(^CancelClickBlock)(BottomView *obj);

@interface BottomView ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) CGFloat baseViewHeight;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) UIButton *btnSelected;

@property (nonatomic, copy) ItemClickBlock itemClickBlock;
@property (nonatomic, copy) CancelClickBlock cancelClickBlock;

@end

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray *)items
                  defaultItem:(NSInteger)defaultIndex
                    itemClick:(void (^)(NSInteger index))itemClick
                  cancelClick:(void (^)(BottomView *))cancelClick {
    self = [super initWithFrame:frame];
    if (self) {
        _items = items;
        _selectIndex = defaultIndex;
        [self setUI];
        if (itemClick) {
            self.itemClickBlock = itemClick;
        }
        if (cancelClick) {
            self.cancelClickBlock = cancelClick;
        }
    }
    return self;
}

- (void)setUI {
    CGFloat btnHeight = 49.0;
    
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.btnCancel];
    
    for (int i = 0; i < _items.count; i++) {
        CGFloat btnTop = btnHeight * i;
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = 200 + i;
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(clickItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:_items[i] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_B1 forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_C2 forState:UIControlStateSelected];
        btn.titleLabel.font = FONT_F16;
        [self.baseView addSubview:btn];
        
        if (_selectIndex == i) {
            btn.selected = YES;
        }
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.baseView.mas_top).offset(btnTop);
            make.left.right.equalTo(self.baseView);
            make.height.equalTo(@(btnHeight));
        }];
        
        if (i < self.items.count - 1) {
            UIView *lineView = [Utils getLineView];
            [btn addSubview:lineView];
            
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(btn);
                make.height.equalTo(@0.5);
            }];
        }
    }
    
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.baseView);
        make.bottom.equalTo(self.baseView).offset(-KMagrinBottom);
        make.height.equalTo(@(btnHeight));
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    point = [self.baseView.layer convertPoint:point fromLayer:self.layer];
    if (![self.baseView.layer containsPoint:point]) {
        [self clickItemBtnAction:self.btnCancel];
    }
}

#pragma mark - event
- (void)clickItemBtnAction:(UIButton *)sender {
    if (_btnSelected != sender) {
        _btnSelected.selected = NO;
    }
    _btnSelected = nil;
    _btnSelected = sender;
    _btnSelected.selected = YES;
    
    NSInteger index = sender.tag - 200;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.baseView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _baseViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (sender == self.btnCancel) {
            self.cancelClickBlock(self);
        } else {
            self.itemClickBlock(index);
        }
    }];
}

#pragma mark - public

- (void)show {
    _baseViewHeight = 49 * (_items.count + 1) + 5 + KMagrinBottom;
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.baseView.frame = CGRectMake(0, SCREEN_HEIGHT-_baseViewHeight, SCREEN_WIDTH, _baseViewHeight);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - setter and getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 100)];
        _baseView.backgroundColor = COLOR_B0;
    }
    return _baseView;
}

- (UIButton *)btnCancel {
    if (!_btnCancel) {
        _btnCancel = [[UIButton alloc] init];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel setTitleColor:COLOR_B1 forState:UIControlStateNormal];
        _btnCancel.backgroundColor = [UIColor whiteColor];
        _btnCancel.titleLabel.font = FONT_F16;
        [_btnCancel addTarget:self action:@selector(clickItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCancel;
}

@end
