//
//  CreateIntelligenceViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/18.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateIntelligenceViewCtrl.h"
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
#import "BottomView.h"
#import "PermissionSelectViewCtrl.h"

@interface CreateIntelligenceViewCtrl () <UITableViewDelegate, UITableViewDataSource, SubInteligenceCellDelegate, ListSelectViewCtrlDelegate, MemberSelectViewCtrlDelegate, JYUserMoSelectViewCtrlDelegate, HPGrowingTextViewDelegate, RecordingViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) UIButton *btnSelect;
@property (nonatomic, strong) NSIndexPath *editIndexPath;

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;

@property (nonatomic, strong) DicMo *dicMoBig;
@property (nonatomic, strong) DicMo *dicMoBusiness;
@property (nonatomic, strong) CustomerMo *linkMember;

@property (nonatomic, assign) NSInteger uploadCount;
@property (nonatomic, assign) NSInteger currentLocation;

//intelligence_big_category     情报大类
//intelligence_business_type    业务类型
//intelligence_info_type        信息类别
//intelligence_type             情报类型

@property (nonatomic, strong) NSMutableArray *arrBigCategoryMos;
@property (nonatomic, strong) NSMutableArray *arrBusinessTypeMos;
@property (nonatomic, strong) NSMutableArray *arrInfoTypeMos;
@property (nonatomic, strong) NSMutableArray *arrTypesMos;

@property (nonatomic, strong) NSMutableArray *uploadArr;
@property (nonatomic, strong) NSMutableDictionary *uploadParam;

@property (nonatomic, strong) NSMutableArray *section0;
@property (nonatomic, strong) CommonRowMo *memberRow;

@property (nonatomic, assign) VoiceChangeType changeType;
@property (nonatomic, strong) RecordingViewCtrl *recordingVC;
@property (nonatomic, strong) NSMutableDictionary *dicPermission;
@property (nonatomic, copy) NSString *visibleType;

@end

static NSString *identifier = @"subInteligenceCell";

@implementation CreateIntelligenceViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    [self setUI];
    _visibleType = @"";
    _changeType = VoiceDefaultType;
    _currentLocation = 0;
    _editIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    self.rightBtn.hidden = NO;
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.tableView registerClass:[SubInteligenceCell class] forCellReuseIdentifier:identifier];
    [self getDefaultDicData];
    [self btnAddClick:nil];
}

