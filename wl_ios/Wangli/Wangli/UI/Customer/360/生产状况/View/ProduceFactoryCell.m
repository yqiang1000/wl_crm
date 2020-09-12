//
//  ProduceFactoryCell.m
//  Wangli
//
//  Created by yeqiang on 2019/1/6.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "ProduceFactoryCell.h"

@interface ProduceFactoryCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labCarName;
@property (nonatomic, strong) UILabel *labEquipType;
@property (nonatomic, strong) UILabel *labEquipFactory;
@property (nonatomic, strong) UILabel *labEquipNum;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *labKeyCarName;
@property (nonatomic, strong) UILabel *labKeyEquipType;
@property (nonatomic, strong) UILabel *labKeyEquipFactory;
@property (nonatomic, strong) UILabel *labKeyEquipNum;

@end

@implementation ProduceFactoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.backgroundColor = COLOR_B0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.labTitle];
    UIView *viewCar = [self itemPartKey:self.labKeyCarName labValue:self.labCarName];
    UIView *viewType = [self itemPartKey:self.labKeyEquipType labValue:self.labEquipType];
    UIView *viewFactory = [self itemPartKey:self.labKeyEquipFactory labValue:self.labEquipFactory];
    UIView *viewNum = [self itemPartKey:self.labKeyEquipNum labValue:self.labEquipNum];
    
    [self.baseView addSubview:viewCar];
    [self.baseView addSubview:viewType];
    [self.baseView addSubview:viewFactory];
    [self.baseView addSubview:viewNum];
    [self.baseView addSubview:self.lineView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.contentView);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(15);
        make.left.equalTo(self.baseView).offset(15);
    }];
    
    [viewCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(13);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView.mas_centerX).offset(-10);
    }];
    
    [viewType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewCar);
        make.left.equalTo(self.baseView.mas_centerX).offset(10);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [viewFactory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewCar.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView.mas_centerX).offset(-10);
        make.bottom.equalTo(self.baseView).offset(-15);
    }];
    
    [viewNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewFactory);
        make.left.equalTo(self.baseView.mas_centerX).offset(10);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
        make.height.equalTo(@0.5);
    }];
}

- (UIView *)itemPartKey:(UILabel *)labKey labValue:(UILabel *)labValue {
    UIView *bottomView = [UIView new];
    [bottomView addSubview:labKey];
    [bottomView addSubview:labValue];
    [labKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView);
        make.left.equalTo(bottomView);
        make.bottom.lessThanOrEqualTo(bottomView);
    }];
    [labValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView);
        make.left.equalTo(labKey.mas_right).offset(3);
        make.right.lessThanOrEqualTo(bottomView);
        make.bottom.equalTo(bottomView);
    }];
    return bottomView;
}

#pragma mark - public

- (void)loadData:(JSONModel *)model {
    if (_model != model) {
        _model = model;
    }
    // 工厂设备
    if ([_model isKindOfClass:[ProduceFactoryMo class]]) {
        ProduceFactoryMo *tmpMo = (ProduceFactoryMo *)_model;
        self.labKeyCarName.text = @"车间:";
        self.labKeyEquipType.text = @"设备类型:";
        self.labKeyEquipFactory.text = @"设备厂商:";
        self.labKeyEquipNum.text = @"设备型号:";
        self.labTitle.text = tmpMo.factoryName;
        self.labCarName.text = tmpMo.equipmentTypeValue;
        self.labEquipType.text = tmpMo.equipmentModel;
        self.labEquipFactory.text = tmpMo.vendor;
        self.labEquipNum.text = tmpMo.equipmentModel;
    }
    // 产能信息
    else if ([_model isKindOfClass:[ProduceCapacityMo class]]) {
        ProduceCapacityMo *tmpMo = (ProduceCapacityMo *)_model;
        self.labKeyCarName.text = @"产品类型:";
        self.labKeyEquipType.text = @"车间:";
        self.labKeyEquipFactory.text = @"理论产能:";
        self.labKeyEquipNum.text = @"实际产能:";
        self.labTitle.text = tmpMo.factoryName;
        self.labCarName.text = tmpMo.productType;
        self.labEquipType.text = tmpMo.workshop;
        self.labEquipFactory.text = tmpMo.theoryYield;
        self.labEquipNum.text = tmpMo.actualYield;
    }
    // IQC
    else if ([_model isKindOfClass:[ProduceIQCMo class]]) {
        ProduceIQCMo *tmpMo = (ProduceIQCMo *)_model;
        self.labKeyCarName.text = @"电池片类型:";
        self.labKeyEquipType.text = @"检验日期:";
        self.labKeyEquipFactory.text = @"客户工厂:";
        self.labKeyEquipNum.text = @"交货单号:";
        self.labTitle.text = tmpMo.finishedProductCode;
        self.labCarName.text = tmpMo.batteryTypeValue;
        self.labEquipType.text = tmpMo.checkDate;
        self.labEquipFactory.text = tmpMo.memberFactory;
        self.labEquipNum.text = tmpMo.arrivalBatch;
    }
    // 研发状况 实验室
    else if ([_model isKindOfClass:[DevelopLaboratoryMo class]]) {
        DevelopLaboratoryMo *tmpMo = (DevelopLaboratoryMo *)_model;
        self.labKeyCarName.text = @"实验室类型:";
        self.labKeyEquipType.text = @"所在地区:";
        self.labKeyEquipFactory.text = @"科研人员人数:";
        self.labKeyEquipNum.text = @"年投入成本:";
        self.labTitle.text = tmpMo.name;
        self.labCarName.text = tmpMo.typeValue;
        self.labEquipType.text = tmpMo.area;
        self.labEquipFactory.text = tmpMo.researchCount;
        self.labEquipNum.text = tmpMo.yearPutCost;
    }

    [self layoutIfNeeded];
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}

- (UIView *)lineView {
    if (!_lineView) _lineView = [Utils getLineView];
    return _lineView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.textColor = COLOR_B1;
        _labTitle.font = FONT_F15;
    }
    return _labTitle;
}

- (UILabel *)labCarName {
    if (!_labCarName) _labCarName = [self getNewLabel];
    return _labCarName;
}

- (UILabel *)labEquipType {
    if (!_labEquipType) _labEquipType = [self getNewLabel];
    return _labEquipType;
}

- (UILabel *)labEquipFactory {
    if (!_labEquipFactory) _labEquipFactory = [self getNewLabel];
    return _labEquipFactory;
}

- (UILabel *)labEquipNum {
    if (!_labEquipNum) _labEquipNum = [self getNewLabel];
    return _labEquipNum;
}

- (UILabel *)labKeyCarName {
    if (!_labKeyCarName) _labKeyCarName = [self getNewLabel];
    return _labKeyCarName;
}

- (UILabel *)labKeyEquipType {
    if (!_labKeyEquipType) _labKeyEquipType = [self getNewLabel];
    return _labKeyEquipType;
}

- (UILabel *)labKeyEquipFactory {
    if (!_labKeyEquipFactory) _labKeyEquipFactory = [self getNewLabel];
    return _labKeyEquipFactory;
}

- (UILabel *)labKeyEquipNum {
    if (!_labKeyEquipNum) _labKeyEquipNum = [self getNewLabel];
    return _labKeyEquipNum;
}

- (UILabel *)getNewLabel {
    UILabel *lab = [UILabel new];
    lab.textColor = COLOR_B2;
    lab.font = FONT_F13;
    lab.numberOfLines = 0;
    return lab;
}

@end
