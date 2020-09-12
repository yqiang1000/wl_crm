
//
//  UpdateIntelligenceViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/1/17.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "UpdateIntelligenceViewCtrl.h"
#import "MyCommonCell.h"
#import "UIButton+ShortCut.h"
#import "SubInteligenceCell.h"
#import "BusinessInteligenceMo.h"
#import "MemberSelectViewCtrl.h"
#import "ListSelectViewCtrl.h"
#import "PhotoPickerManager.h"
#import "CommonRowMo.h"
#import "JYUserMoSelectViewCtrl.h"
#import "VoiceSelectView.h"
#import "RecordingViewCtrl.h"
#import "YQVideoViewController.h"

@interface UpdateIntelligenceViewCtrl () <UITableViewDelegate, UITableViewDataSource, SubInteligenceCellDelegate, ListSelectViewCtrlDelegate, MemberSelectViewCtrlDelegate, JYUserMoSelectViewCtrlDelegate, HPGrowingTextViewDelegate, RecordingViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSMutableArray *defaultData;
@property (nonatomic, strong) UIButton *btnSelect;
@property (nonatomic, strong) NSIndexPath *editIndexPath;

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, assign) NSInteger currentLocation;

//intelligence_big_category     情报大类
//intelligence_business_type    业务类型
//intelligence_info_type        信息类别
//intelligence_type             情报类型

@property (nonatomic, strong) NSMutableArray *arrBigCategoryMos;
@property (nonatomic, strong) NSMutableArray *arrBusinessTypeMos;
@property (nonatomic, strong) NSMutableArray *arrInfoTypeMos;
@property (nonatomic, strong) NSMutableArray *arrTypesMos;

@property (nonatomic, strong) DicMo *dicMoBig;
@property (nonatomic, strong) DicMo *dicMoBusiness;
@property (nonatomic, strong) CustomerMo *linkMember;

@property (nonatomic, assign) VoiceChangeType changeType;
@property (nonatomic, strong) RecordingViewCtrl *recordingVC;

@end

static NSString *identifier = @"subInteligenceCell";

@implementation UpdateIntelligenceViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    [self setUI];
    _changeType = VoiceDefaultType;
    _currentLocation = 0;
    _editIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    self.rightBtn.hidden = NO;
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.tableView registerClass:[SubInteligenceCell class] forCellReuseIdentifier:identifier];
    [self getDefaultDicData];
}

- (void)config {
    NSError *error = nil;
    BusinessInteligenceMo *mo = [[BusinessInteligenceMo alloc] initWithDictionary:self.itemSet.intelligence error:&error];
    [_defaultData removeAllObjects];
    _defaultData = nil;
    CommonRowMo *rowMo0 = [[CommonRowMo alloc] init];
    rowMo0.rowType = K_INPUT_SELECT;
    rowMo0.dictName = @"intelligence_big_category";
    rowMo0.leftContent = @"情报大类";
    rowMo0.rightContent = @"暂无";
    rowMo0.strValue = mo.bigCategoryValue;
    DicMo *dicBig = [[DicMo alloc] init];
    dicBig.name = @"intelligence_big_category";
    dicBig.key = mo.bigCategoryKey;
    dicBig.value = mo.bigCategoryValue;
    self.dicMoBig = dicBig;
    [self.defaultData addObject:rowMo0];
    
    CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
    rowMo1.rowType = K_INPUT_SELECT;
    rowMo1.dictName = @"intelligence_big_category";
    rowMo1.leftContent = @"关联对象";
    rowMo1.rightContent = @"暂无";
    rowMo1.strValue = mo.member[@"orgName"];
    [self.defaultData addObject:rowMo1];
    
    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    rowMo2.rowType = K_INPUT_SELECT;
    rowMo2.dictName = @"intelligence_business_type";
    rowMo2.leftContent = @"业务类型";
    rowMo2.rightContent = @"暂无";
    rowMo2.strValue = mo.businessTypeValue;
    DicMo *dicBusiness = [[DicMo alloc] init];
    dicBusiness.name = @"intelligence_business_type";
    dicBusiness.key = mo.businessTypeKey;
    dicBusiness.value = mo.businessTypeValue;
    self.dicMoBusiness = dicBusiness;
    [self.defaultData addObject:rowMo2];
    
    if (self.itemSet.intelligenceTypeKey.length > 0) {
        DicMo *typeDic = [[DicMo alloc] init];
        typeDic.key = self.itemSet.intelligenceTypeKey;
        typeDic.value = self.itemSet.intelligenceTypeValue;
        typeDic.desp = self.itemSet.intelligenceTypeDesp;
        self.itemSet.intelligenceType = typeDic;
    }
    
    if (self.itemSet.intelligenceInfoKey.length > 0) {
        DicMo *infoDic = [[DicMo alloc] init];
        infoDic.key = self.itemSet.intelligenceInfoKey;
        infoDic.value = self.itemSet.intelligenceInfoValue;
        self.itemSet.intelligenceInfo = infoDic;
    }
    
    self.arrData = [[NSMutableArray alloc] initWithObjects:self.itemSet, nil];
    [self.tableView reloadData];
}

