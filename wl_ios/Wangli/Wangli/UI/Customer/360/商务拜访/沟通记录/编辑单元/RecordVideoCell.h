//
//  RecordVideoCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordUtils.h"
#import "QiniuFileMo.h"

NS_ASSUME_NONNULL_BEGIN

@class RecordVideoCell;
@protocol RecordVideoCellDelegate <NSObject>
@optional
- (void)recordVideoCell:(RecordVideoCell *)recordVideoCell deleteIndexPath:(NSIndexPath *)indexPath;
- (void)recordVideoCell:(RecordVideoCell *)recordVideoCell playIndexPath:(NSIndexPath *)indexPath;

@end

@interface RecordVideoCell : UICollectionViewCell

@property (nonatomic, assign) BOOL unDelete;        // 默认NO：可删除 YES：不可以删除
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *btnDelete;
@property (nonatomic, strong) UIButton *btnPlay;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <RecordVideoCellDelegate> recordVideoCellDelegate;
- (void)showVideo:(QiniuFileMo *)video;

@end

NS_ASSUME_NONNULL_END
