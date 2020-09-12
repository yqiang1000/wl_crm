//
//  PersonCardCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonCardCell : UICollectionViewCell

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *imgHeader;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labPart;
@property (nonatomic, strong) UILabel *labTel;
@property (nonatomic, strong) UILabel *labEmail;
@property (nonatomic, strong) UILabel *labHobby;

@property (nonatomic, strong) ContactMo *model;
- (void)loadData:(ContactMo *)model;

@end

NS_ASSUME_NONNULL_END
