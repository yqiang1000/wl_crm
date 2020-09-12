//
//  VisitAnnexCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisitNoteMo.h"
#import "AttachmentCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@class VisitAnnexCell;
@protocol VisitAnnexCellDelegate <NSObject>

@optional
- (void)visitAnnexCell:(VisitAnnexCell *)visitAnnexCell btnActionIndexPath:(NSIndexPath *)indexPath;

@end

@interface VisitAnnexCell : UITableViewCell

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labContent;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIButton *btnCreate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <VisitAnnexCellDelegate> visitAnnexCellDelegate;
@property (nonatomic, strong) VisitNoteMo *model;
@property (nonatomic, strong) AttachmentCollectionView *collectionView;

- (void)loadData:(VisitNoteMo *)model;

@end

NS_ASSUME_NONNULL_END


