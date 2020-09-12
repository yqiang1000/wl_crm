//
//  TrendsInteligenceCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsInteligenceCell.h"
#import "UIButton+ShortCut.h"
#import "WebDetailViewCtrl.h"
#import "CustomerCardViewCtrl.h"
#import "ContactDetailViewCtrl.h"
#import "TrendsTextView.h"
#import "RecordImageView.h"
#import "RecordVoiceView.h"
#import "RecordVideoView.h"
#import "RecordUtils.h"
#import "ImagePreviewViewCtrl.h"
#import "RecordingViewCtrl.h"
#import <MediaPlayer/MediaPlayer.h>

@interface TrendsInteligenceCell () <TrendsTextViewDelegate, RecordImageViewDelegate, RecordVoiceViewDelegate, RecordVideoViewDelegate, RecordingViewCtrlDelegate>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) TrendsTextView *labContent;
@property (nonatomic, strong) UIButton *btnComment;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *labIcon;
@property (nonatomic, strong) UILabel *labSource;
@property (nonatomic, strong) UIView *dotView;

@property (nonatomic, strong) RecordVoiceView *voiceView;
@property (nonatomic, strong) RecordImageView *recordImageView;
@property (nonatomic, strong) RecordVideoView *videoView;
@property (nonatomic, strong) RecordingViewCtrl *recordingVC;

@end


@implementation TrendsInteligenceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = COLOR_B0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [RecordUtils shareInstance].record_width = (SCREEN_WIDTH-50)/3.0;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.imgIcon];
    [self.baseView addSubview:self.labIcon];
    [self.baseView addSubview:self.labName];
    [self.baseView addSubview:self.labTime];
    [self.baseView addSubview:self.dotView];
    [self.baseView addSubview:self.labContent];
    [self.baseView addSubview:self.voiceView];
    [self.baseView addSubview:self.recordImageView];
    [self.baseView addSubview:self.videoView];
    [self.baseView addSubview:self.bottomView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];

    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(17);
        make.left.equalTo(self.baseView).offset(15);
        make.height.width.equalTo(@35.0);
    }];
    
    [self.labIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.imgIcon);
    }];
    
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(16);
        make.left.equalTo(self.imgIcon.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.baseView).offset(-10);
    }];
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labName.mas_bottom).offset(8);
        make.left.equalTo(self.labName);
        make.right.lessThanOrEqualTo(self.baseView).offset(-10);
    }];
    
    [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(15);
        make.top.equalTo(self.labIcon.mas_bottom).offset(21);
        make.width.height.equalTo(@5.0);
    }];
    
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgIcon.mas_bottom).offset(5);
        make.left.equalTo(self.baseView).offset(25);
        make.right.equalTo(self.baseView).offset(-10);
    }];
    
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labContent.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [self.recordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceView.mas_bottom);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recordImageView.mas_bottom);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoView.mas_bottom);
        make.height.equalTo(@38.0);
        make.left.right.bottom.equalTo(self.baseView);
    }];
}

#pragma mark - TrendsTextViewDelegate

- (void)trendsTextView:(TrendsTextView *)trendsTextView didSelectUrlStr:(NSString *)urlStr {
    if (_delegate && [_delegate respondsToSelector:@selector(trendsInteligenceCell:didSelectIndexPaht:urlStr:)]) {
        [_delegate trendsInteligenceCell:self didSelectIndexPaht:self.indexPath urlStr:urlStr];
    }
}

#pragma mark - public

