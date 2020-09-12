//
//  SubInteligenceCell.h
//  Wangli
//
//  Created by yeqiang on 2019/1/16.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicationRecordMo.h"
#import "BusinessInteligenceMo.h"
#import "RecordView.h"

NS_ASSUME_NONNULL_BEGIN
@class SubInteligenceCell;
@protocol SubInteligenceCellDelegate <NSObject>
@required
// 需要修改frame
- (void)subInteligenceCellFrameChanged:(SubInteligenceCell *)subInteligenceCell indexPath:(NSIndexPath *)indexPath;
// 开始编辑的位置
- (void)subInteligenceCellBeginEdit:(SubInteligenceCell *)subInteligenceCell indexPath:(NSIndexPath *)indexPath;

- (void)subInteligenceCell:(SubInteligenceCell *)subInteligenceCell didSelectToolBarIndex:(NSInteger)barIndex indexPath:(NSIndexPath *)indexPath;

- (void)subInteligenceCell:(SubInteligenceCell *)subInteligenceCell didSelectVoiceCell:(JYVoiceMo *)voiceMo index:(NSInteger)index indexPath:(NSIndexPath *)indexPath;

- (void)subInteligenceCell:(SubInteligenceCell *)subInteligenceCell didSelectImageCell:(JYVoiceMo *)voiceMo index:(NSInteger)index indexPath:(NSIndexPath *)indexPath;

- (void)subInteligenceCell:(SubInteligenceCell *)subInteligenceCell didSelectVideoCell:(JYVoiceMo *)voiceMo index:(NSInteger)index indexPath:(NSIndexPath *)indexPath;

- (void)subInteligenceCell:(SubInteligenceCell *)subInteligenceCell placehold:(NSString *)placehold indexPath:(NSIndexPath *)indexPath;

@required
- (NSMutableArray *)subInteligenceCellArrBigCategoryMos:(SubInteligenceCell *)subInteligenceCell;
- (NSMutableArray *)subInteligenceCellArrIntelligenceMos:(SubInteligenceCell *)subInteligenceCell bigMoKey:(NSString *)bigMoKey;

@end

@interface SubInteligenceCell : UITableViewCell

@property (nonatomic, strong) RecordView *recordView;

@property (nonatomic, strong) NSMutableArray *voiceData;
@property (nonatomic, strong) NSMutableArray *imageData;
@property (nonatomic, strong) NSMutableArray *videoData;

@property (nonatomic, strong) NSIndexPath *cellIndexPath;

@property (nonatomic, strong) IntelligenceItemSet *model;

@property (nonatomic, weak) id <SubInteligenceCellDelegate> subInteligenceCellDelegate;


@property (nonatomic, strong) DicMo *bigMo;
@property (nonatomic, strong) DicMo *intMo;

@property (nonatomic, strong) DicMo *bigCategoryDicMo;
@property (nonatomic, strong) DicMo *intelligenceDicMo;

- (void)loadData:(IntelligenceItemSet *)model;
- (void)resetNormalState;
- (void)hidenBtnSelect:(BOOL)hiden;


@end

NS_ASSUME_NONNULL_END
