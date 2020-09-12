
//
//  SubInteligenceCell.m
//  Wangli
//
//  Created by yeqiang on 2019/1/16.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "SubInteligenceCell.h"
#import "DropDownButton.h"
#import "YQAVPlayer.h"
#import "ImagePreviewViewCtrl.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SubInteligenceCell () <RecordToolBarViewDelegate, RecordVoiceViewDelegate, RecordImageViewDelegate, RecordVideoViewDelegate, DropDownButtonDelegate, RecordTextViewDelegate, ImagePreviewCtrlDelegate>

@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, strong) UIButton *btnSelect;
@property (nonatomic, strong) DropDownButton *btnLeft;
@property (nonatomic, strong) DropDownButton *btnRight;
@property (nonatomic, strong) UIView *lineView;
// 类型选择
@property (nonatomic, strong) NSMutableArray *arrBigCategoryMos;
@property (nonatomic, strong) NSMutableArray *arrIntelligenceMos;

@end

@implementation SubInteligenceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.btnView];
    [self.contentView addSubview:self.recordView];
    [self.btnView addSubview:self.btnSelect];
    [self.btnView addSubview:self.btnLeft];
    [self.btnView addSubview:self.btnRight];
    [self.btnView addSubview:self.lineView];
    
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.height.equalTo(@40.0);
        make.left.right.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.btnView);
        make.height.equalTo(@0.5);
    }];
    
    [self.btnSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btnView);
        make.left.equalTo(self.btnView).offset(15);
        make.height.width.equalTo(@15.0);
    }];
    
    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btnSelect);
        make.left.equalTo(self.btnSelect.mas_right).offset(10);
        make.height.equalTo(@30.0);
    }];
    
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30.0);
        make.centerY.equalTo(self.btnSelect);
        make.left.equalTo(self.btnLeft.mas_right).offset(10);
        make.right.equalTo(self.btnView).offset(-15);
        make.width.equalTo(self.btnLeft);
    }];
    
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnView.mas_bottom);
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
    
    [self.recordView.contentView refreshIntelligenceContentView:self.model];
    if (_subInteligenceCellDelegate && [_subInteligenceCellDelegate respondsToSelector:@selector(subInteligenceCellFrameChanged:indexPath:)]) {
        [_subInteligenceCellDelegate subInteligenceCellFrameChanged:self indexPath:self.cellIndexPath];
    }
}

#pragma mark - RecordToolBarViewDelegate 工具条

- (void)toolBar:(RecordToolBarView *)toolBar didSelectIndex:(NSInteger)index title:(NSString *)title {
    NSLog(@"点击了---%@", title);
    
    if (_subInteligenceCellDelegate && [_subInteligenceCellDelegate respondsToSelector:@selector(subInteligenceCell:didSelectToolBarIndex:indexPath:)]) {
        [_subInteligenceCellDelegate subInteligenceCell:self didSelectToolBarIndex:index indexPath:self.cellIndexPath];
        return;
    }
    
    if (index == 0) {
        
    } else if (index == 1) {
        if (self.voiceData.count == 9) {
            [Utils showToastMessage:@"最多录制9条语音"];
            return;
        }
        [self.voiceData addObject:[JYVoiceMo new]];
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
        [self.videoData addObject:[JYVoiceMo new]];
        [self initVideoData];
    }
    [self refreshHeader:NO];
}

#pragma mark - RecordVoiceViewDelegate 语音

- (void)recordVoiceView:(RecordVoiceView *)recordVoiceView didSelectedIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.voiceData.count) {
        NSLog(@"点击了声音---%@", self.voiceData[indexPath.row]);
        if (_subInteligenceCellDelegate && [_subInteligenceCellDelegate respondsToSelector:@selector(subInteligenceCell:didSelectVoiceCell:index:indexPath:)]) {
            [_subInteligenceCellDelegate subInteligenceCell:self didSelectVoiceCell:self.voiceData[indexPath.row] index:indexPath.item indexPath:self.cellIndexPath];
        }
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
        QiniuFileMo *qiniuMo = self.videoData[indexPath.item];
        NSURL *path = [NSURL fileURLWithPath:qiniuMo.url];
        if ([qiniuMo.url containsString:@"http"]) {
            path = [NSURL URLWithString:qiniuMo.url];
        }
        MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:path];
        playerViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        //第四步:跳转视频播放界面
        [[Utils topViewController] presentViewController:playerViewController animated:YES completion:nil];
    }
    
    
