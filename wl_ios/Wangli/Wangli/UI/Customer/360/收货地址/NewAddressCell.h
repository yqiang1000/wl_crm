//
//  NewAddressCell.h
//  Wangli
//
//  Created by yeqiang on 2018/4/16.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AddressCellNormal = 0,
    AddressCellSelect,
    AddressCellAddress,
    AddressCellDefault,
    AddressCellSave,
} AddressCellType;

@class NewAddressCell;

@protocol NewAddressCellDelegate <NSObject>
@optional

// 输入回调
- (void)newAddressCell:(NewAddressCell *)newAddressCell textFieldDidBeginEditing:(UITextField*)textField textViewDidBeginEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath;

// 结束输入
- (void)newAddressCell:(NewAddressCell *)newAddressCell textFieldShouldReturn:(UITextField *)textField textViewDidEndEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath;

// 保存
- (void)newAddressCellSaveClick:(NewAddressCell *)newAddressCell;

// 是否默认。默认NO
- (void)newAddressCell:(NewAddressCell *)newAddressCell isDefault:(BOOL)isDefault;

@end

#pragma mark - NewAddressCell

@interface NewAddressCell : UITableViewCell

@property (nonatomic, strong) UILabel *labLeft;
@property (nonatomic, strong) UITextField *txtField;
@property (nonatomic, strong) UITextView *txtView;
@property (nonatomic, strong) UIButton *btnArrow;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UISwitch *btnSwitch;

@property (nonatomic, strong) UIButton *btnSave;

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id <NewAddressCellDelegate> delegate;

- (void)setLeftText:(NSString *)text;

// type 0：默认， 1：地区，2：详细地址，3：默认地址，4：保存
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(AddressCellType)type;

@end
