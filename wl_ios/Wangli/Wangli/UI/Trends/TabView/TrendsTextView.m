//
//  TrendsTextView.m
//  Wangli
//
//  Created by yeqiang on 2019/1/27.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsTextView.h"
#import "JYTextMo.h"
#import "ContactDetailViewCtrl.h"
#import "WebDetailViewCtrl.h"
#import "CustomerCardViewCtrl.h"

@interface TrendsTextView () <UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrCustomer;
@property (nonatomic, strong) NSMutableArray *arrAt;
@property (nonatomic, strong) NSMutableArray *arrOrder;

@end

@implementation TrendsTextView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.font = FONT_F14;
        self.textColor = COLOR_B2;
        self.scrollEnabled = NO;
        self.editable = NO;
        self.contentInset = UIEdgeInsetsMake(0,0,0,0);
        self.delegate = self;
        self.editable = NO;
        self.selectable = YES;
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTextView:)];
//        tap.numberOfTapsRequired = 1;
//        tap.numberOfTouchesRequired = 1;
//        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)loadText:(NSString *)myNormalText {
    _myNormalText = myNormalText;
    if (_arrOrder) {
        [_arrOrder removeAllObjects];
        _arrOrder = nil;
    }
    if (_arrCustomer) {
        [_arrCustomer removeAllObjects];
        _arrCustomer = nil;
    }
    if (_arrAt) {
        [_arrAt removeAllObjects];
        _arrAt = nil;
    }
    
    NSMutableAttributedString *tmpAString = [[NSMutableAttributedString alloc] initWithString:_myNormalText];
    tmpAString = [self deallWithOrgText:tmpAString.string tmpAString:tmpAString rangeArray:[self getMemberRangeArray:tmpAString.string] dataArr:self.arrCustomer rules:@""];
    tmpAString = [self deallWithOrgText:tmpAString.string tmpAString:tmpAString rangeArray:[self getAtRangeArray:tmpAString.string] dataArr:self.arrAt rules:@""];
    tmpAString = [self deallWithOrgText:tmpAString.string tmpAString:tmpAString rangeArray:[self getOrderRangeArray:tmpAString.string] dataArr:self.arrOrder rules:@"111"];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    
    [tmpAString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, tmpAString.string.length)];
    [self setLinkTextAttributes:@{NSForegroundColorAttributeName:COLOR_C1}];
    self.myAttText = tmpAString;
    self.attributedText = tmpAString;
}

/**
 *  获取富文本
 *  orgText     原始的纯文字数据
 *  tmpAString  原始的富文本数据
 *  rangeArray  range数组
 *  dataArr     需要存放的数组
 *  isOrder     需要存放的数组
 */
- (NSMutableAttributedString *)deallWithOrgText:(NSString *)orgText tmpAString:(NSMutableAttributedString *)tmpAString rangeArray:(NSArray *)rangeArray dataArr:(NSMutableArray *)dataArr rules:(NSString *)rules {
    for (NSInteger i = 0; i < rangeArray.count; i++) {
        
        JYTextMo *textMo = [[JYTextMo alloc] init];
        // 取出## #=123=XS102981-22.1%档PERC要货120M W#
        NSRange range = NSRangeFromString(rangeArray[i]);
        NSString *str = [orgText substringWithRange:range];
        textMo.orgText = str;
        
        NSArray *idsArr = [self getIds:str rules:rules];
        for (NSInteger j = 0; j < idsArr.count; j++) {
            // 取出Id =123= 订单去出 {xxx}
            NSRange rangeId = NSRangeFromString(idsArr[j]);
            NSString *strId = [str substringWithRange:rangeId];
            textMo.urlText = strId;
            
            NSString *showText = [NSString stringWithFormat:@"%@%@" ,[str substringWithRange:NSMakeRange(0, 1)], [str substringWithRange:NSMakeRange(rangeId.location+rangeId.length, str.length-rangeId.location-rangeId.length)]];
            textMo.showText = showText;
        }
        [dataArr addObject:textMo];
    }
    
    //    cusStr = tmpAString.string;
    // 最开始的字符串
    //    NSMutableAttributedString *tmpAString = [[NSMutableAttributedString alloc] initWithString:cusStr];
    for (int i = 0 ; i < dataArr.count; i++) {
        JYTextMo *textMo = dataArr[i];
        if (textMo.showText.length > 0) {
            NSMutableAttributedString *showText = [[NSMutableAttributedString alloc] initWithString:textMo.showText];
            [showText setAttributes:@{NSFontAttributeName: FONT_F14 , NSLinkAttributeName: textMo.urlText} range:NSMakeRange(0, showText.length)];
            [tmpAString replaceCharactersInRange:[orgText rangeOfString:textMo.orgText] withAttributedString:showText];
        }
    }
    
    return tmpAString;
}

