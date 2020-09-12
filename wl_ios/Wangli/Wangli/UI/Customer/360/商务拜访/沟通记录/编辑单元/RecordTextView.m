//
//  RecordTextView.m
//  Wangli
//
//  Created by yeqiang on 2019/1/2.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "RecordTextView.h"
#import "JYTextMo.h"

@interface RecordTextView () <UITextViewDelegate>

@property (nonatomic, assign) BOOL isInputEmoticon;
/// 改变Range
@property (assign, nonatomic) NSRange changeRange;
/// 是否改变
@property (assign, nonatomic) BOOL isChanged;
/// 光标位置
@property (assign, nonatomic) NSInteger cursorLocation;

/// 改变Range
@property (assign, nonatomic) NSRange changeRanges;
/// 是否改变
@property (assign, nonatomic) BOOL isChangeds;
/// 光标位置
@property (assign, nonatomic) NSInteger cursorLocations;
@property (strong, nonatomic) NSMutableArray *memberArray;
@property (strong, nonatomic) NSMutableArray *AtArray;
@property (strong, nonatomic) NSMutableArray *orderArray;

@end

@implementation RecordTextView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUI];
        self.memberArray = [NSMutableArray array];
        self.AtArray = [NSMutableArray array];
        self.orderArray = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        self.memberArray = [NSMutableArray array];
        self.AtArray = [NSMutableArray array];
        self.orderArray = [NSMutableArray array];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.textView];
    UIView *btnView = [[UIView alloc] init];
    [self addSubview:btnView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(btnView.mas_top);
    }];
    
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@0.0);
    }];
    
    
//    NSArray *arrTitle = @[@"客户", @"同事", @"订单"];
//    UIButton *btnLast = nil;
//    for (int i = 0; i < arrTitle.count; i++) {
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/arrTitle.count, 50)];
//        btn.tag = i+100;
//        btn.titleLabel.font = FONT_F15;
//        [btn setTitle:arrTitle[i] forState:UIControlStateNormal];
//        [btn setTitleColor:COLOR_B2 forState:UIControlStateNormal];
//        [btn setTitleColor:COLOR_C1 forState:UIControlStateSelected];
//        [btn setBackgroundColor:COLOR_C3];
//        [btnView addSubview:btn];
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(btnView);
//            if (btnLast) {
//                make.left.equalTo(btnLast.mas_right);
//                make.width.equalTo(btnLast);
//            } else {
//                make.left.equalTo(btnView);
//            }
//            if (i == arrTitle.count-1) {
//                make.right.equalTo(btnView);
//            }
//        }];
//        btnLast = btn;
//    }
}

