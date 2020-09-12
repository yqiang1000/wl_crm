//
//  DrawBusinessFunnelView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "DrawBusinessFunnelView.h"

@interface DrawBusinessFunnelView ()

@end

@implementation DrawBusinessFunnelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_B4;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self drawShap];
}

- (void)drawShap {
    CGFloat maxWidth = CGRectGetWidth(self.frame)*0.7;
    CGFloat minWidth = CGRectGetWidth(self.frame)*0.5;
    
    CGFloat each_W = (maxWidth-minWidth) / 3.0;
    CGFloat each_H = (CGRectGetHeight(self.frame) - 60) / 4.0;
    
    CGPoint pointZero = CGPointMake(20, 50);
    
    CGPoint pointA = CGPointZero;
    CGPoint pointB = CGPointZero;
    CGPoint pointC = CGPointZero;
    CGPoint pointD = CGPointZero;
    
    CGFloat lineWidth = 20.0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i = 0; i < self.arrData.count; i++) {
        FunnelMo *mo = self.arrData[i];
        pointA = CGPointMake(pointZero.x + each_W*i, pointZero.y+each_H*i);
        pointB = CGPointMake(pointZero.x + maxWidth - each_W*i, pointZero.y+each_H*i);
        if (i == self.arrData.count-1) {
            pointC = CGPointMake(pointZero.x + maxWidth - each_W*i, pointZero.y+each_H*(i+1));
            pointD = CGPointMake(pointZero.x + each_W*i, pointZero.y+each_H*(i+1));
        } else {
            pointC = CGPointMake(pointZero.x + maxWidth - each_W*(i+1), pointZero.y+each_H*(i+1));
            pointD = CGPointMake(pointZero.x + each_W*(i+1), pointZero.y+each_H*(i+1));
        }
        [self drawRectWithColor:mo.color
                         pointA:pointA
                         pointB:pointB
                         pointC:pointC
                         pointD:pointD];
        CGSize size = [Utils getStringSize:mo.title font:FONT_F16];
        [self drawText:mo.title color:COLOR_B1 alpha:1 context:context frame:CGRectMake((pointB.x+pointC.x)/2 + lineWidth, (each_H-size.height)/2.0+pointB.y, size.width+5, size.height) font:FONT_F16];
        
        
        CGSize numSize = [Utils getStringSize:mo.number font:FONT_F15];
        [self drawText:mo.number color:COLOR_B4 alpha:1 context:context frame:CGRectMake((pointA.x+pointB.x-numSize.width)/2.0, (each_H-numSize.height)/2.0+pointB.y, numSize.width, numSize.height) font:FONT_F15];
        
        [self drawLineStartPoint:CGPointMake((pointB.x+pointC.x)/2.0, (pointB.y+pointC.y)/2.0) endPoint:CGPointMake((pointB.x+pointC.x)/2.0+lineWidth, (pointB.y+pointC.y)/2.0) color:mo.color];
    }
}

- (void)drawText:(NSString *)text color:(UIColor *)color alpha:(CGFloat)alpha context:(CGContextRef)context frame:(CGRect)frame font:(UIFont *)font {
    CGContextSetRGBFillColor(context, color.red, color.green, color.blue, alpha); //设置填充颜色
    [text drawInRect:frame withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}];
}

- (void)drawLineStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(UIColor *)color {
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //线条宽
    CGContextSetLineWidth(context, 1);
    //线条颜色
    CGContextSetRGBStrokeColor(context, color.red, color.green, color.blue, 1); //设置线条颜色第一种方法
    //坐标点数组
    
    CGPoint aPoints[2];
    aPoints[0] = startPoint;
    aPoints[1] = endPoint;
    //添加线 points[]坐标数组，和count大小
    CGContextAddLines(context, aPoints, 2);
    //根据坐标绘制路径
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)drawRectWithColor:(UIColor*)color
                   pointA:(CGPoint)pA
                   pointB:(CGPoint)pB
                   pointC:(CGPoint)pC
                   pointD:(CGPoint)pD {
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //开始路径绘制
    CGContextBeginPath(context);
    
    //起点
    CGContextMoveToPoint(context,pA.x,pA.y);
    CGContextAddLineToPoint(context,pB.x, pB.y);
    CGContextAddLineToPoint(context,pC.x, pC.y);
    CGContextAddLineToPoint(context,pD.x, pD.y);
    //设置填充色
    [color setFill];
    //设置边框颜色
    [color setStroke];
    //绘制路径
    CGContextDrawPath(context,kCGPathFillStroke);
}

#pragma mark - public

- (void)loadData:(NSArray<FunnelMo *> *)data {
    _arrData = [[NSMutableArray alloc] initWithArray:data];
    [self setNeedsDisplay];
}

#pragma mark - lazy

- (NSMutableArray<FunnelMo *> *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

@end

@implementation FunnelMo

- (instancetype)initWithTitle:(NSString *)title color:(UIColor *)color number:(NSString *)number {
    self = [super init];
    if (self) {
        self.title = title;
        self.color = color;
        self.number = number;
    }
    return self;
}

@end
