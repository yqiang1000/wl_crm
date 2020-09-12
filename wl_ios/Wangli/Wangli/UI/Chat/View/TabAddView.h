//
//  TabAddView.h
//  Wangli
//
//  Created by yeqiang on 2018/5/3.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabAddView : UIView

- (instancetype)initWithFrame:(CGRect)frame btnClick:(void(^)(NSInteger index))clickBlock cancel:(void(^)(TabAddView *obj))cancelBlock;

@end
