//
//  TaskCell.m
//  Wangli
//
//  Created by yeqiang on 2018/5/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TaskCell.h"

@interface TaskCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *imgHeader;
@property (nonatomic, strong) UILabel *labTime;

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labMsg;
@property (nonatomic, strong) UILabel *labHelp;

@property (nonatomic, strong) UILabel *labPerson;

@property (nonatomic, strong) UILabel *labState;
@property (nonatomic, strong) UILabel *labStaticDelay;
@property (nonatomic, strong) UILabel *labDelay;

@property (nonatomic, strong) UIImageView *imgTmp1;
@property (nonatomic, strong) UIImageView *imgTmp2;
@property (nonatomic, strong) UIImageView *imgTmp3;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation TaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_B0;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.imgHeader];
    [self.baseView addSubview:self.labTime];
    [self.baseView addSubview:self.labState];
    [self.baseView addSubview:self.imgTmp1];
    [self.baseView addSubview:self.labTitle];
    [self.baseView addSubview:self.imgTmp2];
    [self.baseView addSubview:self.labMsg];
    [self.baseView addSubview:self.imgTmp3];
    [self.baseView addSubview:self.labHelp];
    [self.baseView addSubview:self.labStaticDelay];
    [self.baseView addSubview:self.labDelay];
    [self.baseView addSubview:self.lineView];
    [self.baseView addSubview:self.labPerson];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@157);
    }];
    
    [self.imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(20);
        make.left.equalTo(self.baseView).offset(10);
        make.width.height.equalTo(@50);
    }];
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(26);
        make.left.equalTo(self.imgHeader.mas_right).offset(8);
        make.height.greaterThanOrEqualTo(@15);
    }];
    
    [self.imgTmp1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTime.mas_bottom).offset(12);
        make.left.equalTo(self.labTime);
        make.height.width.equalTo(@13);
    }];
    
    [self.imgTmp2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgTmp1.mas_bottom).offset(8);
        make.left.equalTo(self.imgTmp1);
        make.height.width.equalTo(@13);
    }];
    
    [self.imgTmp3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgTmp2.mas_bottom).offset(8);
        make.left.equalTo(self.imgTmp1);
        make.height.width.equalTo(@13);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgTmp1);
        make.left.equalTo(self.imgTmp1.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.baseView).offset(-10);
    }];
    
    [self.labMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgTmp2);
        make.left.equalTo(self.imgTmp2.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.baseView).offset(-10);
    }];
    
    [self.labHelp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgTmp3);
        make.left.equalTo(self.imgTmp3.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.baseView).offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.baseView);
        make.bottom.equalTo(self.baseView).offset(-37);
        make.height.equalTo(@0.5);
    }];
    
    [self.labStaticDelay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.baseView.mas_bottom).offset(-18.5);
        make.left.equalTo(self.imgHeader);
    }];
    
    [self.labDelay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.baseView.mas_bottom).offset(-18.5);
        make.left.equalTo(self.labStaticDelay.mas_right);
        make.right.lessThanOrEqualTo(self.baseView).offset(-10);
    }];
    
    [self.labPerson mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labDelay);
        make.right.equalTo(self.baseView).offset(-10);
    }];
    
    [self.labState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(9);
        make.right.equalTo(self.baseView);
        make.width.equalTo(@65);
        make.height.equalTo(@28);
    }];
}

#pragma mark - public

- (void)loadDataWith:(TaskMo *)model {
    if (_model != model) {
        _model = model;
    }
    
    [self.imgHeader sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:[_model.typeKey isEqualToString:@"assingn"] ? @"task_assign" : @"task_remind"]];
//    self.labTime.text = _model.endTimeStr.length == 0? @"暂无到期时间":_model.endTimeStr;
    self.labTime.text = _model.createdDate;
    self.labTitle.text = _model.title;
    
    NSString *receiveName = _model.receiver[@"name"];
    self.labMsg.text = [NSString stringWithFormat:@"责任人:%@", receiveName.length == 0? @"无":receiveName];
