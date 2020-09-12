//
//  TrackDetailView.h
//  Wangli
//
//  Created by yeqiang on 2018/6/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CusInfoMo.h"
#import "AttachmentCell.h"

@interface TrackDetailView : UIView

@property (nonatomic, strong) CusInfoMo *mo;

@property (nonatomic, assign) BOOL showAttachments;

@property (nonatomic, strong) UITableView *tableView;

- (void)refreshView;

@property (nonatomic, copy) CountChangeBlock countChange;

@end
