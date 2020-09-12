//
//  LinkManOfficeViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/1/3.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "LinkManOfficeViewCtrl.h"
#import "LinkManOfficeTableView.h"
#import "Node.h"

@interface LinkManOfficeViewCtrl () <LinkManOfficeTableViewDelegate>
{
    NSInteger _max_groupId;
}
@property (nonatomic, strong) NSMutableArray <LinkManOfficeMo *> *linkManOfficeMos;
@property (nonatomic, strong) LinkManOfficeTableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrNodes;
@property (nonatomic, strong) LinkManOfficeMo *selectMo;

@end

@implementation LinkManOfficeViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人事组织";
    self.leftBtn.hidden = NO;
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    [self setUI];
    [self getLinkManOffice];
}

#pragma mark - UI

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)linkManOfficeMoChangeNodes {
    // 公司模型
    LinkManOfficeMo *rootMo = [[LinkManOfficeMo alloc] init];
    rootMo.name = TheCustomer.customerMo.abbreviation;
    rootMo.memberId = TheCustomer.customerMo.id;
    rootMo.id = 0;
    rootMo.parentOfficeId = -1;
    rootMo.depth = 0;
    rootMo.totalCount = TheCustomer.customerMo.linkManTotalCount;
    rootMo.expand = YES;
    NSString *msg = (rootMo.totalCount == 0 ? @"" : [NSString stringWithFormat:@"(%ld)", (long)rootMo.totalCount]);
    Node *node0 = [[Node alloc] initWithParentId:rootMo.parentOfficeId nodeId:rootMo.id name:rootMo.name msg:msg url:nil depth:rootMo.depth expand:rootMo.expand isEnd:NO];
    node0.linkManOfficeMo = rootMo;
    [_arrNodes addObject:node0];
    
    _max_groupId = 0;
    for (LinkManOfficeMo *mo in self.linkManOfficeMos) {
        if (mo.parentOfficeId != 0) {
            // 有父节点
            __block LinkManOfficeMo *tmpMo = nil;
            [self.linkManOfficeMos enumerateObjectsUsingBlock:^(LinkManOfficeMo *obj, NSUInteger idx, BOOL *stop) {
                if (obj.id == mo.parentOfficeId) {
                    tmpMo = obj;
                    *stop = YES;
                }
            }];
            mo.depth = tmpMo.depth+1;
            mo.expand = NO;
        } else {
            // 没有父节点，但由于公司是根结点，parentId = -1，所以这里从0开始
            mo.parentOfficeId = 0;
            mo.depth = 1;
            mo.expand = NO;
            rootMo.totalCount = rootMo.totalCount + mo.totalCount;
        }
        NSString *msg = (rootMo.totalCount == 0 ? @"" : [NSString stringWithFormat:@"(%ld)", (long)rootMo.totalCount]);
        Node *node = [[Node alloc] initWithParentId:mo.parentOfficeId nodeId:mo.id name:mo.name msg:msg url:nil depth:mo.depth expand:mo.expand isEnd:NO];
        node.linkManOfficeMo = mo;
        NSLog(@"群组 父节点：%ld 当前节点：%ld, 组名：%@", mo.parentOfficeId, mo.id, mo.name);
        [self.arrNodes addObject:node];
        
        if (mo.id > _max_groupId) {
            _max_groupId = mo.id + 100;
        }
    }
//    node0.msg = [NSString stringWithFormat:@"(%ld人)", rootMo.totalCount];
    self.tableView.data = self.arrNodes;
}

- (void)getLinkManOffice {
    [[JYUserApi sharedInstance] getLinkManOfficeByMemberId:TheCustomer.customerMo.id success:^(id responseObject) {
        NSError *error = nil;
        self.linkManOfficeMos = [LinkManOfficeMo arrayOfModelsFromDictionaries:responseObject error:&error];
        [self linkManOfficeMoChangeNodes];
        NSLog(@"%@", error);
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - LinkManOfficeTableViewDelegate

- (void)linkManOfficeTableView:(LinkManOfficeTableView *)linkManOfficeTableView didSelectedNode:(Node *)node indexPath:(NSIndexPath *)indexPath {
    self.selectMo = node.linkManOfficeMo;
}

- (void)clickLeftButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickRightButton:(UIButton *)sender {
    if (!self.selectMo) {
        [Utils showToastMessage:@"需要选择一个部门"];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.updateSuccess) {
            self.updateSuccess(self.selectMo);
        }
    }];
}

#pragma mark - lazy

- (LinkManOfficeTableView *)tableView {
    if (!_tableView) {
        _tableView = [[LinkManOfficeTableView alloc] initWithFrame:CGRectZero withData:self.arrNodes];
        _tableView.linkManOfficeTableViewDelegate = self;
    }
    return _tableView;
}

- (NSMutableArray *)arrNodes {
    if (!_arrNodes) {
        _arrNodes = [NSMutableArray new];
    }
    return _arrNodes;
}

@end
