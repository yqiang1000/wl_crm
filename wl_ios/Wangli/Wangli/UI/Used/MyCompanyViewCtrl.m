//
//  MyCompanyViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "MyCompanyViewCtrl.h"
#import "TreeTableView.h"
#import "Node.h"
#import "GroupMo.h"
#import "ContactDetailViewCtrl.h"

@interface MyCompanyViewCtrl () <TreeTableCellDelegate>
{
    NSInteger _max_groupId;
}
@property (nonatomic, strong) TreeTableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrDepart;
@property (nonatomic, strong) NSMutableArray *arrPerson;
@property (nonatomic, strong) NSMutableArray *arrNodes;

@end

@implementation MyCompanyViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
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
        self.arrDepart = [GroupMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:nil];
        [self groupMoChangeNodes];
        [self getPerson];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getPerson {
    [[JYUserApi sharedInstance] getDepartmentPersonRules:nil success:^(id responseObject) {
        [Utils dismissHUD];
        NSError *error = nil;
        self.arrPerson = [JYUserMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        [self personMoChangeNodes];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)groupMoChangeNodes {
    _max_groupId = 0;
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
        [self.arrNodes addObject:node];
        
        if (mo.id > _max_groupId) {
            _max_groupId = mo.id + 100;
        }
    }
    self.tableView.data = self.arrNodes;
}

- (void)personMoChangeNodes {
    
    Node *node0 = [[Node alloc] initWithParentId:-1 nodeId:0 name:@"浙江王力集团有限公司" msg:[NSString stringWithFormat:@"(%ld人)", self.arrPerson.count] url:@"cn_address_book_company" depth:0 expand:YES isEnd:NO];
    [_arrNodes addObject:node0];
    
    NSInteger nodeId = self.arrNodes.count + _max_groupId;
    for (JYUserMo *mo in self.arrPerson) {
        if (mo.department) {
            // 有父节点
            GroupMo *groupMo = [[GroupMo alloc] initWithDictionary:mo.department error:nil];
            mo.parentId = groupMo.id;
            [self.arrDepart enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                // 获取 group的id为当前父节点的group
                // 深度+1
                GroupMo *tmpMo = ((GroupMo *)obj);
                if(tmpMo.id == mo.parentId) {
                    mo.depth = tmpMo.depth + 1;
                    *stop = YES;
                }
            }];
        } else {
            // 该用户没有部门（一般不会出现，department是必传的，没有的话，就把该用户挂在公司节点下面）
            mo.parentId = -1;
            mo.depth = 1;
            mo.expand = YES;
        }
        
        Node *node = [[Node alloc] initWithParentId:mo.parentId nodeId:nodeId name:mo.name msg:STRING(mo.position[@"desp"]) url:mo.avatarUrl depth:mo.depth expand:mo.expand isEnd:YES];
        node.userMo = mo;
        NSLog(@"用户 父节点：%ld 当前节点：%ld， 姓名：%@", mo.parentId, nodeId, mo.name);
        [self.arrNodes addObject:node];
        nodeId++;
    }
    self.tableView.data = self.arrNodes;
}

#pragma mark - TreeTableCellDelegate

- (void)cellClick:(Node *)node {
    if (node.isEnd) {
        ContactDetailViewCtrl *vc = [[ContactDetailViewCtrl alloc] init];
        vc.userMo = node.userMo;
        [self.navigationController pushViewController:vc animated:YES];
//        NSLog(@"%@", node.userMo);
    }
}

#pragma mark - event

- (void)clickLeftButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setter getter

- (NSMutableArray *)arrDepart {
    if (!_arrDepart) {
        _arrDepart = [NSMutableArray new];
    }
    return _arrDepart;
}

- (NSMutableArray *)arrNodes {
    if (!_arrNodes) {
        _arrNodes = [NSMutableArray new];
    }
    return _arrNodes;
}

- (NSMutableArray *)arrPerson {
    if (!_arrPerson) {
        _arrPerson = [NSMutableArray new];
    }
    return _arrPerson;
}

- (TreeTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TreeTableView alloc] initWithFrame:CGRectZero withData:self.arrNodes];
        _tableView.treeTableCellDelegate = self;
    }
    return _tableView;
}

@end
