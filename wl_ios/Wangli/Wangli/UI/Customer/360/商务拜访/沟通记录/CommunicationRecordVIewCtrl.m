//
//  CommunicationRecordVIewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CommunicationRecordVIewCtrl.h"
#import "UIButton+ShortCut.h"
#import "RelatedInteligenceCell.h"
#import "CreateIntelligenceViewCtrl.h"
#import "VoiceSelectView.h"
#import "PhotoPickerManager.h"
#import "YQVideoViewController.h"
#import "YQAVPlayer.h"
#import "MyCommonCell.h"
#import "InteligenceCell.h"
#import "RecordingViewCtrl.h"
#import "QiNiuUploadHelper.h"
#import "UpdateIntelligenceViewCtrl.h"
#import "JYUserMoSelectViewCtrl.h"

@interface CommunicationRecordVIewCtrl () <UITableViewDelegate, UITableViewDataSource, RecordToolBarViewDelegate, RecordVoiceViewDelegate, RecordImageViewDelegate, RecordVideoViewDelegate, InteligenceCellDelegate, RecordingViewCtrlDelegate, JYUserMoSelectViewCtrlDelegate, HPGrowingTextViewDelegate>

@property (nonatomic, strong) UIView *tableViewFooter;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, strong) NSMutableArray *voiceData;
@property (nonatomic, strong) NSMutableArray *imageData;
@property (nonatomic, strong) NSMutableArray *videoData;

@property (nonatomic, assign) VoiceChangeType changeType;
@property (nonatomic, strong) RecordingViewCtrl *recordingVC;

@property (nonatomic, strong) InteligenceCell *inteligenceCell;
@property (nonatomic, assign) NSInteger currentLocation;

@end

@implementation CommunicationRecordVIewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentLocation = 0;
    _changeType = VoiceDefaultType;
    [self.model configAttachmentList];
    [self config];
    [self setUI];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self getActivityPage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)getActivityPage {
    [[JYUserApi sharedInstance] getLinkActivityPageByDetailId:self.model.id param:nil success:^(id responseObject) {
        NSError *error = nil;
        self.arrData = [IntelligenceItemSet arrayOfModelsFromDictionaries:responseObject error:&error];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)config {
//    JYVoiceMo *mo = [[JYVoiceMo alloc] init];
//    mo.fileName = @"20181229173113.wav";
//    mo.secondCount = 4;
//    [self.model.voices addObject:mo];
    self.voiceData = self.model.voices;
    self.imageData = self.model.images;
    self.videoData = self.model.videos;
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 2 : self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return indexPath.row == 0 ? 45 : 200;
    } else {
        return  65.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [UIView new];
    }
    NSString *identifier = @"headerView";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
        header.contentView.backgroundColor = COLOR_B0;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 15)];
        lineView.layer.mask = [Utils drawContentFrame:lineView.bounds corners:UIRectCornerAllCorners cornerRadius:1.5];
        lineView.backgroundColor = COLOR_C1;
        [header.contentView addSubview:lineView];
        
        UILabel *labTxt = [UILabel new];
        labTxt.text = @"关联情报";
        labTxt.font = FONT_F16;
        labTxt.textColor = COLOR_B1;
        [header.contentView addSubview:labTxt];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(header.contentView);
            make.left.equalTo(header.contentView).offset(15);
            make.height.equalTo(@15.0);
            make.width.equalTo(@3.0);
        }];
        
        [labTxt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(header.contentView);
            make.left.equalTo(lineView.mas_right).offset(8);
            make.right.lessThanOrEqualTo(header).offset(-15);
        }];
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *cellId = @"MyCommonCell";
            MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [cell setLeftText:@"客户"];
            ShowTextMo *showTextMo = [Utils showTextRightStr:@"请选择" valueStr:STRING(_model.member[@"orgName"])];
            cell.labRight.text = showTextMo.text;
            cell.labLeft.textColor = COLOR_B1;
            cell.labRight.textColor = COLOR_B2;
            return cell;
        } else {
            static NSString *identifier = @"InteligenceCell";
            InteligenceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[InteligenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.recordView.contentView.placeholder = @"请输入沟通内容";
            cell.recordView.contentView.textView.delegate = self;
            [cell.recordView.contentView.textView resignFirstResponder];
            cell.inteligenceCellDelegate = self;
            [cell loadData:self.model];
            cell.cellIndexPath = indexPath;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self growingTextViewDidChange:cell.recordView.contentView.textView];
            });
            return cell;
        }
    } else {
        NSString *identifier = @"RelatedInteligenceCell";
        RelatedInteligenceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[RelatedInteligenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell loadData:self.arrData[indexPath.row]];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        IntelligenceItemSet *item = self.arrData[indexPath.row];
        UpdateIntelligenceViewCtrl *vc = [[UpdateIntelligenceViewCtrl alloc] init];
        vc.title = @"修改情报详情";
        // 拿单个的id
        vc.itemSet = item;
        __weak typeof(self) weakself = self;
        vc.updateSuccess = ^(id obj) {
            __strong typeof(self) strongself = weakself;
            [strongself getActivityPage];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.inteligenceCell resetNormalState];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? NO : YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该情报？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        IntelligenceItemSet *item = self.arrData[indexPath.row];
        
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] deleteIntelligenceItemDetailId:item.id param:nil success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"删除成功"];
            [self.arrData removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - InteligenceCellDelegate

- (void)inteligenceCellFrameChanged:(InteligenceCell *)inteligenceCell indexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadData];
    NSLog(@"情报-----回掉刷新单元格%@", indexPath);
}

