//
//  RecordVoiceCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordUtils.h"
#import "QiniuFileMo.h"

NS_ASSUME_NONNULL_BEGIN

@class RecordVoiceCell;
@protocol RecordVoiceCellDelegate <NSObject>
@optional
- (void)recordVoiceCell:(RecordVoiceCell *)recordVoiceCell deleteIndexPath:(NSIndexPath *)indexPath;

@end

@interface RecordVoiceCell : UICollectionViewCell

@property (nonatomic, assign) BOOL unDelete;        // 默认NO：可删除 YES：不可以删除
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UIButton *btnDelete;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <RecordVoiceCellDelegate> recordVoiceCellDelegate;

@property (nonatomic, strong) QiniuFileMo *model;

- (void)loadData:(QiniuFileMo *)model;

@end

NS_ASSUME_NONNULL_END