- (void)loadData:(TrendsInteligenceMo *)model {
    if (_model != model) {
        _model = model;
    }
    [_model configAttachmentList];
    // 政策，技术趋势 隐藏来源
    if (![_model.intelligence[@"bigCategoryKey"] isEqualToString:@"industry_policy"] &&
        ![_model.intelligence[@"bigCategoryKey"] isEqualToString:@"technology_trend"]) {
        NSString *titleStr = @"";
        if (_model.member.count > 0) {
            titleStr = [titleStr stringByAppendingString:_model.member[@"abbreviation"]];
        }
        if (_model.intelligence) {
            if (titleStr.length > 0) titleStr = [titleStr stringByAppendingString:@"/"];
            titleStr = [titleStr stringByAppendingString:_model.intelligence[@"businessTypeValue"]];
        }
        if (_model.intelligenceInfoValue.length > 0) {
            if (titleStr.length > 0) titleStr = [titleStr stringByAppendingString:@"/"];
            titleStr = [titleStr stringByAppendingString:_model.intelligenceInfoValue];
        }
        if (_model.intelligenceTypeValue.length > 0) {
            if (titleStr.length > 0) titleStr = [titleStr stringByAppendingString:@"/"];
            titleStr = [titleStr stringByAppendingString:_model.intelligenceTypeValue];
        }
        self.labSource.text = [@"来源:" stringByAppendingString:titleStr];
    }
    
    self.imgIcon.hidden = YES;
    self.labIcon.hidden = !self.imgIcon.hidden;
    self.labIcon.text = [Utils getFeedIconText:_model.operator[@"name"]];
    if (_model.operator) {
        self.labName.text = [NSString stringWithFormat:@"%@:%@", _model.operator[@"title"], _model.operator[@"name"]];
    }
    self.labTime.text = [Utils getLastUpdateInfoLastDateStr:_model.createdDate];
    
    BOOL isRead = _model.read || [UserLocalDataUtils getRemarkByMsgId:_model.id msgType:@"TrendsInteligenceMo"];
    [self.labContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(isRead ? 15 : 25);
    }];
    self.dotView.hidden = isRead;
    
    [self.labContent loadText:_model.content];
    self.labContent.font = FONT_F14;
    
    self.recordImageView.imageData = _model.images;
    self.voiceView.voiceData = _model.voices;
    self.videoView.videoData = _model.videos;
    [self.voiceView reloadData];
    [self.recordImageView reloadData];
    [self.videoView reloadData];
    [self.voiceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([[RecordUtils shareInstance] getHeightByCount:_model.voices.count]));
    }];
    [self.recordImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([[RecordUtils shareInstance] getHeightByCount:_model.images.count]));
    }];
    [self.videoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([[RecordUtils shareInstance] getHeightByCount:_model.videos.count]));
    }];
    
    [self.btnComment setTitle:[NSString stringWithFormat:@"%ld", _model.viewedCount] forState:UIControlStateNormal];
    [self.btnComment imageLeftWithTitleFix:7];
    [self layoutIfNeeded];
}

#pragma mark - RecordImageViewDelegate

- (void)recordImageView:(RecordImageView *)recordImageView didSelectedIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.model.images.count) {
        NSLog(@"点击了图片---%ld", (long)indexPath.row);
        ImagePreviewViewCtrl *ctrl = [[ImagePreviewViewCtrl alloc] initWithArrImage:self.model.images currIndex:indexPath.row];
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
    if (indexPath.item < self.model.voices.count) {
        _recordingVC.voiceMo = self.model.voices[indexPath.item];
        [[Utils topViewController].view addSubview:_recordingVC.view];
        [_recordingVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo([Utils topViewController].view);
        }];
    }
}

#pragma mark - RecordVideoViewDelegate

