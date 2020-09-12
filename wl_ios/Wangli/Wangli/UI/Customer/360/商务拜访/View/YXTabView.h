//
//  YXTabView.h
//  仿造淘宝商品详情页
//
//  Created by yixiang on 16/3/25.
//  Copyright © 2016年 yixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXTabConfigMo;
@class YXTabItemBaseView;
@interface YXTabView : UIView

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray <YXTabItemBaseView *> *arrTableViews;

@property (nonatomic, strong) NSMutableArray <YXTabConfigMo *> *tabConfigArray;

- (void)updateTitle:(NSString *)title index:(NSInteger)index;

-(instancetype)initWithTabConfigArray:(NSMutableArray <YXTabConfigMo *> *)tabConfigArray;//tab页配置数组

@end
