//
//  PersonCardView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PersonCardView;
@protocol PersonCardViewDelegate <NSObject>
@optional
// needLoadMore:是否静默加载下一页
- (void)personCardViewLoadMoreData:(PersonCardView *)personCardView needLoadMore:(BOOL)needLoadMore completeBlock:(void(^)(void))completeBlock;
- (void)personCardView:(PersonCardView *)personCardView didShowIndexPath:(NSIndexPath *)indexPath;

@end

@interface PersonCardView : UIView

@property (nonatomic, weak) id <PersonCardViewDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) BOOL canGetNewData;

- (void)resetView;

@end

NS_ASSUME_NONNULL_END
