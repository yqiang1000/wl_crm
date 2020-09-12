//
//  ServiceConsultationTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ServiceConsultationTableView.h"
#import "ServiceConsultationReplyCell.h"

@interface ServiceConsultationTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ServiceConsultationTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ServiceConsultationReplyCell";
    ServiceConsultationReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ServiceConsultationReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic = self.arrData[indexPath.row];
    [cell loadDataName:dic[@"name"] reply:dic[@"reply"] time:dic[@"time"] content:dic[@"content"]];
    cell.lineView.hidden = (indexPath.row == self.arrData.count-1) ? YES : NO;
    return cell;
}

#pragma mark - UITableViewDelegate

@end
