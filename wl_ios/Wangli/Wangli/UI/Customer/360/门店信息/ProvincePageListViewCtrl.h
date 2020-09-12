//
//  ProvincePageListViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/5/6.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "AreaMo.h"

NS_ASSUME_NONNULL_BEGIN

@class ProvincePageListViewCtrl;
@protocol ProvincePageListViewCtrlDelegate <NSObject>
@required
- (void)provinceVC:(ProvincePageListViewCtrl *)provinceVC didSelected:(ProvinceMo *)provinceMo indexPath:(NSIndexPath *)indexPath;

@end

@interface ProvincePageListViewCtrl : BaseViewCtrl

@property (nonatomic, weak) id <ProvincePageListViewCtrlDelegate> vcDelegate;
@property (nonatomic, copy) NSString *provinceId;

@end

NS_ASSUME_NONNULL_END
