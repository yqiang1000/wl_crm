//
//  TrendsBaseTableViewCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsBaseTableViewCell.h"
#import "UserLocalDataUtils.h"

@interface TrendsBaseTableViewCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation TrendsBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = COLOR_B0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labContent];
    [self.contentView addSubview:self.labPerson];
    [self.contentView addSubview:self.labState];
    [self.contentView addSubview:self.labDate];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.dotView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.labState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.baseView).offset(-15);
        make.top.equalTo(self.baseView).offset(15);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.labState.mas_left).offset(-10);
        make.top.equalTo(self.baseView).offset(15);
    }];
    
    [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(15);
        make.top.equalTo(self.labTitle.mas_bottom).offset(21);
        make.width.height.equalTo(@5.0);
    }];
    
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(25);
        make.top.equalTo(self.labTitle.mas_bottom).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.baseView);
        make.top.equalTo(self.labContent.mas_bottom).offset(15);
        make.bottom.equalTo(self.baseView.mas_bottom).offset(-37);
        make.height.equalTo(@0.5);
    }];
    
    [self.labPerson mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(15);
        make.top.equalTo(self.lineView).offset(10);
    }];
    
    [self.labDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.baseView).offset(-15);
        make.top.equalTo(self.lineView).offset(10);
    }];
}

- (void)loadDataWith:(TrendsBaseMo *)model {
    if (_model != model) {
        _model = model;
    }
    NSString *msgType = @"";
    // 商机
    if ([_model isKindOfClass:[TrendsBusinessMo class]]) {
        TrendsBusinessMo *tmpMo = (TrendsBusinessMo *)_model;
        msgType = @"TrendsBusinessMo";
        self.labTitle.text = [NSString stringWithFormat:@"来源:%@", tmpMo.resourceValue];
        NSString *content = @"";
        if (tmpMo.materialTypes.count > 0) content = [content stringByAppendingString:@"#"];
        for (int i = 0; i < tmpMo.materialTypes.count; i++) {
            NSDictionary *dic = tmpMo.materialTypes[i];
            content = [content stringByAppendingString:STRING(dic[@"name"])];
            if (i < tmpMo.materialTypes.count-1) {
                content = [content stringByAppendingString:@","];
            }
        }
        if (tmpMo.materialTypes.count > 0) content = [content stringByAppendingString:@"#,"];
        content = [content stringByAppendingString:[NSString stringWithFormat:@"金额:%@\n备注:%@", tmpMo.amount, tmpMo.content]];
        self.labContent.text = content;
        self.labPerson.text = [NSString stringWithFormat:@"创建人:%@-%@",tmpMo.operator[@"title"], tmpMo.operator[@"name"]];
        self.labDate.text = [Utils getLastUpdateInfoLastDateStr:tmpMo.createdDate];
        self.labState.text = tmpMo.statusValue;
    }
    // 活动
    else if ([_model isKindOfClass:[TrendMarketActivityMo class]]) {
        msgType = @"TrendMarketActivityMo";
        TrendMarketActivityMo *tmpMo = (TrendMarketActivityMo *)_model;
        self.labTitle.text = [NSString stringWithFormat:@"类型:%@", tmpMo.activityTypeValue];
        self.labContent.text = tmpMo.content;
        if (tmpMo.createOperator) {
            NSString *person = [NSString stringWithFormat:@"%@:%@", STRING(tmpMo.department[@"name"]), STRING(tmpMo.operator[@"name"])];
            
            if (tmpMo.importantValue.length > 0) {
                person = [person stringByAppendingString:[NSString stringWithFormat:@"|重要性:%@", tmpMo.importantValue]];
            }
            self.labPerson.text = person;
        }
        self.labDate.text = [Utils getLastUpdateInfoLastDateStr:tmpMo.createdDate];
        self.labState.text = tmpMo.statusValue;
    }
    // 收款
    else if ([_model isKindOfClass:[TrendsReceiptMo class]]) {
        msgType = @"TrendsReceiptMo";
        TrendsReceiptMo *tmpMo = (TrendsReceiptMo *)_model;
        self.labTitle.text = [NSString stringWithFormat:@"客户:%@ | %@", tmpMo.memberNumber, tmpMo.member[@"abbreviation"]];
        self.labContent.text = [NSString stringWithFormat:@"%@ | %@ | %@ %@", tmpMo.companyValue, tmpMo.typeDesp, tmpMo.currencyValue, tmpMo.amount];
        self.labPerson.text = tmpMo.receiptTypeValue;
        self.labDate.text = [Utils getLastUpdateInfoLastDateStr:tmpMo.receiptDate];
        self.labState.text = tmpMo.statusDesp;
    }
    // 样品
    else if ([_model isKindOfClass:[TrendsSampleMo class]]) {
        msgType = @"TrendsSampleMo";
        TrendsSampleMo *tmpMo = (TrendsSampleMo *)_model;
        self.labTitle.text = [NSString stringWithFormat:@"客户:%@-%@", tmpMo.member[@"crmNumber"], tmpMo.member[@"abbreviation"]];
        self.labPerson.text = [NSString stringWithFormat:@"%@:%@", tmpMo.operator[@"title"] ,tmpMo.operator[@"name"]];
        self.labDate.text = [Utils getLastUpdateInfoLastDateStr:tmpMo.createdDate];
        self.labState.text = tmpMo.statusDesp;
        
        NSString *content = _model.title;
        for (int i = 0; i < tmpMo.sampleItems.count; i++) {
            content = [content stringByAppendingString:@"\n"];
            NSError *error = nil;
            SampleItemMo *itemMo = [[SampleItemMo alloc] initWithDictionary:tmpMo.sampleItems[i] error:&error];
            if (itemMo) {
                content = [content stringByAppendingString:[NSString stringWithFormat:@"%@,效率(%@),数量(%@)", itemMo.productName, itemMo.effectiveness, itemMo.amount]];
            }
        }
        self.labContent.text = content;
    }
    // 线索
    else if ([_model isKindOfClass:[ClueMo class]]) {
        msgType = @"TrendsClueMo";
        ClueMo *tmpMo = (ClueMo *)_model;
        self.labTitle.text = [NSString stringWithFormat:@"来源:%@", tmpMo.resourceValue];
        
        NSString *content = @"";
        if (tmpMo.materialTypes.count > 0) content = [content stringByAppendingString:@"#"];
        for (int i = 0; i < tmpMo.materialTypes.count; i++) {
            NSDictionary *dic = tmpMo.materialTypes[i];
            content = [content stringByAppendingString:STRING(dic[@"name"])];
            if (i < tmpMo.materialTypes.count-1) {
                content = [content stringByAppendingString:@","];
            }
        }
        if (tmpMo.materialTypes.count > 0) content = [content stringByAppendingString:@"#"];
        content = [content stringByAppendingString:[NSString stringWithFormat:@"\n备注:%@", tmpMo.content]];
        self.labContent.text = content;
        
        self.labPerson.text = [NSString stringWithFormat:@"创建人:%@-%@",tmpMo.submitter[@"title"], tmpMo.submitter[@"name"]];
        self.labDate.text = [Utils getLastUpdateInfoLastDateStr:tmpMo.createdDate];
        self.labState.text = tmpMo.statusValue;
    }
    // 报价
    else if ([_model isKindOfClass:[TrendsQuoteMo class]]) {
        msgType = @"TrendsQuoteMo";
        TrendsQuoteMo *tmpMo = (TrendsQuoteMo *)_model;
        NSString *content = @"";
        for (int i = 0; i < tmpMo.quotedPriceItem.count; i++) {
            NSDictionary *dic = tmpMo.quotedPriceItem[i];
            NSError *error = nil;
            TrendsQuoteDetailMo *detailMo = [[TrendsQuoteDetailMo alloc] initWithDictionary:dic error:&error];
            if (detailMo.materialType) {
                content = [content stringByAppendingString:[NSString stringWithFormat:@"%@,档位(%@),数量(%@),单价:%@/%@", detailMo.materialType[@"name"], detailMo.gears, detailMo.quantity, detailMo.price, detailMo.unitValue]];
                content = [content stringByAppendingString:@"\n"];
            }
        }
        content = [content stringByAppendingString:[NSString stringWithFormat:@"付款条件:%@\n付款方式:%@\n报价币种:%@", tmpMo.conditionValue, tmpMo.payWayValue, tmpMo.currencyValue]];
        self.labContent.text = content;
        self.labTitle.text = [NSString stringWithFormat:@"客户:%@-%@", tmpMo.member[@"crmNumber"], tmpMo.member[@"abbreviation"]];
        self.labPerson.text = [NSString stringWithFormat:@"%@:%@", tmpMo.createOperator[@"title"] ,tmpMo.createdBy];
        self.labDate.text = [Utils getLastUpdateInfoLastDateStr:tmpMo.createdDate];
        self.labState.text = tmpMo.statusValue;
    }
    else {
        msgType = @"TrendsBaseMo";
        TrendsBaseMo *tmpMo = (TrendsBaseMo *)_model;
        self.labTitle.text = [NSString stringWithFormat:@"来源:%@", tmpMo.title];
        self.labContent.text = tmpMo.content;
        self.labPerson.text = tmpMo.person;
        self.labDate.text = tmpMo.date;
        self.labState.text = tmpMo.state;
    }
    
    BOOL isRead = _model.read || [UserLocalDataUtils getRemarkByMsgId:_model.id msgType:msgType];
    [self.labContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(isRead ? 15 : 25);
    }];
    self.dotView.hidden = isRead;
    [self layoutIfNeeded];
}

