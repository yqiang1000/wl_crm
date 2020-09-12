//
//  JYUserMoSelectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/8/27.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "JYUserApi.h"

@class JYUserMoSelectViewCtrl;
@protocol JYUserMoSelectViewCtrlDelegate <NSObject>
@optional

// 取消
- (void)jyUserMoSelectViewCtrlDismiss:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl;

// 单选方法
- (void)jyUserMoSelectViewCtrl:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(JYUserMo *)selectMo;

// 多选方法，会覆盖单选方法
- (void)jyUserMoSelectViewCtrl:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl selectedData:(NSArray *)selectedData indexPath:(NSIndexPath *)indexPath;

@end

@interface JYUserMoSelectViewCtrl : BaseViewCtrl

// 默认0，差旅增加无1
@property (nonatomic, assign) NSInteger selectType;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <JYUserMoSelectViewCtrlDelegate> VcDelegate;
@property (nonatomic, assign) BOOL isMultiple; //是否多选，默认NO
@property (nonatomic, strong) NSMutableArray *defaultValues;

@end
