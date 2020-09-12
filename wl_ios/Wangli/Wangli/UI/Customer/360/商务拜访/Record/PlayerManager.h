//
//  PlayerManager.h
//  Wangli
//
//  Created by yeqiang on 2019/2/28.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ETPlayer_Original,
    ETPlayer_UnkonwError,
    ETPlayer_ReadyToPlay,
    ETPlayer_Playing,
    ETPlayer_PlayFailed,
    ETPlayer_Pause,
    ETPlayer_Stop,
    ETPlayer_Loading,
    ETPlayer_FinishedPlay,
} ETPlayerStatus;

@protocol ETPlayerDelagate <NSObject>
@optional
- (void)currentPlayerStatus:(ETPlayerStatus)playerStatus;
@end

@interface PlayerManager : NSObject

+ (instancetype)sharedInstance;

+ (void)destoryInstance;

- (void)startPlay;

- (void)pause;

- (void)stop;

- (void)seekToNewTime:(NSUInteger)newTime;

- (void)resetPlayer;

- (BOOL)isPlaying;

// 当前时间(秒数)
@property (nonatomic, assign) NSInteger currentTime;
// 总时间(秒数)
@property (nonatomic, assign) NSInteger finishTime;

@property (nonatomic, copy) NSString *voiceUrl;

@property (nonatomic, assign) ETPlayerStatus status;

@property (nonatomic, weak) id<ETPlayerDelagate> delegate;


@end

NS_ASSUME_NONNULL_END
