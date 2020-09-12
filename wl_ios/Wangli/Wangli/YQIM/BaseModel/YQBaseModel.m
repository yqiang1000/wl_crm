//
//  YQBaseModel.m
//  Wangli
//
//  Created by yeqiang on 2020/5/26.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "YQBaseModel.h"

@implementation YQBaseModel

// 声明自定义类参数类型
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"x" : [X class]};
//}

// 映射
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

- (NSUInteger)hash {
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}

@end
