//
//  RecordVoiceView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RecordVoiceView;
@protocol RecordVoiceViewDelegate <NSObject>
@optional
- (void)recordVoiceView:(RecordVoiceView *)recordVoiceView didSelectedIndexPath:(NSIndexPath *)indexPath;

- (void)recordVoiceView:(RecordVoiceView *)recordVoiceView didDeleteIndexPath:(NSIndexPath *)indexPath;
@end

@interface RecordVoiceView : UICollectionView

@property (nonatomic, strong) NSMutableArray *voiceData;
@property (nonatomic, assign) BOOL unDelete;        // 默认NO：可删除 YES：不可以删除
@property (nonatomic, weak) id <RecordVoiceViewDelegate> recordVoiceViewDelegate;

@end

NS_ASSUME_NONNULL_END
