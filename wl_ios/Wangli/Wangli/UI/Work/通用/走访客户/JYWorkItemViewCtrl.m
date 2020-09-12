//
//  JYWorkItemViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/8/27.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import "JYWorkItemViewCtrl.h"
#import "QiniuFileMo.h"

@interface JYWorkItemViewCtrl ()

@property (nonatomic, strong) CommonRowMo *memberRowMo;
@property (nonatomic, strong) CommonRowMo *typeRowMo;
@property (nonatomic, strong) CommonRowMo *contRowMo;
@property (nonatomic, strong) CommonRowMo *attRowMo;
@property (nonatomic, strong) CommonRowMo *visitRowMo;
@property (nonatomic, strong) CommonRowMo *monopolyRowMo;
@property (nonatomic, strong) CommonRowMo *completeRowMo;
@property (nonatomic, strong) CommonRowMo *compareRowMo;
@property (nonatomic, strong) CommonRowMo *publicRowMo;
@property (nonatomic, strong) CommonRowMo *trainRowMo;
@property (nonatomic, strong) CommonRowMo *engineerRowMo;

@property (nonatomic, copy) NSString *dicKey;

@end

@implementation JYWorkItemViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"走访客户";
    self.forbidEdit = self.afterDate;
    self.rightBtn.hidden = self.afterDate;
}

- (void)configRowMos {
    [self.arrData removeAllObjects];
    self.arrData = nil;
    
    NSError *error = nil;
    CustomerMo *memberMo = [[CustomerMo alloc] initWithDictionary:self.itemMo.member error:&error];
    self.memberRowMo.m_obj = memberMo;
    self.memberRowMo.strValue = self.itemMo.member[@"orgName"];
    self.memberRowMo.member = memberMo;
    
    DicMo *attributeMo = [[DicMo alloc] initWithDictionary:self.itemMo.memberAttribute error:&error];
    self.typeRowMo.m_obj = attributeMo;
    self.typeRowMo.singleValue = (DicMo<DicMo,Optional> *) attributeMo;
    
    self.attRowMo.attachments = (NSMutableArray<QiniuFileMo *><QiniuFileMo,Optional> *)self.itemMo.attachments;
    
    [self dealWithRowMos];
}

- (void)dealWithRowMos {
    DicMo *dicMo = self.typeRowMo.singleValue;
    
    if ([dicMo.key isEqualToString:self.dicKey]) {
        return;
    }
    self.dicKey = dicMo.key;
    
    // 工程零售
    if ([dicMo.key isEqualToString:@"project_retail"]) {
        [self.arrData removeAllObjects];
        [self.arrData addObject:self.memberRowMo];
        [self.arrData addObject:self.typeRowMo];
        [self.arrData addObject:self.visitRowMo];
        [self.arrData addObject:self.monopolyRowMo];
        [self.arrData addObject:self.completeRowMo];
        [self.arrData addObject:self.compareRowMo];
        [self.arrData addObject:self.publicRowMo];
        [self.arrData addObject:self.trainRowMo];
        [self.arrData addObject:self.engineerRowMo];
        
        if (self.itemMo.comparativeSales) {
            [self.arrData addObject:self.attRowMo];
        } else {
            [self.arrData addObject:self.contRowMo];
        }
    }
    // 零售
    else if ([dicMo.key isEqualToString:@"retail"]) {
        [self.arrData removeAllObjects];
        [self.arrData addObject:self.memberRowMo];
        [self.arrData addObject:self.typeRowMo];
        [self.arrData addObject:self.visitRowMo];
        [self.arrData addObject:self.monopolyRowMo];
        [self.arrData addObject:self.completeRowMo];
        [self.arrData addObject:self.compareRowMo];
        [self.arrData addObject:self.publicRowMo];
        [self.arrData addObject:self.trainRowMo];
        
        if (self.itemMo.comparativeSales) {
            [self.arrData addObject:self.attRowMo];
        } else {
            [self.arrData addObject:self.contRowMo];
        }
    }
    // 工程
    else if ([dicMo.key isEqualToString:@"project"]) {
        [self.arrData removeAllObjects];
        [self.arrData addObject:self.memberRowMo];
        [self.arrData addObject:self.typeRowMo];
        [self.arrData addObject:self.engineerRowMo];
    } else {
        [self.arrData removeAllObjects];
        [self.arrData addObject:self.memberRowMo];
        [self.arrData addObject:self.typeRowMo];
        [self.arrData addObject:self.engineerRowMo];
    }
    [self.tableView reloadData];
}


#pragma mark - event

- (void)continueTodo:(NSString *)toDo selName:(NSString *)selName indexPath:(NSIndexPath *)indexPath {
    if ([toDo isEqualToString:@"comparativeSales"]) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        if (rowMo.defaultValue) {
            if ([self.arrData containsObject:self.contRowMo]) [self.arrData removeObject:self.contRowMo];
            if (![self.arrData containsObject:self.attRowMo]) [self.arrData addObject:self.attRowMo];
        } else {
            if ([self.arrData containsObject:self.attRowMo]) [self.arrData removeObject:self.attRowMo];
            if (![self.arrData containsObject:self.contRowMo]) [self.arrData addObject:self.contRowMo];
        }
        [self.tableView reloadData];
    } else if ([toDo isEqualToString:@"memberAttribute"]) {
        [self dealWithRowMos];
    }
}

