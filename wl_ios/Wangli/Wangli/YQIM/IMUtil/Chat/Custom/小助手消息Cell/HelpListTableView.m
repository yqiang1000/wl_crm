//
//  HelpListTableView.m
//  HangGuo
//
//  Created by yeqiang on 2020/2/6.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "HelpListTableView.h"
#import "HelperItemCell.h"

@interface HelpListTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation HelpListTableView

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
    static NSString *identifier = @"HelperItemCell";
    
    HelperItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HelperItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadDataWith:self.arrData[indexPath.row]];
    return cell;
}
@end