- (void)config {
    if (!self.fromTab) {
        __block NSError *error = nil;
        self.linkMember = [[CustomerMo alloc] initWithDictionary:self.model.member error:&error];
        [[JYUserApi sharedInstance] getMemberCenterByMemberId:[self.model.member[@"id"] integerValue] success:^(id responseObject) {
            self.linkMember = [[CustomerMo alloc] initWithDictionary:responseObject error:&error];
        } failure:^(NSError *error) {
        }];
    }
    
    CommonRowMo *row1 = [[CommonRowMo alloc] init];
    row1.key = @"big";
    row1.leftContent = @"情报大类";
    row1.rightContent = @"请选择";
    row1.editAble = YES;
    row1.nullAble = NO;
    [self.section0 addObject:row1];
    
    [self.section0 addObject:self.memberRow];
    
    CommonRowMo *row3 = [[CommonRowMo alloc] init];
    row3.key = @"business";
    row3.leftContent = @"业务类型";
    row3.rightContent = @"请选择";
    row3.editAble = YES;
    row3.nullAble = NO;
    [self.section0 addObject:row3];
    
    CommonRowMo *row4 = [[CommonRowMo alloc] init];
    row4.key = @"visibleRangeList";
    row4.leftContent = @"可见范围";
    row4.rightContent = @"请选择";
    row4.editAble = YES;
    row4.nullAble = NO;
    
    [self.section0 addObject:row4];
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
    return section == 0 ? self.section0.count : self.arrData.count;
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
    return section == 0 ? 10 : 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *identifier = @"header";
    if (section == 0) {
        UIView *header = [UIView new];
        header.backgroundColor = COLOR_B0;
        return header;
    } else {
        UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        if (!header) {
            header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
            header.contentView.backgroundColor = COLOR_B0;
            
            UIButton *btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
            [btnAdd setTitle:@"+ 新情报" forState:UIControlStateNormal];
            [btnAdd setTitleColor:COLOR_B4 forState:UIControlStateNormal];
            [btnAdd setBackgroundColor:COLOR_C1];
            btnAdd.titleLabel.font = FONT_F13;
            btnAdd.layer.mask = [Utils drawContentFrame:btnAdd.bounds corners:UIRectCornerAllCorners cornerRadius:5];
            [header.contentView addSubview:btnAdd];
            
            [header addSubview:self.btnSelect];
            // 15 * 16
            UIButton *btnDelete = [[UIButton alloc] init];
            [btnDelete setImage:[UIImage imageNamed:@"删除(1)"] forState:UIControlStateNormal];
            [btnDelete setTitleColor:COLOR_B1 forState:UIControlStateNormal];
            [header.contentView addSubview:btnDelete];
            
            UIView *lineView = [Utils getLineView];
            [header.contentView addSubview:lineView];
            
            [btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(header.contentView);
                make.left.equalTo(header.contentView).offset(15);
                make.height.equalTo(@25.0);
                make.width.equalTo(@60.0);
            }];
            
            [btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(header.contentView);
                make.right.equalTo(header.contentView).offset(-15);
                make.height.width.equalTo(@23.0);
            }];
            
            [self.btnSelect mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(header.contentView);
                make.right.equalTo(btnDelete.mas_left).offset(-15);
                make.height.equalTo(@23.0);
//                make.width.equalTo(@50.0);
            }];
            
            [btnAdd addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
            [btnDelete addTarget:self action:@selector(btnDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnSelect addTarget:self action:@selector(btnSelectAllClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        return header;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        CommonRowMo *rowMo = self.section0[indexPath.row];
        NSString *identifier1 = @"commcell";
        MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        [cell setLeftText:rowMo.leftContent];
        ShowTextMo *showTextMo = [Utils showTextRightStr:rowMo.rightContent valueStr:rowMo.strValue];
        cell.labRight.textColor = rowMo.editAble ? showTextMo.color : COLOR_B2;
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
        cell.cellIndexPath = indexPath;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self growingTextViewDidChange:cell.recordView.contentView.textView];
//        });
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self currentCellReset];
    if (indexPath.section == 0) {
        CommonRowMo *rowMo = self.section0[indexPath.row];
        if (!rowMo.editAble) return;
        
        if ([rowMo.key isEqualToString:@"big"]) {
            [_selectShowArr removeAllObjects];
            _selectShowArr = nil;
            self.selectArr = [self.arrBigCategoryMos mutableCopy];
            for (DicMo *tmpDic in self.selectArr) {
                ListSelectMo *mo = [[ListSelectMo alloc] init];
                mo.moId = tmpDic.id;
                mo.moText = tmpDic.value;
                mo.moKey = tmpDic.key;
                [self.selectShowArr addObject:mo];
            }
            [self pushToSelectVC:indexPath];
        } else if ([rowMo.key isEqualToString:@"member"]) {
            if (!self.fromTab) {
                return;
            }
            MemberSelectViewCtrl *vc = [[MemberSelectViewCtrl alloc] init];
            vc.needRules = NO;
            vc.VcDelegate = self;
            vc.defaultId = self.linkMember.id;
            vc.indexPath = indexPath;
            vc.moduleNumber = @"001";
            BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
            [[Utils topViewController] presentViewController:navi animated:YES completion:^{
            }];
        } else if ([rowMo.key isEqualToString:@"business"]) {
            if (!self.dicMoBig) {
                [Utils showToastMessage:@"请先选择情报大类"];
                return;
            }
            // 字典项选择
            self.selectArr = [self filterArrMos:self.arrBusinessTypeMos remark:self.dicMoBig.key];
            [_selectShowArr removeAllObjects];
            _selectShowArr = nil;
            for (DicMo *tmpDic in self.selectArr) {
                ListSelectMo *mo = [[ListSelectMo alloc] init];
                mo.moId = tmpDic.id;
                mo.moText = tmpDic.value;
                mo.moKey = tmpDic.key;
                [self.selectShowArr addObject:mo];
            }
            [self pushToSelectVC:indexPath];
        }  else if ([rowMo.key isEqualToString:@"visibleRangeList"]) {
            __weak typeof(self) weakself = self;
            BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) items:@[@"公开", @"部门", @"客户干系人", @"指定人员"] defaultItem:-1 itemClick:^(NSInteger index) {
                __strong typeof(self) strongself = weakself;
                [strongself permission:index indexPath:indexPath];
            } cancelClick:^(BottomView *obj) {
                if (obj) obj = nil;
            }];
            [bottomView show];
        }
    }
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.section0[indexPath.row];
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = self.selectShowArr;
    vc.title = rowMo.leftContent;
    vc.byText = YES;
    if ([rowMo.key isEqualToString:@"big"]) {
        if (self.dicMoBig) vc.defaultValues = [[NSMutableArray alloc] initWithArray:@[self.dicMoBig.key] copyItems:YES];
    } else if ([rowMo.key isEqualToString:@"business"]) {
        if (self.dicMoBusiness) vc.defaultValues = [[NSMutableArray alloc] initWithArray:@[self.dicMoBusiness.key] copyItems:YES];
    } else if ([rowMo.key isEqualToString:@"visibleRangeList"]) {
        NSArray *arsrfr = [self.dicPermission objectForKey:@"FRSRAR"];
        NSMutableArray *arr = [NSMutableArray new];
        for (int i = 0; i < arsrfr.count; i++) {
            NSDictionary *dic = arsrfr[i];
            [arr addObject:[NSString stringWithFormat:@"%@", dic[@"operatorId"]]];
        }
        if (arr.count > 0) vc.defaultValues = [[NSMutableArray alloc] initWithArray:arr];
        vc.byText = NO;
        vc.isMultiple = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)permission:(NSInteger)index indexPath:(NSIndexPath *)indexPath {
    // 修改成功之后，才修改 _visibleType的值
    if (index == 0) {
        _visibleType = @"PUBLIC";
        [self.dicPermission setObject:@[@{@"visibleType":@"PUBLIC"}] forKey:@"PUBLIC"];
        CommonRowMo *rowMo = self.section0[indexPath.row];
        rowMo.m_obj = @"公开";
        rowMo.strValue = @"公开";
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (index == 1) {
        PermissionSelectViewCtrl *vc = [[PermissionSelectViewCtrl alloc] init];
        NSArray *tmpArr = [self.dicPermission objectForKey:@"DEPARTMENT"];
        for (int i = 0; i < tmpArr.count; i++) {
            NSDictionary *dic = tmpArr[i];
            [vc.arrDefault addObject:dic[@"departmentId"]];
        }
        __weak typeof(self) weakself = self;
        __block NSMutableArray *departArr = [NSMutableArray new];
        __block NSString *departStr = @"";
        vc.updateSuccess = ^(NSMutableArray *obj) {
            __strong typeof(self) strongself = weakself;
            
            for (int i = 0; i < obj.count; i++) {
                GroupMo *groupMo = obj[i];
                [departArr addObject:@{@"visibleType":@"DEPARTMENT",
                                       @"departmentId":@(groupMo.id)}];
                departStr = [departStr stringByAppendingString:groupMo.name];
                if (i < obj.count-1) {
                    departStr = [departStr stringByAppendingString:@","];
                }
            }
            
            if (departArr.count > 0) {
                [strongself.dicPermission setObject:departArr forKey:@"DEPARTMENT"];
                CommonRowMo *rowMo = strongself.section0[indexPath.row];
                rowMo.m_obj = departStr;
                rowMo.strValue = departStr;
                [strongself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            _visibleType = @"DEPARTMENT";
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 2) {
        if (!self.linkMember) {
            [Utils showToastMessage:@"当前没有选择客户"];
            return;
        }
        // 字典项选择
        [_selectArr removeAllObjects];
        _selectArr = nil;
        if (self.linkMember.arId != 0) {
            [self.selectArr addObject:@{@"id":[NSString stringWithFormat:@"%lld", self.linkMember.arId],
                                        @"name":[NSString stringWithFormat:@"AR-%@", self.linkMember.arName],
                                        @"key":@"AR"}];
        }
        if (self.linkMember.frId != 0) {
            [self.selectArr addObject:@{@"id":[NSString stringWithFormat:@"%lld",self.linkMember.frId],
                                        @"name":[NSString stringWithFormat:@"FR-%@", self.linkMember.frName],
                                        @"key":@"FR"}];
        }
        if (self.linkMember.srId != 0) {
            [self.selectArr addObject:@{@"id":[NSString stringWithFormat:@"%lld",self.linkMember.srId],
                                        @"name":[NSString stringWithFormat:@"SR-%@", self.linkMember.srName],
                                        @"key":@"SR"}];
        }
        [_selectShowArr removeAllObjects];
        _selectShowArr = nil;
        for (NSDictionary *tmpDic in self.selectArr) {
            ListSelectMo *mo = [[ListSelectMo alloc] init];
            mo.moId = tmpDic[@"id"];
            mo.moText = tmpDic[@"name"];
            mo.moKey = tmpDic[@"key"];
            [self.selectShowArr addObject:mo];
        }
        [self pushToSelectVC:indexPath];
    } else if (index == 3) {
        JYUserMoSelectViewCtrl *vc = [[JYUserMoSelectViewCtrl alloc] init];
        vc.VcDelegate = self;
        vc.isMultiple = YES;
        vc.indexPath = indexPath;
        NSArray *tmpArr = [self.dicPermission objectForKey:@"SOMEONE"];
        for (int i = 0; i < tmpArr.count; i++) {
            NSDictionary *dic = tmpArr[i];
            [vc.defaultValues addObject:dic[@"operatorId"]];
        }
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    } else if (index == 4) {
        _visibleType = @"";
    }
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
    
    if ([self currentCell] != subInteligenceCell) {
        [self currentCellReset];
    }
    if (barIndex != 0) [self currentCellReset];
    
    subInteligenceCell.recordView.contentView.textView.delegate = self;
    self.editIndexPath = [self.tableView indexPathForCell:subInteligenceCell];
    
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
        vc.indexPath = indexPath;
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    } else if (barIndex == 1) {
        if (itemSet.voices.count >= 9) {
            [Utils showToastMessage:@"最多录制9条语音"];
            return;
        }
//        [Utils showToastMessage:@"该功能将于春节后上线"];
//        return;
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
        [subInteligenceCell resetNormalState];
        [self addPicture:itemSet];
    } else if (barIndex == 3) {
//        [Utils showToastMessage:@"该功能将于春节后上线"];
//        return;
        if (itemSet.videos.count >= 3) {
            [Utils showToastMessage:@"最多录制3条短视频"];
            return;
        }
        [self addVideo];
    }
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

//- (void)subInteligenceCellBeginEdit:(SubInteligenceCell *)subInteligenceCell indexPath:(NSIndexPath *)indexPath {
//    SubInteligenceCell *cell = (SubInteligenceCell *)[self.tableView cellForRowAtIndexPath:self.editIndexPath];
//    if (cell != subInteligenceCell) {
//        [cell resetNormalState];
//    }
//    self.editIndexPath = indexPath;
//}

- (void)subInteligenceCell:(SubInteligenceCell *)subInteligenceCell placehold:(NSString *)placehold indexPath:(NSIndexPath *)indexPath {
    subInteligenceCell.recordView.contentView.placeholder = placehold.length == 0 ? @"请输入内容" : [NSString stringWithFormat:@"建议输入：%@", placehold];
}

- (NSMutableArray *)subInteligenceCellArrBigCategoryMos:(SubInteligenceCell *)subInteligenceCell {
    return [self filterArrMos:self.arrInfoTypeMos remark:self.dicMoBusiness.key];
}

- (NSMutableArray *)subInteligenceCellArrIntelligenceMos:(SubInteligenceCell *)subInteligenceCell bigMoKey:(nonnull NSString *)bigMoKey {
    return [self filterArrMos:self.arrTypesMos remark:bigMoKey];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    CommonRowMo *rowMo = self.section0[indexPath.row];
    
    if ([rowMo.key isEqualToString:@"big"]) {
        // 如果选择的情报大类和原先的不一致，则需要重置底下所有的类别
        DicMo *tmpBig = self.selectArr[index];
        if (![tmpBig.key isEqualToString:self.dicMoBig.key]) {
            self.dicMoBig = self.selectArr[index];
            // 如果是技术，政策则去除客户选项
            if ([self.dicMoBig.key isEqualToString:@"technology_trend"]||
                [self.dicMoBig.key isEqualToString:@"industry_policy"]) {
                if ([self.section0 containsObject:self.memberRow]) [self.section0 removeObject:self.memberRow];
                if (self.memberRow) self.memberRow = nil;
                if (self.linkMember) self.linkMember = nil;
            } else {
                if (![self.section0 containsObject:self.memberRow]) [self.section0 insertObject:self.memberRow atIndex:1];
            }
            // 重新赋值
            for (CommonRowMo *tmpMo in self.section0) {
                if ([tmpMo.key isEqualToString:@"big"]) {
                    tmpMo.strValue = self.dicMoBig.value;
                    tmpMo.m_obj = self.dicMoBig;
                }
                if ([tmpMo.key isEqualToString:@"business"]) {
                    tmpMo.strValue = @"";
                    tmpMo.m_obj = nil;
                    self.dicMoBusiness = nil;
                }
            }
            [self resetAllSubMos];
            [self.tableView reloadData];
        }
    } else if ([rowMo.key isEqualToString:@"business"]) {
        // 如果选择的情报大类和原先的不一致，则需要重置底下所有的类别
        DicMo *tmpBusiness = self.selectArr[index];
        if (![tmpBusiness.key isEqualToString:self.dicMoBusiness.key]) {
            // 重新赋值
            self.dicMoBusiness = self.selectArr[index];
            for (CommonRowMo *tmpMo in self.section0) {
                if ([tmpMo.key isEqualToString:@"business"]) {
                    tmpMo.strValue = self.dicMoBusiness.value;
                    tmpMo.m_obj = self.dicMoBusiness;
                }
            }
            [self resetAllSubMos];
            [self.tableView reloadData];
        }
    }
}

// 多选方法，会覆盖单选方法
- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndexPaths:(NSArray *)selectIndexPaths indexPath:(NSIndexPath *)indexPath {
    
    CommonRowMo *rowMo = self.section0[indexPath.row];
    if ([rowMo.key isEqualToString:@"visibleRangeList"]) {
        NSString *valueStr = @"";
        NSMutableArray *multipleValue = [NSMutableArray new];
        for (int i = 0; i < selectIndexPaths.count; i++) {
            NSIndexPath *tmpIndexPath = selectIndexPaths[i];
            ListSelectMo *tmpMo = [self.selectShowArr objectAtIndex:tmpIndexPath.row];
            
            [multipleValue addObject:@{@"visibleType": @"FRSRAR",
                                       @"operatorId": tmpMo.moId,
                                       @"frSrAr": tmpMo.moKey}];
            valueStr = [valueStr stringByAppendingString:STRING(tmpMo.moText)];
            if (i < selectIndexPaths.count - 1) {
                valueStr = [valueStr stringByAppendingString:@","];
            }
        }
        _visibleType = @"FRSRAR";
        [self.dicPermission setObject:multipleValue forKey:@"FRSRAR"];
        CommonRowMo *rowMo = self.section0[indexPath.row];
        rowMo.m_obj = multipleValue;
        rowMo.strValue = valueStr;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

#pragma mark - MemberSelectViewCtrlDelegate

- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        if (model.id != self.linkMember.id) {
            self.linkMember = model;
            for (CommonRowMo *tmpMo in self.section0) {
                if ([tmpMo.key isEqualToString:@"member"]) {
                    tmpMo.strValue = self.linkMember.orgName;
                    tmpMo.m_obj = self.linkMember;
                }
                if ([tmpMo.key isEqualToString:@"visibleRangeList"]) {
                    if ([_visibleType isEqualToString:@"FRSRAR"]) {
                        [self.dicPermission removeObjectForKey:@"FRSRAR"];
                        tmpMo.strValue = @"";
                        _visibleType = @"";
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+2 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
                    }
                }
            }
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
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

- (void)jyUserMoSelectViewCtrl:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl selectedData:(NSArray *)selectedData indexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CommonRowMo *rowMo = self.section0[indexPath.row];
        if ([rowMo.key isEqualToString:@"visibleRangeList"]) {
            NSMutableArray *arrPerson = [NSMutableArray new];
            NSString *str = @"";
            for (int i = 0; i < selectedData.count; i++) {
                JYUserMo *tmpMo = selectedData[i];
                [arrPerson addObject:@{@"visibleType":@"SOMEONE",
                                       @"operatorId": [NSString stringWithFormat:@"%ld", (long)tmpMo.id]}];
                str = [str stringByAppendingString:STRING(tmpMo.name)];
                if (i < selectedData.count - 1) {
                    str = [str stringByAppendingString:@","];
                }
            }
            _visibleType = @"SOMEONE";
            if (arrPerson.count > 0) [self.dicPermission setObject:arrPerson forKey:@"SOMEONE"];
            rowMo.strValue = str;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
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
        if (textView.text.length == 0) {
            return;
        }
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
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)btnDeleteClick:(UIButton *)sender {
    BOOL canDelete = NO;
    NSMutableArray *deleteArr = [[NSMutableArray alloc] init];
    NSMutableArray *deleteIndexArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.arrData.count; i++) {
        IntelligenceItemSet *mo = self.arrData[i];
        if (mo.isSelected) {
            [deleteArr addObject:mo];
            [deleteIndexArr addObject:[NSIndexPath indexPathForRow:i inSection:1]];
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
        [self.tableView deleteRowsAtIndexPaths:deleteIndexArr withRowAnimation:UITableViewRowAnimationFade];
        self.btnSelect.selected = NO;
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
    if (self.dicMoBig == nil) {
        [Utils showToastMessage:@"请完选择情报大类"];
        return;
    }
    if (self.dicMoBusiness == nil) {
        [Utils showToastMessage:@"请完选择业务类型"];
        return;
    }
    
//    if (!self.linkMember) {
//        [Utils showToastMessage:@"请选择关联客户"];
//        return;
//    }
    if (self.arrData.count == 0) {
        [Utils showToastMessage:@"请添加情报"];
        return;
    }
    
    
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
    
    _uploadArr = [NSMutableArray new];
    self.uploadParam = [NSMutableDictionary new];
    [self.uploadParam setObject:STRING(self.dicMoBig.key) forKey:@"bigCategoryKey"];
    [self.uploadParam setObject:STRING(self.dicMoBig.value) forKey:@"bigCategoryValue"];
    [self.uploadParam setObject:STRING(self.dicMoBusiness.key) forKey:@"businessTypeKey"];
    [self.uploadParam setObject:STRING(self.dicMoBusiness.value) forKey:@"businessTypeValue"];
    
    if (self.linkMember) [self.uploadParam setObject:@{@"id":@(self.linkMember.id)} forKey:@"member"];
    
    NSArray *visibleTyepArr = [self.dicPermission objectForKey:_visibleType];
    if (visibleTyepArr.count != 0) [self.uploadParam setObject:visibleTyepArr forKey:@"visibleRangeList"];
    
    self.uploadCount = self.arrData.count;
    
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < self.arrData.count; i++) {
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            IntelligenceItemSet *itemSet = self.arrData[i];
            if (itemSet.images.count > 0||
                itemSet.voices.count > 0||
                itemSet.videos.count > 0) {
                __weak typeof(self) weakself = self;
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
                    [strongself.uploadArr addObject:itemDic];
                    strongself.uploadCount--;
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
                [self.uploadArr addObject:itemDic];
                self.uploadCount--;
            }
        });
    }
}

- (void)setUploadCount:(NSInteger)uploadCount {
    _uploadCount = uploadCount;
    if (_uploadCount == 0) {
        // 上传成功了
        [self.uploadParam setObject:self.uploadArr forKey:@"intelligenceItemSet"];
        [[JYUserApi sharedInstance] createLinkActivityByDetailId:(self.communId > 0 ? self.communId : 0) param:self.uploadParam success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"新建成功"];
            if (self.updateSuccess) {
                self.updateSuccess(nil);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        
    }
}

- (BOOL)dealWithContentParams:(IntelligenceItemSet *)itemSet  {
    // 找到文本中所有的@
    NSString *string = itemSet.showText;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kATRegular options:NSRegularExpressionCaseInsensitive error:nil];
    if (string.length == 0) {
        return NO;
    }
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    
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

- (NSMutableArray *)selectShowArr {
    if (!_selectShowArr) _selectShowArr = [NSMutableArray new];
    return _selectShowArr;
}

- (NSMutableArray *)selectArr {
    if (!_selectArr) _selectArr = [NSMutableArray new];
    return _selectArr;
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

- (NSMutableArray *)section0 {
    if (!_section0) _section0 = [NSMutableArray new];
    return _section0;
}

- (CommonRowMo *)memberRow {
    if (!_memberRow) {
        _memberRow = [[CommonRowMo alloc] init];
        _memberRow.key = @"member";
        _memberRow.leftContent = @"关联对象";
        _memberRow.rightContent = @"请选择";
        _memberRow.editAble = self.fromTab ? YES : NO;
        _memberRow.nullAble = YES;
        if (!self.fromTab) {
//            NSError *error = nil;
//            self.linkMember = [[CustomerMo alloc] initWithDictionary:self.model.member error:&error];
            _memberRow.m_obj = self.linkMember;
            _memberRow.strValue = self.linkMember.orgName;
        }
    }
    return _memberRow;
}

- (NSMutableDictionary *)dicPermission {
    if (!_dicPermission) _dicPermission = [NSMutableDictionary new];
    return _dicPermission;
}

@end
