//
//  AddressCell.h
//  Wangli
//
//  Created by yeqiang on 2018/4/17.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressMo.h"

@class AddressCell;
@protocol AddressCellDelegate <NSObject>
@optional
- (void)addressCellBtnDeleteClick:(AddressCell *)cell;
- (void)addressCellBtnEditClick:(AddressCell *)cell;
@end


@interface AddressCell : UITableViewCell

@property (nonatomic, strong) UILabel *labAddress;
@property (nonatomic, strong) UILabel *labContact;
@property (nonatomic, strong) UIButton *btnDefault;

@property (nonatomic, strong) AddressMo *mo;
@property (nonatomic, weak) id <AddressCellDelegate> cellDelegate;
- (void)laodDataWith:(AddressMo *)mo;

- (void)refreshView:(BOOL)cellSelected;

@end
