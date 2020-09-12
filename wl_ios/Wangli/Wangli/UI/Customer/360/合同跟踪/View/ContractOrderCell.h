//
//  ContractOrderCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContractOrderCell : UITableViewCell

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labYear;
@property (nonatomic, strong) UILabel *labMonth;
@property (nonatomic, strong) UILabel *labTotalSend;
@property (nonatomic, strong) UILabel *labRealSend;
@property (nonatomic, strong) UILabel *labTotalNote;
@property (nonatomic, strong) UILabel *labRealNote;

@property (nonatomic, strong) UIImageView *imgArrow;

//@property (nonatomic, strong) ContactContractMo *model;

- (void)loadDataWith:(NSString *)model;

@end

NS_ASSUME_NONNULL_END
