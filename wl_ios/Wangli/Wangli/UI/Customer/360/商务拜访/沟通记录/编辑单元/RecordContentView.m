//
//  RecordContentView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RecordContentView.h"
#import "RecordUtils.h"

@interface RecordContentView ()

@property (nonatomic, strong) UILabel *labPlaceholder;

@end

@implementation RecordContentView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUI];
        [RecordUtils shareInstance].record_width = 0;
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.textView];
    [self addSubview:self.imageView];
    [self addSubview:self.voiceView];
    [self addSubview:self.videoView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.height.equalTo(@(IS_IPHONE5 ? 120 : 160.0));
        make.bottom.lessThanOrEqualTo(self).offset(-15);
    }];
    
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(15);
        make.right.equalTo(self).offset(-15);
        make.left.equalTo(self).offset(15);
        make.height.equalTo(@0.0);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceView.mas_bottom);
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.height.equalTo(@0.0);
    }];
    
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.height.equalTo(@0.0);
        make.bottom.equalTo(self);
    }];
}

//#pragma mark - UITextViewDelegate
//
//- (void)textViewDidEndEditing:(UITextView *)textView {
//    self.model.text = textView.text;
//}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.labPlaceholder.text = _placeholder;
    [self.textView.internalTextView addSubview:self.labPlaceholder];
    [self.textView.internalTextView setValue:self.labPlaceholder forKey:@"_placeholderLabel"];
}

- (void)refreshRecordContentView:(BusinessVisitActivityMo *)model {
    if (_model != model) {
        _model = model;
    }
//    self.textView.text = _model.communicateRecord;
//    self.textView.internalTextView.text = _model.communicateRecord;
    self.textView.internalTextView.text = _model.showText;
    self.imageView.imageData = _model.images;
    self.voiceView.voiceData = _model.voices;
    self.videoView.videoData = _model.videos;
    [self.voiceView reloadData];
    [self.imageView reloadData];
    [self.videoView reloadData];
    [self.voiceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([[RecordUtils shareInstance] getHeightByCount:_model.voices.count]));
    }];
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([[RecordUtils shareInstance] getHeightByCount:_model.images.count]));
    }];
    [self.videoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([[RecordUtils shareInstance] getHeightByCount:_model.videos.count]));
    }];
    [self layoutIfNeeded];
}

- (void)refreshIntelligenceContentView:(IntelligenceItemSet *)itemModel {
    if (_itemModel != itemModel) {
        _itemModel = itemModel;
    }
    self.textView.internalTextView.text = _itemModel.showText;
    self.imageView.imageData = _itemModel.images;
    self.voiceView.voiceData = _itemModel.voices;
    self.videoView.videoData = _itemModel.videos;
    [self.voiceView reloadData];
    [self.imageView reloadData];
    [self.videoView reloadData];
    [self.voiceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([[RecordUtils shareInstance] getHeightByCount:_itemModel.voices.count]));
    }];
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([[RecordUtils shareInstance] getHeightByCount:_itemModel.images.count]));
    }];
    [self.videoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([[RecordUtils shareInstance] getHeightByCount:_itemModel.videos.count]));
    }];
    [self layoutIfNeeded];
}


#pragma mark - lazy

//- (RecordTextView *)textView {
//    if (!_textView) {
//        _textView = [[RecordTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
////        _textView.font = FONT_F15;
////        _textView.textColor = COLOR_B1;
////        _textView.delegate = self;
//    }
//    return _textView;
//}

- (HPGrowingTextView *)textView {
    if (!_textView) {
        _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _textView.minHeight = (IS_IPHONE5 ? 120 : 160);
        _textView.maxHeight = (IS_IPHONE5 ? 120 : 160)+1;
        _textView.font = FONT_F15;
        _textView.textColor = COLOR_B1;
        _textView.internalTextView.font = FONT_F15;
    }
    return _textView;
}

- (RecordVoiceView *)voiceView {
    if (!_voiceView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _voiceView = [[RecordVoiceView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _voiceView.backgroundColor = COLOR_B4;
    }
    return _voiceView;
}

- (RecordImageView *)imageView {
    if (!_imageView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _imageView = [[RecordImageView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _imageView.backgroundColor = COLOR_B4;
    }
    return _imageView;
}

- (RecordVideoView *)videoView {
    if (!_videoView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _videoView = [[RecordVideoView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _videoView.backgroundColor = COLOR_B4;
    }
    return _videoView;
}

- (UILabel *)labPlaceholder {
    if (!_labPlaceholder) {
        _labPlaceholder = [UILabel new];
        _labPlaceholder.numberOfLines = 0;
        _labPlaceholder.textColor = COLOR_B3;
        _labPlaceholder.font = FONT_F15;
        [_labPlaceholder sizeToFit];
    }
    return _labPlaceholder;
}

@end
