//
//  UIFont+YQCategorys.h
//  HangGuo
//
//  Created by yeqiang on 2020/1/15.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PFFontWeightStyle) {
    PFFontWeightStyleMedium, // 中黑体
    PFFontWeightStyleSemibold, // 中粗体
    PFFontWeightStyleLight, // 细体
    PFFontWeightStyleUltralight, // 极细体
    PFFontWeightStyleRegular, // 常规体
    PFFontWeightStyleThin, // 纤细体
};//PingFang SC 苹方简体

typedef NS_ENUM(NSInteger, DINFontWeightStyle) {
    DINFontWeightStyle_Bold,
};//DIN Alternate

@interface UIFont (YQCategorys)

/// 苹方简体
/// @param fontWeight 字体粗细（字重)
/// @param fontSize 字体大小
+ (UIFont *)pingFangSCWithWeight:(PFFontWeightStyle)fontWeight size:(CGFloat)fontSize;

/// DIN字体
/// @param fontWeight fontWeight
/// @param fontSize fontSize
+ (UIFont *)DINAlternateWithWeight:(DINFontWeightStyle)fontWeight size:(CGFloat)fontSize;

/// impact 字体
/// @param fontSize fontSize
+ (UIFont *)IMPACTFontWithSize:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
