
//
//  GKHeader.h
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#ifndef GKHeader_h
#define GKHeader_h

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define IS_iPhoneX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
(\
CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(812, 375),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(896, 414),[UIScreen mainScreen].bounds.size))\
:\
NO)

#define kNavBarHeight       (IS_iPhoneX ? 88.0f : 64.0f)

//  适配比例
#define ADAPTATIONRATIO     kScreenW / 750.0f

// 颜色
#define GKColorRGBA(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]
#define GKColorRGB(r, g, b)     GKColorRGBA(r, g, b, 1.0)
#define GKColorGray(v)          GKColorRGB(v, v, v)

#define GKColorHEX(hexValue, a) GKColorRGBA(((float)((hexValue & 0xFF0000) >> 16)), ((float)((hexValue & 0xFF00) >> 8)), ((float)(hexValue & 0xFF)), a)

#define GKColorRandom           GKColorRGB(arc4random() % 255, arc4random() % 255, arc4random() % 255)

#define HEXCOLOR(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0  blue:((float)(hexValue & 0xFF))/255.0 alpha:a]

#define kRefreshDuration   0.5f

#define kBaseHeaderHeight  kScreenW * 385.0f / 704.0f
#define kBaseSegmentHeight 40.0f
#define kBaseSwitchHeight 44.0f

#endif /* GKHeader_h */
