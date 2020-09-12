//
//  ScanTool.h
//  Wangli
//
//  Created by yeqiang on 2018/4/12.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanTool : NSObject

+ (void)scanToolSuccessBlock:(void(^)(BOOL succ))successBlock;

@end
