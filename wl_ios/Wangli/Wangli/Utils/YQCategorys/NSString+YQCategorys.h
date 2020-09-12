//
//  NSString+YQCategorys.h
//  HangGuo
//
//  Created by yeqiang on 2020/1/22.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (YQCategorys)

/// 去掉首位空格
- (NSString *)withOutSpace;

/// 判断字符串不为空
- (BOOL)isAvailable;

@end

NS_ASSUME_NONNULL_END
