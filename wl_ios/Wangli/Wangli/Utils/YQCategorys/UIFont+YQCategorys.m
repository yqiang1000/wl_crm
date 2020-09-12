//
//  UIFont+YQCategorys.m
//  HangGuo
//
//  Created by yeqiang on 2020/1/15.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "UIFont+YQCategorys.h"

@implementation UIFont (YQCategorys)

+ (UIFont *)pingFangSCWithWeight:(PFFontWeightStyle)fontWeight size:(CGFloat)fontSize {
    fontSize = FontAuto(fontSize);
    
    if (fontWeight < PFFontWeightStyleMedium || fontWeight > PFFontWeightStyleThin) {
        fontWeight = PFFontWeightStyleRegular;
    }
    
    NSString *fontName = @"PingFangSC-Regular";
    switch (fontWeight) {
        case PFFontWeightStyleMedium:
            fontName = @"PingFangSC-Medium";
            break;
        case PFFontWeightStyleSemibold:
            fontName = @"PingFangSC-Semibold";
            break;
        case PFFontWeightStyleLight:
            fontName = @"PingFangSC-Light";
            break;
        case PFFontWeightStyleUltralight:
            fontName = @"PingFangSC-Ultralight";
            break;
        case PFFontWeightStyleRegular:
            fontName = @"PingFangSC-Regular";
            break;
        case PFFontWeightStyleThin:
            fontName = @"PingFangSC-Thin";
            break;
    }
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    
    return font ?: [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)DINAlternateWithWeight:(DINFontWeightStyle)fontWeight size:(CGFloat)fontSize {
    if (fontWeight < DINFontWeightStyle_Bold || fontWeight > DINFontWeightStyle_Bold) {
        fontWeight = DINFontWeightStyle_Bold;
    }
    
    NSString *fontName = @"DINAlternate-Bold";
    switch (fontWeight) {
        case DINFontWeightStyle_Bold:
            fontName = @"DINAlternate-Bold";
            break;
    }
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    
    return font ?: [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)IMPACTFontWithSize:(CGFloat)fontSize{
    UIFont *font = [UIFont fontWithName:@"impact" size:fontSize];
    return font;
}

@end