- (void)createParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    [self updateParams:params attachementList:attachementList];
}

- (void)updateParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    [Utils dismissHUD];
    //    NSMutableArray *arr = [NSMutableArray new];
    //    for (QiniuFileMo *tmpMo in attachementList) {
    //        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[tmpMo toDictionary]];
    //        [arr addObject:dic];
    //    }
    self.itemMo.attachments = attachementList;
    for (CommonRowMo *rowMo in self.arrData) {
        if ([rowMo.key isEqualToString:@"member"]) {
            CustomerMo *member = (CustomerMo *)rowMo.member;
            NSMutableDictionary *memberDic = [NSMutableDictionary new];
            [memberDic setObject:@(member.id) forKey:@"id"];
            [memberDic setObject:STRING(member.orgName) forKey:@"orgName"];
            self.itemMo.member = memberDic;
        } else if ([rowMo.key isEqualToString:@"memberAttribute"]) {
            self.itemMo.visit = rowMo.defaultValue;
            DicMo *dic = rowMo.singleValue;
            self.itemMo.memberAttribute = [dic toDictionary];
        } else if ([rowMo.key isEqualToString:@"visit"]) {
            self.itemMo.visit = rowMo.defaultValue;
        } else if ([rowMo.key isEqualToString:@"monopoly"]) {
            self.itemMo.monopoly = rowMo.defaultValue;
        } else if ([rowMo.key isEqualToString:@"complete"]) {
            self.itemMo.complete = rowMo.defaultValue;
        } else if ([rowMo.key isEqualToString:@"comparativeSales"]) {
            self.itemMo.comparativeSales = rowMo.defaultValue;
        } else if ([rowMo.key isEqualToString:@"policyProcessAdvocacy"]) {
            self.itemMo.policyProcessAdvocacy = rowMo.defaultValue;
        } else if ([rowMo.key isEqualToString:@"train"]) {
            self.itemMo.train = rowMo.defaultValue;
        } else if ([rowMo.key isEqualToString:@"content"]) {
            self.itemMo.content = rowMo.strValue;
        } else if ([rowMo.key isEqualToString:@"engineerProcessingMatters"]) {
            self.itemMo.engineerProcessingMatters = rowMo.strValue;
        }
    }
    if (self.updateSuccess) self.updateSuccess(self.itemMo);
    [self.navigationController popViewControllerAnimated:YES];
}

- (JYWorkItemMo *)itemMo {
    if (!_itemMo) _itemMo = [[JYWorkItemMo alloc] init];
    return _itemMo;
}

- (CommonRowMo *)memberRowMo {
    if (!_memberRowMo) {
        _memberRowMo = [[CommonRowMo alloc] init];
        _memberRowMo.rowType = K_INPUT_MEMBER;
        _memberRowMo.leftContent = @"客户";
        _memberRowMo.inputType = K_SHORT_TEXT;
        _memberRowMo.rightContent = @"请选择";
        _memberRowMo.editAble = !self.afterDate;
        _memberRowMo.key = @"member";
    }
    return _memberRowMo;
}

- (CommonRowMo *)typeRowMo {
    if (!_typeRowMo) {
        _typeRowMo = [[CommonRowMo alloc] init];
        _typeRowMo.rowType = K_INPUT_SELECT;
        _typeRowMo.leftContent = @"客户属性";
        _typeRowMo.inputType = K_SHORT_TEXT;
        _typeRowMo.rightContent = @"请选择";
        _typeRowMo.key = @"memberAttribute";
        _typeRowMo.editAble = !self.afterDate;
        _typeRowMo.dictName = @"member_attribute";
        _typeRowMo.strValue = self.itemMo.memberAttribute[@"value"];
    }
    return _typeRowMo;
}

- (CommonRowMo *)attRowMo {
    if (!_attRowMo) {
        _attRowMo = [[CommonRowMo alloc] init];
        _attRowMo.rowType = K_FILE_INPUT;
        _attRowMo.leftContent = @"相关附件";
        _attRowMo.inputType = K_SHORT_TEXT;
        _attRowMo.key = @"attachments";
        _attRowMo.editAble = self.handleDate;
        _attRowMo.nullAble = YES;
    }
    return _attRowMo;
}

- (CommonRowMo *)contRowMo {
    if (!_contRowMo) {
        _contRowMo = [[CommonRowMo alloc] init];
        _contRowMo.rowType = K_INPUT_TEXT;
        _contRowMo.leftContent = @"内容";
        _contRowMo.inputType = K_LONG_TEXT;
        _contRowMo.rightContent = @"请输入";
        _contRowMo.editAble = self.handleDate;
        _contRowMo.nullAble = YES;
        _contRowMo.key = @"content";
        _contRowMo.strValue = self.itemMo.content;
    }
    return _contRowMo;
}

