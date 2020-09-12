//
//  XValueFormatter.m
//  Wangli
//
//  Created by yeqiang on 2018/6/5.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "XValueFormatter.h"

@interface XValueFormatter ()
{
    NSArray * _arr;
}
@end

@implementation XValueFormatter

-(id)initWithArr:(NSArray *)arr{
    self = [super init];
    if (self)
    {
        _arr = arr;
        
    }
    return self;
}
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    return _arr[(NSInteger)value];
}

@end
