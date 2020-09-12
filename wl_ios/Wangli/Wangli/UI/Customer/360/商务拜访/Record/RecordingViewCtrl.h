//
//  RecordingViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/12/28.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "QiniuFileMo.h"

NS_ASSUME_NONNULL_BEGIN

@class RecordingViewCtrl;
@protocol RecordingViewCtrlDelegate <NSObject>
@optional
- (void)recordingViewCtrlCancelAction:(RecordingViewCtrl *)recordingViewCtrl;
- (void)recordingViewCtrlConfirmAction:(RecordingViewCtrl *)recordingViewCtrl fileName:(NSString *)fileName mp3Path:(NSString *)mp3Path count:(NSInteger)count;
- (void)recordingViewCtrlwDismiss:(RecordingViewCtrl *)recordingViewCtrl;

@end

@interface RecordingViewCtrl : BaseViewCtrl

@property (nonatomic, weak) id <RecordingViewCtrlDelegate> delegate;
- (void)showView;
- (void)hidenView;

@property (nonatomic, strong) QiniuFileMo *voiceMo;

@end

NS_ASSUME_NONNULL_END
