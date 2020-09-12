//
//  CustomMsgMo.m
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "CustomMsgMo.h"

@implementation CustomMsgMo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Cells" : [CustomItemMo class],
        @"Contents" : [ContentTextMo class]
    };
}

@end
