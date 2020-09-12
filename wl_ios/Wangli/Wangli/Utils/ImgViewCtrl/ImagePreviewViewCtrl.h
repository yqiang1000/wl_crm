//
//  ImagePreviewViewCtrl.h
//  ABCInstitution-Teacher
//
//  Created by dev001 on 2017/12/22.
//  Copyright © 2017年 北京暄暄科技有限公司. All rights reserved.
//

#import "BaseViewCtrl.h"

//typedef enum EditImgType {
//    EditImgType_Pen = 1,
//    EditImgType_White,
//    EditImgType_Black,
//    EditImgType_Red,
//    EditImgType_Yellow,
//    EditImgType_Green,
//    EditImgType_Undo,
//    EditImgType_Redo,
//}EditImgType;

@protocol ImagePreviewCtrlDelegate<NSObject>

@optional
- (void)deleteImageIndexes:(NSArray *)arrIndex;
- (void)sendVideo:(NSString *)url andImage:(UIImage *)image duration:(long) duration;

@end

typedef void(^ImageBlock)(NSArray * arrImg);

@interface ImagePreviewViewCtrl : BaseViewCtrl

@property (nonatomic, assign) BOOL hidenDelete;
@property (nonatomic, assign) BOOL isIM;
@property (nonatomic, weak) id<ImagePreviewCtrlDelegate> imgPrevCtrlDelegate;

//图片url集合
- (id)initWithArrImage:(NSArray *)arrImg
             currIndex:(NSInteger)currIndex;

- (id)initWithArrImage:(NSArray *)arrImg
             currIndex:(NSInteger)currIndex
             dataBlock:(ImageBlock) imgBlock;

@end
