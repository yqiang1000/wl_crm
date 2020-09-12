//
//  RadarMapCompleteView.m
//  RadarMap
//
//  Created by A053 on 16/9/22.
//  Copyright © 2016年 Yvan. All rights reserved.
//


#define RADAR_WIDTH     ([UIScreen mainScreen].bounds.size.width-40)
#define RADAR_HEIGHT    ([UIScreen mainScreen].bounds.size.width-90)
#define FONT(x)         [UIFont systemFontOfSize:(x*([UIScreen mainScreen].bounds.size.width/375.0))]
#define LENGTH(x)       (x*(([UIScreen mainScreen].bounds.size.width)/375.0))
#define RGB_M(r,g,b)     [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1]

#import "RadarMapCompleteView.h"


@implementation ElementItem
- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key {}
@end

@implementation Item

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LENGTH(10), LENGTH(10))];
        [self addSubview:self.colorView];
        
        self.itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(LENGTH(16), 0, LENGTH(40), LENGTH(10))];
        self.itemLabel.font = FONT(10);
        self.itemLabel.textAlignment = NSTextAlignmentLeft;
        self.itemLabel.textColor = RGB_M(94, 97, 107);
        [self addSubview:self.itemLabel];
    }
    return self;
}

@end

@interface RadarMapCompleteView()

@property (strong, nonatomic) NSArray       *elements;
@property (strong, nonatomic) NSMutableArray*items;

@property (strong, nonatomic) UIColor       *lengthColor;
@property (strong, nonatomic) UILabel       *ablilityLabel;
@property (strong, nonatomic) UITextView    *contents;
@property (strong, nonatomic) UIView        *abilityBGView;
@property (nonatomic, strong) NSMutableArray *arrValueLables;

@end

static float radar_l  = 0;
static float center_w = 0;
static float center_h = 0;

@implementation RadarMapCompleteView

#pragma mark - 画雷达图主题部分

- (void)drawBody {
    
    // 获取画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 划线颜色
    if (self.lengthColor)
        CGContextSetStrokeColorWithColor(context, self.lengthColor.CGColor);
    else
        CGContextSetStrokeColorWithColor(context, RGB_M(148, 148, 148).CGColor);
    
    CGContextSetLineWidth(context, 1);
    // 起点坐标
    CGContextMoveToPoint(context, center_w, center_h);
    // 第一条线
    CGContextAddLineToPoint(context, center_w, center_h - radar_l);
    // 添加元素名称
    UILabel *bodyLabel = [self buildElementLabelWithText:self.elements[0] Frame:CGRectMake(center_w-LENGTH(40), center_h-radar_l-LENGTH(30), LENGTH(80), LENGTH(20)) Alignment:NSTextAlignmentCenter font:FONT_F12];
    [self addSubview:bodyLabel];
    
    //画元素主干
    for (int i = 1; i <self.elements.count; i++) {
        float x   = 0;
        float y   = 0;
        double pi = (M_PI*2.0/(self.elements.count))*i;
        // 计算主干落点坐标
        Coordinate_2(pi, radar_l, center_w, center_h,&x, &y);
        //添加元素名称
        UILabel *bodyLabel;
        CGRect frame;
        if (x > center_w) {
                frame = CGRectMake(x+LENGTH(10), y-LENGTH(7.5), LENGTH(80), LENGTH(20));
            bodyLabel = [self buildElementLabelWithText:self.elements[i] Frame:frame Alignment:NSTextAlignmentLeft font:FONT_F12];
        } else if (x == center_w) {
            if (y>center_h) {
                frame = CGRectMake(x-LENGTH(40), y+LENGTH(10), LENGTH(80), LENGTH(20));
            } else {
                frame = CGRectMake(x-LENGTH(40), y-LENGTH(20), LENGTH(80), LENGTH(20));
            }
            bodyLabel = [self buildElementLabelWithText:self.elements[i] Frame:frame Alignment:NSTextAlignmentCenter font:FONT_F12];
        } else {
            frame = CGRectMake(x-LENGTH(90), y-LENGTH(7.5), LENGTH(80), LENGTH(20));
            bodyLabel = [self buildElementLabelWithText:self.elements[i] Frame:frame Alignment:NSTextAlignmentRight font:FONT_F12];
        }
        [self addSubview:bodyLabel];
        // 设置每次的初始点坐标
        CGContextMoveToPoint(context, center_w, center_h);
        // 设置终点坐标
        CGContextAddLineToPoint(context, x, y);
    }
    CGContextStrokePath(context);
    
}

#pragma mark - 画雷达分等分图

