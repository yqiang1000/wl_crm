//
//  YQAVPlayer.h
//  KJCamera
//
//  Created by yeqiang on 2018/12/10.
//  Copyright © 2018年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YQAVPlayer : UIView

- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)url
              finishplayblock:(void (^)(YQAVPlayer *obj))finishplayblock;

@property (copy, nonatomic) NSURL *videoUrl;

- (void)stopPlayer;

@end

NS_ASSUME_NONNULL_END
