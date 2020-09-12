//
//  NSUserDefaults+YQCategorys.m
//  HangGuo
//
//  Created by yeqiang on 2020/1/22.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "NSUserDefaults+YQCategorys.h"

@implementation NSUserDefaults (YQCategorys)

+ (void)setUserDefaultsWithKey:(NSString*)key data:(id)data {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getUserDefaultsWithKey:(NSString*)key {
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if ([object isKindOfClass:[NSData class]]) {
         return [NSKeyedUnarchiver unarchiveObjectWithData:object];
    }
    return object;
}

+ (void)removeUserDefaultsWithKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)synchronize {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