- (void)buildPart {
    
    float r = 5.0f;
    
    // 获取画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 划线颜色
    if (self.lengthColor)
        CGContextSetStrokeColorWithColor(context, self.lengthColor.CGColor);
    else
        CGContextSetStrokeColorWithColor(context, RGB_M(148, 148, 148).CGColor);
    
    // 划线宽度
    CGContextSetLineWidth(context, 1);
    // 添加百分比
    UILabel *partLabel = [self buildPartLabelWithText:@"0" Frame:CGRectMake(center_w-LENGTH(25), center_h-LENGTH(3), LENGTH(20), LENGTH(6)) Alignment:NSTextAlignmentRight font:FONT_F9];
    [self addSubview:partLabel];
    
    // 话分割线
    for (int j = 0; j<r; j++) {
        // 设置每次的初始点坐标
        CGContextMoveToPoint(context, center_w,center_h -radar_l);
        // 添加百分比
        UILabel *partLabels = [self buildPartLabelWithText:[NSString stringWithFormat:@"%.f",100*((r-j)/r)] Frame:CGRectMake(center_w-LENGTH(30), center_h -radar_l + radar_l*j/r-LENGTH(4), LENGTH(25), LENGTH(10)) Alignment:NSTextAlignmentRight font:FONT_F9];
        [self addSubview:partLabels];
        // 画百分比分部
        for (int i = 1; i<=self.elements.count; i++) {
            float x   = 0;
            float y   = 0;
            double pi = (M_PI*2.0/(self.elements.count))*i;
            Coordinate_2(pi,radar_l*(r-j)/r, center_w, center_h,&x, &y);
            
            if (i == 1) {
                CGContextMoveToPoint(context, center_w, center_h -radar_l + radar_l*j/r);
            }
            if (i == self.elements.count) {
                CGContextAddLineToPoint(context, center_w, center_h -radar_l + radar_l*j/r);
            } else {
                CGContextAddLineToPoint(context, x, y);
            }
        }
    }
    CGContextStrokePath(context);
}


#pragma mark - 画百分比占比线

- (void)buildPercent {
    for (int i = 0; i<self.items.count; i++) {
        ElementItem *item = self.items[i];
        // 获取画布
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, item.itemColor.CGColor);
        // 划线宽度
        CGContextSetLineWidth(context, 2);
        CGContextMoveToPoint(context, center_w, center_h-radar_l +radar_l*(1-[item.itemPercent[0] floatValue]));
        for (int j = 1; j<=item.itemPercent.count; j++) {
            float x   = 0;
            float y   = 0;
            
            if (j == self.elements.count) {
                //终点，最终回到开始点坐标
                CGContextAddLineToPoint(context, center_w, center_h-radar_l +radar_l*(1-[item.itemPercent[0] floatValue]));
                
                CGFloat tmpValue = [item.itemPercent[0] floatValue] * 100;
                [self drawText:[NSString stringWithFormat:@"%.f",tmpValue] red:66 green:144 blue:247 alpha:1 context:context frame:CGRectMake(center_w-10, center_h-radar_l +radar_l*(1-[item.itemPercent[0] floatValue])-20, 30, 10) font:FONT_F12 alignment:NSTextAlignmentCenter];
            } else {
                double pi = (M_PI*2.0/(self.elements.count))*j;
                Coordinate_2(pi,radar_l*[item.itemPercent[j] floatValue], center_w, center_h,&x, &y);
                CGContextAddLineToPoint(context, x, y);
                
                CGFloat tmpValue = [item.itemPercent[j] floatValue] * 100;
                [self drawText:[NSString stringWithFormat:@"%.f",tmpValue] red:66 green:144 blue:247 alpha:1 context:context frame:CGRectMake(x-10, y-20, 30, 10) font:FONT_F12 alignment:NSTextAlignmentCenter];
            }
        }
        
        UIColor *fullColor = [UIColor colorWithRed:66/255.0 green:144/255.0 blue:247/255.0 alpha:0.1];
        CGContextSetFillColorWithColor(context, fullColor.CGColor);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextStrokePath(context);
    }
}


#pragma mark - 算落点坐标

void Coordinate_2 (double pi, float l, float c_w , float c_h, float *x, float *y) {
    *x = c_w + sin(pi)*l;
    *y = c_h - cos(pi)*l;
}

#pragma mark - 百分比占比label

- (UILabel *)buildPartLabelWithText:(NSString *)text Frame:(CGRect)frame Alignment:(NSTextAlignment)alignment font:(UIFont *)font {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textAlignment = alignment;
    label.font = font;
    label.text = text;
    label.frame = frame;
    [self.arrValueLables addObject:label];
    return label;
}

