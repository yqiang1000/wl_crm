
//
//  MemberChooseMo.m
//  Wangli
//
//  Created by yeqiang on 2018/5/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "MemberChooseMo.h"

@implementation ChooseBeansMo

//+ (BOOL)propertyIsOptional:(NSString *)propertyName {
//    if ([propertyName isEqualToString:@"hidden"])
//        return YES;
//
//    return NO;
//}

@end

@implementation MemberChooseMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"hidden"]||
        [propertyName isEqualToString:@"selectTag"]||
        [propertyName isEqualToString:@"special"]||
        [propertyName isEqualToString:@"multiSelect"])
        return YES;
    
    return NO;
}

//- (void)setChooseBeans:(NSArray<ChooseBeansMo *><ChooseBeansMo,Optional> *)chooseBeans {
//    _chooseBeans = [ChooseBeansMo arrayOfModelsFromDictionaries:(NSArray *)chooseBeans error:nil];
//}

@end
