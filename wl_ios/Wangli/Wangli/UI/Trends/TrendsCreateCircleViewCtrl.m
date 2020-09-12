//
//  TrendsCreateCircleViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/1/8.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsCreateCircleViewCtrl.h"
#import "CreateIntelligenceViewCtrl.h"
#import "VoiceSelectView.h"
#import "PhotoPickerManager.h"
#import "YQVideoViewController.h"
#import "YQAVPlayer.h"
#import "MyCommonCell.h"
#import "InteligenceCell.h"
#import "RecordingViewCtrl.h"
#import "QiNiuUploadHelper.h"
#import "ListSelectViewCtrl.h"
#import "JYUserMoSelectViewCtrl.h"
#import "MemberSelectViewCtrl.h"

@interface TrendsCreateCircleViewCtrl () <UITableViewDelegate, UITableViewDataSource, RecordToolBarViewDelegate, RecordVoiceViewDelegate, RecordImageViewDelegate, RecordVideoViewDelegate, RecordingViewCtrlDelegate, InteligenceCellDelegate, RecordingViewCtrlDelegate, MyButtonCellDelegate, ListSelectViewCtrlDelegate, JYUserMoSelectViewCtrlDelegate, HPGrowingTextViewDelegate, MemberSelectViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, strong) NSMutableArray *voiceData;
@property (nonatomic, strong) NSMutableArray *imageData;
@property (nonatomic, strong) NSMutableArray *videoData;

@property (nonatomic, assign) VoiceChangeType changeType;
@property (nonatomic, strong) RecordingViewCtrl *recordingVC;

@property (nonatomic, strong) InteligenceCell *inteligenceCell;

@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) NSMutableArray *arrDeparts;

@property (nonatomic, strong) NSString *departStr;


@property (nonatomic, assign) NSInteger currentLocation;

@end

@implementation TrendsCreateCircleViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建动态";
    _currentLocation = 0;
    self.model = [[BusinessVisitActivityMo alloc] init];
    _changeType = VoiceDefaultType;
    self.rightBtn.hidden = YES;
    [self.model configAttachmentList];
    [self config];
    [self setUI];
    [self getActivityPage];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 0.001;
    } else if (indexPath.row == 1) {
        return 200;
    } else {
        return 100;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *cellId = @"MyCommonCell";
        MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell setLeftText:@"可见范围"];
//        cell.labRight.text = self.departStr.length == 0 ? @"请选择" : self.departStr;
//        cell.labLeft.textColor = COLOR_B1;
//        cell.labRight.textColor = COLOR_B2;
        cell.labRight.text = self.departStr.length == 0 ? @"暂不支持" : self.departStr;
        cell.labLeft.textColor = COLOR_B2;
        cell.labRight.textColor = COLOR_B2;
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *identifier = @"InteligenceCell";
        InteligenceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[InteligenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.recordView.contentView.placeholder = @"请输入动态内容";
        [cell.recordView.toolBar updateTitles:@[@"客户", @"同事", @"图片", @"视频"] imgNormal:@[@"client_trends", @"@", @"picture", @"video"] imgSelect:@[@"", @"", @"", @""]];
        cell.recordView.contentView.textView.delegate = self;
        cell.inteligenceCellDelegate = self;
        [cell loadData:self.model];
        cell.cellIndexPath = indexPath;
        return cell;
    } else {
        static NSString *cellId = @"MyButtonCell";
        MyButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.cellDelegate = self;
        }
        [cell.btnSave setTitle:@"提交" forState:UIControlStateNormal];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        [Utils showHUDWithStatus:nil];
