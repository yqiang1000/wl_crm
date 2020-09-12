//
//  MenuTableView.h
//  Wangli
//
//  Created by yeqiang on 2018/4/19.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuTableView;
@protocol MenuTableViewDelegate <NSObject>

@optional
- (void)menuTableView:(MenuTableView *)menuTableView didSelectItem:(NSString *)item indexPath:(NSIndexPath *)indexPath;

@end

@interface MenuTableView : UITableView

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, weak) id <MenuTableViewDelegate> menuDelegate;
@property (nonatomic, assign) NSInteger selectIndex;

@end