- (CommonRowMo *)visitRowMo {
    if (!_visitRowMo) {
        _visitRowMo = [[CommonRowMo alloc] init];
        _visitRowMo.rowType = K_INPUT_TOGGLEBUTTON;
        _visitRowMo.leftContent = @"是否走访";
        _visitRowMo.inputType = K_SHORT_TEXT;
        _visitRowMo.rightContent = @"请选择";
        _visitRowMo.editAble = self.handleDate;
        _visitRowMo.defaultValue = self.itemMo.visit;
        _visitRowMo.strValue = self.itemMo.visit ? @"YES" : @"NO";
        _visitRowMo.key = @"visit";
    }
    return _visitRowMo;
}

- (CommonRowMo *)monopolyRowMo {
    if (!_monopolyRowMo) {
        _monopolyRowMo = [[CommonRowMo alloc] init];
        _monopolyRowMo.rowType = K_INPUT_TOGGLEBUTTON;
        _monopolyRowMo.leftContent = @"是否专卖/专营";
        _monopolyRowMo.inputType = K_SHORT_TEXT;
        _monopolyRowMo.rightContent = @"请选择";
        _monopolyRowMo.editAble = self.handleDate;
        _monopolyRowMo.defaultValue = self.itemMo.monopoly;
        _monopolyRowMo.strValue = self.itemMo.monopoly?@"YES":@"NO";
        _monopolyRowMo.key = @"monopoly";
    }
    return _monopolyRowMo;
}

- (CommonRowMo *)completeRowMo {
    if (!_completeRowMo) {
        _completeRowMo = [[CommonRowMo alloc] init];
        _completeRowMo.rowType = K_INPUT_TOGGLEBUTTON;
        _completeRowMo.leftContent = @"基本款上样是否齐全";
        _completeRowMo.inputType = K_SHORT_TEXT;
        _completeRowMo.rightContent = @"请选择";
        _completeRowMo.editAble = self.handleDate;
        _completeRowMo.defaultValue = self.itemMo.complete;
        _completeRowMo.strValue = self.itemMo.complete?@"YES":@"NO";
        _completeRowMo.key = @"complete";
    }
    return _completeRowMo;
}

- (CommonRowMo *)compareRowMo {
    if (!_compareRowMo) {
        _compareRowMo = [[CommonRowMo alloc] init];
        _compareRowMo.rowType = K_INPUT_TOGGLEBUTTON;
        _compareRowMo.leftContent = @"对比销售";
        _compareRowMo.inputType = K_SHORT_TEXT;
        _compareRowMo.rightContent = @"请选择";
        _compareRowMo.editAble = self.handleDate;
        _compareRowMo.defaultValue = self.itemMo.comparativeSales;
        _compareRowMo.strValue = self.itemMo.comparativeSales?@"YES":@"NO";
        _compareRowMo.key = @"comparativeSales";
    }
    return _compareRowMo;
}

- (CommonRowMo *)publicRowMo {
    if (!_publicRowMo) {
        _publicRowMo = [[CommonRowMo alloc] init];
        _publicRowMo.rowType = K_INPUT_TOGGLEBUTTON;
        _publicRowMo.leftContent = @"政策流程宣导";
        _publicRowMo.inputType = K_SHORT_TEXT;
        _publicRowMo.rightContent = @"请选择";
        _publicRowMo.editAble = self.handleDate;
        _publicRowMo.defaultValue = self.itemMo.policyProcessAdvocacy;
        _publicRowMo.strValue = self.itemMo.policyProcessAdvocacy?@"YES":@"NO";
        _publicRowMo.key = @"policyProcessAdvocacy";
    }
    return _publicRowMo;
}

- (CommonRowMo *)trainRowMo {
    if (!_trainRowMo) {
        _trainRowMo = [[CommonRowMo alloc] init];
        _trainRowMo.rowType = K_INPUT_TOGGLEBUTTON;
        _trainRowMo.leftContent = @"培训";
        _trainRowMo.inputType = K_SHORT_TEXT;
        _trainRowMo.rightContent = @"请选择";
        _trainRowMo.editAble = !self.afterDate;
        _trainRowMo.defaultValue = self.itemMo.train;
        _trainRowMo.strValue = self.itemMo.train?@"YES":@"NO";
        _trainRowMo.key = @"train";
    }
    return _trainRowMo;
}

- (CommonRowMo *)engineerRowMo {
    if (!_engineerRowMo) {
        _engineerRowMo = [[CommonRowMo alloc] init];
        _engineerRowMo.rowType = K_INPUT_TEXT;
        _engineerRowMo.leftContent = @"工程处理事项";
        _engineerRowMo.inputType = K_LONG_TEXT;
        _engineerRowMo.rightContent = @"请输入";
        _engineerRowMo.editAble = !self.afterDate;
        _engineerRowMo.nullAble = YES;
        _engineerRowMo.strValue = self.itemMo.engineerProcessingMatters;
        _engineerRowMo.key = @"engineerProcessingMatters";
    }
    return _engineerRowMo;
}

@end
