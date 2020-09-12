//
//  TrendsCompetitorMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/15.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsCompetitorMo.h"

@implementation TrendsCompetitorMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

- (void)setMember:(CustomerMo<Optional> *)member {
    if ([member isKindOfClass:[CustomerMo class]]) {
        _member = member;
    } else  {
        NSError *error = nil;
        _member = [[CustomerMo alloc] initWithDictionary:member error:&error];
    }
}

@end
