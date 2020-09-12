//
//  CreateBondInfoViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/11/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateBondInfoViewCtrl.h"
#import "MyCommonCell.h"

@interface CreateBondInfoViewCtrl () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) NSArray *arrLeft;
//@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSMutableArray *arrValues;

@end

@implementation CreateBondInfoViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self config];
}

//@property (nonatomic, copy) NSString <Optional> *bondNum; //债券编号
//@property (nonatomic, copy) NSString <Optional> *bondName; //债券名称
//@property (nonatomic, copy) NSString <Optional> *bondTimeLimit; //债劵期限
//@property (nonatomic, copy) NSString <Optional> *publishTimeStr; //债劵发行日
//@property (nonatomic, copy) NSString <Optional> *bondTradeTimeStr; //上市交易日

//@property (nonatomic, copy) NSString <Optional> *publishExpireTimeStr; //债劵到期日
//@property (nonatomic, copy) NSString <Optional> *bondStopTimeStr; //债劵摘牌日
//@property (nonatomic, copy) NSString <Optional> *planIssuedQuantity; //计划发行量(亿)
//@property (nonatomic, copy) NSString <Optional> *realIssuedQuantity; //实际发行量(亿)
//@property (nonatomic, copy) NSString <Optional> *bondType; //债券类型

//@property (nonatomic, copy) NSString <Optional> *calInterestType; //计息方式
//@property (nonatomic, copy) NSString <Optional> *creditRatingGov; //信用评级机构
//@property (nonatomic, copy) NSString <Optional> *debtRating; //债项评级
//@property (nonatomic, copy) NSString <Optional> *escrowAgent; //托管机构
//@property (nonatomic, copy) NSString <Optional> *exeRightTimeStr; //行权日期

//@property (nonatomic, copy) NSString <Optional> *exeRightType; //行权类型
//@property (nonatomic, copy) NSString <Optional> *faceInterestRate; //票面利率(%)
//@property (nonatomic, copy) NSString <Optional> *faceValue; //面值
//@property (nonatomic, copy) NSString <Optional> *flowRange; //流通范围
//@property (nonatomic, copy) NSString <Optional> *interestDiff; //利差(BP)

//@property (nonatomic, copy) NSString <Optional> *issuedPrice; //发行价格(元)
//@property (nonatomic, copy) NSString <Optional> *payInterestHZ; //付息频率
//@property (nonatomic, copy) NSString <Optional> *refInterestRate; //参考利率
//@property (nonatomic, copy) NSString <Optional> *deleted; //是否删除
//@property (nonatomic, copy) NSString <Optional> *remark; //备注
- (void)config {
    if (_bondInfoMo) {
        [self.arrValues replaceObjectAtIndex:0 withObject:[Utils saveToValues:_bondInfoMo.bondNum]];
        [self.arrValues replaceObjectAtIndex:1 withObject:[Utils saveToValues:_bondInfoMo.bondName]];
        [self.arrValues replaceObjectAtIndex:2 withObject:[Utils saveToValues:_bondInfoMo.bondTimeLimit]];
        [self.arrValues replaceObjectAtIndex:3 withObject:[Utils saveToValues:_bondInfoMo.publishTimeStr]];
        [self.arrValues replaceObjectAtIndex:4 withObject:[Utils saveToValues:_bondInfoMo.bondTradeTimeStr]];
        
        [self.arrValues replaceObjectAtIndex:5 withObject:[Utils saveToValues:_bondInfoMo.publishExpireTimeStr]];
        [self.arrValues replaceObjectAtIndex:6 withObject:[Utils saveToValues:_bondInfoMo.bondStopTimeStr]];
        [self.arrValues replaceObjectAtIndex:7 withObject:[Utils saveToValues:_bondInfoMo.planIssuedQuantity]];
        [self.arrValues replaceObjectAtIndex:8 withObject:[Utils saveToValues:_bondInfoMo.realIssuedQuantity]];
        [self.arrValues replaceObjectAtIndex:9 withObject:[Utils saveToValues:_bondInfoMo.bondType]];
        
        [self.arrValues replaceObjectAtIndex:10 withObject:[Utils saveToValues:_bondInfoMo.calInterestType]];
        [self.arrValues replaceObjectAtIndex:11 withObject:[Utils saveToValues:_bondInfoMo.creditRatingGov]];
        [self.arrValues replaceObjectAtIndex:12 withObject:[Utils saveToValues:_bondInfoMo.debtRating]];
        [self.arrValues replaceObjectAtIndex:13 withObject:[Utils saveToValues:_bondInfoMo.escrowAgent]];
        [self.arrValues replaceObjectAtIndex:14 withObject:[Utils saveToValues:_bondInfoMo.exeRightTimeStr]];
        
        [self.arrValues replaceObjectAtIndex:15 withObject:[Utils saveToValues:_bondInfoMo.exeRightType]];
        [self.arrValues replaceObjectAtIndex:16 withObject:[Utils saveToValues:_bondInfoMo.faceInterestRate]];
        [self.arrValues replaceObjectAtIndex:17 withObject:[Utils saveToValues:_bondInfoMo.faceValue]];
        [self.arrValues replaceObjectAtIndex:18 withObject:[Utils saveToValues:_bondInfoMo.flowRange]];
        [self.arrValues replaceObjectAtIndex:19 withObject:[Utils saveToValues:_bondInfoMo.interestDiff]];
        
        [self.arrValues replaceObjectAtIndex:20 withObject:[Utils getPriceFrom:_bondInfoMo.issuedPrice]];
        [self.arrValues replaceObjectAtIndex:21 withObject:[Utils saveToValues:_bondInfoMo.payInterestHZ]];
        [self.arrValues replaceObjectAtIndex:22 withObject:[Utils saveToValues:_bondInfoMo.refInterestRate]];
        [self.arrValues replaceObjectAtIndex:23 withObject:[Utils saveToValues:_bondInfoMo.remark]];
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
        _arrLeft = @[@"债券编号",
                     @"债券名称",
                     @"债劵期限",
                     @"债劵发行日",
                     @"上市交易日",
                     
                     @"债劵到期日",
                     @"债劵摘牌日",
                     @"计划发行量(亿)",
                     @"实际发行量(亿)",
                     @"债券类型",
                     
                     @"计息方式",
                     @"信用评级机构",
                     @"债项评级",
                     @"托管机构",
                     @"行权日期",
                     
                     @"行权类型",
                     @"票面利率(%)",
                     @"面值",
                     @"流通范围",
                     @"利差(BP)",
                     
                     @"发行价格(元)",
                     @"付息频率",
                     @"参考利率",
                     @"备注"];
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
