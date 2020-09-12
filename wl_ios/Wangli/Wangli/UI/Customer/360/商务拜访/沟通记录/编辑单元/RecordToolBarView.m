//
//  RecordToolBarView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RecordToolBarView.h"
#import "UIButton+ShortCut.h"

@interface RecordToolBarView ()
{
    UIColor *_colorSelect;
    UIColor *_colorNormal;
}
@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) NSArray *imgSelect;
@property (nonatomic, strong) NSArray *imgNormal;

@end

@implementation RecordToolBarView

- (instancetype)initWithTitles:(NSArray *)titles
                     imgNormal:(NSArray *)imgNormal
                     imgSelect:(NSArray *)imgSelect{
    self = [super init];
    if (self) {
        _colorNormal = COLOR_B2;
        _colorSelect = COLOR_C1;
        _titles = [[NSMutableArray alloc] initWithArray:titles];
        _imgNormal = imgNormal;
        _imgSelect = imgSelect;
        [self setUI];
    }
    return self;
}

- (void)updateTitles:(NSArray *)titles
           imgNormal:(NSArray *)imgNormal
           imgSelect:(NSArray *)imgSelect {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    _titles = [[NSMutableArray alloc] initWithArray:titles];
    _imgNormal = imgNormal;
    _imgSelect = imgSelect;
    [self setUI];
}

- (void)setUI {
    
    if (self.titles.count != self.imgNormal.count || self.titles.count != self.imgSelect.count) {
        [Utils showToastMessage:@"标题、图片数量需要一致"];
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
    
    UIButton *btnLast = nil;
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/_titles.count, 50)];
        btn.tag = i+100;
        btn.titleLabel.font = FONT_F15;
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:_colorNormal forState:UIControlStateNormal];
        [btn setTitleColor:_colorSelect forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:_imgNormal[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_imgSelect[i]] forState:UIControlStateSelected];
        [btn setBackgroundColor:COLOR_B4];
        [btn imageLeftWithTitleFix:7];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            if (btnLast) {
                make.left.equalTo(btnLast.mas_right);
                make.width.equalTo(btnLast);
            } else {
                make.left.equalTo(self);
            }
            if (i == self.titles.count-1) {
                make.right.equalTo(self);
            }
        }];
        btnLast = btn;
    }
    
    UIView *topLine = [Utils getLineView];
    UIView *bottomLine = [Utils getLineView];
    [self addSubview:topLine];
    [self addSubview:bottomLine];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - event

- (void)btnClick:(UIButton *)sender {
    NSInteger index = sender.tag-100;
    //NSLog(@"-----%ld", index);
    if (_toolBarDelegate && [_toolBarDelegate respondsToSelector:@selector(toolBar:didSelectIndex:title:)]) {
        [_toolBarDelegate toolBar:self didSelectIndex:index title:sender.titleLabel.text];
    }
}

@end
