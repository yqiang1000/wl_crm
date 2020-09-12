//
//  RecordImageView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RecordImageView;
@protocol RecordImageViewDelegate <NSObject>
@optional
- (void)recordImageView:(RecordImageView *)recordImageView didSelectedIndexPath:(NSIndexPath *)indexPath;

- (void)recordImageView:(RecordImageView *)recordImageView didDeleteIndexPath:(NSIndexPath *)indexPath;
@end

@interface RecordImageView : UICollectionView

@property (nonatomic, assign) BOOL unDelete;        // 默认NO：可删除 YES：不可以删除
@property (nonatomic, strong) NSMutableArray *imageData;
@property (nonatomic, weak) id <RecordImageViewDelegate> recordImageViewDelegate;

@end

NS_ASSUME_NONNULL_END
