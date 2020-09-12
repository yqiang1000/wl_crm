
//
//  ArrowLayer.m
//  Wangli
//
//  Created by yeqiang on 2018/4/24.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "ArrowLayer.h"

@implementation ArrowLayer

//实现代理方法
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
  
    CGContextSaveGState(ctx);
    
    UIImage * image = [UIImage imageNamed:@"圆心"];
    CGContextDrawImage(ctx, CGRectMake(0, 0, 62, 21), image.CGImage);
    CGContextRestoreGState(ctx);
    
}

-(void)countFrom:(CGFloat)startValue to:(CGFloat)endValue withDuration:(NSTimeInterval)duration {
    CABasicAnimation * animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation2.duration = duration;
    animation2.fromValue = [NSNumber numberWithFloat:startValue];
    animation2.toValue = [NSNumber numberWithFloat:endValue];
    animation2.repeatCount = 1;
    animation2.removedOnCompletion = NO;
    animation2.fillMode = kCAFillModeForwards;
    [self addAnimation:animation2 forKey:@"rotation"];
}

@end
