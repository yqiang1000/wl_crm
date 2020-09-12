//
//  TabTrendsTableViewCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TabTrendsTableViewCell.h"
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

@interface TabTrendsTableViewCell () <RecordImageViewDelegate, RecordVoiceViewDelegate, RecordVideoViewDelegate, RecordingViewCtrlDelegate>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) TrendsTextView *labContent;
@property (nonatomic, strong) UILabel *labType;
@property (nonatomic, strong) UIButton *btnCollection;
@property (nonatomic, strong) UIButton *btnLike;
@property (nonatomic, strong) UIButton *btnComment;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, copy) NSString *orgStr;

@property (nonatomic, strong) NSMutableArray *arrCustomer;
@property (nonatomic, strong) NSMutableArray *arrAt;
@property (nonatomic, strong) NSMutableArray *arrOrder;

@property (nonatomic, strong) UILabel *labIcon;

@property (nonatomic, strong) RecordVoiceView *voiceView;
@property (nonatomic, strong) RecordImageView *recordImageView;
@property (nonatomic, strong) RecordVideoView *videoView;
@property (nonatomic, strong) RecordingViewCtrl *recordingVC;

@end


@implementation TabTrendsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = COLOR_B0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [RecordUtils shareInstance].record_width = (SCREEN_WIDTH-120)/3.0;
        
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
    [self.baseView addSubview:self.labContent];
    [self.baseView addSubview:self.labType];
    [self.baseView addSubview:self.bottomView];
    [self.baseView addSubview:self.voiceView];
    [self.baseView addSubview:self.recordImageView];
    [self.baseView addSubview:self.videoView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-10);
//        make.height.equalTo(@138.0);
    }];

    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(17);
        make.left.equalTo(self.baseView).offset(15);
        make.height.width.equalTo(@(35));
    }];
    
    [self.labIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.imgIcon);
    }];
    
    [self.labType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(10);
        make.right.equalTo(self.baseView).offset(-10);
        make.height.equalTo(@24.0);
        make.width.equalTo(@44.0);
    }];
    
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(16);
        make.left.equalTo(self.imgIcon.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.labType.mas_left).offset(-10);
    }];
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labName.mas_bottom).offset(8);
        make.left.equalTo(self.labName);
        make.right.lessThanOrEqualTo(self.baseView).offset(-10);
    }];
    
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTime.mas_bottom).offset(5);
        make.left.equalTo(self.labName).offset(-5);
        make.right.equalTo(self.baseView).offset(-10);
    }];
    
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labContent.mas_bottom).offset(10);
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
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoView.mas_bottom);
        make.height.equalTo(@38.0);
        make.left.right.bottom.equalTo(self.baseView);
    }];
}

#pragma mark - public

