//
//  SwitchUrlViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/1/25.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "SwitchUrlViewCtrl.h"
#import "WebDetailViewCtrl.h"

@interface SwitchUrlViewCtrl () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation SwitchUrlViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试";
    self.rightBtn.hidden = NO;
    [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self setUI];
}

- (void)setUI {
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.naviView.mas_bottom);
//        make.left.right.bottom.equalTo(self.view);
//    }];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(15);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@200.0);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
    vc.titleStr = @"H5条转调试";
    vc.urlStr = [NSString stringWithFormat:@"%@token=%@", self.textView.text, [Utils token]];
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
    }
    return _textView;
}


@end
