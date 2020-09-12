//
//  PermissionSelectViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/3/7.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "PermissionSelectViewCtrl.h"
#import "PermissionTableView.h"
#import "Node.h"

@interface PermissionSelectViewCtrl ()

{
    NSInteger _max_groupId;
}
@property (nonatomic, strong) PermissionTableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrDepart;
@property (nonatomic, strong) NSMutableArray *arrNodes;

@end

@implementation PermissionSelectViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请选择部门";
    [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self setUI];
    [self loadData];
}

#pragma mark - ui

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - network

- (void)loadData {
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] getDepartmentSuccess:^(id responseObject) {
        [Utils dismissHUD];
        self.arrDepart = [GroupMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:nil];
        [self groupMoChangeNodes];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)groupMoChangeNodes {
    _max_groupId = 0;
    Node *node0 = [[Node alloc] initWithParentId:-1 nodeId:0 name:@"浙江王力集团有限公司" msg:@"" url:@"cn_address_book_company" depth:0 expand:YES isEnd:NO];
    [_arrNodes addObject:node0];
    
    for (GroupMo *mo in self.arrDepart) {
        if (mo.parent) {
            // 有父节点
            mo.parentId = [mo.parent[@"id"] integerValue];
            GroupMo *tmpMo = [[GroupMo alloc] initWithDictionary:mo.parent error:nil];
            NSInteger depth = 2;
            while (tmpMo.parent) {
                tmpMo = [[GroupMo alloc] initWithDictionary:tmpMo.parent error:nil];
                depth++;
            }
            mo.depth = depth;
            mo.expand = NO;
        } else {
            // 没有父节点，但由于爱旭公司是根结点，parentId = -1，所以这里从0开始
            mo.parentId = 0;
            mo.depth = 1;
            mo.expand = NO;
        }
        
        NSInteger totalCount = [mo.totalCount integerValue];
        NSString *msg = (totalCount == 0 ? @"" : [NSString stringWithFormat:@"(%ld)", (long)totalCount]);
        
        Node *node = [[Node alloc] initWithParentId:mo.parentId nodeId:mo.id name:mo.name msg:msg url:nil depth:mo.depth expand:mo.expand isEnd:NO];
        node.groupMo = mo;
        NSLog(@"群组 父节点：%ld 当前节点：%ld, 组名：%@", mo.parentId, mo.id, mo.name);
        
        if ([self.arrDefault containsObject:@(mo.id)]) {
            node.isSelect = YES;
        }
        
        [self.arrNodes addObject:node];
    }
    self.tableView.data = self.arrNodes;
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    NSMutableArray *groups = [NSMutableArray new];
    
    for (Node *node in self.arrNodes) {
        if (node.isSelect && node.nodeId != 0) {
            if (node.groupMo) {
                [groups addObject:node.groupMo];
            }
        }
    }
    if (groups.count == 0) {
        [Utils showToastMessage:@"请至少选择一个部门"];
        return;
    }
    if (self.updateSuccess) {
        self.updateSuccess(groups);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazy

- (PermissionTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PermissionTableView alloc] initWithFrame:CGRectZero withData:self.arrNodes];
//        _tableView.treeTableCellDelegate = self;
    }
    return _tableView;
}

- (NSMutableArray *)arrNodes {
    if (!_arrNodes) _arrNodes = [NSMutableArray new];
    return _arrNodes;
}

- (NSMutableArray *)arrDepart {
    if (!_arrDepart) _arrDepart = [NSMutableArray new];
    return _arrDepart;
}

- (NSMutableArray *)arrDefault {
    if (!_arrDefault) _arrDefault = [NSMutableArray new];
    return _arrDefault;
}

@end
