//
//  InteligenceCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/18.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicationRecordMo.h"
#import "BusinessVisitActivityMo.h"
#import "RecordView.h"

NS_ASSUME_NONNULL_BEGIN
@class InteligenceCell;
@protocol InteligenceCellDelegate <NSObject>
@required
// 需要修改frame
- (void)inteligenceCellFrameChanged:(InteligenceCell *)inteligenceCell indexPath:(NSIndexPath *)indexPath;
// 开始编辑的位置
- (void)inteligenceCellBeginEdit:(InteligenceCell *)inteligenceCell indexPath:(NSIndexPath *)indexPath;

- (void)inteligenceCell:(InteligenceCell *)inteligenceCell didSelectToolBarIndex:(NSInteger)barIndex indexPath:(NSIndexPath *)indexPath;

- (void)inteligenceCell:(InteligenceCell *)inteligenceCell didSelectVoiceCell:(JYVoiceMo *)voiceMo index:(NSInteger)index indexPath:(NSIndexPath *)indexPath;

@end

@interface InteligenceCell : UITableViewCell

@property (nonatomic, strong) RecordView *recordView;

@property (nonatomic, strong) NSMutableArray *voiceData;
@property (nonatomic, strong) NSMutableArray *imageData;
@property (nonatomic, strong) NSMutableArray *videoData;

@property (nonatomic, strong) NSIndexPath *cellIndexPath;

@property (nonatomic, strong) BusinessVisitActivityMo *model;

@property (nonatomic, weak) id <InteligenceCellDelegate> inteligenceCellDelegate;

@property (nonatomic, strong) DicMo *bigCategoryDicMo;
@property (nonatomic, strong) DicMo *intelligenceDicMo;

- (void)loadData:(BusinessVisitActivityMo *)model;
- (void)resetNormalState;

@end

NS_ASSUME_NONNULL_END
