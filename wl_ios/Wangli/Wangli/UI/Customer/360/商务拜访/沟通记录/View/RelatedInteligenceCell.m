//
//  RelatedInteligenceCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/18.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RelatedInteligenceCell.h"

@interface RelatedInteligenceCell ()

@property (nonatomic, strong) UILabel *labClass;                // 情报大类
@property (nonatomic, strong) UILabel *labObject;               // 关联对象
@property (nonatomic, strong) UILabel *labCategory;             // 信息类别
@property (nonatomic, strong) UILabel *labType;                 // 情报类型
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *imgArrow;

@end

@implementation RelatedInteligenceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_B4;
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)setUI {
    [self.contentView addSubview:self.labClass];
    [self.contentView addSubview:self.labObject];
    [self.contentView addSubview:self.labCategory];
    [self.contentView addSubview:self.labType];
    [self.contentView addSubview:self.imgArrow];
    [self.contentView addSubview:self.lineView];
    
    [self.imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@13.0);
        make.width.equalTo(@8.0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.right.left.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    [self.labClass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.labCategory.mas_left).offset(-5);
    }];
    
    [self.labCategory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset((SCREEN_WIDTH-30-8-10)/2.0);
        make.right.lessThanOrEqualTo(self.imgArrow.mas_left).offset(-10);
    }];
    
    [self.labObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labClass);
        make.top.equalTo(self.labClass.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.right.lessThanOrEqualTo(self.labCategory.mas_left).offset(-5);
    }];
    
    [self.labType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labObject);
        make.left.equalTo(self.labCategory);
        make.right.lessThanOrEqualTo(self.imgArrow.mas_left).offset(-10);
    }];
}

#pragma mark - public

- (void)loadData:(IntelligenceItemSet *)model {
    if (_model != model) {
        _model = model;
    }
    
    NSError *error = nil;
    BusinessInteligenceMo *tmpMo = [[BusinessInteligenceMo alloc] initWithDictionary:_model.intelligence error:&error];
    self.labClass.attributedText = [self mutableKey:@"情报大类" line:@" | " value:tmpMo.bigCategoryValue.length==0?@"暂无":tmpMo.bigCategoryValue];
    NSString *orgName = tmpMo.member[@"abbreviation"];
    self.labObject.attributedText = [self mutableKey:@"关联对象" line:@" | " value:orgName.length==0?@"暂无":orgName];
    self.labCategory.attributedText = [self mutableKey:@"信息类别" line:@" | " value:_model.intelligenceTypeValue.length==0?@"暂无":_model.intelligenceTypeValue];
    self.labType.attributedText = [self mutableKey:@"情报类型" line:@" | " value:_model.intelligenceInfoValue.length==0?@"暂无":_model.intelligenceInfoValue];
}

- (NSMutableAttributedString *)mutableKey:(NSString *)key line:(NSString *)line value:(NSString *)value {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", key, line, value]];
    [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_B2 range:NSMakeRange(0, key.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_B3 range:NSMakeRange(key.length, line.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_B1 range:NSMakeRange(attStr.length-value.length, value.length)];
    return attStr;
}

#pragma mark - setter getter

- (UILabel *)labClass {
    if (!_labClass) {
        _labClass = [[UILabel alloc] init];
        _labClass.font = FONT_F13;
    }
    return _labClass;
}

- (UILabel *)labObject {
    if (!_labObject) {
        _labObject = [[UILabel alloc] init];
        _labObject.font = FONT_F13;
    }
    return _labObject;
}

- (UILabel *)labCategory {
    if (!_labCategory) {
        _labCategory = [[UILabel alloc] init];
        _labCategory.font = FONT_F13;
    }
    return _labCategory;
}

- (UILabel *)labType {
    if (!_labType) {
        _labType = [[UILabel alloc] init];
        _labType.font = FONT_F13;
    }
    return _labType;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

- (UIImageView *)imgArrow {
    if (!_imgArrow) {
        //8 * 13
        _imgArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"client_arrow"]];
    }
    return _imgArrow;
}

@end
