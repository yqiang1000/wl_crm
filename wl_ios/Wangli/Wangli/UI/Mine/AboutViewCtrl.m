
//
//  AboutViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/27.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "AboutViewCtrl.h"
#import "MyCommonCell.h"
#import "BaseWebViewCtrl.h"

@interface AboutViewCtrl () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *labCompany;
@property (nonatomic, strong) NSMutableArray *arrData;

@end

@implementation AboutViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.labCompany];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.labCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableView.mas_bottom).offset(-45);
        make.centerX.equalTo(self.tableView);
    }];
    
    [self getConfig];
}

- (void)getConfig {
    [[JYUserApi sharedInstance] getConfigDicByName:@"about_us" success:^(id responseObject) {
        NSError *error = nil;
        self.arrData = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 160;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        static NSString *identifier = @"topCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.backgroundColor = COLOR_B0;
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            imgView.layer.mask = [Utils drawContentFrame:imgView.bounds corners:UIRectCornerAllCorners cornerRadius:7];
            imgView.backgroundColor = COLOR_B2;
            imgView.image = [UIImage imageNamed:@"AppIcon"];
            [cell.contentView addSubview:imgView];
            
            UILabel *lab = [UILabel new];
            lab.text = self.arrLeft[indexPath.row];
            lab.font = FONT_F13;
            lab.textColor = COLOR_B2;
            [cell.contentView addSubview:lab];
            
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).offset(45);
                make.centerX.equalTo(cell.contentView);
                make.height.width.equalTo(@60);
            }];
            
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imgView.mas_bottom).offset(13);
                make.centerX.equalTo(cell.contentView);
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
    static NSString *identifier = @"suggestCell";
    MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.labLeft.textColor = COLOR_B1;
        cell.labLeft.font = FONT_F17;
        cell.labRight.textColor = COLOR_B2;
        cell.labRight.font = FONT_F17;
    }
    cell.lineView.hidden = NO;
    if (indexPath.row == self.arrLeft.count - 2) {
        cell.lineView.hidden = YES;
    }
    [cell setLeftText:self.arrLeft[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = COLOR_B0;
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseWebViewCtrl *vc = [[BaseWebViewCtrl alloc] init];
    if (indexPath.row == 0 || indexPath.row == 5 || self.arrData.count == 0) {
        return;
    }
    DicMo *tmpDic = self.arrData[indexPath.row - 1];
    NSString *urlStr = [NSString stringWithFormat:@"%@token=%@", tmpDic.value, [Utils token]];
    vc.titleStr = self.arrLeft[indexPath.row];
    vc.urlStr = urlStr;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - setter getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_B0;
    }
    return _tableView;
}

- (NSArray *)arrLeft {
    if (!_arrLeft) {
        NSString *string = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *name = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleDisplayName"];
        _arrLeft = @[[NSString stringWithFormat:@"%@ V%@", name, string],
                     @"功能介绍",
                     @"联系管理员",
                     @"常见问题",
                     @"版权信息",
                     [NSString stringWithFormat:@"%@ V%@", name, string]];
    }
    return _arrLeft;
}

- (UILabel *)labCompany {
    if (!_labCompany) {
        _labCompany = [UILabel new];
        _labCompany.text = self.arrLeft[0];
        _labCompany.font = FONT_F13;
        _labCompany.textColor = COLOR_B2;
    }
    return _labCompany;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

@end
