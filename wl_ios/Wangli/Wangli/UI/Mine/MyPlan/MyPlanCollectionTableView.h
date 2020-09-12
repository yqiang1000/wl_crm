//
//  MyPlanCollectionTableView.h
//  Wangli
//
//  Created by yeqiang on 2018/7/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyPlanCollectionTableView;
@protocol MyPlanCollectionTableViewDelegate <NSObject>
@optional
- (void)myPlanCollectionTableView:(MyPlanCollectionTableView *)myPlanCollectionTableView didSelectIndexPath:(NSIndexPath *)indexPath;
@end
@interface MyPlanCollectionTableView : UITableView

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, weak) id <MyPlanCollectionTableViewDelegate> myPlanCollectionTableViewDelegate;

- (void)headerFooterEndRefreshing;

@end
