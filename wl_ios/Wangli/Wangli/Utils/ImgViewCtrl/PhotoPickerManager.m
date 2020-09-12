//
//  PhotoPickerManager.m
//  GPMIS
//
//  Created by abel on 15/8/3.
//  Copyright (c) 2015年 zhoug. All rights reserved.
//

#import "PhotoPickerManager.h"
#import "TZImagePickerController.h"
#import "BottomView.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface PhotoPickerManager () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, TZImagePickerControllerDelegate> {
}

@property (nonatomic, weak)     UIViewController          *fromController;
@property (nonatomic, copy)     HYBPickerCompelitionBlock completion;
@property (nonatomic, copy)     HYBPickerCancelBlock      cancelBlock;
@property (nonatomic, assign)   NSInteger maxCount;

@end

@implementation PhotoPickerManager

+ (PhotoPickerManager *)shared {
    static PhotoPickerManager *sharedObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!sharedObject) {
            sharedObject = [[[self class] alloc] init];
        }
    });
    
    return sharedObject;
}

- (void)showActionSheetInView:(UIView *)inView
               fromController:(UIViewController *)fromController
                     maxCount:(NSInteger)maxCount
                   completion:(HYBPickerCompelitionBlock)completion
                  cancelBlock:(HYBPickerCancelBlock)cancelBlock {
    self.completion = [completion copy];
    self.cancelBlock = [cancelBlock copy];
    self.fromController = fromController;
    self.maxCount = maxCount;
    
    NSArray *items = @[@"拍照",
                       @"相册"];
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) items:items defaultItem:-1 itemClick:^(NSInteger index) {
        if (index == 0) {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied)
            {
                [Utils goToSettingPage:@"请在iPhone的\"设置-隐私-相机\"选项中，允许访问你的相机 "];
            } else {
                if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar_bg"] forBarMetrics:UIBarMetricsDefault];
                    picker.delegate = self;
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    picker.delegate = self;
                    picker.navigationBar.barTintColor = self.fromController.navigationController.navigationBar.barTintColor;
                    
                    // 设置导航默认标题的颜色及字体大小
                    //picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                    //                                             NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
                    [self.fromController presentViewController:picker animated:YES completion:nil];
                }
            }
        } else if (index == 1) {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:_maxCount delegate:self];
                imagePickerVc.allowPickingVideo = NO;
                imagePickerVc.allowPickingOriginalPhoto = NO;
                // 你可以通过block或者代理，来得到用户选择的照片.
                //                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
                
                //                }];
                
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *phoots, NSArray *assets, BOOL result) {
                    
                }];
                
                [self.fromController presentViewController:imagePickerVc animated:YES completion:nil];
            }
        }
    } cancelClick:^(BottomView *obj) {
        if (obj) {
            obj = nil;
        }
    }];
    
    [bottomView show];
    return;
}

#pragma mark - UIImagePickerControllerDelegate
// 选择了图片或者拍照了
- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    __block UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    if (image && self.completion) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.fromController setNeedsStatusBarAppearanceUpdate];
        
        self.completion(@[image]);
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    //image = [image imageResizedToSize:CGSizeMake(UIScreenWidth / 2.0, UIScreenHeight / 2.0)];
//
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        self.completion(image);
//                    });
//                });
    }
    return;
}

// 取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)aPicker {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.cancelBlock) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.fromController setNeedsStatusBarAppearanceUpdate];
        
        self.cancelBlock();
    }
    return;
}

#pragma mark TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
//- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
//
//}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    if (photos.count > 0 && self.completion) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.fromController setNeedsStatusBarAppearanceUpdate];
        
        self.completion(photos);
    }
}

@end
