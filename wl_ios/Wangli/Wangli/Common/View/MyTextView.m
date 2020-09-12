//
//  MyTextView.h
//  Wangli
//
//  Created by yeqiang on 2018/4/2.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "MyTextView.h"
//#import "UIView+ShapeLayer.h"

@interface MyTextView ()

@property (strong, nonatomic) UIView *contentView;
@property (assign, nonatomic) CGFloat btnWidth;     //按钮宽度
@property (assign, nonatomic) CGFloat rightPadding; //按钮距两边间距
@property (assign, nonatomic) MyBtnType btnType;
@property (strong, nonatomic) UIView *lineView;     //下划线

@end

@implementation MyTextView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)initData:(UIImage *)leftImage
     placeholder:(NSString *)placeholder
      returnType:(UIReturnKeyType)returnType
    keyboardType:(UIKeyboardType)keyboardType
         btnType:(MyBtnType)btnType
{
    self.backgroundColor = COLOR_B0;
    //控件未初始化完成或者已经设置过
    _btnType = btnType;
    if (_btnType == MyBtnTypeDefault) {
        _btnWidth = 0;
    } else if (_btnType == MyBtnTypeBtn) {
        _btnWidth = 74;
    }
    _rightPadding = 13;
    
    [self.imgLeft setImage:leftImage];
    
    //TextField
    self.txtField.returnKeyType = returnType;
    self.txtField.keyboardType = keyboardType;
    self.txtField.textColor = COLOR_B4;
    self.txtField.font = FONT_F15;
    if (placeholder.length > 0) {
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:placeholder];
        NSRange range = NSMakeRange(0, attribtStr.length);
        [attribtStr addAttribute:NSForegroundColorAttributeName value:COLOR_CECECE range:range];
        _txtField.attributedPlaceholder = attribtStr;
    }
    self.clipsToBounds = YES;
}

//根据标题画界面
- (void)setupViewWithLeftImage:(UIImage *)leftImage
                   placeholder:(NSString *)placeholder
                    returnType:(UIReturnKeyType)returnType
                  keyboardType:(UIKeyboardType)keyboardType
                       btnType:(MyBtnType)btnType
{
    if (_txtField.placeholder.length > 0) return;
    
    [self initData:leftImage
       placeholder:placeholder
        returnType:returnType
      keyboardType:keyboardType
           btnType:btnType];
    [self setUI];
}

- (void)setUI {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.txtField];
    [self.contentView addSubview:self.btnRight];
    [self.contentView addSubview:self.imgLeft];
    [self.contentView addSubview:self.lineView];
    
    [self.imgLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.width.equalTo(@20);
        make.height.equalTo(_imgLeft.mas_width);
    }];
    
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-_rightPadding);
        make.width.equalTo(@(_btnWidth));
        make.height.equalTo(@(self.btnType == MyBtnTypeDefault ? 0 : 32));
    }];
    
    [self.txtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.imgLeft.mas_right).offset(10);
        if (_btnType == MyBtnTypeDefault) {
            make.right.equalTo(self.contentView).offset(-_rightPadding);
        } else if (_btnType == MyBtnTypeBtn) {
            make.right.equalTo(self.btnRight.mas_left).offset(-_rightPadding);
        }
        make.height.equalTo(@35);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

- (void)drawRect:(CGRect)rect {
    self.contentView.frame = self.bounds;
}

- (void)btnRightClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(myTextView:btnRightSelected:)]) {
        [_delegate myTextView:self btnRightSelected:self.btnRight];
    }
}

- (void)textFieldChange:(NSNotification *)noti {
    if (_delegate && [_delegate respondsToSelector:@selector(myTextView:textChanged:)]) {
        [_delegate myTextView:self textChanged:self.txtField];
    }
}

#pragma mark - setter and getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UITextField *)txtField {
    if (!_txtField) {
        _txtField = [[UITextField alloc] init];
        _txtField.font = FONT_F15;
    }
    return _txtField;
}

- (UIButton *)btnRight {
    if (!_btnRight) {
        _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRight addTarget:self action:@selector(btnRightClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnRight setTitleColor:COLOR_CECECE forState:UIControlStateDisabled];
        [_btnRight setTitleColor:COLOR_B4 forState:UIControlStateNormal];
        _btnRight.layer.cornerRadius = 5;
        _btnRight.layer.borderColor = COLOR_E9E9E9.CGColor;
        _btnRight.layer.borderWidth = 0.5;
        _btnRight.clipsToBounds = YES;
        _btnRight.titleLabel.font = FONT_F12;
        [_btnRight sizeToFit];
        [_btnRight setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    return _btnRight;
}

- (UIImageView *)imgLeft {
    if (!_imgLeft) {
        _imgLeft = [[UIImageView alloc] init];
        _imgLeft.contentMode = UIViewContentModeCenter;
    }
    return _imgLeft;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLOR_CECECE;
    }
    return _lineView;
}

@end
