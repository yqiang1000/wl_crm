//
//  ValueAssessmentView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ValueAssessmentView.h"
#import "ZJScrollSegmentView.h"
#import "BaseWebViewCtrl.h"

@interface ValueAssessmentView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) ZJScrollSegmentView *segmentView;

@end

@implementation ValueAssessmentView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_CLEAR;
        _currentIndex = 0;
        [self setUI];
        [self refreshView:self.arrData];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.baseView];
    [self addSubview:self.titleView];
    [self addSubview:self.segmentView];
    [self addSubview:self.tableView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(16);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
        make.height.equalTo(@60.0);
    }];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.equalTo(self.baseView);
        make.right.equalTo(self.baseView);
        make.height.equalTo(@40.0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(10);
        make.right.equalTo(self.baseView).offset(-10);
        make.top.equalTo(self.segmentView.mas_bottom).offset(15);
        make.bottom.equalTo(self.baseView.mas_bottom).offset(-16);
        make.height.equalTo(@(30*6));
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ValueAssessmentCell";
    ValueAssessmentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ValueAssessmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadData:self.arrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CUSTOMER_360_SELECT object:nil userInfo:@{@"section": [NSNumber numberWithInteger:0],@"item": [NSNumber numberWithInteger:5]}];
}

#pragma mark - event

- (void)resetSegmentView:(NSInteger)index {
    if (index >= 0 && index < self.segmentView.titles.count) {
        [self.segmentView setSelectedIndex:index animated:NO enBlock:NO];
    }
}

- (void)btnMoreClick:(UIButton *)sender {
    [[JYUserApi sharedInstance] getConfigDicByName:@"radar_url" success:^(id responseObject) {
        NSArray *arr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
        for (int i = 0 ; i < arr.count; i++) {
            DicMo *dicMo = arr[i];
            if ([dicMo.key isEqualToString:@"radar_detail_url"]) {
                if (dicMo.value.length > 0) {
                    NSString *urlStr = [NSString stringWithFormat:@"%@%@loginid=%ld&officeName=%@&token=%@", dicMo.value,[dicMo.value containsString:@"?"]?@"&":@"?", (long)TheUser.userMo.id, [Utils officeName], [Utils token]];
                    BaseWebViewCtrl *vc = [[BaseWebViewCtrl alloc] init];
                    vc.urlStr = urlStr;
                    vc.titleStr = @"客户价值评估说明";
                    vc.hidesBottomBarWhenPushed = YES;
                    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
                }
                return;
            }
        }
    } failure:^(NSError *error) {
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)refreshView:(NSMutableArray *)arrData {
    self.arrData = arrData;
    [self.tableView reloadData];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(arrData.count==0 ? 30 : 30*arrData.count));
    }];
    [self layoutIfNeeded];
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 10;
        _baseView.clipsToBounds = YES;
    }
    return _baseView;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        UILabel *lab = [UILabel new];
        lab.font = FONT_F15;
        lab.textColor = COLOR_B1;
        lab.text = @"客户价值评估";
        [_titleView addSubview:lab];
        
        [_titleView addSubview:self.labLevel];
        
        UIButton *btnMore = [UIButton new];
        [btnMore setImage:[UIImage imageNamed:@"valueAssessment"] forState:UIControlStateNormal];
        [btnMore addTarget:self action:@selector(btnMoreClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:btnMore];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_titleView);
            make.top.equalTo(_titleView).offset(16);
        }];
        
        [btnMore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleView).offset(5);
            make.right.equalTo(_titleView).offset(-5);
            make.width.height.equalTo(@18);
        }];
        
        [self.labLevel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_titleView);
            make.top.equalTo(lab.mas_bottom).offset(10);
        }];
    }
    return _titleView;
}

- (UILabel *)labLevel {
    if (!_labLevel) {
        _labLevel = [UILabel new];
        _labLevel.text = @"信用等级:A";
        _labLevel.font = FONT_F12;
        _labLevel.textColor = COLOR_B1;
    }
    return _labLevel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.layer.borderColor = COLOR_LINE.CGColor;
        _tableView.layer.borderWidth = 0.5;
    }
    return _tableView;
}

#pragma mark - lazy

- (ZJScrollSegmentView *)segmentView {
    if (!_segmentView) {
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
        // 缩放标题
        style.scaleTitle = YES;
        // 颜色渐变
        style.gradualChangeTitleColor = YES;
        style.normalTitleColor = COLOR_B1;
        style.selectedTitleColor = COLOR_C1;
        style.titleFont = FONT_F12;
//        style.titleMargin = 25;
        style.segmentHeight = 40;
        style.showLine = YES;
        style.scrollLineColor = COLOR_C1;
        style.autoAdjustTitlesWidth = YES;
        __weak typeof(self) weakSelf = self;
        _segmentView = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH-30, style.segmentHeight) segmentStyle:style delegate:nil titles:@[@"财务维度", @"技术维度", @"战略协同", @"竞争分析", @"质量成本", @"关键需求", @"关键指标"] titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf.currentIndex == index) {
                return;
            } else {
                strongSelf.currentIndex = index;
                if (_valueAssessmentViewDelegate && [_valueAssessmentViewDelegate respondsToSelector:@selector(valueAssessmentView:didselectTab:)]) {
                    [_valueAssessmentViewDelegate valueAssessmentView:self didselectTab:_currentIndex];
                }
            }
        }];
        _segmentView.backgroundColor = COLOR_B4;
        UIView *lineView = [Utils getLineView];
        [_segmentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_segmentView);
            make.height.equalTo(@0.5);
        }];
    }
    return _segmentView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) _arrData = [[NSMutableArray alloc] init];
    return _arrData;
}

