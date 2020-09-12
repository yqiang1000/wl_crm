//
//  CardView.h
//  Wangli
//
//  Created by yeqiang on 2018/7/31.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerCollectionView.h"
#import "CustomerMo.h"
#import "MemberCenterMo.h"

#pragma mark - SquaredCardView

@interface SquaredCardView : UIView

@property (nonatomic, strong) UIImageView *imgHeader;
@property (nonatomic, strong) UIButton *btnCollect;
@property (nonatomic, strong) UILabel *labCompanyName;
@property (nonatomic, strong) UILabel *labCode;
@property (nonatomic, strong) UILabel *labMsg;
@property (nonatomic, strong) UILabel *labTag;
@property (nonatomic, strong) UIButton *btnTag;
@property (nonatomic, strong) UIButton *btnEdit;
@property (nonatomic, strong) CustomerMo *mo;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) UILabel *labInfo;
@property (nonatomic, strong) CustomerCollectionView *collectionView;

- (void)refreshView:(CustomerMo *)mo;

@end


#pragma mark - DashboardCardView

@interface DashboardCardView : UIView

@property (nonatomic, strong) CustomerMo *mo;
@property (nonatomic, strong) MemberCenterMo *centerMo;

- (void)refreshView:(CustomerMo *)mo centerMo:(MemberCenterMo *)centerMo;

@end


#pragma mark - TrendsCardView

@interface TrendsCardView : UIView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MemberCenterMo *mo;
- (void)refreshView:(MemberCenterMo *)mo;

@end

#pragma mark - MonthCardView

@interface MonthCardView : UIView

@property (nonatomic, strong) MemberCenterMo *mo;
- (void)refreshView:(MemberCenterMo *)mo;

@end

#pragma mark - TrendsCardCell

@interface TrendsCardCell : UITableViewCell

@property (nonatomic, strong) UILabel *labLeft;
@property (nonatomic, strong) UILabel *labRight;

@end

#pragma mark - RadarCardView

@interface RadarCardView : UIView

@property (nonatomic, strong) NSMutableArray *arrRadar;
- (void)refreshView:(NSMutableArray *)radar;

@end


#pragma mark - PostCardView

@interface PostCardView : UIView

- (void)loadDataWith:(NSDictionary *)model;

@end