#pragma mark - lazy

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.textColor = COLOR_B3;
        _labTitle.font = FONT_F13;
        _labTitle.numberOfLines = 0;
    }
    return _labTitle;
}

- (UILabel *)labContent {
    if (!_labContent) {
        _labContent = [UILabel new];
        _labContent.textColor = COLOR_B1;
        _labContent.font = FONT_F15;
        _labContent.numberOfLines = 0;
    }
    return _labContent;
}

- (UILabel *)labPerson {
    if (!_labPerson) {
        _labPerson = [UILabel new];
        _labPerson.textColor = COLOR_B3;
        _labPerson.font = FONT_F13;
    }
    return _labPerson;
}

- (UILabel *)labState {
    if (!_labState) {
        _labState = [UILabel new];
        _labState.textColor = COLOR_C3;
        _labState.font = FONT_F13;
    }
    return _labState;
}

- (UILabel *)labDate {
    if (!_labDate) {
        _labDate = [UILabel new];
        _labDate.textColor = COLOR_B3;
        _labDate.font = FONT_F13;
    }
    return _labDate;
}

- (UIView *)lineView {
    if (!_lineView) _lineView = [Utils getLineView];
    return _lineView;
}

- (UIView *)dotView {
    if (!_dotView) {
        _dotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _dotView.backgroundColor = COLOR_FE5A57;
        _dotView.layer.mask = [Utils drawContentFrame:_dotView.bounds corners:UIRectCornerAllCorners cornerRadius:CGRectGetWidth(_dotView.frame)/2.0];
    }
    return _dotView;
}
@end
