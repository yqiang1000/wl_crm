//
//  InteligenceCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/18.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "InteligenceCell.h"
#import "YQAVPlayer.h"
#import "ImagePreviewViewCtrl.h"
#import <MediaPlayer/MediaPlayer.h>

@interface InteligenceCell () <RecordToolBarViewDelegate, RecordVoiceViewDelegate, RecordImageViewDelegate, RecordVideoViewDelegate, RecordTextViewDelegate, ImagePreviewCtrlDelegate>

@end

@implementation InteligenceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.recordView];
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.bottom.left.right.equalTo(self.contentView);
    }];
}

- (void)initVoiceData {
    self.recordView.contentView.voiceView.voiceData = self.voiceData;
}

- (void)initImageData {
    self.recordView.contentView.imageView.imageData = self.imageData;
}

- (void)initVideoData {
    self.recordView.contentView.videoView.videoData = self.videoData;
}

- (void)refreshHeader:(BOOL)first {
    
    [self.recordView.contentView.textView.internalTextView resignFirstResponder];
    self.model.showText = self.recordView.contentView.textView.internalTextView.text;
    
    [self.recordView.contentView refreshRecordContentView:self.model];
    if (_inteligenceCellDelegate && [_inteligenceCellDelegate respondsToSelector:@selector(inteligenceCellFrameChanged:indexPath:)]) {
        [_inteligenceCellDelegate inteligenceCellFrameChanged:self indexPath:self.cellIndexPath];
    }
}

#pragma mark - RecordToolBarViewDelegate 工具条

- (void)toolBar:(RecordToolBarView *)toolBar didSelectIndex:(NSInteger)index title:(NSString *)title {
    NSLog(@"点击了---%@", title);
    
    if (_inteligenceCellDelegate && [_inteligenceCellDelegate respondsToSelector:@selector(inteligenceCell:didSelectToolBarIndex:indexPath:)]) {
        [_inteligenceCellDelegate inteligenceCell:self didSelectToolBarIndex:index indexPath:self.cellIndexPath];
        return;
    }
    
    if (index == 0) {
        
    } else if (index == 1) {
        if (self.voiceData.count == 9) {
            [Utils showToastMessage:@"最多录制9条语音"];
            return;
        }
        [self.voiceData addObject:[NSString stringWithFormat:@"08:%ld", self.voiceData.count+10+1]];
        [self initVoiceData];
    } else if (index == 2) {
        if (self.imageData.count == 9) {
            [Utils showToastMessage:@"最多添加9张图片"];
            return;
        }
        [self.imageData addObject:[NSString stringWithFormat:@"08:%ld", self.imageData.count+10+1]];
        [self initImageData];
    } else if (index == 3) {
        if (self.videoData.count >= 3) {
            [Utils showToastMessage:@"最多录制3条短视频"];
            return;
        }
        [self.videoData addObject:[NSString stringWithFormat:@"08:%ld", self.videoData.count+10+1]];
        [self initVideoData];
    }
    [self refreshHeader:NO];
}

#pragma mark - RecordVoiceViewDelegate 语音

- (void)recordVoiceView:(RecordVoiceView *)recordVoiceView didSelectedIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.voiceData.count) {
        NSLog(@"点击了声音---%@", self.voiceData[indexPath.row]);
        if (_inteligenceCellDelegate && [_inteligenceCellDelegate respondsToSelector:@selector(inteligenceCell:didSelectVoiceCell:index:indexPath:)]) {
            [_inteligenceCellDelegate inteligenceCell:self didSelectVoiceCell:self.voiceData[indexPath.row] index:indexPath.item indexPath:self.cellIndexPath];
        }
//
//        QiniuFileMo *qiniuMo = self.voiceData[indexPath.item];
//        NSURL *path = [NSURL fileURLWithPath:qiniuMo.url];
//        if ([qiniuMo.url containsString:@"http"]) {
//            path = [NSURL URLWithString:qiniuMo.url];
//        }
//        // 第二步:创建视频播放器
//        MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:path];
//        playerViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
//        //第四步:跳转视频播放界面
//        [[Utils topViewController] presentViewController:playerViewController animated:YES completion:nil];
    }
}