// 点击无链接区域处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    UITextPosition *textPosition = [self closestPositionToPoint:point];
    NSDictionary *attributes = [self textStylingAtPosition:textPosition inDirection:UITextStorageDirectionForward];
    NSURL *url = attributes[NSLinkAttributeName];
    
    if (url) {
//        NSLog(@"点击链接：%@", url);
//        NSString *urlStr = (NSString *)url;
//        NSRange range = [self.myNormalText rangeOfString:urlStr];
//        [super touchesBegan:touches withEvent:event];
    } else {
        NSLog(@"点击无链接区域");
        if (_trendsDelegate && [_trendsDelegate respondsToSelector:@selector(trendsTextView:didSelectUrlStr:)]) {
            [_trendsDelegate trendsTextView:self didSelectUrlStr:@""];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

#pragma mark - UITextViewDelegate

//- (void)tappedTextView:(UITapGestureRecognizer *)tapGesture {
//    CGPoint point = [tapGesture locationInView:self];
//    if (tapGesture.state != UIGestureRecognizerStateEnded) {
//        return;
//    }
//
//    UITextView *textView = (UITextView *)tapGesture.view;
//    CGPoint tapLocation = [tapGesture locationInView:textView];
//    UITextPosition *textPosition = [textView closestPositionToPoint:tapLocation];
//    NSDictionary *attributes = [textView textStylingAtPosition:textPosition inDirection:UITextStorageDirectionForward];
//    NSURL *url = attributes[NSLinkAttributeName];
//
//    if (url) {
//        NSLog(@"点击链接：%@", url);
//        NSString *urlStr = (NSString *)url;
//        NSRange range = [self.myNormalText rangeOfString:urlStr];
//
//    } else {
//        NSLog(@"点击无链接区域");
//        if (_trendsDelegate && [_trendsDelegate respondsToSelector:@selector(trendsTextView:didSelectUrlStr:)]) {
//            [_trendsDelegate trendsTextView:self didSelectUrlStr:@""];
//        }
//    }
//}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    // 自带的URL
    NSString *urlStr = URL.absoluteString;
    // 先判断自带的链接，如果没有，则从富文本中取
    if (urlStr.length == 0) {
        NSAttributedString *attString = [self.attributedText attributedSubstringFromRange:characterRange];
        NSRange maxRange = NSMakeRange(0, attString.length);
        NSDictionary *dic = [attString attributesAtIndex:0 longestEffectiveRange:&maxRange inRange:maxRange];
        urlStr = dic[@"NSLink"];
    }
    if (urlStr > 0) {
        NSAttributedString *attr = self.attributedText;
        NSString *orgStr = attr.string;
        // 带符号名称
        NSString *title = [orgStr substringWithRange:characterRange];
        // 去等号id
        urlStr = [urlStr substringWithRange:NSMakeRange(1, urlStr.length-2)];

        if ([title hasPrefix:@"@"]) {
            ContactDetailViewCtrl *vc = [[ContactDetailViewCtrl alloc] init];
            JYUserMo *userMo = [[JYUserMo alloc] init];
            userMo.id = [urlStr integerValue];
            vc.userMo = userMo;
            vc.hidesBottomBarWhenPushed = YES;
            [[Utils topViewController].navigationController pushViewController:vc animated:YES];
        } else if ([title hasPrefix:@"$"]) {
            CustomerCardViewCtrl *vc = [[CustomerCardViewCtrl alloc] init];
            CustomerMo *mo = [[CustomerMo alloc] init];
            [TheCustomer insertCustomer:mo];
            mo.orgName = [title substringWithRange:NSMakeRange(1, title.length-2)];
            mo.id = [urlStr integerValue];
            vc.mo = mo;
            vc.index = 0;
            vc.forbidRefresh = YES;
            TheCustomer.fromTab = 0;
            vc.arrData = [[NSMutableArray alloc] initWithObjects:mo, nil];
            vc.hidesBottomBarWhenPushed = YES;
            [[Utils topViewController].navigationController pushViewController:vc animated:YES];
        } else if ([title hasPrefix:@"#"]) {
            WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
            //            ACTION:10061-http://192.168.1.200:9098/*/contract-details?id=96
            // 去{}
            urlStr = [urlStr substringWithRange:NSMakeRange(13, urlStr.length-13)];
            // 替换*
            NSString *newUrl = [urlStr stringByReplacingOccurrencesOfString:@"*" withString:@"#"];
            newUrl = [NSString stringWithFormat:@"%@&token=%@", newUrl, [Utils token]];
            vc.titleStr = [title substringWithRange:NSMakeRange(1, title.length-2)];
            vc.urlStr = newUrl;
            vc.hidesBottomBarWhenPushed = YES;
            [[Utils topViewController].navigationController pushViewController:vc animated:YES];
        }
        if (_trendsDelegate && [_trendsDelegate respondsToSelector:@selector(trendsTextView:didSelectUrlStr:)]) {
            [_trendsDelegate trendsTextView:self didSelectUrlStr:urlStr];
        }
        return NO;
    }
    if (_trendsDelegate && [_trendsDelegate respondsToSelector:@selector(trendsTextView:didSelectUrlStr:)]) {
        [_trendsDelegate trendsTextView:self didSelectUrlStr:urlStr];
    }
    return YES;
}

- (NSArray *)getMemberRangeArray:(NSString *)attributedString {
    NSAttributedString *traveAStr = [[NSAttributedString alloc] initWithString:attributedString];
    __block NSMutableArray *rangeArray = [NSMutableArray array];
    static NSRegularExpression *iExpression;
    iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:@"\\$(.*?)\\$" options:0 error:NULL];
    [iExpression enumerateMatchesInString:traveAStr.string
                                  options:0
                                    range:NSMakeRange(0, traveAStr.string.length)
                               usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                   NSRange resultRange = result.range;
                                   NSDictionary *attributedDict = [traveAStr attributesAtIndex:resultRange.location effectiveRange:&resultRange];
                                   //                                   if ([attributedDict[NSForegroundColorAttributeName] isEqual:COLOR_LINK]) {
                                   [rangeArray addObject:NSStringFromRange(result.range)];
                                   //                                   }
                               }];
    return rangeArray;
}
- (NSArray *)getAtRangeArray:(NSString *)attributedString {
    NSAttributedString *traveAStr = [[NSAttributedString alloc] initWithString:attributedString];
    __block NSMutableArray *rangeArrays = [NSMutableArray array];
    static NSRegularExpression *iExpression;
    iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:@"\\@(.*?)\\@" options:0 error:NULL];
    [iExpression enumerateMatchesInString:traveAStr.string
                                  options:0
                                    range:NSMakeRange(0, traveAStr.string.length)
                               usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                   NSRange resultRange = result.range;
                                   NSDictionary *attributedDict = [traveAStr attributesAtIndex:resultRange.location effectiveRange:&resultRange];
                                   //                                   if ([attributedDict[NSForegroundColorAttributeName] isEqual:COLOR_LINK]) {
                                   [rangeArrays addObject:NSStringFromRange(result.range)];
                                   //                                   }
                               }];
    return rangeArrays;
}

