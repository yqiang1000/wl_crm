//
//  SystemHelpListViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/3/13.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "SystemHelpListViewCtrl.h"
#import "HelpPersonMo.h"
#import "ContactCell.h"
#import "ContactDetailViewCtrl.h"
#import "CreateHelpListViewCtrl.h"
#import "EmptyView.h"

@interface SystemHelpListViewCtrl () <UITableViewDelegate, UITableViewDataSource>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;

@end

@implementation SystemHelpListViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"协助人列表";
    [self.rightBtn setTitle:@"新建" forState:UIControlStateNormal];
    [self setUI];
    [self getData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.updateSuccess) self.updateSuccess([NSString stringWithFormat:@"%lu", (unsigned long)self.arrData.count]);
}

- (void)getData {
    
    [[JYUserApi sharedInstance] getMemberAssistFindOperatorMemberId:TheCustomer.customerMo.id param:nil success:^(id responseObject) {
        [Utils dismissHUD];
        NSError *error = nil;
        self.arrData = [HelpPersonMo arrayOfModelsFromDictionaries:responseObject error:&error];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
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
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    if (self.arrData.count == 0) {
        _emptyView = [[EmptyView alloc] init];
        [self.tableView addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.tableView);
            make.width.height.equalTo(self.tableView);
        }];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"contactCell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    HelpPersonMo *model = self.arrData[indexPath.row];
    //    [self.imgHeader sd_setImageWithURL:[NSURL URLWithString:_model.avator] placeholderImage:nil];
    cell.imgHeader.image = [UIImage imageNamed:@"client_default_avatar"];
    cell.labName.text = [NSString stringWithFormat:@"%@-%@", model.operator[@"name"], model.assistRole];
    cell.labOrg.text = model.member[@"abbreviation"];
    cell.labPart.text = model.operator[@"title"];
    cell.labJob.text =  model.operator[@"department"][@"name"];

    cell.lineView.hidden = (indexPath.row == self.arrData.count - 1) ? YES : NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactDetailViewCtrl *vc = [[ContactDetailViewCtrl alloc] init];
    HelpPersonMo *mo = self.arrData[indexPath.row];
    JYUserMo *userMo = [[JYUserMo alloc] init];
    userMo.id = [mo.operator[@"id"] integerValue];
    vc.userMo = userMo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该记录？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [Utils showHUDWithStatus:nil];
            HelpPersonMo *model = self.arrData[indexPath.row];
            [[JYUserApi sharedInstance] deleteMemberAssistId:model.id param:nil success:^(id responseObject) {
                [Utils dismissHUD];
                [self.arrData removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
                [Utils showToastMessage:STRING(error.userInfo[@"message"])];
            }];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    CreateHelpListViewCtrl *vc = [[CreateHelpListViewCtrl alloc] init];
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(NSString *obj) {
        __strong typeof(self) strongself = weakself;
        [strongself getData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_B0;
        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = KMagrinBottom;
    }
    return _tableView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) _arrData = [NSMutableArray new];
    return _arrData;
}

                        ///
         /////////     ///
        ///   ///     ///
       ///   ///     ///
      ///   /////////////////
     ///   ///     ///
    ///   ///     ///
   /////////     ///
                ///



    ///////////  ///////////
           ///  ///     ///
          ///  ///////////
  //////////       ///
 ///          ///////////
//////////   ///  ///  ///
      ///    ///////////
///  ///        ///    ///
 //////   ////////////////






@end
