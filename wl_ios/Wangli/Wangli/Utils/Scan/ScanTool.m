//
//  ScanTool.m
//  Wangli
//
//  Created by yeqiang on 2018/4/12.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "ScanTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation ScanTool


+ (void)scanToolSuccessBlock:(void (^)(BOOL))successBlock {
    // iOS 8 后，全部都要授权
    AVAuthorizationStatus status =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (successBlock) {
                            successBlock(YES);
                        }
//                        [self gotoQrViewCtrl];
                    });
                    
                }else{
                    if (successBlock) {
                        successBlock(NO);
                    }
                    //用户拒绝
                    NSLog(@"用户明确地拒绝授权,请打开权限");
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            
            if (successBlock) {
                successBlock(YES);
            }
//            [self gotoQrViewCtrl];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
        {
//            NSLog(@"用户明确地拒绝授权，或者相机设备无法访问,请打开权限");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机功能" message:@"请在iPhone的\"设置-隐私-相机\"选项中，允许使用相机功能" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
            
            if (successBlock) {
                successBlock(NO);
            }
            break;
        }
        default:
            break;
    }
}

@end
