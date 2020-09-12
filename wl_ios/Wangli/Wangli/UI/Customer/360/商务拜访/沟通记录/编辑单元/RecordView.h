//
//  RecordView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordToolBarView.h"
#import "RecordContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordView : UIView

@property (nonatomic, strong) RecordToolBarView *toolBar;
@property (nonatomic, strong) RecordContentView *contentView;

@end

NS_ASSUME_NONNULL_END