//    self.labMsg.text = _model.remark.length == 0 ? @"暂无备注":_model.remark;
    
    NSString *name = [[NSString alloc] init];
    for (int i = 0; i < _model.collaboratorSet.count; i++) {
        NSDictionary *dic = _model.collaboratorSet[i];
        name = [name stringByAppendingString:STRING(dic[@"name"])];
        if (i < _model.collaboratorSet.count - 1) {
            name = [name stringByAppendingString:@","];
        }
    }
    
    self.labHelp.text = [NSString stringWithFormat:@"协办人:%@", name.length == 0? @"无":name];
    self.labDelay.text = _model.endTime;
    self.labPerson.text = [NSString stringWithFormat:@"创建人:%@", _model.founder[@"name"]];
    
//    self.labDelay.text = [NSString stringWithFormat:@"%@于%@创建", _model.founder[@"name"], _model.createdDate];
    self.labState.text = _model.statusValue.length == 0? @"暂无状态":_model.statusValue;;
    CGSize size = [Utils getStringSize:self.labState.text font:self.labState.font];
    [self.labState mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width+20));
    }];
    

    [self layoutIfNeeded];
}

#pragma mark - setter and getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 157)];
        _baseView.layer.mask = [Utils drawContentFrame:_baseView.bounds corners:UIRectCornerAllCorners cornerRadius:5];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}

- (UIImageView *)imgHeader {
    if (!_imgHeader) {
        _imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _imgHeader.layer.mask = [Utils drawContentFrame:_imgHeader.bounds corners:UIRectCornerAllCorners cornerRadius:25];
        _imgHeader.backgroundColor = [UIColor redColor];
    }
    return _imgHeader;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [[UILabel alloc] init];
        _labTime.textColor = COLOR_B2;
        _labTime.font = FONT_F13;
    }
    return _labTime;
}

- (UIImageView *)imgTmp1 {
    if (!_imgTmp1) {
        _imgTmp1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_origin"]];
    }
    return _imgTmp1;
}

- (UIImageView *)imgTmp2 {
    if (!_imgTmp2) {
        _imgTmp2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rask_coordinator-1"]];
    }
    return _imgTmp2;
}

- (UIImageView *)imgTmp3 {
    if (!_imgTmp3) {
        _imgTmp3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rask_coordinator"]];
    }
    return _imgTmp3;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.textColor = COLOR_B1;
        _labTitle.font = FONT_F16;
    }
    return _labTitle;
}

- (UILabel *)labMsg {
    if (!_labMsg) {
        _labMsg = [[UILabel alloc] init];
        _labMsg.textColor = COLOR_B2;
        _labMsg.font = FONT_F13;
    }
    return _labMsg;
}

- (UILabel *)labHelp {
    if (!_labHelp) {
        _labHelp = [[UILabel alloc] init];
        _labHelp.textColor = COLOR_B2;
        _labHelp.font = FONT_F13;
    }
    return _labHelp;
}

- (UILabel *)labDelay {
    if (!_labDelay) {
        _labDelay = [[UILabel alloc] init];
        _labDelay.textColor = COLOR_EC675D;
        _labDelay.font = FONT_F13;
    }
    return _labDelay;
}

- (UILabel *)labStaticDelay {
    if (!_labStaticDelay) {
        _labStaticDelay = [[UILabel alloc] init];
        _labStaticDelay.font = FONT_F13;
        _labStaticDelay.textColor = COLOR_B2;
        _labStaticDelay.text = @"截止时间:";
    }
    return _labStaticDelay;
}

- (UILabel *)labPerson {
    if (!_labPerson) {
        _labPerson = [[UILabel alloc] init];
        _labPerson.textColor = COLOR_B2;
        _labPerson.font = FONT_F13;
    }
    return _labPerson;
}

- (UILabel *)labState {
    if (!_labState) {
        _labState = [[UILabel alloc] init];
        // 特地加宽，防止字符串过长
        _labState.frame = CGRectMake(0, 0, 100, 28);
        _labState.layer.mask = [Utils drawContentFrame:_labState.bounds corners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadius:14];
        _labState.clipsToBounds = YES;
        
        _labState.textColor = COLOR_B4;
        _labState.backgroundColor = COLOR_C3;
        _labState.font = FONT_F13;
        _labState.textAlignment = NSTextAlignmentCenter;
    }
    return _labState;
}

@end
