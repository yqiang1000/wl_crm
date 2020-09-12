//
//  CustomListCell.h
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "RootHelpCell.h"
#import "NewHelpListTableView.h"
#import "NewHelpeMessageCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomListCell : RootHelpCell

@property (nonatomic, strong) MLLinkLabel *labTitle;
@property (nonatomic, strong) MLLinkLabel *labTime;
@property (nonatomic, strong) MLLinkLabel *labContent;
@property (nonatomic, strong) NewHelpListTableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;

@end

NS_ASSUME_NONNULL_END
