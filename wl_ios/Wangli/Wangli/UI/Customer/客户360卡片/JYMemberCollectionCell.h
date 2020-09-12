//
//  JYMemberCollectionCell.h
//  Wangli
//
//  Created by yeqiang on 2019/3/18.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYMemberCollectionCell : UICollectionViewCell

@property (nonatomic, strong) CustomerMo *model;
@property (nonatomic, strong) MemberCenterMo *centerMo;
@property (nonatomic, strong) AuthorityBean *authorityBean;

- (void)loadData:(CustomerMo *)model;

@end

NS_ASSUME_NONNULL_END
