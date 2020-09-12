//
//  BusinessHeaderView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/16.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessVisitActivityMo.h"
NS_ASSUME_NONNULL_BEGIN

#pragma mark - BusinessHeaderView

@interface BusinessHeaderView : UIView

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *labTitle;

@end

#pragma mark - BusinessHeaderCell

@interface BusinessHeaderCell : UITableViewCell

@property (nonatomic, strong) UILabel *labContent;

@end

NS_ASSUME_NONNULL_END