- (void)inteligenceCell:(InteligenceCell *)inteligenceCell didSelectVoiceCell:(JYVoiceMo *)voiceMo index:(NSInteger)index indexPath:(NSIndexPath *)indexPath {
    if (_recordingVC) {
        _recordingVC.delegate = self;
        _recordingVC = nil;
    }
    _recordingVC = [[RecordingViewCtrl alloc] init];
    _recordingVC.delegate = self;
    _recordingVC.voiceMo = self.model.voices[index];
    [self.view addSubview:_recordingVC.view];
    [_recordingVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

- (void)inteligenceCell:(InteligenceCell *)inteligenceCell didSelectToolBarIndex:(NSInteger)barIndex indexPath:(NSIndexPath *)indexPath {
    if (barIndex != 0) [self.inteligenceCell resetNormalState];
    if (barIndex == 0) {
        [Utils showToastMessage:@"该功能将于春节后上线"];
        return;
        _currentLocation = self.inteligenceCell.recordView.contentView.textView.text.length;
        if (self.inteligenceCell.recordView.contentView.textView.isFirstResponder) {
            _currentLocation = self.inteligenceCell.recordView.contentView.textView.selectedRange.location + self.inteligenceCell.recordView.contentView.textView.selectedRange.length;
        }
        JYUserMoSelectViewCtrl *vc = [[JYUserMoSelectViewCtrl alloc] init];
        vc.VcDelegate = self;
        vc.isMultiple = NO;
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    } else if (barIndex == 1) {
//        [Utils showToastMessage:@"该功能将于春节后上线"];
//        return;
        if (self.voiceData.count >= 9) {
            [Utils showToastMessage:@"最多录制9条语音"];
            return;
        }
        // 弹出选择框
        __weak typeof(self) weakself = self;
        VoiceSelectView *selectView = [[VoiceSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) changeType:_changeType itemClick:^(VoiceChangeType type) {
            weakself.changeType = type;
            // 录音页面
            [weakself addVoice];
        } cancelClick:^(VoiceSelectView * _Nonnull obj) {
            obj = nil;
        }];
        [selectView showView];
    } else if (barIndex == 2) {
        if (self.imageData.count >= 9) {
            [Utils showToastMessage:@"最多添加9张图片"];
            return;
        }
        [self addPicture];
    } else if (barIndex == 3) {
//        [Utils showToastMessage:@"该功能将于春节后上线"];
//        return;
        if (self.videoData.count >= 3) {
            [Utils showToastMessage:@"最多录制3条短视频"];
            return;
        }
        [self addVideo];
    }
}

#pragma mark - 添加语音

- (void)addVoice {
    if (!_recordingVC) {
        _recordingVC = [[RecordingViewCtrl alloc] init];
        _recordingVC.delegate = self;
    }
    [self.view addSubview:_recordingVC.view];
    [_recordingVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - 添加图片

- (void)addPicture {
    [[PhotoPickerManager shared] showActionSheetInView:[Utils topViewController].view fromController:[Utils topViewController] maxCount:9-self.model.images.count completion:^(NSArray *photos) {
        for (int i = 0; i < photos.count; i++) {
            [self.imageData addObject:photos[i]];
        }
        [self.tableView reloadData];
    } cancelBlock:^{
    }];
}

#pragma mark - 添加视频

- (void)addVideo {
    YQVideoViewController *vc = [[YQVideoViewController alloc] init];
    __weak typeof(self)weakself = self;
    vc.takeBlock = ^(id  _Nonnull item) {
        if ([item isKindOfClass:[UIImage class]]) {
            if (self.imageData.count >= 9) {
                [Utils showToastMessage:@"最多添加9张图片"];
            } else {
                [self.imageData addObject:item];
            }
        } else if ([item isKindOfClass:[NSURL class]]) {
            QiniuFileMo *qiniuMo = [[QiniuFileMo alloc] init];
            qiniuMo.fileType = @"mp4";
            qiniuMo.url = ((NSURL *)item).absoluteString;
            [weakself.videoData addObject:qiniuMo];
        }
        [weakself.tableView reloadData];
    };
    [[Utils topViewController].navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - RecordVoiceViewDelegate 语音

//- (void)recordVoiceView:(RecordVoiceView *)recordVoiceView didSelectedIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row < self.voiceData.count) {
//        NSLog(@"点击了声音---%@", self.voiceData[indexPath.row]);
//    }
//}
//
//- (void)recordVoiceView:(RecordVoiceView *)recordVoiceView didDeleteIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item < self.voiceData.count) {
//        [self.voiceData removeObjectAtIndex:indexPath.row];
//    }
//    [self initVoiceData];
//}

#pragma mark - RecordImageViewDelegate

//- (void)recordImageView:(RecordImageView *)recordImageView didSelectedIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item < self.imageData.count) {
//        NSLog(@"点击了图片---%ld", indexPath.row);
//    }
//}
//
//- (void)recordImageView:(RecordImageView *)recordImageView didDeleteIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item < self.imageData.count) {
//        [self.imageData removeObjectAtIndex:indexPath.row];
//    }
//    [self initImageData];
//}

#pragma mark - RecordVideoViewDelegate

//- (void)recordVideoView:(RecordVideoView *)recordVideoView didSelectedIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item < self.videoData.count) {
////        NSLog(@"点击了视频---%ld", indexPath.row);
//        NSURL *path = self.videoData[indexPath.item];
//        YQAVPlayer *player = [[YQAVPlayer alloc] initWithFrame:[Utils topViewController].view.bounds url:path finishplayblock:^(YQAVPlayer * _Nonnull obj) {
//            [obj removeFromSuperview];
//        }];
//        [self.view addSubview:player];
//    }
//}
//
//- (void)recordVideoView:(RecordVideoView *)recordVideoView didDeleteIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item < self.videoData.count) {
//        [self.videoData removeObjectAtIndex:indexPath.row];
//    }
//    [self initVideoData];
//    [self refreshHeader];
//}

#pragma mark - RecordingViewCtrlDelegate 录制过程

- (void)recordingViewCtrlCancelAction:(RecordingViewCtrl *)recordingViewCtrl {
    [_recordingVC.view removeFromSuperview];
    _recordingVC.delegate = nil;
    _recordingVC = nil;
}

- (void)recordingViewCtrlConfirmAction:(RecordingViewCtrl *)recordingViewCtrl fileName:(NSString *)fileName mp3Path:(NSString *)mp3Path count:(NSInteger)count {
    QiniuFileMo *voiceMo = [[QiniuFileMo alloc] init];
    voiceMo.fileType = @"mp3";
    voiceMo.fileName = fileName;
    voiceMo.url = mp3Path;
    voiceMo.extData = count;
    [self.model.voices addObject:voiceMo];
    [self.tableView reloadData];
}

- (void)recordingViewCtrlwDismiss:(RecordingViewCtrl *)recordingViewCtrl {
    [_recordingVC.view removeFromSuperview];
    _recordingVC.delegate = nil;
    _recordingVC = nil;
}

#pragma mark - JYUserMoSelectViewCtrlDelegate

- (void)jyUserMoSelectViewCtrl:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(JYUserMo *)selectMo {
    
    [self.model.userMos addObject:selectMo];
    
    [self.inteligenceCell.recordView.contentView.textView.internalTextView unmarkText];
    UITextView *textView = self.inteligenceCell.recordView.contentView.textView.internalTextView;
    NSString *insertString = [NSString stringWithFormat:kATFormat,selectMo.name];
    NSMutableString *string = [NSMutableString stringWithString:textView.text];
    [string insertString:insertString atIndex:_currentLocation];
    self.inteligenceCell.recordView.contentView.textView.internalTextView.text = string;
    [self.inteligenceCell.recordView.contentView.textView becomeFirstResponder];
    textView.selectedRange = NSMakeRange(_currentLocation + insertString.length, 0);
    [self growingTextViewDidChange:self.inteligenceCell.recordView.contentView.textView];
}

- (void)jyUserMoSelectViewCtrlDismiss:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl {
    jyUserMoSelectViewCtrl = nil;
}

#pragma mark - HPGrowingTextViewDelegate

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self.inteligenceCell.recordView.contentView.textView resignFirstResponder];
    return YES;
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""])
    {
        NSRange selectRange = growingTextView.selectedRange;
        if (selectRange.length > 0)
        {
            //用户长按选择文本时不处理
            return YES;
        }

        // 判断删除的是一个@中间的字符就整体删除
        NSMutableString *string = [NSMutableString stringWithString:growingTextView.text];
        NSArray *matches = [self findAllAt];

        BOOL inAt = NO;
        NSInteger index = range.location;
        for (NSTextCheckingResult *match in matches)
        {
            NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
            if (NSLocationInRange(range.location, newRange))
            {
                inAt = YES;
                index = match.range.location;
                [string replaceCharactersInRange:match.range withString:@""];
                break;
            }
        }

        if (inAt)
        {
            growingTextView.text = string;
            growingTextView.selectedRange = NSMakeRange(index, 0);
            return NO;
        }
    } else if ([text isEqualToString:@"@"]) {
        _currentLocation = self.inteligenceCell.recordView.contentView.textView.text.length;
        if (self.inteligenceCell.recordView.contentView.textView.isFirstResponder) {
            _currentLocation = self.inteligenceCell.recordView.contentView.textView.selectedRange.location + self.inteligenceCell.recordView.contentView.textView.selectedRange.length;
        }
        JYUserMoSelectViewCtrl *vc = [[JYUserMoSelectViewCtrl alloc] init];
        vc.VcDelegate = self;
        vc.isMultiple = NO;
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
        return NO;
    }

    //    //判断是回车键就发送出去
    //    if ([text isEqualToString:@"\n"])
    //    {
    //        [self.comments addObject:growingTextView.text];
    //        self.growingTextView.text = @"";
    //        [self.growingTextView resignFirstResponder];
    //        [self.tableView reloadData];
    //        return NO;
    //    }
    return YES;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    UITextRange *selectedRange = growingTextView.internalTextView.markedTextRange;
    NSString *newText = [growingTextView.internalTextView textInRange:selectedRange];

    if (newText.length < 1)
    {
        // 高亮输入框中的@
        UITextView *textView = self.inteligenceCell.recordView.contentView.textView.internalTextView;
        NSRange range = textView.selectedRange;

        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:textView.text];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.string.length)];

        NSArray *matches = [self findAllAt];

        for (NSTextCheckingResult *match in matches)
        {
            [string addAttribute:NSForegroundColorAttributeName value:COLOR_C1 range:NSMakeRange(match.range.location, match.range.length)];
        }

        textView.attributedText = string;
        textView.selectedRange = range;
        textView.font = FONT_F15;
    }
}

- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView
{
    // 光标不能点落在@词中间
    NSRange range = growingTextView.selectedRange;
    if (range.length > 0)
    {
        // 选择文本时可以
        return;
    }

    NSArray *matches = [self findAllAt];

    for (NSTextCheckingResult *match in matches)
    {
        NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
        if (NSLocationInRange(range.location, newRange))
        {
            growingTextView.internalTextView.selectedRange = NSMakeRange(match.range.location + match.range.length, 0);
            break;
        }
    }
}


#pragma mark - Private

- (NSArray<NSTextCheckingResult *> *)findAllAt
{
    // 找到文本中所有的@
    NSString *string = self.inteligenceCell.recordView.contentView.textView.text;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kATRegular options:NSRegularExpressionCaseInsensitive error:nil];
    if (string.length == 0) {
        return nil;
    }
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    [self.inteligenceCell resetNormalState];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    if (![self dealWithContentParams:param]) return;
    
    [param setObject:@(self.model.id) forKey:@"id"];
    
    [Utils showHUDWithStatus:nil];

//    [self.model.videos removeAllObjects];
//    QiniuFileMo *qiniuMo = [[QiniuFileMo alloc] init];
//    qiniuMo.fileType = @"mp4";
//    qiniuMo.url = @"/Users/yeqiang/Library/Developer/CoreSimulator/Devices/727AA91B-BFD1-4F45-AD2D-5C1DEF3C82DB/data/Containers/Data/Application/95D44750-4393-4BA4-BDBF-0BD0FC68BC19/Documents/userId_143/video/20190302124506.MP4";
////    @"/Users/yeqiang/Library/Developer/CoreSimulator/Devices/727AA91B-BFD1-4F45-AD2D-5C1DEF3C82DB/data/Containers/Data/Application/AC2763D6-827B-4DCA-B999-DAAC02EC2294/Documents/userId_143/video/20190302124506.MP4";
//    qiniuMo.extData = 10;
//    [self.model.videos addObject:qiniuMo];
    
    if (self.model.images.count > 0 ||
        self.model.voices.count > 0 ||
        self.model.videos.count > 0) {
        [Utils showHUDWithStatus:nil];
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadImages:self.model.images voices:self.model.voices videos:self.model.videos success:^(id responseObject) {
            [Utils showHUDWithStatus:@"附件上传成功"];
            [self dealWithParams:param attachmentList:responseObject];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [self dealWithParams:param attachmentList:@[]];
    }
}


