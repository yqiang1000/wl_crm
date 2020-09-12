//
//  PlanTableView.h
//  Wangli
//
//  Created by yeqiang on 2018/6/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlanTableView;
@protocol PlanTableViewDelegate <NSObject>
@optional
- (void)planTableView:(PlanTableView *)planTableView didSelectIndexPath:(NSIndexPath *)indexPath;
@end
@interface PlanTableView : UITableView

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, weak) id <PlanTableViewDelegate> planDelegate;

- (void)headerFooterEndRefreshing;

@end
