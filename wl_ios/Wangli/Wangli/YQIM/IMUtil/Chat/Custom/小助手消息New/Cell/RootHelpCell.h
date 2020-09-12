//
//  RootHelpCell.h
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "TUIMessageCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface RootHelpCell : TUIMessageCell

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, assign) CGFloat cusHeight;

@property NewHelpeMessageCellData *customData;

- (void)fillWithData:(NewHelpeMessageCellData *)data;

@end

NS_ASSUME_NONNULL_END
