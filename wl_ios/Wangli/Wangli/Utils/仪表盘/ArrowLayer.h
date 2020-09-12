//
//  ArrowLayer.h
//  Wangli
//
//  Created by yeqiang on 2018/4/24.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface ArrowLayer : CALayer

-(void)countFrom:(CGFloat)startValue to:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

@end
