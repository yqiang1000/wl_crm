//
//  AttachmentCollectionCell.h
//  Wangli
//
//  Created by yeqiang on 2018/5/30.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseImageView.h"
#import "QiniuFileMo.h"

@class AttachmentCollectionCell;
@protocol AttachmentCollectionCellDelegate <NSObject>
@optional
- (void)cell:(AttachmentCollectionCell *)cell deleteIndexPath:(NSIndexPath *)indexPath;

@end

@interface AttachmentCollectionCell : UICollectionViewCell

@property (nonatomic, strong) BaseImageView *imgView;
@property (nonatomic, strong) UIButton *btnDelete;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <AttachmentCollectionCellDelegate> cellDelegate;
- (void)showImage:(id)image;

@end
