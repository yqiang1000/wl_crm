//
//  RecordVideoView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RecordVideoView;
@protocol RecordVideoViewDelegate <NSObject>
@optional
- (void)recordVideoView:(RecordVideoView *)recordVideoView didSelectedIndexPath:(NSIndexPath *)indexPath;

- (void)recordVideoView:(RecordVideoView *)recordVideoView didDeleteIndexPath:(NSIndexPath *)indexPath;

@end

@interface RecordVideoView : UICollectionView

@property (nonatomic, assign) BOOL unDelete;        // 默认NO：可删除 YES：不可以删除
@property (nonatomic, strong) NSMutableArray *videoData;
@property (nonatomic, weak) id <RecordVideoViewDelegate> recordVideoViewDelegate;


@end

NS_ASSUME_NONNULL_END