@end




@interface ValueAssessmentCell ()

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labContent;
@property (nonatomic, strong) UILabel *labScore;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIView *imgScore;

@end

@implementation ValueAssessmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labContent];
    [self.contentView addSubview:self.labScore];
    [self.contentView addSubview:self.progressView];
    [self.contentView addSubview:self.imgScore];
    [self.contentView addSubview:self.lineView];
    
    UIView *leftLine = [Utils getLineView];
    [self.contentView addSubview:leftLine];
    
    UIView *rightLine = [Utils getLineView];
    [self.contentView addSubview:rightLine];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(80.0);
        make.width.equalTo(@0.5);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-50.0);
        make.width.equalTo(@0.5);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.right.equalTo(leftLine.mas_left);
    }];
    
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLine.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(rightLine.mas_left);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLine.mas_right).offset(10);
        make.right.equalTo(rightLine.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@13.0);
    }];
    
    [self.labScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.contentView);
        make.left.equalTo(rightLine.mas_right);
    }];
    
    [self.imgScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.progressView);
        make.width.equalTo(@0.0);
    }];
}

- (void)loadData:(WorthBeanMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labTitle.text = _model.leftContent;
//    self.labScore.text = _model.score.length > 0 ? _model.score : @"-";
    self.labContent.text = _model.rightContent;
    
    if (_model.isTitle) {
        self.labTitle.text = _model.leftContent;
        self.labContent.text = _model.rightContent;
        self.labScore.text = _model.score;
        self.progressView.hidden = YES;
        self.imgScore.hidden = YES;
        self.labContent.hidden = NO;
    } else {
        if (_model.isText) {
            // 纯文本
            self.labTitle.text = _model.leftContent;
            self.labContent.text = _model.rightContent;
            self.labScore.text = @"-";
            self.progressView.hidden = YES;
            self.imgScore.hidden = YES;
            self.labContent.hidden = NO;
        } else {
            // 柱状图
            if (_model.type) {
                CGFloat sorce = [_model.rightContent integerValue] / 100.0;
                self.labTitle.text = _model.leftContent;
                self.labContent.text = _model.rightContent;
                self.labScore.text = _model.rightContent;
                
                self.progressView.progress = sorce;
                self.progressView.hidden = NO;
                self.imgScore.hidden = NO;
                self.labContent.hidden = YES;
                self.imgScore.backgroundColor = COLOR_B1;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    CGFloat width = CGRectGetWidth(self.progressView.frame);
                    [self.imgScore mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@(width * sorce));
                    }];
                    [self layoutIfNeeded];
                });
            }
            // 文字
            else {
                self.labTitle.text = _model.leftContent;
                self.labContent.text = _model.rightContent;
                self.labScore.text = @"-";
                
                self.progressView.hidden = YES;
                self.imgScore.hidden = YES;
                self.labContent.hidden = NO;
            }
        }
    }
}

#pragma mark - lazy

- (UILabel *)labTitle {
    if (!_labTitle) _labTitle = [self getNewLabel];
    return _labTitle;
}

- (UILabel *)labContent {
    if (!_labContent) _labContent = [self getNewLabel];
    return _labContent;
}

- (UILabel *)labScore {
    if (!_labScore) _labScore = [self getNewLabel];
    return _labScore;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        [_progressView setTrackTintColor:COLOR_F4F4F4];
        [_progressView setProgressTintColor:COLOR_F7CF6D];
        for (UIImageView * imageview in _progressView.subviews) {
            imageview.layer.cornerRadius = 7.5;
            imageview.clipsToBounds = YES;
        }
    }
    return _progressView;
}

- (UIView *)lineView {
    if (!_lineView) _lineView = [Utils getLineView];
    return _lineView;
}

- (UILabel *)getNewLabel {
    UILabel *lab = [UILabel new];
    lab.font = FONT_F13;
    lab.textColor = COLOR_B1;
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

- (UIView *)imgScore {
    if (!_imgScore) {
        _imgScore = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 13)];
        _imgScore.layer.cornerRadius = 7.5;
        _imgScore.clipsToBounds = YES;
        [_imgScore.layer addSublayer:[self setGradualChangingColor:_imgScore fromColor:COLOR_FFD778 toColor:COLOR_FFA300]];
    }
    return _imgScore;
}

//绘制渐变色颜色的方法
- (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromHexColorStr toColor:(UIColor *)toHexColorStr {
    
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromHexColorStr.CGColor,(__bridge id)toHexColorStr.CGColor];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}

@end