- (void)recordVoiceView:(RecordVoiceView *)recordVoiceView didDeleteIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.voiceData.count) {
        [self.voiceData removeObjectAtIndex:indexPath.row];
    }
    [self initVoiceData];
    [self refreshHeader:NO];
}

#pragma mark - RecordImageViewDelegate

- (void)recordImageView:(RecordImageView *)recordImageView didSelectedIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.imageData.count) {
        NSLog(@"点击了图片---%ld", (long)indexPath.row);
        ImagePreviewViewCtrl *ctrl = [[ImagePreviewViewCtrl alloc] initWithArrImage:self.imageData currIndex:indexPath.row];
        ctrl.hidenDelete = NO;
        ctrl.imgPrevCtrlDelegate = self;
        [[Utils topViewController].navigationController pushViewController:ctrl animated:YES];
    }
}

- (void)recordImageView:(RecordImageView *)recordImageView didDeleteIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.imageData.count) {
        [self.imageData removeObjectAtIndex:indexPath.row];
    }
    [self initImageData];
    [self refreshHeader:NO];
}

#pragma mark - ImagePreviewCtrlDelegate

- (void)deleteImageIndexes:(NSArray *)arrIndex {
    for (NSNumber *i in arrIndex) {
        [self.imageData removeObjectAtIndex:[i integerValue]];
    }
    [self initImageData];
    [self refreshHeader:NO];
}


#pragma mark - RecordVideoViewDelegate

- (void)recordVideoView:(RecordVideoView *)recordVideoView didSelectedIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.videoData.count) {
        //        NSLog(@"点击了视频---%ld", indexPath.row);
        QiniuFileMo *qiniuMo = self.videoData[indexPath.item];
        NSURL *path = [NSURL fileURLWithPath:qiniuMo.url];
        if ([qiniuMo.url containsString:@"http"]) {
            path = [NSURL URLWithString:qiniuMo.url];
        }
        // 第二步:创建视频播放器
        MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:path];
        playerViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        //第四步:跳转视频播放界面
        [[Utils topViewController] presentViewController:playerViewController animated:YES completion:nil];
        
//        YQAVPlayer *player = [[YQAVPlayer alloc] initWithFrame:[Utils topViewController].view.bounds url:path finishplayblock:^(YQAVPlayer * _Nonnull obj) {
//            [obj removeFromSuperview];
//        }];
//        [[Utils topViewController].view addSubview:player];
    }
}

- (void)recordVideoView:(RecordVideoView *)recordVideoView didDeleteIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.videoData.count) {
        [self.videoData removeObjectAtIndex:indexPath.row];
    }
    [self initVideoData];
    [self refreshHeader:NO];
}

#pragma mark - RecordTextViewDelegate

- (void)recordTextViewBeginEdit:(RecordTextView *)recordTextView {
    if (_inteligenceCellDelegate && [_inteligenceCellDelegate respondsToSelector:@selector(inteligenceCellBeginEdit:indexPath:)]) {
        [_inteligenceCellDelegate inteligenceCellBeginEdit:self indexPath:self.cellIndexPath];
    }
}

#pragma mark - public

- (void)resetNormalState {
    [self.recordView.contentView.textView.internalTextView resignFirstResponder];
    self.model.showText = self.recordView.contentView.textView.internalTextView.text;
//    self.model.communicateRecord = self.recordView.contentView.textView.internalTextView.text;
}

- (void)loadData:(BusinessVisitActivityMo *)model {
    _model = model;
    [self.recordView.contentView refreshRecordContentView:_model];
    self.imageData = _model.images;
    self.videoData = _model.videos;
    self.voiceData = _model.voices;
}

#pragma mark - lazy

- (RecordView *)recordView {
    if (!_recordView) {
        _recordView = [[RecordView alloc] init];
        _recordView.toolBar.toolBarDelegate = self;
        _recordView.contentView.voiceView.recordVoiceViewDelegate = self;
        _recordView.contentView.imageView.recordImageViewDelegate = self;
        _recordView.contentView.videoView.recordVideoViewDelegate = self;
        _recordView.contentView.textView.delegate = self;
//        _recordView.contentView.placeholder = @"填写建议：请填写产品类型、新建/减产、产能大小、所在区域等信息";
    }
    return _recordView;
}

@end
