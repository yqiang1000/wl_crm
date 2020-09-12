//
//  TrendsInteligenceTableView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrendsInteligenceTableView : UITableView

@property (nonatomic, strong) DicMo *currentDic;
@property (nonatomic, strong) NSString *sourceString;
@property (nonatomic, assign) NSInteger sourceType;

@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) NSMutableArray *arrData;

- (void)tableViewHeaderRefreshAction;

@end

NS_ASSUME_NONNULL_END