//    if (indexPath.item < self.videoData.count) {
//        //        NSLog(@"点击了视频---%ld", indexPath.row);
//        NSURL *path = self.videoData[indexPath.item];
//        YQAVPlayer *player = [[YQAVPlayer alloc] initWithFrame:[Utils topViewController].view.bounds url:path finishplayblock:^(YQAVPlayer * _Nonnull obj) {
//            [obj removeFromSuperview];
//        }];
//        [[Utils topViewController].view addSubview:player];
//    }
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
    if (self.btnLeft.isShow) [self.btnLeft startPackUpAnimation];
    if (self.btnRight.isShow) [self.btnRight startPackUpAnimation];
    
    if (_subInteligenceCellDelegate && [_subInteligenceCellDelegate respondsToSelector:@selector(subInteligenceCellBeginEdit:indexPath:)]) {
        [_subInteligenceCellDelegate subInteligenceCellBeginEdit:self indexPath:self.cellIndexPath];
    }
}

#pragma mark - DropDownButtonDelegate

- (void)dropDownButtonBeginEdit:(DropDownButton *)dropDownButton {
    if (dropDownButton == self.btnLeft) {
        if (self.btnRight.isShow) [self.btnRight startPackUpAnimation];
    } else if (dropDownButton == self.btnRight) {
        if (self.btnLeft.isShow) [self.btnLeft startPackUpAnimation];
    }
    [self.recordView.contentView.textView.internalTextView resignFirstResponder];
    if (_subInteligenceCellDelegate && [_subInteligenceCellDelegate respondsToSelector:@selector(subInteligenceCellBeginEdit:indexPath:)]) {
        [_subInteligenceCellDelegate subInteligenceCellBeginEdit:self indexPath:self.cellIndexPath];
    }
}

- (void)dropDownButton:(DropDownButton *)dropDownButton didSelectIndex:(NSIndexPath *)indexPath {
    if (dropDownButton == self.btnLeft) {
        DicMo *tmpBig = self.arrBigCategoryMos[indexPath.row];
        DicMo *tmpDic = [[DicMo alloc] init];
        tmpDic.key = tmpBig.key;
        tmpDic.value = tmpBig.value;
        tmpDic.desp = tmpBig.desp;
        tmpDic.name = tmpBig.name;
        
        if (![tmpDic.key isEqualToString:self.bigMo.key]) {
            self.bigMo = tmpDic;
            self.model.intelligenceInfoValue = self.bigMo.value;
            self.model.intelligenceInfoKey = self.bigMo.key;
            self.model.intelligenceInfo = self.bigMo;
            self.intMo = nil;
            self.model.intelligenceType = nil;
            self.model.intelligenceTypeKey = @"";
            self.model.intelligenceTypeValue = @"";
        }
    } else if (dropDownButton == self.btnRight) {
        DicMo *tmpInt = self.arrIntelligenceMos[indexPath.row];
        DicMo *tmpDic = [[DicMo alloc] init];
        tmpDic.key = tmpInt.key;
        tmpDic.value = tmpInt.value;
        tmpDic.desp = tmpInt.desp;
        tmpDic.name = tmpInt.name;
        
        self.intMo = tmpDic;
        self.model.intelligenceType = self.intMo;
        self.model.intelligenceTypeKey = self.intMo.key;
        self.model.intelligenceTypeValue = self.intMo.value;
    }
    [self.btnLeft setTitle:self.model.intelligenceInfoValue.length==0?@"请选择":self.model.intelligenceInfoValue forState:UIControlStateNormal];
    [self.btnRight setTitle:self.model.intelligenceTypeValue.length==0?@"请选择":self.model.intelligenceTypeValue forState:UIControlStateNormal];
    if (_subInteligenceCellDelegate && [_subInteligenceCellDelegate respondsToSelector:@selector(subInteligenceCell:placehold:indexPath:)]) {
        _model.intelligenceTypeDesp = self.intMo.desp;
        [_subInteligenceCellDelegate subInteligenceCell:self placehold:self.intMo.desp indexPath:self.cellIndexPath];
    }
}

- (NSArray *)listForDropDownButton:(DropDownButton *)dropDownButton {
    if (dropDownButton == self.btnLeft) {
        NSMutableArray *arr = [NSMutableArray new];
        for (DicMo *tmpMo in self.arrBigCategoryMos) {
            [arr addObject:STRING(tmpMo.value)];
        }
        return arr;
    } else if (dropDownButton == self.btnRight) {
        NSMutableArray *arr = [NSMutableArray new];
        for (DicMo *tmpMo in self.arrIntelligenceMos) {
            [arr addObject:STRING(tmpMo.value)];
        }
        return arr;
    }
    return @[];
}

