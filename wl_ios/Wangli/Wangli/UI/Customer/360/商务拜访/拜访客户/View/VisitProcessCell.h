//
//  VisitProcessCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    VisitProcessCellOne     = 0,
    VisitProcessCellTwo,
    VisitProcessCellThree,
} VisitProcessCellType;

@class VisitProcessCell;
@protocol VisitProcessCellDelegate <NSObject>

@optional
- (void)visitProcessCell:(VisitProcessCell *)visitProcessCell btnActionIndexPath:(NSIndexPath *)indexPath;

@end

@interface VisitProcessCell : UITableViewCell

@property (nonatomic, strong) UILabel *labStep;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labContent;
@property (nonatomic, strong) UIButton *btnAddress;
@property (nonatomic, strong) UIView *lineTop;
@property (nonatomic, strong) UIView *lineBottom;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIButton *btnCreate;
@property (nonatomic, assign) VisitProcessCellType type;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id <VisitProcessCellDelegate> visitProcessCellDelegate;

- (void)loadData:(VisitProcessCellType)type content:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