- (void)loadDataModel:(TrendsFeedMo *)model source:(TrendFeedItemMo *)source {
    if (_model != model) {
        _model = model;
    }
    if (_source != source) {
        _source = source;
    }
    [_model configAttachmentList];
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:[Utils imgUrlWithKey:_model.avatarUrl]] placeholderImage:nil];
    self.imgIcon.hidden = _model.avatarUrl.length==0?YES:NO;
    self.labIcon.hidden = !self.imgIcon.hidden;
    self.labIcon.text = [Utils getFeedIconText:_model.operatorNameSrFrAr];
    self.labType.text = _model.fkTypeValue;
    CGSize size = [Utils getStringSize:self.labType.text font:self.labType.font];
    [self.labType mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width+10));
    }];
    
    self.labName.text = _model.operatorNameSrFrAr;
    self.labTime.text = _model.createdDate;
    self.orgStr = _model.content.length == 0 ? @"" : _model.content;
    [self.labContent loadText:self.orgStr];
    self.labContent.font = FONT_F14;
    self.btnCollection.selected = _model.favorited > 0 ? YES : NO;
    self.btnLike.selected = _model.liked > 0 ? YES : NO;
    
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
    
    [self.btnLike setTitle:[NSString stringWithFormat:@"%ld", (long)_model.likedCount] forState:UIControlStateNormal];
    [self.btnComment setTitle:[NSString stringWithFormat:@"%ld", 90] forState:UIControlStateNormal];
    [self.btnLike imageLeftWithTitleFix:7];
    [self.btnComment imageLeftWithTitleFix:7];
    
    [self layoutIfNeeded];
    _labType.layer.mask = [Utils drawContentFrame:_labType.bounds corners:UIRectCornerAllCorners cornerRadius:3];
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
        [[UIApplication sharedApplication].keyWindow addSubview:_recordingVC.view];
        [_recordingVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo([UIApplication sharedApplication].keyWindow);
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

- (void)btnCollectionClick:(UIButton *)sender {
    [Utils showHUDWithStatus:nil];
    if (_model.favorited > 0) {
        [[JYUserApi sharedInstance] deleteFavoriteId:_model.favorited success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"取消收藏成功"];
            _model.favorited = 0;
            sender.selected = !sender.selected;
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [[JYUserApi sharedInstance] createFavoriteTypeId:@"FEED_FLOW" favoriteId:_model.id success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"收藏成功"];
            _model.favorited = [responseObject[@"id"] longLongValue];
            sender.selected = !sender.selected;
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

- (void)btnLikeClick:(UIButton *)sender {
    [Utils showHUDWithStatus:nil];
    if (_model.liked > 0) {
        [[JYUserApi sharedInstance] removeFeedLikeRecordId:_model.liked param:nil success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"取消点赞成功"];
            _model.likedCount--;
            _model.liked = 0;
            sender.selected = !sender.selected;
            [self.btnLike setTitle:[NSString stringWithFormat:@"%ld", _model.likedCount] forState:UIControlStateNormal];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:@"FEED_FLOW" forKey:@"fkType"];
        [param setObject:@(_model.id) forKey:@"fkId"];
        [[JYUserApi sharedInstance] addFeedLikeRecord:param success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"点赞成功"];
            _model.likedCount++;
            _model.liked = [responseObject[@"id"] integerValue];;
            [self.btnLike setTitle:[NSString stringWithFormat:@"%ld", _model.likedCount] forState:UIControlStateNormal];
            sender.selected = !sender.selected;
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

- (void)btnCommentClick:(UIButton *)sender {
    
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

- (TrendsTextView *)labContent {
    if (!_labContent) _labContent = [[TrendsTextView alloc] init];
    return _labContent;
}

- (UILabel *)labType {
    if (!_labType) {
        _labType = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 24)];
        _labType.textAlignment = NSTextAlignmentCenter;
        _labType.backgroundColor = COLOR_F2F3F5;
        _labType.textColor = COLOR_B2;
        _labType.font = FONT_F11;
    }
    return _labType;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        [_bottomView addSubview:self.btnCollection];
        [_bottomView addSubview:self.btnLike];
        [_bottomView addSubview:self.btnComment];
        _btnComment.hidden = YES;
        
        [_btnCollection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bottomView);
            make.left.equalTo(_bottomView).offset(15);
        }];
        
//        [_btnComment mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_bottomView);
//            make.right.equalTo(_bottomView).offset(-13);
//        }];
//
//        [_btnLike mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_bottomView);
//            make.right.equalTo(_btnComment.mas_left).offset(-20);
//        }];
        
        [_btnLike mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bottomView);
            make.right.equalTo(_bottomView).offset(-13);
        }];
        
        UIView *line = [Utils getLineView];
        [_bottomView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomView);
            make.left.equalTo(_bottomView).offset(15);
            make.right.equalTo(_bottomView).offset(-10);
            make.height.equalTo(@0.5);
        }];
    }
    return _bottomView;
}

- (UIButton *)btnCollection {
    if (!_btnCollection) {
        _btnCollection = [[UIButton alloc] init];
        [_btnCollection setTitle:@"收藏" forState:UIControlStateNormal];
        _btnCollection.titleLabel.font = FONT_F13;
        [_btnCollection setTitleColor:COLOR_B3 forState:UIControlStateNormal];
        [_btnCollection setTitleColor:COLOR_C3 forState:UIControlStateSelected];
        [_btnCollection setImage:[UIImage imageNamed:@"trendsCollect"] forState:UIControlStateNormal];
        [_btnCollection setImage:[UIImage imageNamed:@"orderassistant_collection_s"] forState:UIControlStateSelected];
        [_btnCollection imageLeftWithTitleFix:4];
        [_btnCollection addTarget:self action:@selector(btnCollectionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCollection;
}

- (UIButton *)btnLike {
    if (!_btnLike) {
        _btnLike = [[UIButton alloc] init];
        [_btnLike setTitle:@"0" forState:UIControlStateNormal];
        [_btnLike setImage:[UIImage imageNamed:@"trendsZan"] forState:UIControlStateNormal];
        [_btnLike setImage:[UIImage imageNamed:@"trendsZaned"] forState:UIControlStateSelected];
        [_btnLike setTitleColor:COLOR_B3 forState:UIControlStateNormal];
        _btnLike.titleLabel.font = FONT_F13;
        [_btnLike addTarget:self action:@selector(btnLikeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLike;
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
