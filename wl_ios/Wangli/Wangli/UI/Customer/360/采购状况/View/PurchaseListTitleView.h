//
//  PurchaseListTitleView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/13.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseListTitleView : UIView

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSUInteger newCount;
@property (nonatomic, strong) UIButton *btnAdd;

- (void)setupTitle:(NSString *)title count:(NSInteger)count;

//- (void)setupTitle:(NSString *)title count:(NSInteger)count newCount:(NSInteger)newCount;

@end

NS_ASSUME_NONNULL_END
