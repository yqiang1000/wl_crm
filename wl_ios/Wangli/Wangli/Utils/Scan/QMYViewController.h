//
//  QMYViewController.h
//  Wangli
//
//  Created by yeqiang on 2018/4/12.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "BaseViewCtrl.h"

@protocol ScanDelegete <NSObject>

-(void)equmname:(NSString *)name;

@end

@interface QMYViewController : BaseViewCtrl

@property (nonatomic,copy) NSString * scanImageViewName;
@property (nonatomic,copy) NSString * scanImgaeName;
//@property (nonatomic) int  from;
@property (nonatomic,weak) id<ScanDelegete> delegate;
//调用自定义的初始化方法  传入扫描框，扫描线图片和图片缩放比例
-(void) initWithScanViewName:(NSString *)ScvName withScanLinaName:(NSString*) SclName withPickureZoom:(CGFloat) pkz;

@end
