//
//  RecordImageCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordUtils.h"

NS_ASSUME_NONNULL_BEGIN

@class RecordImageCell;
@protocol RecordImageCellDelegate <NSObject>
@optional
- (void)recordImageCell:(RecordImageCell *)recordImageCell deleteIndexPath:(NSIndexPath *)indexPath;

@end

@interface RecordImageCell : UICollectionViewCell

@property (nonatomic, assign) BOOL unDelete;        // 默认NO：可删除 YES：不可以删除
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *btnDelete;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <RecordImageCellDelegate> recordImageCellDelegate;
- (void)showImage:(id)image;

@end

NS_ASSUME_NONNULL_END
