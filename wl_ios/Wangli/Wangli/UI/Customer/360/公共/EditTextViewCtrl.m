//
//  EditTextViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/7.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "EditTextViewCtrl.h"
#import "RestrictionInput.h"
#import "LeftLabel.h"

@interface EditTextViewCtrl () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *labPlaceholder;
@property (nonatomic, assign) BOOL isStop;
@property (nonatomic, strong) LeftLabel *labCount;
@property (nonatomic, strong) UIView *baseView;

@end

@implementation EditTextViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    _isStop = NO;
    [self setUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextViewTextDidChangeNotification object:nil];
    [self.txtView becomeFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUI {
    [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightBtn setImage:nil forState:UIControlStateNormal];
    
    [self.view addSubview:self.baseView];
    [self.baseView addSubview:self.txtView];
    [self.baseView addSubview:self.labCount];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@150);
    }];
    
    [self.txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.baseView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    [self.labCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.baseView.mas_right).offset(-20);
        make.bottom.equalTo(self.baseView.mas_bottom).offset(-20);
    }];
    
    NSInteger length = [Utils getToLength:_txtView.text];
    [self.labCount setLeftLength:(_max_length-length/2) totalLength:_max_length];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    _currentText = textView.text;
}

- (void)textFieldChange:(NSNotification *)noti
{
    UITextView *txtView = (UITextView *)noti.object;
    //判断输入(不能输入特殊字符)
    [RestrictionInput restrictionInputTextView:self.txtView maxNumber:_max_length*2+1 showErrorMessage:nil checkChar:NO];
    
    NSString *toBeString = txtView.text;
    NSString *lang = [[txtView textInputMode] primaryLanguage];
    if([lang isEqualToString:@"zh-Hans"]){ //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [txtView markedTextRange];
        UITextPosition *position = [txtView positionFromPosition:selectedRange.start offset:0];
        if (!position){//非高亮
            NSInteger length = [Utils getToLength:toBeString];
            [self.labCount setLeftLength:(_max_length-length/2) totalLength:_max_length];
            if ((_max_length-length/2) > 0) {
                _isStop = NO;
            } else {
                _isStop = YES;
            }
        }
    }else{//中文输入法以外
        NSInteger length = [Utils getToLength:toBeString];
        [self.labCount setLeftLength:(_max_length-length/2) totalLength:_max_length];
        
        if ((_max_length-length/2) > 0) {
            _isStop = NO;
        } else {
            _isStop = YES;
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""]) {
        if (_numberOnly) {
            return [self validateNumber:text];
        } else {
            return YES;
        }
    }
    if (_isStop) {
        return NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    if ([RestrictionInput isInputRuleAndBlank:text regular:REGULAR_EXPRESSION]) {
        if (_numberOnly) {
            return [self validateNumber:text];
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark - public

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    if (!_labPlaceholder) {
        self.labPlaceholder.text = _placeholder;
        [self.txtView addSubview:self.labPlaceholder];
        [self.txtView setValue:self.labPlaceholder forKey:@"_placeholderLabel"];
    }
}

- (void)setCurrentText:(NSString *)currentText {
    _currentText = currentText;
    self.txtView.text = currentText;
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    if (_editVCDelegate && [_editVCDelegate respondsToSelector:@selector(editVC:content:indexPath:btnRightClick:complete:)]) {
        [_editVCDelegate editVC:self content:self.currentText indexPath:self.indexPath btnRightClick:sender complete:^(BOOL updateSucce, NSString *tost) {
            if (tost.length != 0) [Utils showToastMessage:tost];
            if (updateSucce) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        return;
    }
    else {
        if (_editVCDelegate && [_editVCDelegate respondsToSelector:@selector(editVC:content:indexPath:)]) {
            [_editVCDelegate editVC:self content:self.currentText indexPath:self.indexPath];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)setKeyType:(UIKeyboardType)keyType {
    _keyType = keyType;
    self.txtView.keyboardType = keyType;
}

- (void)setHidenCount:(BOOL)hidenCount {
    _hidenCount = hidenCount;
    self.labCount.hidden = _hidenCount;
}

#pragma mark - setter getter

- (UITextView *)txtView {
    if (!_txtView) {
        _txtView = [[UITextView alloc] init];
        _txtView.textColor = COLOR_B1;
        _txtView.font = FONT_F16;
        _txtView.delegate = self;
    }
    return _txtView;
}

- (UILabel *)labPlaceholder {
    if (!_labPlaceholder) {
        _labPlaceholder = [UILabel new];
        _labPlaceholder.numberOfLines = 0;
        _labPlaceholder.textColor = COLOR_B3;
        _labPlaceholder.font = FONT_F16;
        [_labPlaceholder sizeToFit];
    }
    return _labPlaceholder;
}

- (LeftLabel *)labCount {
    if (!_labCount) {
        _labCount = [[LeftLabel alloc] init];
    }
    return _labCount;
}

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}

@end