//- (void)btnClick:(UIButton *)sender {
//    NSInteger index = sender.tag - 100;
//    [self.textView becomeFirstResponder];
//    if (index == 0) {
//        [self atClick];
//    } else if (index == 1) {
//        [self memberClick];
//    } else if (index == 2) {
//        [self orderClick];
//    }
//}
//
//-(void)atClick {
//    static NSInteger index = 0;
//    NSString *showText = [NSString stringWithFormat:@"@马化云%04ld号@", index];
//    NSString *urlText = [NSString stringWithFormat:@"mahuayun%04ld", index];
//
//    JYTextMo *textMo = [[JYTextMo alloc] init];
//    textMo.showText = showText;
//    textMo.urlText = urlText;
//    textMo.orgText = [Utils insertShowText:showText idStr:urlText];
//    [self.AtArray addObject:textMo];
//    index++;
//
//    [self.textView insertText:showText];
//    NSMutableAttributedString *tmpAString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
//    [tmpAString setAttributes:@{ NSForegroundColorAttributeName: COLOR_LINK, NSFontAttributeName: [UIFont systemFontOfSize:16] , NSLinkAttributeName: urlText} range:NSMakeRange(self.textView.selectedRange.location - showText.length, showText.length)];
//    self.textView.attributedText = tmpAString;
//}
//
//-(void)memberClick{
//    static NSInteger index = 0;
//    NSString *showText = [NSString stringWithFormat:@"$爱旭客户%04ld号$", index];
//    NSString *urlText = [NSString stringWithFormat:@"Wanglicustomer%04ld", index];
//    JYTextMo *textMo = [[JYTextMo alloc] init];
//    textMo.showText = showText;
//    textMo.urlText = urlText;
//    textMo.orgText = [Utils insertShowText:showText idStr:urlText];
//    [self.memberArray addObject:textMo];
//    index++;
//
//    [self.textView insertText:showText];
//    NSMutableAttributedString *tmpAString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
//    [tmpAString setAttributes:@{ NSForegroundColorAttributeName: COLOR_LINK, NSFontAttributeName: [UIFont systemFontOfSize:16], NSLinkAttributeName: urlText} range:NSMakeRange(self.textView.selectedRange.location - showText.length, showText.length)];
//    self.textView.attributedText = tmpAString;
//}
//
//- (void)orderClick{
//    [Utils getTimeByCount: 0];
//    static NSInteger index = 0;
//    NSString *showText = [NSString stringWithFormat:@"#销售订单%04ld号#", index];
//    NSString *urlText = [NSString stringWithFormat:@"orderID%04ld", index];
//    JYTextMo *textMo = [[JYTextMo alloc] init];
//    textMo.showText = showText;
//    textMo.urlText = urlText;
//    textMo.orgText = [Utils insertShowText:showText idStr:urlText];
//    [self.orderArray addObject:textMo];
//    index++;
//
//    [self.textView insertText:showText];
//    NSMutableAttributedString *tmpAString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
//    [tmpAString setAttributes:@{ NSForegroundColorAttributeName: COLOR_LINK, NSFontAttributeName: [UIFont systemFontOfSize:16], NSLinkAttributeName: urlText} range:NSMakeRange(self.textView.selectedRange.location - showText.length, showText.length)];
//    self.textView.attributedText = tmpAString;
//}
//
//
//- (void)textViewDidChangeSelection:(UITextView *)textView {
//    //客户
//    NSArray *rangeArray = [self getMemberRangeArray:nil];
//    BOOL inRange = NO;
//    for (NSInteger i = 0; i < rangeArray.count; i++) {
//        NSRange range = NSRangeFromString(rangeArray[i]);
//        if (textView.selectedRange.location > range.location && textView.selectedRange.location < range.location + range.length) {
//            inRange = YES;
//            break;
//        }
//    }
//    if (inRange) {
//        textView.selectedRange = NSMakeRange(self.cursorLocation, textView.selectedRange.length);
//        return;
//    }
//    self.cursorLocation = textView.selectedRange.location;
//
//    //@功能
//    NSArray *rangeArrays = [self getAtRangeArray:nil];
//    BOOL inRanges = NO;
//    for (NSInteger i = 0; i < rangeArrays.count; i++) {
//        NSRange ranges = NSRangeFromString(rangeArrays[i]);
//        if (textView.selectedRange.location > ranges.location && textView.selectedRange.location < ranges.location + ranges.length) {
//            inRanges = YES;
//            break;
//        }
//    }
//    if (inRanges) {
//        textView.selectedRange = NSMakeRange(self.cursorLocations, textView.selectedRange.length);
//        return;
//    }
//    self.cursorLocations = textView.selectedRange.location;
//
//    //订单
//    NSArray *rangeArray1 = [self getOrderRangeArray:nil];
//    BOOL inRanges1 = NO;
//    for (NSInteger i = 0; i < rangeArray1.count; i++) {
//        NSRange ranges = NSRangeFromString(rangeArray1[i]);
//        if (textView.selectedRange.location > ranges.location && textView.selectedRange.location < ranges.location + ranges.length) {
//            inRanges1 = YES;
//            break;
//        }
//    }
//    if (inRanges1) {
//        textView.selectedRange = NSMakeRange(self.cursorLocations, textView.selectedRange.length);
//        return;
//    }
//    self.cursorLocations = textView.selectedRange.location;
//}
//
//- (void)textViewDidChange:(UITextView *)textView {
//    //客户
//    if (_isChanged) {
//        NSMutableAttributedString *tmpAString = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
//        [tmpAString setAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:16] } range:_changeRange];
//        textView.attributedText = tmpAString;
//        _isChanged = NO;
//    }
//    //@功能
//    if (_isChangeds) {
//        NSMutableAttributedString *tmpAStrings = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
//        [tmpAStrings setAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:16] } range:_changeRanges];
//        textView.attributedText = tmpAStrings;
//        _isChangeds = NO;
//    }
//
//    //订单
//    if (_isChanged) {
//        NSMutableAttributedString *tmpAString = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
//        [tmpAString setAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:16] } range:_changeRange];
//        textView.attributedText = tmpAString;
//        _isChanged = NO;
//    }
//
//}
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([text isEqualToString:@""]) { // 删除
//        //客户
//        NSArray *rangeArray = [self getMemberRangeArray:nil];
//
//        for (NSInteger i = 0; i < rangeArray.count; i++) {
//            NSRange tmpRange = NSRangeFromString(rangeArray[i]);
//            if ((range.location + range.length) == (tmpRange.location + tmpRange.length)) {
//                if ([NSStringFromRange(tmpRange) isEqualToString:NSStringFromRange(textView.selectedRange)]) {
//                    // 第二次点击删除按钮 删除
//                    NSLog(@"打印前%@",self.memberArray);
//                    [self.memberArray removeObjectAtIndex:rangeArray.count-1];
//                    NSLog(@"打印后%@",self.memberArray);
//                    return YES;
//                } else {
//                    // 第一次点击删除按钮 选中
//                    textView.selectedRange = tmpRange;
//                    return NO;
//                }
//            }
//        }
//        //@功能
//        NSArray *rangeArrays = [self getAtRangeArray:nil];
//        for (NSInteger i = 0; i < rangeArrays.count; i++) {
//            NSRange tmpRanges = NSRangeFromString(rangeArrays[i]);
//            if ((range.location + range.length) == (tmpRanges.location + tmpRanges.length)) {
//                if ([NSStringFromRange(tmpRanges) isEqualToString:NSStringFromRange(textView.selectedRange)]) {
//                    NSLog(@"打印前%@",self.AtArray);
//                    [self.AtArray removeObjectAtIndex:rangeArrays.count-1];
//                    NSLog(@"打印后%@",self.AtArray);
//                    // 第二次点击删除按钮 删除
//                    return YES;
//                } else {
//                    // 第一次点击删除按钮 选中
//                    textView.selectedRange = tmpRanges;
//                    return NO;
//                }
//            }
//        }
//
//        //订单
//        NSArray *rangeArray1 = [self getOrderRangeArray:nil];
//
//        for (NSInteger i = 0; i < rangeArray1.count; i++) {
//            NSRange tmpRange = NSRangeFromString(rangeArray1[i]);
//            if ((range.location + range.length) == (tmpRange.location + tmpRange.length)) {
//                if ([NSStringFromRange(tmpRange) isEqualToString:NSStringFromRange(textView.selectedRange)]) {
//                    // 第二次点击删除按钮 删除
//                    NSLog(@"打印前%@",self.orderArray);
//                    [self.orderArray removeObjectAtIndex:rangeArray1.count-1];
//                    NSLog(@"打印后%@",self.orderArray);
//                    return YES;
//                } else {
//                    // 第一次点击删除按钮 选中
//                    textView.selectedRange = tmpRange;
//                    return NO;
//                }
//            }
//        }
//
//    } else { // 增加
//        //客户
//        NSArray *rangeArray = [self getMemberRangeArray:nil];
//        if ([rangeArray count]) {
//            for (NSInteger i = 0; i < rangeArray.count; i++) {
//                NSRange tmpRange = NSRangeFromString(rangeArray[i]);
//                if ((range.location + range.length) == (tmpRange.location + tmpRange.length) || !range.location) {
//                    _changeRange = NSMakeRange(range.location, text.length);
//                    _isChanged = YES;
//                    return YES;
//                }
//            }
//        } else {
//            // 客户在第一个删除后 重置text color
//            if (!range.location) {
//                _changeRange = NSMakeRange(range.location, text.length);
//                _isChanged = YES;
//                return YES;
//            }
//        }
//        //@功能
//        NSArray *rangeAtrray = [self getAtRangeArray:nil];
//        if ([rangeAtrray count]) {
//            for (NSInteger i = 0; i < rangeAtrray.count; i++) {
//                NSRange tmpTRange = NSRangeFromString(rangeAtrray[i]);
//                if ((range.location + range.length) == (tmpTRange.location + tmpTRange.length) || !range.location) {
//                    _changeRanges = NSMakeRange(range.location, text.length);
//                    _isChangeds = YES;
//                    return YES;
//                }
//            }
//        } else {
//            // 客户在第一个删除后 重置text color
//            if (!range.location) {
//                _changeRanges = NSMakeRange(range.location, text.length);
//                _isChangeds = YES;
//                return YES;
//            }
//        }
//
//        // 订单
//        NSArray *rangeArray1 = [self getOrderRangeArray:nil];
//        if ([rangeArray1 count]) {
//            for (NSInteger i = 0; i < rangeArray1.count; i++) {
//                NSRange tmpRange = NSRangeFromString(rangeArray1[i]);
//                if ((range.location + range.length) == (tmpRange.location + tmpRange.length) || !range.location) {
//                    _changeRange = NSMakeRange(range.location, text.length);
//                    _isChanged = YES;
//                    return YES;
//                }
//            }
//        } else {
//            // 客户在第一个删除后 重置text color
//            if (!range.location) {
//                _changeRange = NSMakeRange(range.location, text.length);
//                _isChanged = YES;
//                return YES;
//            }
//        }
//    }
//    return YES;
//}
//- (NSArray *)getMemberRangeArray:(NSAttributedString *)attributedString {
//    NSAttributedString *traveAStr = attributedString ?: _textView.attributedText;
//    __block NSMutableArray *rangeArray = [NSMutableArray array];
//    static NSRegularExpression *iExpression;
//    iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:@"\\$(.*?)\\$" options:0 error:NULL];
//    [iExpression enumerateMatchesInString:traveAStr.string
//                                  options:0
//                                    range:NSMakeRange(0, traveAStr.string.length)
//                               usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//                                   NSRange resultRange = result.range;
//                                   NSDictionary *attributedDict = [traveAStr attributesAtIndex:resultRange.location effectiveRange:&resultRange];
//                                   if ([attributedDict[NSForegroundColorAttributeName] isEqual:COLOR_LINK]) {
//                                       [rangeArray addObject:NSStringFromRange(result.range)];
//                                   }
//                               }];
//    return rangeArray;
//}
//- (NSArray *)getAtRangeArray:(NSAttributedString *)attributedString {
//    NSAttributedString *traveAStr = attributedString ?:_textView.attributedText;
//    __block NSMutableArray *rangeArrays = [NSMutableArray array];
//    static NSRegularExpression *iExpression;
//    iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:@"\\@(.*?)\\@" options:0 error:NULL];
//    [iExpression enumerateMatchesInString:traveAStr.string
//                                  options:0
//                                    range:NSMakeRange(0, traveAStr.string.length)
//                               usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//                                   NSRange resultRange = result.range;
//                                   NSDictionary *attributedDict = [traveAStr attributesAtIndex:resultRange.location effectiveRange:&resultRange];
//                                   if ([attributedDict[NSForegroundColorAttributeName] isEqual:COLOR_LINK]) {
//                                       [rangeArrays addObject:NSStringFromRange(result.range)];
//                                   }
//                               }];
//    return rangeArrays;
//}
//
//- (NSArray *)getOrderRangeArray:(NSAttributedString *)attributedString {
//    NSAttributedString *traveAStr = attributedString ?:_textView.attributedText;
//    __block NSMutableArray *rangeArrays = [NSMutableArray array];
//    static NSRegularExpression *iExpression;
//    iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:@"\\#(.*?)\\#" options:0 error:NULL];
//    [iExpression enumerateMatchesInString:traveAStr.string
//                                  options:0
//                                    range:NSMakeRange(0, traveAStr.string.length)
//                               usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//                                   NSRange resultRange = result.range;
//                                   NSDictionary *attributedDict = [traveAStr attributesAtIndex:resultRange.location effectiveRange:&resultRange];
//                                   if ([attributedDict[NSForegroundColorAttributeName] isEqual:COLOR_LINK]) {
//                                       [rangeArrays addObject:NSStringFromRange(result.range)];
//                                   }
//                               }];
//    return rangeArrays;
//}
//
////- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
////    [self.view endEditing:YES];
////}
//
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (_delegate && [_delegate respondsToSelector:@selector(recordTextViewBeginEdit:)]) {
        [_delegate recordTextViewBeginEdit:self];
    }
}
//
//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
//    if (URL.absoluteString.length > 0) {
//        NSLog(@"点击了----URL： %@", URL.absoluteString);
//        [Utils showToastMessage:URL.absoluteString];
////        WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
////        vc.urlStr = URL.absoluteString;
////        NSAttributedString *attr = self.labContent.attributedText;
////        NSString *str = [attr string];
////        vc.titleStr = [str substringWithRange:characterRange];
////        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
//        return NO;
//    }
//    return YES;
//}

#pragma mark - lazy

- (UITextView *)textView {
    if (!_textView) {;
        _textView = [UITextView new];
        _textView.textContainerInset = UIEdgeInsetsMake(0,0,0,0);
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.alwaysBounceVertical = YES;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textColor = [UIColor blackColor];
        _textView.delegate = self;
        _textView.inputAccessoryView = [UIView new];
    }
    return _textView;
}

@end
