//
//  ListSelectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/5/7.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"

#pragma mark - ListSelectMo

@interface ListSelectMo : NSObject

@property (nonatomic, copy) NSString *moId;
@property (nonatomic, copy) NSString *moText;
@property (nonatomic, copy) NSString *moKey;

@end

#pragma mark - ListSelectViewCtrl

@class ListSelectViewCtrl;
@protocol ListSelectViewCtrlDelegate <NSObject>
@optional
// 单选方法
- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo;

// 多选方法，会覆盖单选方法
- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndexPaths:(NSArray *)selectIndexPaths indexPath:(NSIndexPath *)indexPath;

@end

@interface ListSelectViewCtrl : BaseViewCtrl

@property (nonatomic, strong) NSMutableArray<ListSelectMo *> *arrData;  //数据源
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <ListSelectViewCtrlDelegate> listVCdelegate;

@property (nonatomic, assign) BOOL isMultiple; //是否多选，默认NO
@property (nonatomic, strong) NSMutableArray *defaultValues;
@property (nonatomic, assign) BOOL byText; // 默认defaultValues是id还是key，默认id

@property (nonatomic, assign) BOOL enableSearch; //是否可以搜索，默认NO

@end

#pragma mark - ListselectCell

@interface ListselectCell : UITableViewCell

@property (nonatomic, strong) UILabel *labText;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *imgArrow;

@end

