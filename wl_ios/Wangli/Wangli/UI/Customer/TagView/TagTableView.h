//
//  TagTableView.h
//  Wangli
//
//  Created by yeqiang on 2018/9/7.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerMo.h"

#pragma mark - TagTableView
@class TagTableView;
@protocol TagTableViewDelegate <NSObject>

- (void)tagTableViewDidScrollView:(TagTableView *)tagTableView;

- (void)tagTableView:(TagTableView *)tagTableView didSelectIndexPath:(NSIndexPath *)indexPath;

@end

@interface TagTableView : UITableView

@property (nonatomic, strong) NSMutableArray <TagMo *> *data0;
@property (nonatomic, strong) NSMutableArray <TagMo *> *data;
@property (nonatomic, weak) id <TagTableViewDelegate> tagDelegate;

@end

#pragma mark - TagCell

@class TagCell;
@protocol TagCellDelegate <NSObject>

- (void)tagCell:(TagCell *)tagCell didSelectIndexPath:(NSIndexPath *)indexPath index:(NSInteger)index;

@end

@interface TagCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSMutableArray <UIView *> *viewData;
@property (nonatomic, strong) NSMutableArray <TagMo *> *data;
@property (nonatomic, weak) id <TagCellDelegate> cellDelegate;

- (void)loadData:(NSArray<TagMo *> *)data showX:(BOOL)showX;

@end

#pragma mark - TagHeaderView

@interface TagHeaderView : UIView

@property (nonatomic, copy) NSString *title;

@end

