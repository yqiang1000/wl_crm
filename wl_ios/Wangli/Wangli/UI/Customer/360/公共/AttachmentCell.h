//
//  AttachmentCell.h
//  Wangli
//
//  Created by yeqiang on 2018/5/4.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttachmentCollectionView.h"
#import "QiniuFileMo.h"

@interface AttachmentCell : UITableViewCell

@property (nonatomic, strong) UILabel *labTitle;
// default 9
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray *attachments;
// default NO
@property (nonatomic, assign) BOOL showLine;

// 禁止编辑 默认NO
@property (nonatomic, assign) BOOL forbidDelete;

@property (nonatomic, strong) AttachmentCollectionView *collectionView;

@property (nonatomic, copy) CountChangeBlock countChange;

- (void)refreshView;

@end
