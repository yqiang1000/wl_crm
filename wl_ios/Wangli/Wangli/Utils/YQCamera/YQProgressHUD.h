//
//  YQProgressHUD.h
//  KJCamera
//
//  Created by yeqiang on 2018/12/10.
//  Copyright © 2018年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YQProgressHUD : UIView

@property (assign, nonatomic) NSInteger timeMax;

- (void)clearProgress;

@end

NS_ASSUME_NONNULL_END
