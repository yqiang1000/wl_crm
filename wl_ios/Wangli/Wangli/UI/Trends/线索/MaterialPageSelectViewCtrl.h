//
//  MaterialPageSelectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/1/16.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "MaterialMo.h"

NS_ASSUME_NONNULL_BEGIN

@class MaterialPageSelectViewCtrl;
@protocol MaterialPageSelectViewCtrlDelegate <NSObject>
@optional
- (void)materialPageSelectViewCtrl:(MaterialPageSelectViewCtrl *)materialPageSelectViewCtrl didSelectData:(NSArray *)data indexPath:(NSIndexPath *)indexPath;
- (void)materialPageSelectViewCtrlDismiss:(MaterialPageSelectViewCtrl *)materialPageSelectViewCtrl;

@end

@interface MaterialPageSelectViewCtrl : BaseViewCtrl

@property (nonatomic, weak) id <MaterialPageSelectViewCtrlDelegate> vcDelegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

/** 是否多选 YES:单选， NO:多选 */
@property (nonatomic, assign) BOOL isSignal;

@end

NS_ASSUME_NONNULL_END
