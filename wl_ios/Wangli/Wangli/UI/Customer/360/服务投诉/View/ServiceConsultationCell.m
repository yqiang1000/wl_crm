
//
//  ServiceConsultationCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ServiceConsultationCell.h"
#import "ServiceConsultationTableView.h"

@interface ServiceConsultationCell ()

@property (nonatomic, strong) UILabel *labContent;
@property (nonatomic, strong) UILabel *labAsker;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) ServiceConsultationTableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrReplyData;

@end

@implementation ServiceConsultationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.imgIcon];
    [self.contentView addSubview:self.labContent];
    [self.contentView addSubview:self.labAsker];
    [self.contentView addSubview:self.labTime];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.lineView];
    
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(17);
        make.left.equalTo(self.contentView).offset(15);
        make.width.equalTo(@17.0);
        make.height.equalTo(@15.0);
    }];
    
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.imgIcon.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.labAsker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labContent.mas_bottom).offset(10);
        make.left.equalTo(self.labContent);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labAsker.mas_bottom).offset(10);
        make.left.equalTo(self.labContent);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTime.mas_bottom).offset(10);
        make.left.equalTo(self.labContent);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tableView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - public

- (void)loadData:(NSString *)model {
    self.labContent.text = @"贵公司在我司有驻场人员吗";
    self.labAsker.text = @"咨询人：晶科生产部-张明";
    self.labTime.text = @"2018-11-01";
    self.tableView.arrData = self.arrReplyData;
    [self.tableView reloadData];
//    CGSize size = self.tableView.contentSize;
//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(size.height));
//    }];
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat ht = _tableView.contentSize.height;
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(ht));
        }];
    }
}

-(void)dealloc {
    [_tableView removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark - lazy

- (UILabel *)labContent {
    if (!_labContent) {
        _labContent = [[UILabel alloc] init];
        _labContent.font = FONT_F15;
        _labContent.textColor = COLOR_B1;
        _labContent.numberOfLines = 0;
    }
    return _labContent;
}

- (UILabel *)labAsker {
    if (!_labAsker) {
        _labAsker = [[UILabel alloc] init];
        _labAsker.font = FONT_F13;
        _labAsker.textColor = COLOR_B2;
        _labAsker.numberOfLines = 0;
    }
    return _labAsker;
}

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] init];
        _imgIcon.image = [UIImage imageNamed:@"consultation"];
    }
    return _imgIcon;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [[UILabel alloc] init];
        _labTime.font = FONT_F13;
        _labTime.textColor = COLOR_B2;
        _labTime.numberOfLines = 0;
    }
    return _labTime;
}

- (ServiceConsultationTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ServiceConsultationTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _tableView;
}

- (NSMutableArray *)arrReplyData {
    if (!_arrReplyData) {
        _arrReplyData = [NSMutableArray new];
        NSString *str = @"回复内容那个打底就开始点击啦地方卢卡斯金德拉克绝世独立副科级啊了焦俪的家啊个发动机来个反馈大感觉啊老地方";
        for (int i = 0; i < 5; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            int x = arc4random() % 30 + 5;
            [dic setObject:[NSString stringWithFormat:@"FR/林可%d", i] forKey:@"name"];
            [dic setObject:[NSString stringWithFormat:@"回复%d:", i] forKey:@"reply"];
            [dic setObject:[NSString stringWithFormat:@"2018-12-%02d", i] forKey:@"time"];
            [dic setObject:[str substringToIndex:x] forKey:@"content"];
            [_arrReplyData addObject:dic];
        }
    }
    return _arrReplyData;
}

- (UIView *)lineView {
    if (!_lineView) _lineView = [Utils getLineView];
    return _lineView;
}

@end
