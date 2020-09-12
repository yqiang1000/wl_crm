//
//  VisitNoteCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisitNoteMo.h"

NS_ASSUME_NONNULL_BEGIN

@class VisitNoteCell;
@protocol VisitNoteCellDelegate <NSObject>

@optional
- (void)visitNoteCell:(VisitNoteCell *)visitNoteCell btnActionIndexPath:(NSIndexPath *)indexPath;

@end

@interface VisitNoteCell : UITableViewCell

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labContent;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIButton *btnCreate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <VisitNoteCellDelegate> visitNoteCellDelegate;
@property (nonatomic, strong) VisitNoteMo *model;

- (void)loadData:(VisitNoteMo *)model;

@end

NS_ASSUME_NONNULL_END
