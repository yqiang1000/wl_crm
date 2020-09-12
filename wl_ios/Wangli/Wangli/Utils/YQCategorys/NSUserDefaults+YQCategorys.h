//
//  NSUserDefaults+YQCategorys.h
//  HangGuo
//
//  Created by yeqiang on 2020/1/22.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (YQCategorys)

+ (void)setUserDefaultsWithKey:(NSString*)key data:(id)data;

+ (id)getUserDefaultsWithKey:(NSString*)key;

+ (void)removeUserDefaultsWithKey:(NSString*)key;

+ (void)synchronize;

@end

NS_ASSUME_NONNULL_END
