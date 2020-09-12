//
//  TrendsInteligenceCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendsInteligenceMo.h"
#import "UserLocalDataUtils.h"

NS_ASSUME_NONNULL_BEGIN
@class TrendsInteligenceCell;
@protocol TrendsInteligenceCellDelegate <NSObject>
@optional
- (void)trendsInteligenceCell:(TrendsInteligenceCell *)trendsInteligenceCell didSelectIndexPaht:(NSIndexPath *)indexPath urlStr:(NSString *)urlStr;
@end

@interface TrendsInteligenceCell : UITableViewCell

@property (nonatomic, weak) id <TrendsInteligenceCellDelegate> delegate;
@property (nonatomic, strong) TrendsInteligenceMo *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)loadData:(TrendsInteligenceMo *)model;

@end

NS_ASSUME_NONNULL_END
