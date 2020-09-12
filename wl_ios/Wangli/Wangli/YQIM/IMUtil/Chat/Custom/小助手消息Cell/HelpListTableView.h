//
//  HelpListTableView.h
//  HangGuo
//
//  Created by yeqiang on 2020/2/6.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYMessageDataTableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HelpListTableView : UITableView

@property (nonatomic, strong) NSArray<JYMessageDataTableModel *> *arrData;

@end

NS_ASSUME_NONNULL_END
