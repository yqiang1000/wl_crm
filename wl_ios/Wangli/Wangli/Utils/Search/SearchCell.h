//
//  SearchCell.h
//  AbcPen-ipad
//
//  Created by yeqiang on 2017/8/7.
//  Copyright © 2017年 wangchun. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - SearchCell

@class SearchCell;

@protocol SearchCellDelegate <NSObject>

@optional

- (void)searchCellDidDelete:(SearchCell *)searchCell;

@end

@interface SearchCell : UITableViewCell <SearchCellDelegate>

@property (nonatomic, weak) id <SearchCellDelegate> delegate;

- (void)loadData:(NSString *)text;

@end


#pragma mark - HotCell

@class HotCell;

@protocol HotCellDelegate <NSObject>

@optional

- (void)hotCellDidSelected:(NSUInteger)index message:(NSString *)message indexPath:(NSIndexPath *)indexPath;

@end

@interface HotCell : UITableViewCell <HotCellDelegate>

@property (nonatomic, weak) id <HotCellDelegate> delegate;

@property (nonatomic, strong) NSMutableArray <UIView *> *data;
@property (nonatomic, strong) NSIndexPath *indexPath;
- (void)loadData:(NSArray *)data;

@end


#pragma mark - SearchHeader

@interface SearchHeader : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIButton *btnClear;

@end

#pragma mark - SearchFooter

@interface SearchFooter : UIView


@property (nonatomic, strong) UIButton *btnBottom;

- (instancetype)initWithTitle:(NSString *)title;

@end


