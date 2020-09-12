//
//  DropDownButton.m
//  Wangli
//
//  Created by yeqiang on 2018/12/18.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "DropDownButton.h"

static NSString *CellIdentifier = @"DropDownCell";

@interface DropDownButton () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) UIButton *btnArrow;

@end
    
@implementation DropDownButton

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString*)title List:(NSArray *)list {
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        self.list = list;
        self.titleLabel.font = FONT_F16;
        [self setUI];
    }
    
    return self;
}

- (void)setUI {
    [self setTitleColor:COLOR_B1 forState:UIControlStateNormal];
    [self setTitle:self.title forState:UIControlStateNormal];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self addTarget:self action:@selector(clickedToDropDown:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnArrow];
    
    [self.btnArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-5);
        make.height.equalTo(self);
        make.width.equalTo(@10.0);
    }];
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //设置列表中的每一项文本、字体、颜色等
    cell.textLabel.text = self.list[indexPath.row];
    cell.textLabel.font = self.titleLabel.font;
    cell.textLabel.textColor = self.titleLabel.textColor;
    
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //选择某项后，使按钮标题内容变为当前选项
    [self setTitle:self.list[indexPath.row] forState:UIControlStateNormal];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    //执行列表收起动画
    [self clickedToDropDown:nil];
    if (_btnDelegate && [_btnDelegate respondsToSelector:@selector(dropDownButton:didSelectIndex:)]) {
        [_btnDelegate dropDownButton:self didSelectIndex:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //设置表单元高度为按钮高度
    return self.frame.size.height;
}

- (void)startDropDownAnimation {
    self.selected = YES;
    self.btnArrow.selected = self.selected;
    //使listView高度在0.3秒内从0过渡到最大高度以显示全部列表项
//    [self.superview.superview addSubview:self.listView];
    [[Utils topViewController].view addSubview:self.listView];
    [UIView animateWithDuration:0.3 animations:^{
        [self.listView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.frame.size.height*(self.list.count>8?8:self.list.count)));
            make.top.equalTo(self.mas_bottom);
            make.left.right.equalTo(self);
        }];
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.isShow = YES;
    }];
    if (_btnDelegate && [_btnDelegate respondsToSelector:@selector(dropDownButtonBeginEdit:)]) {
        [_btnDelegate dropDownButtonBeginEdit:self];
    }
}

- (void)startPackUpAnimation {
    self.selected = NO;
    self.btnArrow.selected = self.selected;
    //使listView高度在0.3秒内从最大高度过渡到0以隐藏全部列表项
    [UIView animateWithDuration:0.3 animations:^{
        [self.listView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.0);
            make.top.equalTo(self.mas_bottom);
            make.left.right.equalTo(self);
        }];
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.listView removeFromSuperview];
        _listView = nil;
        self.isShow = NO;
    }];
}

- (void)clickedToDropDown:(UIButton *)sender {
    self.selected = !self.selected;
    self.selected ? [self startDropDownAnimation] : [self startPackUpAnimation];
    self.btnArrow.selected = self.selected;
    [self.listView reloadData];
}

- (void)btnArrowClick:(UIButton *)sender {
    [self clickedToDropDown:self];
    sender.selected = self.selected;
}

- (UITableView *)listView {
    if (!_listView) {
        //将listView放在当前按钮下方位置，保持宽度相同，初始高度设置为0
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+self.frame.size.height, self.frame.size.width, 0) style:UITableViewStylePlain];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.layer.borderColor = COLOR_LINE.CGColor;
        _listView.layer.borderWidth = 0.5;
    }
    return _listView;
}

- (NSArray *)list {
    return [_btnDelegate listForDropDownButton:self];
}

- (UIButton *)btnArrow {
    if (!_btnArrow) {
        _btnArrow = [[UIButton alloc] init];
        [_btnArrow setImage:[UIImage imageNamed:@"client_down_n"] forState:UIControlStateNormal];
        [_btnArrow setImage:[UIImage imageNamed:@"drop_down_s"] forState:UIControlStateSelected];
        [_btnArrow addTarget:self action:@selector(btnArrowClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnArrow;
}


@end
