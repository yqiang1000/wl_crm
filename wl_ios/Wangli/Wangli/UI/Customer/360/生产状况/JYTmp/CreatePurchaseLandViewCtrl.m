//
//  CreatePurchaseLandViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/11/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreatePurchaseLandViewCtrl.h"
#import "MyCommonCell.h"
#import "BaseWebViewCtrl.h"

@interface CreatePurchaseLandViewCtrl () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) NSArray *arrLeft;
//@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSMutableArray *arrValues;

@end

@implementation CreatePurchaseLandViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self config];
}

//@property (nonatomic, copy) NSString <Optional> *purchaseLandNumber; //crm编号
//@property (nonatomic, copy) NSString <Optional> *assignee; //受让人
//@property (nonatomic, copy) NSString <Optional> *location; //宗地位置
//@property (nonatomic, copy) NSString <Optional> *signedDateStr; //签订日期
//@property (nonatomic, copy) NSString <Optional> *adminRegion; //行政区
//
//@property (nonatomic, copy) NSString <Optional> *dealPrice; //成交价款（万元）
//@property (nonatomic, copy) NSString <Optional> *elecSupervisorNo; //电子监管号
//@property (nonatomic, copy) NSString <Optional> *endTimeStr; //约定竣工时间
//@property (nonatomic, copy) NSString <Optional> *maxVolume; //最大容积率
//@property (nonatomic, copy) NSString <Optional> *minVolume; //最小容积率
//
//@property (nonatomic, copy) NSString <Optional> *parentCompany; //上级公司
//@property (nonatomic, copy) NSString <Optional> *purpose; //土地用途
//@property (nonatomic, copy) NSString <Optional> *startTimeStr; //约定动工时间
//@property (nonatomic, copy) NSString <Optional> *supplyWay; //供应方式
//@property (nonatomic, copy) NSString <Optional> *totalArea; //供地总面积(公顷)
//
//@property (nonatomic, copy) NSString <Optional> *updateTimeStr; //更新时间
//@property (nonatomic, copy) NSString <Optional> *linkUrl; //链接
- (void)config {
    if (_purchaseMo) {
        [self.arrValues replaceObjectAtIndex:0 withObject:[Utils saveToValues:_purchaseMo.purchaseLandNumber]];
        [self.arrValues replaceObjectAtIndex:1 withObject:[Utils saveToValues:_purchaseMo.assignee]];
        [self.arrValues replaceObjectAtIndex:2 withObject:[Utils saveToValues:_purchaseMo.location]];
        [self.arrValues replaceObjectAtIndex:3 withObject:[Utils saveToValues:_purchaseMo.signedDateStr]];
        [self.arrValues replaceObjectAtIndex:4 withObject:[Utils saveToValues:_purchaseMo.adminRegion]];
        
        [self.arrValues replaceObjectAtIndex:5 withObject:[Utils saveToValues:_purchaseMo.dealPrice]];
        [self.arrValues replaceObjectAtIndex:6 withObject:[Utils saveToValues:_purchaseMo.elecSupervisorNo]];
        [self.arrValues replaceObjectAtIndex:7 withObject:[Utils saveToValues:_purchaseMo.endTimeStr]];
        [self.arrValues replaceObjectAtIndex:8 withObject:[Utils saveToValues:_purchaseMo.maxVolume]];
        [self.arrValues replaceObjectAtIndex:9 withObject:[Utils saveToValues:_purchaseMo.minVolume]];
        
        [self.arrValues replaceObjectAtIndex:10 withObject:[Utils saveToValues:_purchaseMo.parentCompany]];
        [self.arrValues replaceObjectAtIndex:11 withObject:[Utils saveToValues:_purchaseMo.purpose]];
        [self.arrValues replaceObjectAtIndex:12 withObject:[Utils saveToValues:_purchaseMo.startTimeStr]];
        [self.arrValues replaceObjectAtIndex:13 withObject:[Utils saveToValues:_purchaseMo.supplyWay]];
        [self.arrValues replaceObjectAtIndex:14 withObject:[Utils saveToValues:_purchaseMo.totalArea]];
        
        [self.arrValues replaceObjectAtIndex:15 withObject:[Utils saveToValues:_purchaseMo.updateTimeStr]];
        [self.arrValues replaceObjectAtIndex:16 withObject:[Utils saveToValues:_purchaseMo.linkUrl]];
    }
    [self.tableView reloadData];
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
    return self.arrLeft.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"commonCell";
    MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setLeftText:self.arrLeft[indexPath.row]];
    ShowTextMo *showTextMo = [Utils showTextRightStr:@"暂无" valueStr: self.arrValues[indexPath.row]];
    cell.labRight.textColor = showTextMo.color;
    cell.labRight.text = showTextMo.text;
    cell.labLeft.textColor = COLOR_B1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.arrLeft.count-1) {
        NSString *url = self.arrValues[indexPath.row];
        if (url.length != 0) {
            BaseWebViewCtrl *vc = [[BaseWebViewCtrl alloc] init];
            vc.urlStr = url;
            vc.titleStr = @"中国土地市场网";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - setter getter

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

- (NSArray *)arrLeft {
    if (!_arrLeft) {
        _arrLeft = @[@"crm编号",
                     @"受让人",
                     @"宗地位置",
                     @"签订日期",
                     @"行政区",
                     
                     @"成交价款（万元",
                     @"电子监管号",
                     @"约定竣工时间",
                     @"最大容积率",
                     @"最小容积率",
                     
                     @"上级公司",
                     @"土地用途",
                     @"约定动工时间",
                     @"供应方式",
                     @"供地总面积(公顷)",
                     
                     @"更新时间",
                     @"链接"];
    }
    return _arrLeft;
}

//- (NSArray *)arrRight {
//    if (!_arrRight) {
//        _arrRight = @[@"暂无",
//                      @"暂无",
//                      @"暂无",
//                      @"暂无",
//                      @"暂无"];
//    }
//    return _arrRight;
//}

- (NSMutableArray *)arrValues {
    if (!_arrValues) {
        _arrValues = [NSMutableArray new];
        for (int i = 0; i < self.arrLeft.count; i++) {
            [_arrValues addObject:@"demo"];
        }
    }
    return _arrValues;
}

@end