- (void)getDefaultDicData {
    [[JYUserApi sharedInstance] getConfigDicByName:@"intelligence_big_category" success:^(id responseObject) {
        self.arrBigCategoryMos = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
    } failure:^(NSError *error) {
    }];
    
    [[JYUserApi sharedInstance] getConfigDicByName:@"intelligence_business_type" success:^(id responseObject) {
        self.arrBusinessTypeMos = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
    } failure:^(NSError *error) {
    }];
    
    [[JYUserApi sharedInstance] getConfigDicByName:@"intelligence_info_type" success:^(id responseObject) {
        self.arrInfoTypeMos = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
    } failure:^(NSError *error) {
    }];
    
    [[JYUserApi sharedInstance] getConfigDicByName:@"intelligence_type" success:^(id responseObject) {
        self.arrTypesMos = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
    } failure:^(NSError *error) {
    }];
    
    [[JYUserApi sharedInstance] getIntelligenceItemDetailId:self.itemSet.id param:nil success:^(id responseObject) {
        NSError *error = nil;
        self.itemSet = [[IntelligenceItemSet alloc] initWithDictionary:responseObject error:&error];
        [self.itemSet configAttachmentList];
        [self config];
    } failure:^(NSError *error) {
    }];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.defaultData.count : self.arrData.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return 45.0;
//    } else {
//        BusinessVisitActivityMo *mo = self.arrData[indexPath.row];
//        return mo.height;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 45.0 : 200.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSString *identifier = @"header";
//    if (section == 0) {
        UIView *header = [UIView new];
        header.backgroundColor = COLOR_B0;
        return header;
//    } else {
//        UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
//        if (!header) {
//            header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
//            header.contentView.backgroundColor = COLOR_B0;
//
//            UIButton *btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
//            [btnAdd setTitle:@"+ 新情报" forState:UIControlStateNormal];
//            [btnAdd setTitleColor:COLOR_B4 forState:UIControlStateNormal];
//            [btnAdd setBackgroundColor:COLOR_C1];
//            btnAdd.titleLabel.font = FONT_F13;
//            btnAdd.layer.mask = [Utils drawContentFrame:btnAdd.bounds corners:UIRectCornerAllCorners cornerRadius:5];
//            [header.contentView addSubview:btnAdd];
//
//            [header addSubview:self.btnSelect];
//            // 15 * 16
//            UIButton *btnDelete = [[UIButton alloc] init];
//            [btnDelete setImage:[UIImage imageNamed:@"删除(1)"] forState:UIControlStateNormal];
//            [btnDelete setTitleColor:COLOR_B1 forState:UIControlStateNormal];
//            [header.contentView addSubview:btnDelete];
//
//            UIView *lineView = [Utils getLineView];
//            [header.contentView addSubview:lineView];
//
//            [btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(header.contentView);
//                make.left.equalTo(header.contentView).offset(15);
//                make.height.equalTo(@25.0);
//                make.width.equalTo(@60.0);
//            }];
//
//            [btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(header.contentView);
//                make.right.equalTo(header.contentView).offset(-15);
//                make.height.width.equalTo(@23.0);
//            }];
//
//            [self.btnSelect mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(header.contentView);
//                make.right.equalTo(btnDelete.mas_left).offset(-15);
//                make.height.equalTo(@23.0);
//                //                make.width.equalTo(@50.0);
//            }];
//
//            [btnAdd addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
//            [btnDelete addTarget:self action:@selector(btnDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
//            [self.btnSelect addTarget:self action:@selector(btnSelectAllClick:) forControlEvents:UIControlEventTouchUpInside];
//        }
//        return header;
//    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *identifier1 = @"commcell";
        MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        CommonRowMo *rowMo = self.defaultData[indexPath.row];
        [cell setLeftText:rowMo.leftContent];
        ShowTextMo *showTextMo = [Utils showTextRightStr:rowMo.rightContent valueStr:rowMo.strValue];
        cell.labRight.textColor = COLOR_B2;
        cell.labRight.text = showTextMo.text;
        cell.labLeft.textColor = COLOR_B1;
        return cell;
    }
    else {
        SubInteligenceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[SubInteligenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.subInteligenceCellDelegate = self;
        IntelligenceItemSet *model = self.arrData[indexPath.row];
        [cell loadData:model];
        if (indexPath.row == self.editIndexPath.row && indexPath.section == self.editIndexPath.section) {
            cell.recordView.contentView.textView.delegate = self;
        }
        [cell hidenBtnSelect:YES];
        cell.cellIndexPath = indexPath;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self growingTextViewDidChange:cell.recordView.contentView.textView];
        });
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return;
//    [self currentCellReset];
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            [Utils showHUDWithStatus:nil];
//            [[JYUserApi sharedInstance] getConfigDicByName:@"intelligence_big_category" success:^(id responseObject) {
//                [Utils dismissHUD];
//                [_selectArr removeAllObjects];
//                _selectArr = nil;
//                [_selectShowArr removeAllObjects];
//                _selectShowArr = nil;
//                self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
//                for (int i = 0; i < self.selectArr.count; i++) {
//                    DicMo *tmpDic = self.selectArr[i];
//                    if ([tmpDic.key isEqualToString:@"all"]) {
//                        [_selectArr removeObject:tmpDic];
//                        break;
//                    }
//                }
//                for (DicMo *tmpDic in self.selectArr) {
//                    ListSelectMo *mo = [[ListSelectMo alloc] init];
//                    mo.moId = tmpDic.id;
//                    mo.moText = tmpDic.value;
//                    mo.moKey = tmpDic.key;
//                    [self.selectShowArr addObject:mo];
//                }
//                [self pushToSelectVC:indexPath];
//            } failure:^(NSError *error) {
//                [Utils dismissHUD];
//            }];
//        }
//        else if (indexPath.row == 2 && self.dicMoBig) {
//            // 字典项选择
//            [[JYUserApi sharedInstance] getDicListByName:@"intelligence_business_type" remark:self.dicMoBig.key param:nil success:^(id responseObject) {
//                [Utils dismissHUD];
//                [_selectArr removeAllObjects];
//                _selectArr = nil;
//                [_selectShowArr removeAllObjects];
//                _selectShowArr = nil;
//                self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
//                for (int i = 0; i < self.selectArr.count; i++) {
//                    DicMo *tmpDic = self.selectArr[i];
//                    if ([tmpDic.key isEqualToString:@"all"]) {
//                        [_selectArr removeObject:tmpDic];
//                        break;
//                    }
//                }
//                for (DicMo *tmpDic in self.selectArr) {
//                    ListSelectMo *mo = [[ListSelectMo alloc] init];
//                    mo.moId = tmpDic.id;
//                    mo.moText = tmpDic.value;
//                    mo.moKey = tmpDic.key;
//                    [self.selectShowArr addObject:mo];
//                }
//                [self pushToSelectVC:indexPath];
//            } failure:^(NSError *error) {
//                [Utils dismissHUD];
//            }];
//        }
//        else if (indexPath.row == 1) {
//            MemberSelectViewCtrl *vc = [[MemberSelectViewCtrl alloc] init];
//            vc.needRules = NO;
//            vc.VcDelegate = self;
//            vc.defaultId = self.linkMember.id;
//            vc.indexPath = indexPath;
//            BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
//            [[Utils topViewController] presentViewController:navi animated:YES completion:^{
//            }];
//        }
//    }
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = self.selectShowArr;
    vc.title = indexPath.row == 0 ? @"情报大类" : @"业务类型";
    vc.byText = YES;
    if (indexPath.row == 0) {
        if (self.dicMoBig) vc.defaultValues = [[NSMutableArray alloc] initWithArray:@[self.dicMoBig.key] copyItems:YES];
    } else {
        if (self.dicMoBusiness) vc.defaultValues = [[NSMutableArray alloc] initWithArray:@[self.dicMoBusiness.key] copyItems:YES];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self currentCellReset];
    }
}

