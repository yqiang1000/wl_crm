//
//  RiskFollowCell.m
//  Wangli
//
//  Created by yeqiang on 2018/4/18.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "RiskFollowCell.h"
#import "WebDetailViewCtrl.h"
#import "RecordImageView.h"
#import "RecordVoiceView.h"
#import "RecordVideoView.h"
#import "RecordUtils.h"
#import "ImagePreviewViewCtrl.h"
#import "RecordingViewCtrl.h"
#import <MediaPlayer/MediaPlayer.h>

@interface RiskFollowCell () <UITextViewDelegate, RecordImageViewDelegate, RecordVoiceViewDelegate, RecordVideoViewDelegate, RecordingViewCtrlDelegate>

@property (nonatomic, strong) RecordVoiceView *voiceView;
@property (nonatomic, strong) RecordImageView *recordImageView;
@property (nonatomic, strong) RecordVideoView *videoView;
@property (nonatomic, strong) RecordingViewCtrl *recordingVC;

@end

@implementation RiskFollowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.imgHeader];
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labTime];
    [self.contentView addSubview:self.labContent];
    [self.contentView addSubview:self.labCreater];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.voiceView];
    [self.contentView addSubview:self.recordImageView];
    [self.contentView addSubview:self.videoView];
    
    [self.imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.left.equalTo(self.contentView).offset(10);
        make.height.width.equalTo(@30.0);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgHeader);
        make.left.equalTo(self.imgHeader.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.labTime.mas_left).offset(-10);
    }];
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.labTitle);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(12);
        make.left.equalTo(self.labTitle);
        make.right.equalTo(self.labTime);
//        make.height.equalTo(@100);
    }];
    
    [self.labCreater mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labContent.mas_bottom).offset(8);
        make.left.equalTo(self.labTitle);
        make.right.equalTo(self.contentView).offset(-10);
//        make.bottom.lessThanOrEqualTo(self.contentView).offset(-16);
    }];
    
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labCreater.mas_bottom).offset(10);
        make.left.equalTo(self.labContent);
        make.right.equalTo(self.labContent);
    }];
    
    [self.recordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceView.mas_bottom);
        make.left.equalTo(self.labContent);
        make.right.equalTo(self.labContent);
    }];
    
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recordImageView.mas_bottom);
        make.left.equalTo(self.labContent);
        make.right.equalTo(self.labContent);
        make.bottom.equalTo(self.contentView).offset(-6);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgHeader.mas_bottom).offset(5);
        make.centerX.equalTo(self.imgHeader);
        make.width.equalTo(@1.0);
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - public

- (void)loadDataWith:(RiskFollowMo *)model {
//    if (_model != model) {
//        _model = model;
//    }
//    [self.imgHeader sd_setImageWithURL:[NSURL URLWithString:_model.iconUrl] placeholderImage:[UIImage imageNamed:@"default_icon_small"]];
//    self.labTitle.text = _model.title;
//    self.labTime.text = _model.createdDate;
//
//    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[_model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//    self.labContent.attributedText = attrStr;
//    self.labContent.textColor = COLOR_B2;
//
//    if (_model.operatorName.length == 0) {
//        self.labCreater.text = @"";
//        [self.labCreater mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.labContent.mas_bottom);
//        }];
//    } else {
//        self.labCreater.text = [NSString stringWithFormat:@"创建人：%@",_model.operatorName];
//        [self.labCreater mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.labContent.mas_bottom).offset(8);
//        }];
//    }
//
//    CGSize size = [Utils getStringSize:self.labTime.text font:self.labTime.font];
//    [self.labTime mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(size.width + 3));
//    }];
//
//    self.imgContent.hidden = NO;
//    self.imgContent.arrImgs = [[NSMutableArray alloc] initWithArray:_model.arrImgs];
//    self.imgContent.arrUrls = [[NSMutableArray alloc] initWithArray:_model.arrUrls];
//    [self.imgContent reloadData];
//
//    if (_model.hasImgUrl) {
//        // 行数
//        NSInteger x = _model.arrImgs.count / 3;
//        NSInteger y = _model.arrImgs.count % 3;
//        x = x + (y == 0 ? 0 : 1);
//        NSInteger jggHeight = x * (_jggWidth + 10) - 10;
//        [self.imgContent mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(jggHeight));
//            make.top.equalTo(self.labCreater.mas_bottom).offset(10);
//        }];
//    } else {
//        self.imgContent.hidden = YES;
//        [self.imgContent mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@0);
//            make.top.equalTo(self.labCreater.mas_bottom);
//        }];
//    }
//    [self layoutIfNeeded];
}

