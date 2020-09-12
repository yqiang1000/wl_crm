//
//  ContactCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ContactCell

@interface ContactCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgHeader;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labOrg;
@property (nonatomic, strong) UILabel *labPart;
@property (nonatomic, strong) UILabel *labJob;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) id model;

// 自适应用
- (void)loadDataWith:(id)model;

@end

#pragma mark - MyCommonHeaderView

@interface MyCommonHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *labLeft;
//是否隐藏竖条，默认值 NO
@property (nonatomic, assign) BOOL isHidenLine;
@property (nonatomic, assign) NSInteger section;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier isHidenLine:(BOOL)isHidenLine;

@end


NS_ASSUME_NONNULL_END