- (BOOL)dealWithContentParams:(NSMutableDictionary *)param  {
    NSArray *matches = [self findAllAt];

    NSMutableString *contentStr = [[NSMutableString alloc] initWithString: self.inteligenceCell.recordView.contentView.textView.text];

    for (int i = 0; i < matches.count; i++) {
        NSTextCheckingResult *match = matches[matches.count-i-1];
        NSString *userName = [contentStr substringWithRange:NSMakeRange(match.range.location+1, match.range.length-2)];
        // 是否存在
        __block BOOL isExit = NO;
        [self.model.userMos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JYUserMo *mo = (JYUserMo *)obj;
            if ([mo.name isEqualToString:userName]) {
                [contentStr replaceCharactersInRange:match.range withString:[NSString stringWithFormat:@"@=%ld=%@@", (long)mo.id, mo.name]];
                isExit = YES;
                *stop = YES;
            }
        }];

        if (!isExit) {
            [Utils showToastMessage:@"部分操作员不存在，需要剔除"];
            [contentStr replaceCharactersInRange:match.range withString:@""];
            NSMutableString *orgStr = [[NSMutableString alloc] initWithString: self.inteligenceCell.recordView.contentView.textView.text];
            [orgStr replaceCharactersInRange:match.range withString:@""];
            self.inteligenceCell.recordView.contentView.textView.text = orgStr;
        }
    }
    if (contentStr.length == 0) {
        [Utils showToastMessage:@"内容不能为空"];
        return NO;
    }

    [param setObject:STRING(contentStr) forKey:@"communicateRecord"];
    return YES;
}

