//
//  LinkManOfficeCell.h
//  Wangli
//
//  Created by yeqiang on 2019/1/3.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"

NS_ASSUME_NONNULL_BEGIN

@class LinkManOfficeCell;
@protocol LinkManOfficeCellDelegate <NSObject>
@optional
- (void)linkManOfficeCell:(LinkManOfficeCell *)linkManOfficeCell didSelected:(BOOL)selected indexPath:(NSIndexPath *)indexPath;

@end

@interface LinkManOfficeCell : UITableViewCell

@property (nonatomic, strong) UIButton *btnIcon;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labMsg;
@property (nonatomic, strong) UIImageView *imgArrow;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <LinkManOfficeCellDelegate> linkDelegate;

@property (nonatomic, strong) Node *node;
- (void)loadDataWith:(Node *)node;

@end

NS_ASSUME_NONNULL_END
