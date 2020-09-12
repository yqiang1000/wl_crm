//
//  DrawBusinessFunnelView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FunnelMo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *number;

- (instancetype)initWithTitle:(NSString *)title color:(UIColor *)color number:(NSString *)number;

@end

@interface DrawBusinessFunnelView : UIView

@property (nonatomic, strong) NSMutableArray <FunnelMo *> *arrData;
- (void)loadData:(NSArray <FunnelMo *> *)data;

@end

NS_ASSUME_NONNULL_END
