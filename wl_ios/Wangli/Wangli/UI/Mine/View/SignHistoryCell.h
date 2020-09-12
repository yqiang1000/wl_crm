//
//  SignHistoryCell.h
//  Wangli
//
//  Created by yeqiang on 2019/3/21.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignHistoryCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) SignInMo *model;

- (void)loadData:(SignInMo *)model;

@end

NS_ASSUME_NONNULL_END
