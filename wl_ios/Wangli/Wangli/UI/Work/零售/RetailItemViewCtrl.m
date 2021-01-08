//
//  RetailItemViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/4/19.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "RetailItemViewCtrl.h"
#import "QiniuFileMo.h"

@interface RetailItemViewCtrl ()

@property (nonatomic, strong) CommonRowMo *visitRowMo;
@property (nonatomic, strong) CommonRowMo *contRowMo;
@property (nonatomic, strong) CommonRowMo *attRowMo;

@end

@implementation RetailItemViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"走访客户";
    self.forbidEdit = self.afterDate;
    self.rightBtn.hidden = self.afterDate;
}

- (void)configRowMos {
    [self.arrData removeAllObjects];
    self.arrData = nil;
    
    CommonRowMo *rowMo0 = [[CommonRowMo alloc] init];
    rowMo0.rowType = K_INPUT_MEMBER;
    rowMo0.leftContent = @"客户";
    rowMo0.inputType = K_SHORT_TEXT;
    rowMo0.rightContent = @"请选择";
    rowMo0.editAble = !self.afterDate;
    rowMo0.key = @"member";
    NSError *error = nil;
    CustomerMo *memberMo = [[CustomerMo alloc] initWithDictionary:self.itemMo.member error:&error];
    rowMo0.m_obj = memberMo;
    rowMo0.strValue = self.itemMo.member[@"orgName"];
    rowMo0.member = memberMo;
    [self.arrData addObject:rowMo0];
    
    [self.arrData addObject:self.visitRowMo];

    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    rowMo2.rowType = K_INPUT_TOGGLEBUTTON;
    rowMo2.leftContent = @"是否专卖/专营";
    rowMo2.inputType = K_SHORT_TEXT;
    rowMo2.rightContent = @"请选择";
    rowMo2.editAble = self.handleDate;
    rowMo2.defaultValue = self.itemMo.monopoly;
    rowMo2.strValue = self.itemMo.monopoly?@"YES":@"NO";
    rowMo2.key = @"monopoly";
    [self.arrData addObject:rowMo2];
    
    CommonRowMo *rowMo3 = [[CommonRowMo alloc] init];
    rowMo3.rowType = K_INPUT_TOGGLEBUTTON;
    rowMo3.leftContent = @"基本款上样是否齐全";
    rowMo3.inputType = K_SHORT_TEXT;
    rowMo3.rightContent = @"请选择";
    rowMo3.editAble = self.handleDate;
    rowMo3.defaultValue = self.itemMo.complete;
    rowMo3.strValue = self.itemMo.complete?@"YES":@"NO";
    rowMo3.key = @"complete";
    [self.arrData addObject:rowMo3];
    
    CommonRowMo *rowMo4 = [[CommonRowMo alloc] init];
    rowMo4.rowType = K_INPUT_TOGGLEBUTTON;
    rowMo4.leftContent = @"对比销售";
    rowMo4.inputType = K_SHORT_TEXT;
    rowMo4.rightContent = @"请选择";
    rowMo4.editAble = self.handleDate;
    rowMo4.defaultValue = self.itemMo.comparativeSales;
    rowMo4.strValue = self.itemMo.comparativeSales?@"YES":@"NO";
    rowMo4.key = @"comparativeSales";
    [self.arrData addObject:rowMo4];
    
    CommonRowMo *rowMo5 = [[CommonRowMo alloc] init];
    rowMo5.rowType = K_INPUT_TOGGLEBUTTON;
    rowMo5.leftContent = @"政策流程宣导";
    rowMo5.inputType = K_SHORT_TEXT;
    rowMo5.rightContent = @"请选择";
    rowMo5.editAble = self.handleDate;
    rowMo5.defaultValue = self.itemMo.policyProcessAdvocacy;
    rowMo5.strValue = self.itemMo.policyProcessAdvocacy?@"YES":@"NO";
    rowMo5.key = @"policyProcessAdvocacy";
    [self.arrData addObject:rowMo5];
    
    CommonRowMo *rowMo6 = [[CommonRowMo alloc] init];
    rowMo6.rowType = K_INPUT_TOGGLEBUTTON;
    rowMo6.leftContent = @"培训";
    rowMo6.inputType = K_SHORT_TEXT;
    rowMo6.rightContent = @"请选择";
    rowMo6.editAble = !self.afterDate;
    rowMo6.defaultValue = self.itemMo.train;
    rowMo6.strValue = self.itemMo.train?@"YES":@"NO";
    rowMo6.key = @"train";
    [self.arrData addObject:rowMo6];
    
//    NSMutableArray *att = [NSMutableArray new];
//    for (NSDictionary *dic in self.itemMo.attachments) {
//        error = nil;
//        QiniuFileMo *qiniuMo = [[QiniuFileMo alloc] initWithDictionary:dic error:&error];
//        if ([qiniuMo.fileName containsString:@".jpg"] || [qiniuMo.fileName containsString:@".png"]) {
//            [att addObject:qiniuMo];
//        }
//    }
    self.attRowMo.attachments = (NSMutableArray<QiniuFileMo *><QiniuFileMo,Optional> *)self.itemMo.attachments;
    if (self.itemMo.comparativeSales) {
        [self.arrData addObject:self.attRowMo];
    } else {
        [self.arrData addObject:self.contRowMo];
    }
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
    }
    // 是否走访，是，则附件必填
    else if ([toDo isEqualToString:@"visit"]) {
        self.attRowMo.nullAble = !self.visitRowMo.defaultValue;
        [self.tableView reloadData];
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
        }
    }
    if (self.updateSuccess) self.updateSuccess(self.itemMo);
    [self.navigationController popViewControllerAnimated:YES];
}

- (RetailChannelItemsMo *)itemMo {
    if (!_itemMo) _itemMo = [[RetailChannelItemsMo alloc] init];
    return _itemMo;
}

- (CommonRowMo *)attRowMo {
    if (!_attRowMo) {
        _attRowMo = [[CommonRowMo alloc] init];
        _attRowMo.rowType = K_FILE_INPUT;
        _attRowMo.leftContent = @"上传图片";
        _attRowMo.inputType = K_SHORT_TEXT;
        _attRowMo.key = @"attachments";
        _attRowMo.editAble = self.handleDate;
        _attRowMo.nullAble = !self.visitRowMo.defaultValue;
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



@end
