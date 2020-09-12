//
//  TreeTableView.m
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "TreeTableView.h"
#import "Node.h"
#import "TreeTableViewCell.h"

@interface TreeTableView ()<UITableViewDataSource,UITableViewDelegate>

//@property (nonatomic , strong) NSArray *data;//传递过来已经组织好的数据（全量数据）

@property (nonatomic , strong) NSMutableArray *tempData;//用于存储数据源（部分数据）


@end

@implementation TreeTableView

-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.sectionHeaderHeight = 0;
        self.sectionFooterHeight = 0;
//        _data = data;
//        _tempData = [self createTempData:data];
    }
    return self;
}

- (void)setData:(NSArray *)data {
    _data = data;
    _tempData = [self createTempData:data];
    [self reloadData];
}

/**
 * 初始化数据源
 */
-(NSMutableArray *)createTempData : (NSArray *)data{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<data.count; i++) {
        Node *node = [_data objectAtIndex:i];
        if (node.expand) {
            [tempArray addObject:node];
        }
    }
    return tempArray;
}


#pragma mark - UITableViewDataSource

#pragma mark - Required

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tempData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *NODE_CELL_ID = @"node_cell_id";
    
    TreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
    if (!cell) {
        cell = [[TreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
    }
    
    Node *node = [_tempData objectAtIndex:indexPath.row];
    
    NSLog(@"expand---%d" , node.expand);
    
    // cell有缩进的方法
//    cell.indentationLevel = node.depth; // 缩进级别
//    cell.indentationWidth = 30.f; // 每个缩进级别的距离

    
//    NSMutableString *name = [NSMutableString string];
//    for (int i=0; i<node.depth; i++) {
//        [name appendString:@"     "];
//    }
//    [name appendString:node.name];
    
//    cell.textLabel.text = node.name;
//    cell.labTitle.text = node.name;
//    cell.labMsg.text = node.msg;

    [cell loadDataWith:self.tempData[indexPath.row]];
    
    return cell;
}


#pragma mark - Optional
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Node *node = [_tempData objectAtIndex:indexPath.row];
    return node.isEnd ? 55 : 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UITableViewDelegate

#pragma mark - Optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //先修改数据源
    Node *parentNode = [_tempData objectAtIndex:indexPath.row];
    if (!parentNode.isEnd) {
        parentNode.isOpen = !parentNode.isOpen;
    }
    
    if (_treeTableCellDelegate && [_treeTableCellDelegate respondsToSelector:@selector(cellClick:)]) {
        [_treeTableCellDelegate cellClick:parentNode];
    }
    
    NSUInteger startPosition = indexPath.row+1;
    NSUInteger endPosition = startPosition;
    BOOL expand = NO;
    for (int i=0; i<_data.count; i++) {
        // 遍历原始数据
        Node *node = [_data objectAtIndex:i];
        // 如果node的父节点和当前的节点一样，则修改他的展开状态
        if (node.parentId == parentNode.nodeId) {
            node.expand = !node.expand;
            // 如果展开，则插入_tempData中 当前元素的下一个
            if (node.expand) {
                [_tempData insertObject:node atIndex:endPosition];
                expand = YES;
                endPosition++;
            }else{
                // 如果收缩，则将_tempData移除 以当前节点为父节点的 node
                expand = NO;
                endPosition = [self removeAllNodesAtParentNode:parentNode];
                break;
            }
        }
    }
    
    //获得需要修正的indexPath
    NSMutableArray *indexPathArray = [NSMutableArray array];
    
    for (NSUInteger i=startPosition; i<endPosition; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArray addObject:tempIndexPath];
//        if (!parentNode.isOpen) {
//            Node *node = [_tempData objectAtIndex:i];
//            node.isOpen = NO;
//        }
    }

    //插入或者删除相关节点
    // indexPathArray判空操作
    if (expand) {
        if (indexPathArray.count > 0) {
            [self insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        }
    }else{
        if (indexPathArray.count > 0) {
            [self deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    if (indexPathArray.count > 0) {
        [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

/**
 *  删除该父节点下的所有子节点（包括孙子节点）
 *
 *  @param parentNode 父节点
 *
 *  @return 该父节点下一个相邻的统一级别的节点的位置
 */
-(NSUInteger)removeAllNodesAtParentNode : (Node *)parentNode{
    NSUInteger startPosition = [_tempData indexOfObject:parentNode];
    NSUInteger endPosition = startPosition;
    for (NSUInteger i=startPosition+1; i<_tempData.count; i++) {
        Node *node = [_tempData objectAtIndex:i];
        endPosition++;
        if (node.depth <= parentNode.depth) {
            break;
        }
        if(endPosition == _tempData.count-1){
            endPosition++;
            node.expand = NO;
            node.isOpen = NO;
            break;
        }
        node.isOpen = NO;
        node.expand = NO;
    }
    if (endPosition>startPosition) {
        [_tempData removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition-1)];
    }
    return endPosition;
}

@end