- (void)loadDataWithFeedMo:(TrendsFeedMo *)feedMo {
    [RecordUtils shareInstance].record_width = (SCREEN_WIDTH - 60 - 20)/3.0;
    
    if (_feedMo != feedMo) {
        _feedMo = feedMo;
    }
    [_feedMo configAttachmentList];
    
    [self.imgHeader sd_setImageWithURL:[NSURL URLWithString:_feedMo.iconUrl] placeholderImage:[UIImage imageNamed:@"default_icon_small"]];
    self.labTitle.text = _feedMo.title;
    self.labTime.text = [Utils getLastUpdateInfoLastDateStr:_feedMo.createdDate];
    
    [self.labContent loadText:_feedMo.content];
    self.labContent.font = FONT_F14;
    self.labContent.textColor = COLOR_B2;
    
    if (_feedMo.operatorName.length == 0) {
        self.labCreater.text = @"";
        [self.labCreater mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labContent.mas_bottom);
        }];
    } else {
        self.labCreater.text = [NSString stringWithFormat:@"创建人：%@",_feedMo.operatorName];
        [self.labCreater mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labContent.mas_bottom).offset(8);
        }];
    }
    
    CGSize size = [Utils getStringSize:self.labTime.text font:self.labTime.font];
    [self.labTime mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width + 3));
    }];
    
    self.recordImageView.imageData = _feedMo.images;
    self.voiceView.voiceData = _feedMo.voices;
    self.videoView.videoData = _feedMo.videos;
    [self.voiceView reloadData];
    [self.recordImageView reloadData];
    [self.videoView reloadData];
    [self.voiceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([[RecordUtils shareInstance] getHeightByCount:_feedMo.voices.count]));
    }];
    [self.recordImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([[RecordUtils shareInstance] getHeightByCount:_feedMo.images.count]));
    }];
    [self.videoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([[RecordUtils shareInstance] getHeightByCount:_feedMo.videos.count]));
    }];
    [self layoutIfNeeded];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if (URL.absoluteString.length > 0) {
        WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
        vc.urlStr = URL.absoluteString;
        NSAttributedString *attr = self.labContent.attributedText;
        NSString *str = [attr string];
        vc.titleStr = [str substringWithRange:characterRange];
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}

#pragma mark - RecordImageViewDelegate

- (void)recordImageView:(RecordImageView *)recordImageView didSelectedIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.feedMo.images.count) {
        NSLog(@"点击了图片---%ld", (long)indexPath.row);
        ImagePreviewViewCtrl *ctrl = [[ImagePreviewViewCtrl alloc] initWithArrImage:self.feedMo.images currIndex:indexPath.row];
        ctrl.hidesBottomBarWhenPushed = YES;
        ctrl.hidenDelete = YES;
        [[Utils topViewController].navigationController pushViewController:ctrl animated:YES];
    }
}

#pragma mark - RecordVoiceViewDelegate

- (void)recordVoiceView:(RecordVoiceView *)recordVoiceView didSelectedIndexPath:(NSIndexPath *)indexPath {
    if (_recordingVC) {
        _recordingVC.delegate = self;
        _recordingVC = nil;
    }
    _recordingVC = [[RecordingViewCtrl alloc] init];
    _recordingVC.delegate = self;
    if (indexPath.item < self.feedMo.voices.count) {
        _recordingVC.voiceMo = self.feedMo.voices[indexPath.item];
        [[UIApplication sharedApplication].keyWindow addSubview:_recordingVC.view];
        [_recordingVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo([UIApplication sharedApplication].keyWindow);
        }];
    }
}

