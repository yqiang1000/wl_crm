//
//  PersonDemandCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PersonDemandCell.h"

@interface PersonDemandCell ()

@property (nonatomic, strong) UILabel *labContent;
@property (nonatomic, strong) UILabel *labAsker;
@property (nonatomic, strong) UILabel *labCreater;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UILabel *labState;
@property (nonatomic, strong) UILabel *labReply;
@property (nonatomic, strong) UILabel *labReplyContent;

@property (nonatomic, strong) UIView *bottomView;

//@property (nonatomic, strong) ReplyTableView *tableView;
//@property (nonatomic, strong) NSMutableArray *arrReplyData;

@end

@implementation PersonDemandCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labContent];
    [self.contentView addSubview:self.labAsker];
    [self.contentView addSubview:self.labCreater];
    [self.contentView addSubview:self.labState];
    [self.contentView addSubview:self.labTime];
    [self.contentView addSubview:self.bottomView];
    [self.contentView addSubview:self.lineView];
    
    [self.labState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.labState.mas_left).offset(-10);
    }];
    
    [self.labAsker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labContent.mas_bottom).offset(12);
        make.left.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.labCreater mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labAsker);
        make.left.equalTo(self.contentView.mas_centerX).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labAsker.mas_bottom).offset(7);
        make.left.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTime.mas_bottom).offset(7);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - public

- (void)loadData:(LinkManDemandMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labContent.text = _model.desp;
    NSString *name = @"暂无";
    if (_model.linkMan) {
        name = STRING(_model.linkMan[@"name"]);
    }
    self.labAsker.text = [NSString stringWithFormat:@"提出人：%@" , name];
    self.labCreater.text = [NSString stringWithFormat:@"创建人：%@" , _model.createdBy.length==0?@"暂无":_model.createdBy];
    self.labTime.text = [NSString stringWithFormat:@"创建日期：%@" , [_model.createdDate substringToIndex:10]];
    self.labState.text = _model.needFeedBack ? @"需响应" : @"无需响应";
    self.labState.textColor = _model.needFeedBack ? COLOR_C3 : COLOR_B3;
    CGSize size = [Utils getStringSize:self.labState.text font:self.labState.font];
    
    [self.labState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width+3));
    }];

    if (_model.needFeedBack && _model.reply.length > 0) {
        self.labReplyContent.text = _model.reply;
        self.labReply.text = @"回复:";
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labTime.mas_bottom).offset(7);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    } else {
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labTime.mas_bottom).offset(7);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.height.equalTo(@0.0);
        }];
    }
    
    [self layoutIfNeeded];
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        CGFloat ht = _tableView.contentSize.height;
//        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(ht));
//        }];
//    }
//}

//-(void)dealloc {
//    [_tableView removeObserver:self forKeyPath:@"contentSize"];
//}

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
    }
    return _labAsker;
}

- (UILabel *)labCreater {
    if (!_labCreater) {
        _labCreater = [[UILabel alloc] init];
        _labCreater.font = FONT_F13;
        _labCreater.textColor = COLOR_B2;
    }
    return _labCreater;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [[UILabel alloc] init];
        _labTime.font = FONT_F13;
        _labTime.textColor = COLOR_B2;
    }
    return _labTime;
}

- (UILabel *)labState {
    if (!_labState) {
        _labState = [[UILabel alloc] init];
        _labState.font = FONT_F13;
        _labState.textColor = COLOR_C3;
    }
    return _labState;
}

//- (ReplyTableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[ReplyTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        [_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
//    }
//    return _tableView;
//}
//
//- (NSMutableArray *)arrReplyData {
//    if (!_arrReplyData) {
//        _arrReplyData = [NSMutableArray new];
//        NSString *str = @"回复内容那个打底就开始点击啦地方卢卡斯金德拉克绝世独立副科级啊了焦俪的家啊个发动机来个反馈大感觉啊老地方";
//        for (int i = 0; i < 5; i++) {
//            NSMutableDictionary *dic = [NSMutableDictionary new];
//            int x = arc4random() % 30 + 5;
//            [dic setObject:[NSString stringWithFormat:@"回复%d:", i] forKey:@"reply"];
//            [dic setObject:[str substringToIndex:x] forKey:@"content"];
//            [_arrReplyData addObject:dic];
//        }
//    }
//    return _arrReplyData;
//}

- (UIView *)lineView {
    if (!_lineView) _lineView = [Utils getLineView];
    return _lineView;
}

- (UILabel *)labReply {
    if (!_labReply) {
        _labReply = [[UILabel alloc] init];
        _labReply.font = FONT_F13;
        _labReply.textColor = COLOR_336699;
    }
    return _labReply;
}

- (UILabel *)labReplyContent {
    if (!_labReplyContent) {
        _labReplyContent = [[UILabel alloc] init];
        _labReplyContent.font = FONT_F13;
        _labReplyContent.textColor = COLOR_B1;
        _labReplyContent.numberOfLines = 0;
    }
    return _labReplyContent;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = COLOR_B0;
        [_bottomView addSubview:self.labReply];
        [_bottomView addSubview:self.labReplyContent];
        
        [self.labReply mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bottomView).offset(10);
            make.top.equalTo(_bottomView).offset(10);
            make.bottom.lessThanOrEqualTo(_bottomView).offset(-10);
        }];
        
        [self.labReplyContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.labReply.mas_right).offset(5);
            make.top.equalTo(_bottomView).offset(10);
            make.right.equalTo(_bottomView).offset(-10);
            make.bottom.equalTo(_bottomView).offset(-10);
        }];
    }
    return _bottomView;
}

@end