#pragma mark - public

- (void)resetNormalState {
    [self.recordView.contentView.textView.internalTextView resignFirstResponder];
    [self.btnLeft startPackUpAnimation];
    [self.btnRight startPackUpAnimation];
//    self.recordView.contentView.textView.delegate = nil;
    self.model.showText = self.recordView.contentView.textView.internalTextView.text;
}

- (void)loadData:(IntelligenceItemSet *)model {
    _model = model;
    [self.recordView.contentView refreshIntelligenceContentView:_model];
    self.recordView.contentView.placeholder = _model.intelligenceTypeDesp.length==0?@"请填写内容":[NSString stringWithFormat:@"填写建议：%@", _model.intelligenceTypeDesp];
    self.imageData = _model.images;
    self.videoData = _model.videos;
    self.voiceData = _model.voices;
    self.btnSelect.selected = _model.isSelected;
    self.bigMo.key = _model.intelligenceInfoKey;
    self.bigMo.value = _model.intelligenceInfoValue;
    self.intMo.key = _model.intelligenceTypeKey;
    self.intMo.value = _model.intelligenceTypeValue;
    
    [self.btnLeft setTitle:self.model.intelligenceInfoValue.length==0?@"请选择":self.model.intelligenceInfoValue forState:UIControlStateNormal];
    [self.btnRight setTitle:self.model.intelligenceTypeValue.length==0?@"请选择":self.model.intelligenceTypeValue forState:UIControlStateNormal];
}

- (void)btnSelectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.model.isSelected = _btnSelect.selected;
}

- (void)hidenBtnSelect:(BOOL)hiden {
    if (hiden) {
        [self.btnSelect mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.btnView);
            make.left.equalTo(self.btnView).offset(5);
            make.height.width.equalTo(@0.0);
        }];
    } else {
        [self.btnSelect mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.btnView);
            make.left.equalTo(self.btnView).offset(15);
            make.height.width.equalTo(@15.0);
        }];
    }
    [self layoutIfNeeded];
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
        _recordView.contentView.placeholder = @"填写建议：请填写产品类型、新建/减产、产能大小、所在区域等信息";
    }
    return _recordView;
}

- (DropDownButton *)btnLeft {
    if (!_btnLeft) {
        _btnLeft = [[DropDownButton alloc] initWithFrame:CGRectZero Title:@"信息类别" List:@[@"信息类别1", @"信息类别2", @"信息类别3"]];
        _btnLeft.titleLabel.font = FONT_F13;
        _btnLeft.layer.borderWidth = 1;
        _btnLeft.layer.cornerRadius = 3;
        _btnLeft.btnDelegate = self;
        _btnLeft.layer.borderColor = COLOR_LINE.CGColor;
    }
    return _btnLeft;
}

- (DropDownButton *)btnRight {
    if (!_btnRight) {
        _btnRight = [[DropDownButton alloc] initWithFrame:CGRectZero Title:@"情报类型" List:@[@"情报类型1", @"情报类型2", @"情报类型3"]];
        _btnRight.titleLabel.font = FONT_F13;
        _btnRight.layer.borderWidth = 1;
        _btnRight.layer.cornerRadius = 3;
        _btnRight.btnDelegate = self;
        _btnRight.layer.borderColor = COLOR_LINE.CGColor;
    }
    return _btnRight;
}

- (UIButton *)btnSelect {
    if (!_btnSelect) {
        _btnSelect = [[UIButton alloc] init];
        [_btnSelect setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [_btnSelect setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        [_btnSelect addTarget:self action:@selector(btnSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSelect;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

- (UIView *)btnView {
    if (!_btnView) {
        _btnView = [UIView new];
        _btnView.backgroundColor = COLOR_B4;
        _btnView.clipsToBounds = YES;
    }
    return _btnView;
}

- (NSMutableArray *)arrBigCategoryMos {
    if (_arrBigCategoryMos.count != 0) {
        return _arrBigCategoryMos;
    }
    return [_subInteligenceCellDelegate subInteligenceCellArrBigCategoryMos:self];
}

- (NSMutableArray *)arrIntelligenceMos {
    return [_subInteligenceCellDelegate subInteligenceCellArrIntelligenceMos:self bigMoKey:self.model.intelligenceInfoKey];
}

@end
