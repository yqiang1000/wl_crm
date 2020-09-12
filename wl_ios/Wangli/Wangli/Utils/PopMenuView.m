//
//  PopMenuView.m
//  Wangli
//
//  Created by yeqiang on 2018/4/12.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "PopMenuView.h"

#define MenuHeight 46.0 // ((IS_IPAD) ? 49.0f : 49.0f)

typedef void(^ItemClickBlock)(NSInteger index);
typedef void(^CancelClickBlock)(id);

@interface PopMenuView()
{
    UIImageView *m_popView;
    NSInteger _defaultIndex;
    CGFloat _btnY;
    
    float m_itemHeight;
}

@property (nonatomic, copy) ItemClickBlock itemClickBlock;
@property (nonatomic, copy) CancelClickBlock cancelClickBlock;

@end

@implementation PopMenuView

- (instancetype)initWithFrame:(CGRect)frame
                     position:(ArrowPosition)positipon
                     arrTitle:(NSArray *)arrTitle
                     arrImage:(NSArray *)arrImage
                  defaultItem:(NSInteger)defaultIndex
                    itemClick:(void (^)(NSInteger index))itemClick
                  cancelClick:(void (^)(id))cancelClick
{
    m_itemHeight = MenuHeight;
    
    float width = SCREEN_WIDTH;
    float height = SCREEN_HEIGHT;
    _btnY = 7.0;
    if (self = [super initWithFrame:CGRectMake(0, 0, width, height)]) {
        
        self.backgroundColor = COLOR_CLEAR;
        [UIView animateWithDuration:0.35 animations:^{
            self.backgroundColor = COLOR_MASK;
        }];
        
        
        _defaultIndex = defaultIndex;
        self.itemClickBlock = itemClick;
        self.cancelClickBlock = cancelClick;
        
        float height = (frame.size.height - _btnY)/arrTitle.count;
        m_itemHeight = height < m_itemHeight ? height : m_itemHeight;
        m_popView = [[UIImageView alloc] init];
        [self addSubview:m_popView];
        
        [m_popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(frame.size.width-(width-frame.origin.x));
            make.width.mas_equalTo(frame.size.width);
            make.height.mas_equalTo(frame.size.height);
            make.top.equalTo(self).offset(frame.origin.y);
        }];
        
        [self setPopMenuOption:positipon
                      ArrTitle:arrTitle
                      arrImage:arrImage];
    }
    
    return self;
}

- (void) setPopMenuOption:(ArrowPosition)positipon
                 ArrTitle:(NSArray *)arrTitle
                 arrImage:(NSArray *)arrImage
{
    for (UIView *subView in m_popView.subviews) {
        [subView removeFromSuperview];
    }
    
    float btnY = 7;
    NSString *strImg =  (positipon == ArrowPosition_RightTop)?@"bg_Popup_left":@"more_bg";
    m_popView.image = (positipon == ArrowPosition_RightTop)?[[UIImage imageNamed:strImg] stretchableImageWithLeftCapWidth:35 topCapHeight:16]:[[UIImage imageNamed:strImg] stretchableImageWithLeftCapWidth:50 topCapHeight:16];
    //    m_popView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    m_popView.layer.shadowOffset = CGSizeMake(2, 2);
    //    m_popView.layer.shadowRadius = 4;
    //    m_popView.layer.shadowOpacity = 0.4;
    //    m_popView.layer.cornerRadius = 4;
    //    m_popView.clipsToBounds = YES;
    m_popView.userInteractionEnabled = YES;
    
    for (int i=0; i<arrTitle.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_popView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(m_popView).offset(btnY + m_itemHeight*i);
            make.left.right.equalTo(m_popView);
            make.height.equalTo(@(m_itemHeight));
        }];
        
        [button setTitle:arrTitle[i] forState:UIControlStateNormal];
        [button setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        button.titleLabel.font = FONT_F14;
        button.tag = i;
        if (i == _defaultIndex) {
            button.selected = YES;
        }
        
        [button addTarget:self action:@selector(itemClickBlockAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (arrImage != nil) {
            [button setImage:[UIImage imageNamed:arrImage[i]] forState:UIControlStateNormal];
//            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_hover", arrImage[i]]] forState:UIControlStateHighlighted];
//            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_hover", arrImage[i]]] forState:UIControlStateSelected];
            //            [button setImageEdgeInsets:UIEdgeInsetsMake(0, -60, 0, -60)];
            //            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 66, 0, -66)];
        }
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 18);
        [m_popView addSubview:button];
        //
        if (i < arrTitle.count-1) {
            UIView *lineView = [[UIView alloc] init]; //WithFrame:CGRectMake(24, btnY+m_itemHeight*(i+1)+0.5, m_popView.frame.size.width-40, 0.5)];
            lineView.backgroundColor = COLOR_LINE;
            [m_popView addSubview:lineView];
            
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(button);
                make.left.equalTo(button).offset(30);
                make.right.equalTo(button).offset(-20);
                make.height.equalTo(@0.5);
            }];
        }
    }
}

#pragma mark - event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissSelf:nil];
}

- (void)itemClickBlockAction:(UIButton *)sender {
    if (sender.tag == _defaultIndex) {
        sender.selected = YES;
    }
    if (self.itemClickBlock) {
        self.itemClickBlock(sender.tag);
    }
    [self dismissSelf:nil];
}


//点击自己消失
- (void)dismissSelf:(UIButton *)sender
{
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundColor = COLOR_CLEAR;
        [m_popView removeFromSuperview];
    } completion:^(BOOL finished) {
        if (self.cancelClickBlock) {
            self.cancelClickBlock(self);
            return;
        }
        if (self.superview != nil) {
            [self removeFromSuperview];
        }
    }];
}


@end
