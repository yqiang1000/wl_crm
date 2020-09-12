//
//  XValueFormatter.h
//  Wangli
//
//  Created by yeqiang on 2018/6/5.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wangli-Bridging-Header.h"
#import "Wangli-Swift.h"
#import "Charts-Swift.h"

@interface XValueFormatter : NSObject <IChartAxisValueFormatter>

-(id)initWithArr:(NSArray *)arr;

@end