#pragma mark - RecordVideoViewDelegate

- (void)recordVideoView:(RecordVideoView *)recordVideoView didSelectedIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.feedMo.videos.count) {
        QiniuFileMo *qiniuMo = self.feedMo.videos[indexPath.item];
        NSURL *path = [NSURL fileURLWithPath:qiniuMo.url];
        if ([qiniuMo.url containsString:@"http"]) {
            path = [NSURL URLWithString:qiniuMo.url];
        }
        MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:path];
        playerViewController.hidesBottomBarWhenPushed = YES;
        playerViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        //第四步:跳转视频播放界面
        [[Utils topViewController] presentViewController:playerViewController animated:YES completion:nil];
    }
}

#pragma mark - RecordingViewCtrlDelegate

//- (void)recordingViewCtrlCancelAction:(RecordingViewCtrl *)recordingViewCtrl {
//    [_recordingVC.view removeFromSuperview];
//    _recordingVC.delegate = nil;
//    _recordingVC = nil;
//}
//
//- (void)recordingViewCtrlConfirmAction:(RecordingViewCtrl *)recordingViewCtrl fileName:(NSString *)fileName mp3Path:(NSString *)mp3Path count:(NSInteger)count {
//    QiniuFileMo *voiceMo = [[QiniuFileMo alloc] init];
//    voiceMo.fileType = @"mp3";
//    voiceMo.fileName = fileName;
//    voiceMo.url = mp3Path;
//    voiceMo.extData = count;
//    [self.model.voices addObject:voiceMo];
//    [self.tableView reloadData];
//}

- (void)recordingViewCtrlwDismiss:(RecordingViewCtrl *)recordingViewCtrl {
    [_recordingVC.view removeFromSuperview];
    _recordingVC.delegate = nil;
    _recordingVC = nil;
}

#pragma mark - setter getter

- (UIImageView *)imgHeader {
    if (!_imgHeader) {
        _imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _imgHeader.layer.mask = [Utils drawContentFrame:_imgHeader.frame corners:UIRectCornerAllCorners cornerRadius:15];
        _imgHeader.backgroundColor = COLOR_B4;
    }
    return _imgHeader;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F15;
        _labTitle.textColor = COLOR_1893D5;
    }
    return _labTitle;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [[UILabel alloc] init];
        _labTime.font = FONT_F13;
        _labTime.textColor = COLOR_B3;
    }
    return _labTime;
}

- (UILabel *)labCreater {
    if (!_labCreater) {
        _labCreater = [[UILabel alloc] init];
        _labCreater.font = FONT_F12;
        _labCreater.textColor = COLOR_B3;
    }
    return _labCreater;
}

- (TrendsTextView *)labContent {
    if (!_labContent) _labContent = [[TrendsTextView alloc] init];
    return _labContent;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_BDBDBD;
    }
    return _lineView;
}

- (RecordVoiceView *)voiceView {
    if (!_voiceView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _voiceView = [[RecordVoiceView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _voiceView.backgroundColor = COLOR_B4;
        _voiceView.unDelete = YES;
        _voiceView.recordVoiceViewDelegate = self;
    }
    return _voiceView;
}

- (RecordImageView *)recordImageView {
    if (!_recordImageView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _recordImageView = [[RecordImageView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _recordImageView.backgroundColor = COLOR_B4;
        _recordImageView.unDelete = YES;
        _recordImageView.recordImageViewDelegate = self;
    }
    return _recordImageView;
}

- (RecordVideoView *)videoView {
    if (!_videoView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _videoView = [[RecordVideoView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _videoView.backgroundColor = COLOR_B4;
        _videoView.unDelete = YES;
        _videoView.recordVideoViewDelegate = self;
    }
    return _videoView;
}

@end
