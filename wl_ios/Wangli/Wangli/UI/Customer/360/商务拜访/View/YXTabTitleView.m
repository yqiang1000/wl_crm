//
//  YXTabTitleView.m
//  仿造淘宝商品详情页
//
//  Created by yixiang on 16/3/25.
//  Copyright © 2016年 yixiang. All rights reserved.
//

#import "YXTabTitleView.h"
#import "YX.h"

@interface YXTabTitleView()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *titleBtnArray;
@property (nonatomic, strong) UIView  *indicateLine;

@end

@implementation YXTabTitleView

-(instancetype)initWithTitleArray:(NSArray *)titleArray{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _titleArray = titleArray;
        _titleBtnArray = [NSMutableArray array];
        
        CGFloat totalWidth = SCREEN_WIDTH - 20;
        
        self.frame = CGRectMake(10, 0, totalWidth, kTabTitleViewHeight);
        self.backgroundColor = COLOR_B0;
        
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, totalWidth, kTabTitleViewHeight-5)];
        coverView.backgroundColor = COLOR_B4;
        coverView.layer.mask = [Utils drawContentFrame:coverView.bounds corners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:5];
        [self addSubview:coverView];
        
        CGFloat btnWidth = totalWidth/titleArray.count;
        
        for (int i=0; i<titleArray.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*btnWidth, 5, btnWidth, kTabTitleViewHeight)];
            btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
            if (i==0) {
                [btn setTitleColor:COLOR_C1 forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:COLOR_B1 forState:UIControlStateNormal];
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
            
            [self addSubview:btn];
            [_titleBtnArray addObject:btn];
        }
        
        
        UIView *lineView = [Utils getLineView];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        _indicateLine = [[UIView alloc] initWithFrame:CGRectMake(0, kTabTitleViewHeight-2, btnWidth, 2)];
        _indicateLine.backgroundColor = COLOR_C1;
        [self addSubview:_indicateLine];
    }
    return self;
}

-(void)clickBtn : (UIButton *)btn{
    NSInteger tag = btn.tag;
    [self setItemSelected:tag];
    
    if (self.titleClickBlock) {
        self.titleClickBlock(tag);
    }
}

-(void)setItemSelected: (NSInteger)column{
    for (int i=0; i<_titleBtnArray.count; i++) {
        UIButton *btn = _titleBtnArray[i];
        if (i==column) {
            [btn setTitleColor:COLOR_C1 forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:COLOR_B1 forState:UIControlStateNormal];
        }
    }
    CGFloat totalWidth = SCREEN_WIDTH - 20;
    CGFloat btnWidth = totalWidth/_titleBtnArray.count;
    [UIView animateWithDuration:0.35 animations:^{
        _indicateLine.frame = CGRectMake(btnWidth*column, kTabTitleViewHeight-2, btnWidth, 2);
    }];
}

- (void)updateTitle:(NSString *)title index:(NSInteger)index {
    if (index >=0 && index < _titleBtnArray.count) {
        UIButton *btn = _titleBtnArray[index];
        [btn setTitle:STRING(title) forState:UIControlStateNormal];
    }
}

@end
