//
//  TrendsMoreView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TrendsMoreView;
@protocol TrendsMoreViewDelegate <NSObject>
@optional
- (void)trendsMoreView:(TrendsMoreView *)trendsMoreView didSelectIndex:(NSInteger)index title:(NSString *)title;
- (void)trendsMoreViewDismiss:(TrendsMoreView *)trendsMoreView;

@end


@interface TrendsMoreView : UIView

@property (nonatomic, weak) id <TrendsMoreViewDelegate> trendsMoreViewDelegate;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) NSInteger currentTag;

- (void)showView;

- (void)hidenView;

@end

NS_ASSUME_NONNULL_END
