//
//  PermissionCell.h
//  Wangli
//
//  Created by yeqiang on 2019/3/7.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"

NS_ASSUME_NONNULL_BEGIN

@class PermissionCell;
@protocol PermissionCellDelegate <NSObject>
@optional
- (void)permissionCell:(PermissionCell *)permissionCell didSelected:(BOOL)selected indexPath:(NSIndexPath *)indexPath;

@end

@interface PermissionCell : UITableViewCell

@property (nonatomic, strong) UIButton *btnIcon;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labMsg;
@property (nonatomic, strong) UIImageView *imgArrow;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <PermissionCellDelegate> permissionDelegate;

@property (nonatomic, strong) Node *node;
- (void)loadDataWith:(Node *)node;

@end

NS_ASSUME_NONNULL_END
