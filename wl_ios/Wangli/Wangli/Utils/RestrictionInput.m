//
//  RestrictionInput.m
//  ABCInstitution
//
//  Created by bing on 2017/5/26.
//  Copyright © 2017年 北京暄暄科技有限公司. All rights reserved.
//

#import "RestrictionInput.h"

@implementation RestrictionInput

+ (void)restrictionInputTextField:(UITextField *)inputClass maxNumber:(NSInteger)maxNumber showErrorMessage:(NSString *)errorMessage
{
    
    NSString *toBeString = inputClass.text;
    
    if (![self isInputRuleAndBlank:toBeString regular:REGULAR_EXPRESSION]) {
        inputClass.text = [self disable_emoji:toBeString];
        return;
    }
    
    NSString *lang = [[inputClass textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
        UITextRange *selectedRange = [inputClass markedTextRange];
        //获取高亮部分
        UITextPosition *position = [inputClass positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            NSString *getStr = [self getSubString:toBeString maxNumber:maxNumber];
            if(getStr && getStr.length > 0) {
                inputClass.text = getStr;
                [Utils showToastMessage:errorMessage];
            }
        }
    } else{
        NSString *getStr = [self getSubString:toBeString maxNumber:maxNumber];
        if(getStr && getStr.length > 0) {
            inputClass.text= getStr;
        }
    }
}

+ (void)restrictionInputTextView:(UITextView *)inputClass maxNumber:(NSInteger)maxNumber showErrorMessage:(NSString *)errorMessage checkChar:(BOOL)checkChar
{
    NSString *toBeString = inputClass.text;
    
    if (checkChar) {
        if (![self isInputRuleAndBlank:toBeString regular:REGULAR_EXPRESSION]) {
            inputClass.text = [self disable_emoji:toBeString];
            return;
        }
    }
    
    NSString *lang = [[inputClass textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
        UITextRange *selectedRange = [inputClass markedTextRange];
        //获取高亮部分
        UITextPosition *position = [inputClass positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            NSString *getStr = [self getSubString:toBeString maxNumber:maxNumber];
            if(getStr && getStr.length > 0) {
                inputClass.text = getStr;
                [Utils showToastMessage:errorMessage];
            }
        }
    } else{
        NSString *getStr = [self getSubString:toBeString maxNumber:maxNumber];
        if(getStr && getStr.length > 0) {
            inputClass.text= getStr;
            [Utils showToastMessage:errorMessage];
        }
    }
}

/**
 *  获得 kMaxLength长度的字符
 */
+ (NSString *)getSubString:(NSString*)string maxNumber:(NSInteger)maxNumber
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:encoding];
    NSInteger length = [data length];
    if (length > maxNumber) {
        NSData *data1 = [data subdataWithRange:NSMakeRange(0, maxNumber)];
        NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];//【注意4】：当截取kMaxLength长度字符时把中文字符截断返回的content会是nil
        if (!content || content.length == 0) {
            data1 = [data subdataWithRange:NSMakeRange(0, maxNumber - 1)];
            content =  [[NSString alloc] initWithData:data1 encoding:encoding];
        }
        return content;
    }
    return nil;
}

/**
 * 字母、数字、中文正则判断（不包括空格）
 */
+ (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[➋➌➍➎➏➐➑➒\a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
/**
 * 字母、数字、中文正则判断（包括空格）【注意3】
 */
+ (BOOL)isInputRuleAndBlank:(NSString *)str regular:(NSString *)regular {
    
    //九宫格无法输入解决需要加上正则 \➋➌➍➎➏➐➑➒
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

+ (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

@end