//        [[JYUserApi sharedInstance] getDepartmentSuccess:^(id responseObject) {
//            [Utils dismissHUD];
//            self.arrData = [GroupMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:nil];
//            GroupMo *groupAll = [[GroupMo alloc] init];
//            groupAll.id = -1;
//            groupAll.name = @"全公司";
//            [self.arrData insertObject:groupAll atIndex:0];
//            [_selectShowArr removeAllObjects];
//            _selectShowArr = nil;
//            for (GroupMo *tmpMo in self.arrData) {
//                ListSelectMo *mo = [[ListSelectMo alloc] init];
//                mo.moId = [NSString stringWithFormat:@"%ld", (long)tmpMo.id];
//                mo.moText = tmpMo.name;
//                mo.moKey = [NSString stringWithFormat:@"%ld", (long)tmpMo.id];
//                [self.selectShowArr addObject:mo];
//            }
//            [self pushToSelectVC:indexPath];
//        } failure:^(NSError *error) {
//            [Utils dismissHUD];
//            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
//        }];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.inteligenceCell resetNormalState];
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = self.selectShowArr;
    vc.title = @"请选择部门";
    vc.byText = YES;
    NSMutableArray *arrValue = [NSMutableArray new];
    // 多选
    vc.isMultiple = YES;
    for (GroupMo *tmpMo in self.arrDeparts) {
        [arrValue addObject:[NSString stringWithFormat:@"%ld", (long)tmpMo.id]];
    }
    if (arrValue.count > 0) vc.defaultValues = [[NSMutableArray alloc] initWithArray:arrValue copyItems:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
//    CommonRowMo *rowMo = self.arrData[indexPath.row];
//    DicMo *dicMo = [self.selectArr objectAtIndex:index];
//    rowMo.singleValue = dicMo;
//    rowMo.strValue = selectMo.moText;
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

// 多选方法，会覆盖单选方法
- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndexPaths:(NSArray *)selectIndexPaths indexPath:(NSIndexPath *)indexPath {
    self.departStr = @"";
    [self.arrDeparts removeAllObjects];
    // 包含所有
    if ([selectIndexPaths containsObject:[NSIndexPath indexPathForRow:0 inSection:0]]) {
        [self.arrDeparts addObject:[self.arrData firstObject]];
        self.departStr = @"全公司";
    } else {
        for (int i = 0; i < selectIndexPaths.count; i++) {
            NSIndexPath *tmpIndexPath = selectIndexPaths[i];
            GroupMo *tmpMo = [self.arrData objectAtIndex:tmpIndexPath.row];
            [self.arrDeparts addObject:tmpMo];
            self.departStr = [self.departStr stringByAppendingString:STRING(tmpMo.name)];
            if (i < selectIndexPaths.count - 1) {
                self.departStr = [self.departStr stringByAppendingString:@","];
            }
        }
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - MyButtonCellDelegate

- (void)cell:(MyButtonCell *)cell btnClick:(UIButton *)sender {
    [self clickRightButton:self.rightBtn];
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
//        [Utils showToastMessage:@"该功能将于春节后上线"];
//        return;
        _currentLocation = self.inteligenceCell.recordView.contentView.textView.text.length;
        if (self.inteligenceCell.recordView.contentView.textView.isFirstResponder) {
            _currentLocation = self.inteligenceCell.recordView.contentView.textView.selectedRange.location + self.inteligenceCell.recordView.contentView.textView.selectedRange.length;
        }
        MemberSelectViewCtrl *vc = [[MemberSelectViewCtrl alloc] init];
        vc.needRules = YES;
        vc.isWangli = YES;
        vc.VcDelegate = self;
        vc.indexPath = indexPath;
        BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
        [[Utils topViewController] presentViewController:navi animated:YES completion:^{
        }];
    } else if (barIndex == 1) {
        _currentLocation = self.inteligenceCell.recordView.contentView.textView.text.length;
        if (self.inteligenceCell.recordView.contentView.textView.isFirstResponder) {
            _currentLocation = self.inteligenceCell.recordView.contentView.textView.selectedRange.location + self.inteligenceCell.recordView.contentView.textView.selectedRange.length;
        }
        JYUserMoSelectViewCtrl *vc = [[JYUserMoSelectViewCtrl alloc] init];
        vc.VcDelegate = self;
        vc.isMultiple = NO;
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
//        [Utils showToastMessage:@"该功能将于春节后上线"];
//        return;
//        if (self.voiceData.count >= 9) {
//            [Utils showToastMessage:@"最多录制9条语音"];
//            return;
//        }
//        // 弹出选择框
//        __weak typeof(self) weakself = self;
//        VoiceSelectView *selectView = [[VoiceSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) changeType:_changeType itemClick:^(VoiceChangeType type) {
//            weakself.changeType = type;
//            // 录音页面
//            [weakself addVoice];
//        } cancelClick:^(VoiceSelectView * _Nonnull obj) {
//            obj = nil;
//        }];
//        [selectView showView];
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

-  (void)addVideo {
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

#pragma mark - MemberSelectViewCtrlDelegate

- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    [self.model.memberMos addObject:model];
    [self.inteligenceCell.recordView.contentView.textView.internalTextView unmarkText];
    UITextView *textView = self.inteligenceCell.recordView.contentView.textView.internalTextView;
    NSString *insertString = [NSString stringWithFormat:kATMemberFormat,model.abbreviation];
    NSMutableString *string = [NSMutableString stringWithString:textView.text];
    [string insertString:insertString atIndex:_currentLocation];
    self.inteligenceCell.recordView.contentView.textView.internalTextView.text = string;
    [self.inteligenceCell.recordView.contentView.textView becomeFirstResponder];
    textView.selectedRange = NSMakeRange(_currentLocation + insertString.length, 0);
    [self growingTextViewDidChange:self.inteligenceCell.recordView.contentView.textView];
}

- (void)memberSelectViewCtrlDismiss:(MemberSelectViewCtrl *)memberSelectViewCtrl {
    memberSelectViewCtrl = nil;
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
        NSArray *matches = [self findAllAt:@""];
        
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
        
        // 判断删除的是一个$中间的字符就整体删除
        NSArray *memberMatches = [self findAllMember:@""];
        
        BOOL inMember = NO;
//        NSInteger index = range.location;
        for (NSTextCheckingResult *match in memberMatches)
        {
            NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
            if (NSLocationInRange(range.location, newRange))
            {
                inMember = YES;
                index = match.range.location;
                [string replaceCharactersInRange:match.range withString:@""];
                break;
            }
        }
        
        if (inMember)
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
    } else if ([text isEqualToString:@"$"]) {
        _currentLocation = self.inteligenceCell.recordView.contentView.textView.text.length;
        if (self.inteligenceCell.recordView.contentView.textView.isFirstResponder) {
            _currentLocation = self.inteligenceCell.recordView.contentView.textView.selectedRange.location + self.inteligenceCell.recordView.contentView.textView.selectedRange.length;
        }
        MemberSelectViewCtrl *vc = [[MemberSelectViewCtrl alloc] init];
        vc.needRules = YES;
        vc.isWangli = YES;
        vc.VcDelegate = self;
        BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
        [[Utils topViewController] presentViewController:navi animated:YES completion:^{
        }];
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
        
        NSArray *matches = [self findAllAt:@""];
        
        for (NSTextCheckingResult *match in matches)
        {
            [string addAttribute:NSForegroundColorAttributeName value:COLOR_C1 range:NSMakeRange(match.range.location, match.range.length)];
        }
        
        NSArray *memberMatches = [self findAllMember:@""];
        
        for (NSTextCheckingResult *match in memberMatches)
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
    
    NSArray *matches = [self findAllAt:@""];
    
    for (NSTextCheckingResult *match in matches)
    {
        NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
        if (NSLocationInRange(range.location, newRange))
        {
            growingTextView.internalTextView.selectedRange = NSMakeRange(match.range.location + match.range.length, 0);
            break;
        }
    }
    
    NSArray *memberMatches = [self findAllMember:@""];
    
    for (NSTextCheckingResult *match in memberMatches)
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

- (NSArray<NSTextCheckingResult *> *)findAllAt:(NSString *)string
{
    // 找到文本中所有的@
    string = (string.length == 0 ? self.inteligenceCell.recordView.contentView.textView.text : string);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kATRegular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}

- (NSArray<NSTextCheckingResult *> *)findAllMember:(NSString *)string
{
    // 找到文本中所有的$
    string = (string.length == 0 ? self.inteligenceCell.recordView.contentView.textView.text : string);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kATMemberRegular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    [self.inteligenceCell resetNormalState];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    if (![self dealWithContentParams:param]) return;
    
    [Utils showHUDWithStatus:nil];
    if (self.model.images.count > 0||
        self.model.videos.count > 0) {
        // 上传图片
        [Utils showHUDWithStatus:nil];
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadImages:self.model.images voices:@[] videos:self.model.videos success:^(id responseObject)  {
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

    NSMutableString *contentStr = [[NSMutableString alloc] initWithString: self.inteligenceCell.recordView.contentView.textView.text];
    NSArray *matches = [self findAllAt:contentStr];

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
    
    NSArray *memberMatches = [self findAllMember:contentStr];
    
    for (int i = 0; i < memberMatches.count; i++) {
        NSTextCheckingResult *match = memberMatches[memberMatches.count-i-1];
        NSString *userName = [contentStr substringWithRange:NSMakeRange(match.range.location+1, match.range.length-2)];
        // 是否存在
        __block BOOL isExit = NO;
        [self.model.memberMos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CustomerMo *mo = (CustomerMo *)obj;
            if ([mo.abbreviation isEqualToString:userName]) {
                [contentStr replaceCharactersInRange:match.range withString:[NSString stringWithFormat:@"$=%ld=%@$", (long)mo.id, mo.abbreviation]];
                isExit = YES;
                *stop = YES;
            }
        }];
        
        if (!isExit) {
            [Utils showToastMessage:@"部分客户不存在，需要剔除"];
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
    
    [param setObject:STRING(contentStr) forKey:@"content"];
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
    
//    BOOL isAll = NO;
//    if (((GroupMo *)self.arrDeparts.firstObject).id == -1) isAll = YES;
//    if (!isAll) {
//        NSMutableArray *departmentSet = [NSMutableArray new];
//        for (GroupMo *tmpMo in self.arrDeparts) {
//            [departmentSet addObject:@{@"id":@(tmpMo.id)}];
//        }
//        if (departmentSet.count > 0) [param setObject:departmentSet forKey:@"departmentSet"];
//    }
    [[JYUserApi sharedInstance] createWorkingCircleParam:param isAll:YES success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"创建成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_B0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)voiceData {
    if (!_voiceData) _voiceData = [NSMutableArray new];
    return _voiceData;
}

- (NSMutableArray *)imageData {
    if (!_imageData) _imageData = [NSMutableArray new];
    return _imageData;
}

- (NSMutableArray *)videoData {
    if (!_videoData) _videoData = [NSMutableArray new];
    return _videoData;
}

- (NSMutableArray *)arrData {
    if (!_arrData) _arrData = [NSMutableArray new];
    return _arrData;
}

- (NSMutableArray *)arrDeparts {
    if (!_arrDeparts) _arrDeparts = [NSMutableArray new];
    return _arrDeparts;
}

- (NSMutableArray *)selectShowArr {
    if (!_selectShowArr) _selectShowArr = [NSMutableArray new];
    return _selectShowArr;
}

- (InteligenceCell *)inteligenceCell {
    if (!_inteligenceCell) _inteligenceCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    return _inteligenceCell;
}


@end