- (UILabel *)buildValueLabelWithText:(NSString *)text Frame:(CGRect)frame Alignment:(NSTextAlignment)alignment font:(UIFont *)font {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textAlignment = alignment;
    label.font = font;
    label.text = text;
    frame.size.width = [Utils getStringSize:text font:font].width;
    label.frame = frame;
    label.textColor = COLOR_4290F7;
    [self.arrValueLables addObject:label];
    return label;
}

#pragma mark - 能力测试方面label

- (UILabel *)buildElementLabelWithText:(NSString *)text Frame:(CGRect)frame Alignment:(NSTextAlignment)alignment font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = alignment;
    label.font = font;
    label.text = text;
    [self.arrValueLables addObject:label];
    return label;
}

- (void)drawText:(NSString *)text red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha context:(CGContextRef)context frame:(CGRect)frame font:(UIFont *)font alignment:(NSTextAlignment)alignment {
    CGContextSetRGBFillColor(context, red/255.0, green/255.0, blue/255.0, alpha);//设置填充颜色
    [text drawInRect:frame withFont:font];
}

#pragma mark - 能力评估描述

- (void)abilityContent {
    // 能力评估描述
    self.contents = [[UITextView alloc]initWithFrame:CGRectMake(LENGTH(25), LENGTH(285), RADAR_WIDTH-LENGTH(50), RADAR_HEIGHT-LENGTH(300))];
    self.contents.textColor = RGB_M(151, 156, 155);
    self.contents.backgroundColor = [UIColor clearColor];
    self.contents.font = [UIFont boldSystemFontOfSize:LENGTH(12)];
    self.contents.editable = NO;
    self.contents.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.contents];
}

#pragma mark - 能力评估的几个模块

- (void)abillityOptions {
    
    // 能力评估
    self.ablilityLabel = [[UILabel alloc]initWithFrame:CGRectMake(RADAR_WIDTH-LENGTH(90), LENGTH(5), LENGTH(60), LENGTH(15))];
    self.ablilityLabel.textAlignment = NSTextAlignmentRight;
    self.ablilityLabel.font = [UIFont boldSystemFontOfSize:LENGTH(15)];
    self.ablilityLabel.text = @"能力评估";
    [self addSubview:self.ablilityLabel];
    
    // 能力苹果模块
    self.abilityBGView = [[UIView alloc] initWithFrame:CGRectMake(LENGTH(30), LENGTH(25), RADAR_WIDTH-LENGTH(60), LENGTH(10))];
    [self addSubview:self.abilityBGView];
}

- (void)addAbilitysWithElements:(NSArray <ElementItem*>*)elements {
    [self.items addObjectsFromArray: elements];
    for (int i = 0; i < self.items.count; i++) {
        ElementItem *element = self.items[i];
        Item *item = [[Item alloc]initWithFrame:CGRectMake(RADAR_WIDTH-LENGTH(116)-LENGTH(70)*i, 0, LENGTH(56), LENGTH(10))];
        item.itemLabel.text = element.itemName;
        item.colorView.backgroundColor = element.itemColor;
        [self.abilityBGView addSubview:item];
    }
    for (int i = 0; i < self.arrValueLables.count; i++) {
        UILabel *lab = self.arrValueLables[i];
        [lab removeFromSuperview];
        lab = nil;
    }
    [self setNeedsDisplay];
}

- (void)updateItemName:(NSArray *)elements {
    self.elements = elements;
    [self setNeedsDisplay];
}



- (void)setContent:(NSString *)content {
    _content = content;
    self.contents.text = content;
}
- (instancetype)initWithRadarElements:(NSArray *)elements lengthColor:(UIColor *)lengthColor{
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, RADAR_WIDTH, RADAR_HEIGHT);
        self.backgroundColor = COLOR_B4;//RGB_M(243, 243, 243);
        self.elements = elements;
        self.lengthColor = lengthColor;
        self.items = [[NSMutableArray alloc]init];

        radar_l  = LENGTH(88);
        center_w = RADAR_WIDTH/2;
        center_h = RADAR_HEIGHT/2 - LENGTH(15);
//        [self abilityContent];
//        [self abillityOptions];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 画主体内容
    [self drawBody];
    // 画分割线
    [self buildPart];
    // 画百分比占比
    [self buildPercent];
}

- (NSMutableArray *)arrValueLables {
    if (!_arrValueLables) {
        _arrValueLables = [NSMutableArray new];
    }
    return _arrValueLables;
}


@end
