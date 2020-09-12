//
//  LongCommonCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - LongCommonCell

@interface LongCommonCell : UITableViewCell

@property (nonatomic, strong) UILabel *labLeft;
@property (nonatomic, strong) UILabel *labRight;
@property (nonatomic, strong) UIView *lineView;

- (void)setLongRightText:(NSString *)rightText;

@end

NS_ASSUME_NONNULL_END
