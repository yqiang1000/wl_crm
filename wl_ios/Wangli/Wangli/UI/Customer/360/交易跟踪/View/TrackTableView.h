//
//  TrackTableView.h
//  Wangli
//
//  Created by yeqiang on 2018/6/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrackTableView;
@protocol TrackTableViewDelegate <NSObject>
@optional
- (void)trackTableView:(TrackTableView *)tableView didSelectIndexPath:(NSIndexPath *)indexPath;
- (void)trackTableView:(TrackTableView *)tableView topCellDidSelectIndexPath:(NSIndexPath *)indexPath;

@end

@interface TrackTableView : UITableView

@property (nonatomic, strong) NSMutableArray *arrTopList;
@property (nonatomic, strong) NSMutableArray *arrListData;
@property (nonatomic, weak) id <TrackTableViewDelegate> trackDelegate;

@end
