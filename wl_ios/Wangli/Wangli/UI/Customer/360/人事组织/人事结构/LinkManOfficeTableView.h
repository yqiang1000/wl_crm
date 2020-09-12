//
//  LinkManOfficeTableView.h
//  Wangli
//
//  Created by yeqiang on 2019/1/3.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Node;
@class LinkManOfficeTableView;
@protocol LinkManOfficeTableViewDelegate <NSObject>
@optional
- (void)linkManOfficeTableView:(LinkManOfficeTableView *)linkManOfficeTableView didSelectedNode:(Node *)node indexPath:(NSIndexPath *)indexPath;
@end

@interface LinkManOfficeTableView : UITableView

@property (nonatomic , weak) id<LinkManOfficeTableViewDelegate> linkManOfficeTableViewDelegate;

-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data;

@property (nonatomic , strong) NSArray *data;//传递过来已经组织好的数据（全量数据）

@end

NS_ASSUME_NONNULL_END