- (void)dealWithParams:(NSMutableDictionary *)param attachmentList:(NSArray *)attachmentList {
    NSMutableArray *arr = [NSMutableArray new];
    for (QiniuFileMo *tmpMo in attachmentList) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[tmpMo toDictionary]];
        [dic setObject:@"" forKey:@"url"];
        [dic setObject:@"" forKey:@"thumbnail"];
        [arr addObject:dic];
    }
    [param setObject:arr forKey:@"attachmentList"];
    [[JYUserApi sharedInstance] updateVisitActivityCommunicateRecordParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"保存成功"];
        if (self.updateSuccess) {
            self.updateSuccess(param[@"communicateRecord"]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)createInteligence:(UIButton *)sender {
    NSLog(@"新建情报");
    CreateIntelligenceViewCtrl *vc = [[CreateIntelligenceViewCtrl alloc] init];
    vc.title = @"添加情报详情";
    vc.fromTab = NO;
    vc.communId = self.model.id;
    vc.model = self.model;
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(id obj) {
        __strong typeof(self) strongself = weakself;
        [strongself getActivityPage];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_B0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = self.tableViewFooter;
    }
    return _tableView;
}

- (UIView *)tableViewFooter {
    if (!_tableViewFooter) {
        _tableViewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _tableViewFooter.backgroundColor = COLOR_B0;
        UIButton *btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [btnAdd setTitle:@"添加" forState:UIControlStateNormal];
        [btnAdd setImage:[UIImage imageNamed:@"add_business"] forState:UIControlStateNormal];
        btnAdd.titleLabel.font = FONT_F15;
        [btnAdd setTitleColor:COLOR_336699 forState:UIControlStateNormal];
        [btnAdd setBackgroundColor:COLOR_B4];
        
        [btnAdd addTarget:self action:@selector(createInteligence:) forControlEvents:UIControlEventTouchUpInside];
        [_tableViewFooter addSubview:btnAdd];
        
        [btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_tableViewFooter);
            make.height.equalTo(@44.0);
        }];
        
        UIView *lineView = [Utils getLineView];
        [btnAdd addSubview:lineView];

        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(btnAdd);
            make.height.equalTo(@0.5);
        }];
        
        [btnAdd imageLeftWithTitleFix:10];
    }
    return _tableViewFooter;
}

- (NSMutableArray *)voiceData {
    if (!_voiceData) {
        _voiceData = [NSMutableArray new];
    }
    return _voiceData;
}

- (NSMutableArray *)imageData {
    if (!_imageData) {
        _imageData = [NSMutableArray new];
    }
    return _imageData;
}

- (NSMutableArray *)videoData {
    if (!_videoData) {
        _videoData = [NSMutableArray new];
    }
    return _videoData;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (InteligenceCell *)inteligenceCell {
    if (!_inteligenceCell) {
        _inteligenceCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    }
    return _inteligenceCell;
}

@end