- (void)recordVideoView:(RecordVideoView *)recordVideoView didSelectedIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.model.videos.count) {
        QiniuFileMo *qiniuMo = self.model.videos[indexPath.item];
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

#pragma mark - event

- (void)btnCommentClick:(UIButton *)sender {
//    [Utils showHUDWithStatus:nil];
//    if (_model.favorited > 0) {
//        [[JYUserApi sharedInstance] deleteFavoriteId:_model.favorited success:^(id responseObject) {
//            [Utils dismissHUD];
//            [Utils showToastMessage:@"取消收藏成功"];
//            _model.favorited = 0;
//            sender.selected = !sender.selected;
//        } failure:^(NSError *error) {
//            [Utils dismissHUD];
//            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
//        }];
//    } else {
//        [[JYUserApi sharedInstance] createFavoriteTypeId:@"FEED_FLOW" favoriteId:_model.id success:^(id responseObject) {
//            [Utils dismissHUD];
//            [Utils showToastMessage:@"收藏成功"];
//            _model.favorited = [responseObject[@"id"] longLongValue];
//            sender.selected = !sender.selected;
//        } failure:^(NSError *error) {
//            [Utils dismissHUD];
//            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
//        }];
//    }
}

#pragma mark - lazy

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        _imgIcon.layer.mask = [Utils drawContentFrame:_imgIcon.bounds corners:UIRectCornerAllCorners cornerRadius:CGRectGetWidth(_imgIcon.frame)/2.0];
        _imgIcon.backgroundColor = COLOR_C1;
    }
    return _imgIcon;
}

- (UILabel *)labIcon {
    if (!_labIcon) {
        _labIcon = [[UILabel alloc] initWithFrame:self.imgIcon.bounds];
        _labIcon.layer.mask = [Utils drawContentFrame:_imgIcon.bounds corners:UIRectCornerAllCorners cornerRadius:CGRectGetWidth(_imgIcon.frame)/2.0];
        _labIcon.backgroundColor = COLOR_C1;
        _labIcon.textColor = COLOR_B4;
        _labIcon.font = FONT_F13;
        _labIcon.textAlignment = NSTextAlignmentCenter;
    }
    return _labIcon;
}


- (UILabel *)labName {
    if (!_labName) {
        _labName = [UILabel new];
        _labName.textColor = COLOR_B1;
        _labName.font = FONT_F15;
        _labName.numberOfLines = 0;
    }
    return _labName;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [UILabel new];
        _labTime.textColor = COLOR_B3;
        _labTime.font = FONT_F12;
        _labTime.numberOfLines = 0;
    }
    return _labTime;
}

- (UILabel *)labSource {
    if (!_labSource) {
        _labSource = [UILabel new];
        _labSource.textColor = COLOR_B3;
        _labSource.font = FONT_F12;
        _labSource.numberOfLines = 0;
    }
    return _labSource;
}

- (TrendsTextView *)labContent {
    if (!_labContent) {
        _labContent = [[TrendsTextView alloc] init];
        _labContent.trendsDelegate = self;
    }
    return _labContent;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        [_bottomView addSubview:self.labSource];
        [_bottomView addSubview:self.btnComment];
        
        [_labSource mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bottomView);
            make.left.equalTo(_bottomView).offset(15);
        }];
        
        [_btnComment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bottomView);
            make.right.equalTo(_bottomView).offset(-13);
        }];
        
        UIView *line = [Utils getLineView];
        [_bottomView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_bottomView);
            make.height.equalTo(@0.5);
        }];
    }
    return _bottomView;
}

- (UIButton *)btnComment {
    if (!_btnComment) {
        _btnComment = [[UIButton alloc] init];
        [_btnComment setTitle:@"0" forState:UIControlStateNormal];
        [_btnComment setImage:[UIImage imageNamed:@"trendsComment"] forState:UIControlStateNormal];
        _btnComment.titleLabel.font = FONT_F13;
        [_btnComment setTitleColor:COLOR_B3 forState:UIControlStateNormal];
        [_btnComment addTarget:self action:@selector(btnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnComment;
}

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 5;
        _baseView.clipsToBounds = YES;
    }
    return _baseView;
}

- (UIView *)dotView {
    if (!_dotView) {
        _dotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _dotView.backgroundColor = COLOR_FE5A57;
        _dotView.layer.mask = [Utils drawContentFrame:_dotView.bounds corners:UIRectCornerAllCorners cornerRadius:CGRectGetWidth(_dotView.frame)/2.0];
    }
    return _dotView;
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
