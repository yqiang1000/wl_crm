//
//  RecordVideoCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RecordVideoCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface RecordVideoCell ()

@property (nonatomic, strong) UIView *coverView;

@end

@implementation RecordVideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_B0;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.coverView];
    [self.contentView addSubview:self.btnDelete];
    [self.contentView addSubview:self.btnPlay];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
    
    [self.btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.imgView).offset(2);
        make.right.equalTo(self.imgView).offset(-2);
        make.width.height.equalTo(@15.0);
    }];
    
    [self.btnPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.height.equalTo(@25.0);
    }];
}

#pragma mark - public

- (void)btnDeleteClick:(UIButton *)sender {
    if (_recordVideoCellDelegate && [_recordVideoCellDelegate respondsToSelector:@selector(recordVideoCell:deleteIndexPath:)]) {
        [_recordVideoCellDelegate recordVideoCell:self deleteIndexPath:self.indexPath];
    }
}

- (void)btnPlayClick:(UIButton *)sender {
    if (_recordVideoCellDelegate && [_recordVideoCellDelegate respondsToSelector:@selector(recordVideoCell:playIndexPath:)]) {
        [_recordVideoCellDelegate recordVideoCell:self playIndexPath:self.indexPath];
    }
}

- (void)showVideo:(QiniuFileMo *)video {
    if ([video isKindOfClass:[QiniuFileMo class]]) {
        
        NSURL *url = [NSURL fileURLWithPath:video.url];
        if ([video.url containsString:@"https"] || [video.url containsString:@"http"]) {
//            self.imgView.image = [UIImage imageNamed:@"riskImage_empty"];
            url = [NSURL URLWithString:video.url];
//            url = [NSURL URLWithString:@"https://media.w3.org/2010/05/sintel/trailer.mp4"];
        }
    
        AVURLAsset *urlSet = [AVURLAsset assetWithURL:url];
        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
        imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
        NSError *error = nil;
        CMTime time = CMTimeMake(0,30);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要获取某一秒的第几帧可以使用CMTimeMake方法)
        CMTime actucalTime; //缩略图实际生成的时间
        CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
        if (error) {
            NSLog(@"截取视频图片失败:%@",error.localizedDescription);
        }
        CMTimeShow(actucalTime);
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        
        CGImageRelease(cgImage);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image) {
                NSLog(@"视频截取成功");
                self.imgView.image = image;
            } else {
                NSLog(@"视频截取失败");
                self.imgView.image = [UIImage imageNamed:@"riskImage_empty"];
            }
        });
    } else {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:video] placeholderImage:[UIImage imageNamed:@"riskImage_empty"]];
    }
}

#pragma mark - setter getter

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

- (UIButton *)btnDelete {
    if (!_btnDelete) {
        _btnDelete = [[UIButton alloc] init];
        [_btnDelete setImage:[UIImage imageNamed:@"upload_close"] forState:UIControlStateNormal];
        [_btnDelete addTarget:self action:@selector(btnDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDelete;
}

- (UIButton *)btnPlay {
    if (!_btnPlay) {
        _btnPlay = [[UIButton alloc] init];
        [_btnPlay setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
        [_btnPlay addTarget:self action:@selector(btnPlayClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPlay;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.backgroundColor = COLOR_MASK;
    }
    return _coverView;
}

@end
