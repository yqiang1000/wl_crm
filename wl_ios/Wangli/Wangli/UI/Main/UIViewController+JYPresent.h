//
//  UIViewController+JYPresent.h
//  Wangli
//
//  Created by yeqiang on 2020/5/6.
//  Copyright © 2020 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Present)

- (void)jy_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;


@end

NS_ASSUME_NONNULL_END
