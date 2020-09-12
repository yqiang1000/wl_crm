//
//  RecordToolBarView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RecordToolBarView;
@protocol RecordToolBarViewDelegate <NSObject>
@optional
- (void)toolBar:(RecordToolBarView *)toolBar didSelectIndex:(NSInteger)index title:(NSString *)title;

@end

@interface RecordToolBarView : UIView

- (instancetype)initWithTitles:(NSArray *)titles
                     imgNormal:(NSArray *)imgNormal
                     imgSelect:(NSArray *)imgSelect;

- (void)updateTitles:(NSArray *)titles
           imgNormal:(NSArray *)imgNormal
           imgSelect:(NSArray *)imgSelect;

@property (nonatomic, weak) id <RecordToolBarViewDelegate> toolBarDelegate;

@end

NS_ASSUME_NONNULL_END
