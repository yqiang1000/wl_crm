//
//  H.m
//  Wangli
//
//  Created by yeqiang on 2020/5/6.
//  Copyright © 2020 jiuyisoft. All rights reserved.
//


#import "UIViewController+JYPresent.h"
#import<objc/runtime.h>

@implementation UIViewController (Present)
 
+ (void)load {
    Method originAddObserverMethod = class_getInstanceMethod(self, @selector(presentViewController:animated:completion:));
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, @selector(jy_presentViewController:animated:completion:));
    method_exchangeImplementations(originAddObserverMethod, swizzledAddObserverMethod);
}
 
- (void)jy_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (@available(iOS 13.0, *)) {
        if (viewControllerToPresent.modalPresentationStyle == UIModalPresentationPageSheet) {
            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
        }
    }
    [self jy_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
