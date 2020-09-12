//
//  CommonAutoViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/12/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "CommonRowMo.h"
#import "QiniuFileMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonAutoViewCtrl : BaseViewCtrl

/** 来源 默认NO:来自360（不可修改客户） YES:来自Tab（可修改客户） */
@property (nonatomic, assign) BOOL fromTab;                 // 来源
/** 是否更新 默认NO:新建 YES:更新 */
@property (nonatomic, assign) BOOL isUpdate;                // 来源
@property (nonatomic, copy) NSString *dynamicId;            // 动态表单Id
@property (nonatomic, assign) long long detailId;           // 详情id
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;      // 表单模型数组
@property (nonatomic, strong) NSMutableArray *attachments;  // 缩略图
@property (nonatomic, strong) NSMutableArray *attachUrls;   // 图片

@property (nonatomic, strong) NSMutableDictionary *customRules;

/** 人员选择类型 默认0   差旅无1 */
@property (nonatomic, assign) NSInteger userselectType;                

/** 禁止编辑 默认NO:可编辑 YES:不可编辑 */
@property (nonatomic, assign) BOOL forbidEdit;

/** 初始化RowMos 新建和更新都在这里获取列表 */
- (void)configRowMos;
/** 初始化model数据 本地自定义可以用到*/
- (void)config;
/** 隐藏键盘 */
- (void)hidenKeyboard;
/** 新建 */
- (void)createParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList;
/** 修改 */
- (void)updateParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList;

/** 点击方法扩展 必须执行super方法*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/** 执行完某个方法之后，需要继续执行其他方法
 *  toDo rowMo.key
 *  selName 方法标志
 *  indexPath  定位
 */
- (void)continueTodo:(NSString *)toDo selName:(NSString *)selName indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
