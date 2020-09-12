//
//  CreateBusinessVisitAnnexViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateBusinessVisitAnnexViewCtrl.h"
#import "AttachmentCell.h"
#import "QiNiuUploadHelper.h"

@interface CreateBusinessVisitAnnexViewCtrl () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CreateBusinessVisitAnnexViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 附件
    static NSString *cellId = @"attachmentCell";
    AttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.count = 9;
        cell.attachments = _model.model.images;
        [cell refreshView];
    }
    return cell;
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(self.model.model.id) forKey:@"id"];
    [param setObject:STRING(self.model.model.communicateRecord) forKey:@"communicateRecord"];
    
    [Utils showHUDWithStatus:nil];
    if (self.model.model.images.count > 0) {
        // 上传图片
        [Utils showHUDWithStatus:nil];
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadFileMulti:self.model.model.images success:^(id responseObject) {
            [Utils showHUDWithStatus:@"附件上传成功"];
            [self dealWithParams:param attachmentList:responseObject];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [self dealWithParams:param attachmentList:@[]];
    }
}

- (void)dealWithParams:(NSMutableDictionary *)param attachmentList:(NSArray *)attachmentList {
    NSMutableArray *arr = [NSMutableArray new];
    for (QiniuFileMo *tmpMo in attachmentList) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[tmpMo toDictionary]];
        [dic setObject:@"" forKey:@"url"];
        [dic setObject:@"" forKey:@"thumbnail"];
        [arr addObject:dic];
    }
    
    [param setObject:arr forKey:@"attachmentList"];
    [[JYUserApi sharedInstance] updateVisitActivityCommunicateRecordParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"保存成功"];
        _model.model.images = [[NSMutableArray alloc] initWithArray:attachmentList];
        if (self.updateSuccess) {
            self.updateSuccess(nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
