//
//  RecordHistoryViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/28.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RecordHistoryViewCtrl.h"
#import "EmptyView.h"
#import "RecordHelper.h"
#import <MediaPlayer/MediaPlayer.h>

@interface RecordHistoryViewCtrl () <UITableViewDelegate, UITableViewDataSource>
{
    EmptyView *_emptyView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrList;

@end

@implementation RecordHistoryViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"录音";
    self.leftBtn.hidden = NO;
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
//    [self.rightBtn setTitle:@"新建" forState:UIControlStateNormal];
    self.rightBtn.hidden = YES;
    [self setUI];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    if (self.arrList.count == 0) {
        _emptyView = [[EmptyView alloc] init];
        [self.view addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.tableView);
            make.width.height.equalTo(self.tableView);
        }];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSDictionary *dic = self.arrList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%.0fkb)", dic[@"name"], [dic[@"size"] floatValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.arrList[indexPath.row];
    NSString *name = dic[@"name"];
    if ([name containsString:@"mp3"]) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", [RecordHelper sharedInstance].rootPath, name];
        NSURL *path = [NSURL fileURLWithPath:filePath];
        // 第二步:创建视频播放器
        MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:path];
        playerViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        //第四步:跳转视频播放界面
        [[Utils topViewController] presentViewController:playerViewController animated:YES completion:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.arrList[indexPath.row];
    NSString *name = dic[@"name"];
    if ([name containsString:@"mp3"]) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = self.arrList[indexPath.row];
        NSString *name = dic[@"name"];
        if ([name containsString:@"mp3"]) {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", [RecordHelper sharedInstance].rootPath, name];
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            [self.arrList removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - event

- (void)clickLeftButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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

- (NSMutableArray *)arrList {
    if (!_arrList) {
        _arrList = [[NSMutableArray alloc] initWithArray:[[RecordHelper sharedInstance] getHistoryList]];
    }
    return _arrList;
}

@end
