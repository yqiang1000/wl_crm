//
//  StrategicEngineeringItemViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/4/26.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "CommonAutoViewCtrl.h"
#import "StrategicEngineeringMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface StrategicEngineeringItemViewCtrl : CommonAutoViewCtrl

/** 新建时候 YES：是，NO：不是 */
@property (nonatomic, assign) BOOL createDate;
/** 在计划工作时间之前 YES：是，NO：不是 */
@property (nonatomic, assign) BOOL beforeDate;
/** 上班两小时后到次日上班前 YES：是，NO：不是 */
@property (nonatomic, assign) BOOL handleDate;
/** 次日上班后 YES：是，NO：不是 */
@property (nonatomic, assign) BOOL afterDate;

@property (nonatomic, strong) StrategicEngineeringItemMo *itemMo;

@end

NS_ASSUME_NONNULL_END
