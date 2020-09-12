//
//  YQVideoViewController.h
//  KJCamera
//
//  Created by yeqiang on 2018/12/6.
//  Copyright © 2018年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TakeOperationSureBlock)(id item);

@interface YQVideoViewController : UIViewController

@property (copy, nonatomic) TakeOperationSureBlock takeBlock;
@property (assign, nonatomic) NSInteger HSeconds;

@end

NS_ASSUME_NONNULL_END
