//
//  FilterSecondView.h
//  Wangli
//
//  Created by yeqiang on 2018/4/12.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterSecondView;

@protocol FilterSecondViewDelegate <NSObject>

@optional
- (void)filterSecondView:(FilterSecondView *)filterSecondView select:(NSInteger)index;

- (void)filterSecondViewCancel:(FilterSecondView *)filterSecondView;

@end

@interface FilterSecondView : UIView

@property (nonatomic, weak) id <FilterSecondViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *arrData;

- (void)updata:(NSMutableArray *)data selectTag:(NSInteger)selectTag title:(NSString *)title defaultIndex:(NSInteger)defaultIndex;

@end