- (NSArray *)getOrderRangeArray:(NSString *)attributedString {
    NSAttributedString *traveAStr = [[NSAttributedString alloc] initWithString:attributedString];
    __block NSMutableArray *rangeArrays = [NSMutableArray array];
    static NSRegularExpression *iExpression;
    iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:@"\\#(.*?)\\#" options:0 error:NULL];
    [iExpression enumerateMatchesInString:traveAStr.string
                                  options:0
                                    range:NSMakeRange(0, traveAStr.string.length)
                               usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                   NSRange resultRange = result.range;
                                   NSDictionary *attributedDict = [traveAStr attributesAtIndex:resultRange.location effectiveRange:&resultRange];
                                   //                                   if ([attributedDict[NSForegroundColorAttributeName] isEqual:COLOR_LINK]) {
                                   [rangeArrays addObject:NSStringFromRange(result.range)];
                                   //                                   }
                               }];
    return rangeArrays;
}

- (NSArray *)getIds:(NSString *)attributedString rules:(NSString *)rules {
    NSAttributedString *traveAStr = [[NSAttributedString alloc] initWithString:attributedString];
    __block NSMutableArray *rangeArrays = [NSMutableArray array];
    NSString *rulerStr = rules.length == 0 ? @"\\=(.*?)\\=" : @"\\{(.*?)\\}";
    NSRegularExpression *iExpression = [NSRegularExpression regularExpressionWithPattern:rulerStr options:0 error:NULL];
    [iExpression enumerateMatchesInString:traveAStr.string
                                  options:0
                                    range:NSMakeRange(0, traveAStr.string.length)
                               usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                   NSRange resultRange = result.range;
                                   NSDictionary *attributedDict = [traveAStr attributesAtIndex:resultRange.location effectiveRange:&resultRange];
                                   //                                   if ([attributedDict[NSForegroundColorAttributeName] isEqual:COLOR_LINK]) {
                                   [rangeArrays addObject:NSStringFromRange(result.range)];
                                   //                                   }
                               }];
    
    return rangeArrays;
}


- (NSMutableArray *)arrCustomer {
    if (!_arrCustomer) _arrCustomer = [NSMutableArray new];
    return _arrCustomer;
}

- (NSMutableArray *)arrAt {
    if (!_arrAt) _arrAt = [NSMutableArray new];
    return _arrAt;
}

- (NSMutableArray *)arrOrder {
    if (!_arrOrder) _arrOrder = [NSMutableArray new];
    return _arrOrder;
}

@end
