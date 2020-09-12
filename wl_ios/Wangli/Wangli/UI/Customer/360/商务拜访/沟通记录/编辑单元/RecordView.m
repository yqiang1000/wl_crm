//
//  RecordView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RecordView.h"

@interface RecordView ()

@end

@implementation RecordView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_B4;
        
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.contentView];
    [self addSubview:self.toolBar];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom);
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@50.0);
    }];
}

#pragma mark - public


#pragma mark - lazy

- (RecordToolBarView *)toolBar {
    if (!_toolBar) {
        _toolBar = [[RecordToolBarView alloc] initWithTitles:@[@"同事", @"语音", @"图片", @"视频"]
                                                   imgNormal:@[@"@", @"voice", @"picture", @"video"]
                                                   imgSelect:@[@"", @"", @"", @""]];
    }
    return _toolBar;
}

- (RecordContentView *)contentView {
    if (!_contentView) {
        _contentView = [[RecordContentView alloc] init];
    }
    return _contentView;
}


@end
