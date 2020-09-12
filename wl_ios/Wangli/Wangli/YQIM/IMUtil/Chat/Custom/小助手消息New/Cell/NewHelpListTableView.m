//
//  NewHelpListTableView.m
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "NewHelpListTableView.h"
#import "NewHelpListCell.h"

@interface NewHelpListTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation NewHelpListTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 38;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"NewHelpListCell";
    
    NewHelpListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NewHelpListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadDataWith:self.arrData[indexPath.row]];
    return cell;
}

#pragma mark - setter getter


@end