#pragma mark - SubInteligenceCellDelegate

- (void)subInteligenceCell:(SubInteligenceCell *)subInteligenceCell didSelectToolBarIndex:(NSInteger)barIndex indexPath:(NSIndexPath *)indexPath {
    
    IntelligenceItemSet *itemSet = self.arrData[indexPath.row];
    if (barIndex != 0) [self currentCellReset];
    
    if (barIndex == 0) {
//        [Utils showToastMessage:@"该功能将于春节后上线"];
//        return;
        _currentLocation = subInteligenceCell.recordView.contentView.textView.text.length;
        if (subInteligenceCell.recordView.contentView.textView.isFirstResponder) {
            _currentLocation = subInteligenceCell.recordView.contentView.textView.selectedRange.location + subInteligenceCell.recordView.contentView.textView.selectedRange.length;
        }
        JYUserMoSelectViewCtrl *vc = [[JYUserMoSelectViewCtrl alloc] init];
        vc.VcDelegate = self;
        vc.isMultiple = NO;
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    } else if (barIndex == 1) {
//        [Utils showToastMessage:@"该功能将于春节后上线"];
//        return;
        if (itemSet.voices.count >= 9) {
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
        if (itemSet.images.count >= 9) {
            [Utils showToastMessage:@"最多添加9张图片"];
            return;
        }
        [self addPicture:itemSet];
    } else if (barIndex == 3) {
//        [Utils showToastMessage:@"该功能正在开发..."];
//        return;
        if (itemSet.videos.count >= 3) {
            [Utils showToastMessage:@"最多录制3条短视频"];
            return;
        }
        [self addVideo];
    }
}

-(void)subInteligenceCellFrameChanged:(SubInteligenceCell *)subInteligenceCell indexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadData];
    CGFloat height = CGRectGetHeight(subInteligenceCell.frame);
    // 如果单元格超出屏幕宽度，则置低，其他情况滚动到中间
    if (height-(SCREEN_HEIGHT-Height_NavBar-45) > 0) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    } else {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    NSLog(@"情报-----回掉刷新单元格%@", indexPath);
}

