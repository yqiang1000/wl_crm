//
//  VPImageCropperViewCtrl.h
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import "BaseViewCtrl.h"

@class VPImageCropperViewCtrl;

@protocol VPImageCropperDelegate <NSObject>

- (void)imageCropper:(VPImageCropperViewCtrl *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(VPImageCropperViewCtrl *)cropperViewController;

@end

@interface VPImageCropperViewCtrl : BaseViewCtrl

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<VPImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
