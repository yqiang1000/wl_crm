//
//  JYMessageDataModel.m
//  TUIKitDemo
//
//  Created by yeqiang on 2020/1/17.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "JYMessageDataModel.h"

@implementation JYMessageDataModel

// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"table" : [JYMessageDataTableModel class]};
}

@end
