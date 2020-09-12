//
//  RestrictionInput.h
//  ABCInstitution
//
//  Created by bing on 2017/5/26.
//  Copyright © 2017年 北京暄暄科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define REGULAR_EXPRESSION @"^[➋➌➍➎➏➐➑➒\a-zA-Z\u4E00-\u9FA5\uFE10-\uFE1F\\d\\s]*$"
#define REGULAR_EXPRESSION1 @"^[A-Za-z0-9]{1,4}$"

@interface RestrictionInput : NSObject

+ (void)restrictionInputTextField:(UITextField *)inputClass maxNumber:(NSInteger)maxNumber showErrorMessage:(NSString *)errorMessage;

+ (void)restrictionInputTextView:(UITextView *)inputClass maxNumber:(NSInteger)maxNumber showErrorMessage:(NSString *)errorMessage checkChar:(BOOL)checkChar;

+ (BOOL)isInputRuleAndBlank:(NSString *)str regular:(NSString *)regular;

@end
