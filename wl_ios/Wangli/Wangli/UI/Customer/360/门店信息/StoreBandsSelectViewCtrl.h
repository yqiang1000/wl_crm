//
//  StoreBandsSelectViewCtrl.h
//  Wangli
//
//  Created by 杜文杰 on 2019/7/15.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "StoreBandsMo.h"

NS_ASSUME_NONNULL_BEGIN

@class StoreBandsSelectViewCtrl;
@protocol StoreBandsSelectViewCtrlDelegate <NSObject>
@optional

// 取消
- (void)storeBandsSelectViewCtrlDismiss:(StoreBandsSelectViewCtrl *)storeBandsSelectViewCtrl;

// 单选方法
- (void)storeBandsSelectViewCtrl:(StoreBandsSelectViewCtrl *)storeBandsSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(StoreBandsMo *)selectMo;

// 多选方法，会覆盖单选方法
- (void)storeBandsSelectViewCtrl:(StoreBandsSelectViewCtrl *)storeBandsSelectViewCtrl selectedData:(NSArray *)selectedData indexPath:(NSIndexPath *)indexPath;

@end

@interface StoreBandsSelectViewCtrl : BaseViewCtrl

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <StoreBandsSelectViewCtrlDelegate> VcDelegate;
@property (nonatomic, assign) BOOL isMultiple; //是否多选，默认NO
@property (nonatomic, strong) NSMutableArray *defaultValues;

@end

NS_ASSUME_NONNULL_END