- (void)subInteligenceCellBeginEdit:(SubInteligenceCell *)subInteligenceCell indexPath:(NSIndexPath *)indexPath {
    SubInteligenceCell *cell = (SubInteligenceCell *)[self.tableView cellForRowAtIndexPath:self.editIndexPath];
    if (cell != subInteligenceCell) {
        [cell resetNormalState];
    }
    self.editIndexPath = indexPath;
}

- (void)subInteligenceCell:(SubInteligenceCell *)subInteligenceCell didSelectVoiceCell:(JYVoiceMo *)voiceMo index:(NSInteger)index indexPath:(NSIndexPath *)indexPath {
    [self currentCellReset];
    self.editIndexPath = indexPath;
    if (_recordingVC) {
        _recordingVC.delegate = self;
        _recordingVC = nil;
    }
    _recordingVC = [[RecordingViewCtrl alloc] init];
    _recordingVC.delegate = self;
    _recordingVC.voiceMo = [self currentCell].model.voices[index];
    [self.view addSubview:_recordingVC.view];
    [_recordingVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

- (void)subInteligenceCell:(SubInteligenceCell *)subInteligenceCell didSelectImageCell:(JYVoiceMo *)voiceMo index:(NSInteger)index indexPath:(NSIndexPath *)indexPath {
    
}

- (void)subInteligenceCell:(SubInteligenceCell *)subInteligenceCell didSelectVideoCell:(JYVoiceMo *)voiceMo index:(NSInteger)index indexPath:(NSIndexPath *)indexPath {
    
}

- (NSMutableArray *)subInteligenceCellArrBigCategoryMos:(SubInteligenceCell *)subInteligenceCell {
    return [self filterArrMos:self.arrInfoTypeMos remark:self.dicMoBusiness.key];
}

- (NSMutableArray *)subInteligenceCellArrIntelligenceMos:(SubInteligenceCell *)subInteligenceCell bigMoKey:(nonnull NSString *)bigMoKey {
    return [self filterArrMos:self.arrTypesMos remark:bigMoKey];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    if (indexPath.row == 0) {
        self.dicMoBig = self.selectArr[index];
        [self.defaultData replaceObjectAtIndex:0 withObject:@{@"key":@"情报大类",
                                                              @"value":STRING(self.dicMoBig.value)}];
        [self.defaultData replaceObjectAtIndex:2 withObject:@{@"key":@"业务类型",
                                                              @"value":@"请选择"}];
        self.dicMoBusiness = nil;
    } else if (indexPath.row == 2) {
        self.dicMoBusiness = self.selectArr[index];
        [self.defaultData replaceObjectAtIndex:2 withObject:@{@"key":@"业务类型",
                                                              @"value":STRING(self.dicMoBusiness.value)}];
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

// 多选方法，会覆盖单选方法
- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndexPaths:(NSArray *)selectIndexPaths indexPath:(NSIndexPath *)indexPath {
    //    NSString *valueStr = @"";
    //    NSMutableArray *multipleValue = [NSMutableArray new];
    //    for (int i = 0; i < selectIndexPaths.count; i++) {
    //        NSIndexPath *tmpIndexPath = selectIndexPaths[i];
    //        ListSelectMo *tmpMo = [self.selectShowArr objectAtIndex:tmpIndexPath.row];
    //        [multipleValue addObject:self.selectArr[tmpIndexPath.row]];
    //        valueStr = [valueStr stringByAppendingString:STRING(tmpMo.moText)];
    //        if (i < selectIndexPaths.count - 1) {
    //            valueStr = [valueStr stringByAppendingString:@","];
    //        }
    //    }
    //    CommonRowMo *rowMo = self.arrData[indexPath.row];
    //    rowMo.mutipleValue = multipleValue;
    //    rowMo.strValue = valueStr;
    //    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - MemberSelectViewCtrlDelegate

- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        self.linkMember = model;
        [self.defaultData replaceObjectAtIndex:1 withObject:@{@"key":@"关联对象",
                                                              @"value":STRING(self.linkMember.orgName)}];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)memberSelectViewCtrlDismiss:(MemberSelectViewCtrl *)memberSelectViewCtrl {
    memberSelectViewCtrl = nil;
}

#pragma mark - 添加图片

- (void)addPicture:(IntelligenceItemSet *)itemSet {
    [[PhotoPickerManager shared] showActionSheetInView:[Utils topViewController].view fromController:[Utils topViewController] maxCount:9-itemSet.images.count completion:^(NSArray *photos) {
        for (int i = 0; i < photos.count; i++) {
            [itemSet.images addObject:photos[i]];
        }
        [self.tableView reloadData];
    } cancelBlock:^{
    }];
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

#pragma mark - 添加视频

- (void)addVideo {
    YQVideoViewController *vc = [[YQVideoViewController alloc] init];
    __weak typeof(self)weakself = self;
    vc.takeBlock = ^(id  _Nonnull item) {
        if ([item isKindOfClass:[UIImage class]]) {
            if ([weakself currentCell].model.images.count >= 9) {
                [Utils showToastMessage:@"最多添加9张图片"];
            } else {
                [[weakself currentCell].model.images addObject:item];
            }
        } else if ([item isKindOfClass:[NSURL class]]) {
            QiniuFileMo *qiniuMo = [[QiniuFileMo alloc] init];
            qiniuMo.fileType = @"mp4";
            qiniuMo.url = ((NSURL *)item).absoluteString;
            [[weakself currentCell].model.videos addObject:qiniuMo];
        }
        [weakself.tableView reloadData];
    };
    [[Utils topViewController].navigationController presentViewController:vc animated:YES completion:nil];
}

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
    
    IntelligenceItemSet *item = [self currentCell].model;
    if (item) [item.voices addObject:voiceMo];
    //    [self.model.voices addObject:voiceMo];
    [self.tableView reloadData];
}

- (void)recordingViewCtrlwDismiss:(RecordingViewCtrl *)recordingViewCtrl {
    [_recordingVC.view removeFromSuperview];
    _recordingVC.delegate = nil;
    _recordingVC = nil;
}

#pragma mark - JYUserMoSelectViewCtrlDelegate

- (void)jyUserMoSelectViewCtrl:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(JYUserMo *)selectMo {
    
    [[self currentCell].recordView.contentView.textView.internalTextView unmarkText];
    [[self currentCell].model.userMos addObject:selectMo];
    
    UITextView *textView = [self currentCell].recordView.contentView.textView.internalTextView;
    NSString *insertString = [NSString stringWithFormat:kATFormat,selectMo.name];
    NSMutableString *string = [NSMutableString stringWithString:textView.text];
    [string insertString:insertString atIndex:_currentLocation];
    [self currentCell].recordView.contentView.textView.internalTextView.text = string;
    [[self currentCell].recordView.contentView.textView becomeFirstResponder];
    textView.selectedRange = NSMakeRange(_currentLocation + insertString.length, 0);
    [self growingTextViewDidChange:[self currentCell].recordView.contentView.textView];
}

- (void)jyUserMoSelectViewCtrlDismiss:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl {
    jyUserMoSelectViewCtrl = nil;
}

#pragma mark - HPGrowingTextViewDelegate

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [[self currentCell].recordView.contentView.textView resignFirstResponder];
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
        _currentLocation = [self currentCell].recordView.contentView.textView.text.length;
        if ([self currentCell].recordView.contentView.textView.isFirstResponder) {
            _currentLocation = [self currentCell].recordView.contentView.textView.selectedRange.location + [self currentCell].recordView.contentView.textView.selectedRange.length;
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
        UITextView *textView = [self currentCell].recordView.contentView.textView.internalTextView;
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

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView {
    
    SubInteligenceCell *cell = (SubInteligenceCell *)growingTextView.superview.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath != self.editIndexPath) {
        [cell resetNormalState];
    }
    self.editIndexPath = indexPath;
}

#pragma mark - Private

- (NSArray<NSTextCheckingResult *> *)findAllAt
{
    // 找到文本中所有的@
    NSString *string = [self currentCell].recordView.contentView.textView.text;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kATRegular options:NSRegularExpressionCaseInsensitive error:nil];
    if (string.length == 0) {
        return nil;
    }
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}


#pragma mark - event

- (void)btnAddClick:(UIButton *)sender {
    [self currentCellReset];
    for (IntelligenceItemSet *tmpMo in self.arrData) {
        tmpMo.isSelected = NO;
    }
    IntelligenceItemSet *recordMo = [[IntelligenceItemSet alloc] init];
    [self.arrData insertObject:recordMo atIndex:0];
    [self.tableView reloadData];
    [self.tableView scrollsToTop];
}

- (void)btnDeleteClick:(UIButton *)sender {
    BOOL canDelete = NO;
    NSMutableArray *deleteArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.arrData.count; i++) {
        IntelligenceItemSet *mo = self.arrData[i];
        if (mo.isSelected) {
            [deleteArr addObject:mo];
            canDelete = YES;
        }
    }
    if (!canDelete) {
        [Utils showToastMessage:@"至少选择一个"];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该情报？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (IntelligenceItemSet *tmpMo in deleteArr) {
            if (tmpMo.isSelected) {
                [self.arrData removeObject:tmpMo];
            }
        }
        self.btnSelect.selected = NO;
        [self.tableView reloadData];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)btnSelectAllClick:(UIButton *)sender {
    [self currentCellReset];
    sender.selected = !sender.selected;
    BOOL selectAll = sender.selected;
    for (IntelligenceItemSet *tmpMo in self.arrData) {
        tmpMo.isSelected = selectAll;
    }
    [self.tableView reloadData];
}

- (void)clickRightButton:(UIButton *)sender {
    [self currentCellReset];
    
    if ([self.dicMoBig.key isEqualToString:@"customer"]||
        [self.dicMoBig.key isEqualToString:@"supplier"]||
        [self.dicMoBig.key isEqualToString:@"competitor"]||
        [self.dicMoBig.key isEqualToString:@"terminal"]) {
        
        for (int i = 0; i < self.arrData.count; i++) {
            IntelligenceItemSet *itemSet = self.arrData[i];
            if (!itemSet.intelligenceInfo) {
                [Utils showToastMessage:@"请选择信息类别"];
                return;
            }
            if (!itemSet.intelligenceType) {
                [Utils showToastMessage:@"请选择情报类型"];
                return;
            }
            if (![self dealWithContentParams:itemSet]) {
                [Utils showToastMessage:@"请填写内容"];
                return;
            }
        }
    } else {
        for (int i = 0; i < self.arrData.count; i++) {
            IntelligenceItemSet *itemSet = self.arrData[i];
            if (![self dealWithContentParams:itemSet]) {
                [Utils showToastMessage:@"请填写内容"];
                return;
            }
        }
    }
    
    IntelligenceItemSet *itemSet = [self.arrData firstObject];
    __weak typeof(self) weakself = self;
    
    if (itemSet.images.count > 0||
        itemSet.voices.count > 0||
        itemSet.videos.count > 0) {
        
        [itemSet uploadAttementCompleted:^(NSMutableArray *arr) {
            __strong typeof(self) strongself = weakself;
            NSMutableDictionary *itemDic = [NSMutableDictionary new];
            if (itemSet.intelligenceType) {
                [itemDic setObject:STRING(itemSet.intelligenceType.key) forKey:@"intelligenceTypeKey"];
                [itemDic setObject:STRING(itemSet.intelligenceType.value) forKey:@"intelligenceTypeValue"];
            }
            if (itemSet.intelligenceInfo) {
                [itemDic setObject:STRING(itemSet.intelligenceInfo.key) forKey:@"intelligenceInfoKey"];
                [itemDic setObject:STRING(itemSet.intelligenceInfo.value) forKey:@"intelligenceInfoValue"];
            }
            [itemDic setObject:STRING(itemSet.content) forKey:@"content"];
            [itemDic setObject:arr.count>0?arr:@[] forKey:@"attachmentList"];
            [itemDic setObject:@(itemSet.id) forKey:@"id"];
            [strongself update:itemDic];
        }];
    } else {
        NSMutableDictionary *itemDic = [NSMutableDictionary new];
        if (itemSet.intelligenceType) {
            [itemDic setObject:STRING(itemSet.intelligenceType.key) forKey:@"intelligenceTypeKey"];
            [itemDic setObject:STRING(itemSet.intelligenceType.value) forKey:@"intelligenceTypeValue"];
        }
        if (itemSet.intelligenceInfo) {
            [itemDic setObject:STRING(itemSet.intelligenceInfo.key) forKey:@"intelligenceInfoKey"];
            [itemDic setObject:STRING(itemSet.intelligenceInfo.value) forKey:@"intelligenceInfoValue"];
        }
        [itemDic setObject:STRING(itemSet.content) forKey:@"content"];
        [itemDic setObject:@[] forKey:@"attachmentList"];
        [itemDic setObject:@(itemSet.id) forKey:@"id"];
        [self update:itemDic];
    }
}

- (BOOL)dealWithContentParams:(IntelligenceItemSet *)itemSet  {
    NSArray *matches = [self findAllAt];
    
    NSMutableString *contentStr = [[NSMutableString alloc] initWithString:itemSet.showText];
    
    for (int i = 0; i < matches.count; i++) {
        NSTextCheckingResult *match = matches[matches.count-i-1];
        NSString *userName = [contentStr substringWithRange:NSMakeRange(match.range.location+1, match.range.length-2)];
        // 是否存在
        __block BOOL isExit = NO;
        [itemSet.userMos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
            NSMutableString *orgStr = [[NSMutableString alloc] initWithString:itemSet.showText];
            [orgStr replaceCharactersInRange:match.range withString:@""];
            [self currentCell].recordView.contentView.textView.text = orgStr;
        }
    }
    if (contentStr.length == 0) {
        //        [Utils showToastMessage:@"内容不能为空"];
        return NO;
    }
    itemSet.content = contentStr;
    return YES;
}

- (void)update:(NSMutableDictionary *)param {
    [[JYUserApi sharedInstance] updateIntelligenceItemDetailParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"修改成功"];
        if (self.updateSuccess) {
            self.updateSuccess(nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)currentCellReset {
    SubInteligenceCell *cell = (SubInteligenceCell *)[self.tableView cellForRowAtIndexPath:self.editIndexPath];
    [cell resetNormalState];
}

- (SubInteligenceCell *)currentCell {
    SubInteligenceCell *cell =  (SubInteligenceCell *)[self.tableView cellForRowAtIndexPath:self.editIndexPath];
    cell.recordView.contentView.textView.delegate = self;
    return cell;
}

- (NSMutableArray *)filterArrMos:(NSMutableArray *)arrMos remark:(NSString *)remark {
    NSMutableArray *arrResult = [NSMutableArray new];
    for (DicMo *tmpDic in arrMos) {
        if ([tmpDic.remark containsString:remark]) {
            [arrResult addObject:tmpDic];
        }
    }
    return arrResult;
}

// 重置所有
- (void)resetAllSubMos {
    for (IntelligenceItemSet *tmpMo in self.arrData) {
        tmpMo.intelligenceType = nil;
        tmpMo.intelligenceTypeKey = @"";
        tmpMo.intelligenceTypeValue = @"";
        tmpMo.intelligenceInfo = nil;
        tmpMo.intelligenceInfoKey = @"";
        tmpMo.intelligenceInfoValue = @"";
        tmpMo.intelligenceTypeDesp = @"";
    }
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

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (NSMutableArray *)defaultData {
    if (!_defaultData) {
        _defaultData = [[NSMutableArray alloc] init];
//        [_defaultData addObject:@{@"key":@"情报大类",
//                                  @"value":@"请选择"}];
//        [_defaultData addObject:@{@"key":@"关联对象",
//                                  @"value":@"请选择"}];
//        [_defaultData addObject:@{@"key":@"业务类型",
//                                  @"value":@"请选择"}];
    }
    return _defaultData;
}

- (UIButton *)btnSelect {
    if (!_btnSelect) {
        // 23 * 23
        _btnSelect = [[UIButton alloc] init];
        [_btnSelect setTitle:@"全选" forState:UIControlStateNormal];
        [_btnSelect setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [_btnSelect setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        [_btnSelect setTitleColor:COLOR_B1 forState:UIControlStateNormal];
        _btnSelect.titleLabel.font = FONT_F13;
        [_btnSelect imageLeftWithTitleFix:8];
    }
    return _btnSelect;
}

- (NSMutableArray *)selectArr {
    if (!_selectArr) _selectArr = [NSMutableArray new];
    return _selectArr;
}

- (NSMutableArray *)selectShowArr {
    if (!_selectShowArr) _selectShowArr = [NSMutableArray new];
    return _selectShowArr;
}

- (NSMutableArray *)arrBigCategoryMos {
    if (!_arrBigCategoryMos) _arrBigCategoryMos = [NSMutableArray new];
    return _arrBigCategoryMos;
}

- (NSMutableArray *)arrBusinessTypeMos {
    if (!_arrBusinessTypeMos) _arrBusinessTypeMos = [NSMutableArray new];
    return _arrBusinessTypeMos;
}

- (NSMutableArray *)arrInfoTypeMos {
    if (!_arrInfoTypeMos) _arrInfoTypeMos = [NSMutableArray new];
    return _arrInfoTypeMos;
}

- (NSMutableArray *)arrTypesMos {
    if (!_arrTypesMos) _arrTypesMos = [NSMutableArray new];
    return _arrTypesMos;
}

@end
