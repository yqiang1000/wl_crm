
//
//  AvatorViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/6/28.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "AvatorViewCtrl.h"
#import "UIImageView+WebCache.h"
#import "PhotoPickerManager.h"
#import "VPImageCropperViewCtrl.h"
#import "RestrictionInput.h"
#import "LeftLabel.h"
#import "QiNiuUploadHelper.h"

@interface AvatorViewCtrl () <VPImageCropperDelegate>
{
    NSInteger MAX_INPUT_LENGTH;
}

//修改头像
@property (nonatomic, strong) UIImageView *imgAvatorBig;

@end

@implementation AvatorViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _type == AvatorTypeDefault ? @"修改头像" : @"修改客户头像";
    self.rightBtn.hidden = NO;
    [self.rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [self setAvatorUI];
    
    if (_type == AvatorTypeDefault) {
        [self.imgAvatorBig sd_setImageWithURL:[NSURL URLWithString:[Utils imgUrlWithKey: TheUser.userMo.avatarUrl]] placeholderImage:[UIImage imageNamed:@"client_default_avatar"]];
    } else {
        [self.imgAvatorBig sd_setImageWithURL:[NSURL URLWithString:[Utils imgUrlWithKey:TheCustomer.customerMo.avatarUrl]] placeholderImage:[UIImage imageNamed:(@"client_directsales")]];
    }
}

- (void)setAvatorUI {
    [self.view addSubview:self.imgAvatorBig];
    [self.imgAvatorBig mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.equalTo(self.view);
        make.top.equalTo(self.naviView.mas_bottom).offset(81);
        make.height.equalTo(_imgAvatorBig.mas_width);
    }];
}

#pragma mark - network


#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    [self clickChange:nil];
}

- (void)clickChange:(UIGestureRecognizer *)tap {
    [[PhotoPickerManager shared] showActionSheetInView:self.view
                                        fromController:self
                                              maxCount:1
                                            completion:^(NSArray *photos) {
                                                // 裁剪
                                                float y = (SCREEN_HEIGHT-50-SCREEN_WIDTH+60)/2.0;
                                                VPImageCropperViewCtrl *imgEditorVC = [[VPImageCropperViewCtrl alloc] initWithImage:photos[0]
                                                                                                                          cropFrame:CGRectMake(30, y, SCREEN_WIDTH-60, SCREEN_WIDTH-60)
                                                                                                                    limitScaleRatio:3.0];
                                                imgEditorVC.delegate = self;
                                                [self.navigationController pushViewController:imgEditorVC animated:YES];
                                            } cancelBlock:^{
                                                
                                            }];
}


#pragma mjark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self.navigationController popViewControllerAnimated:NO];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image != nil) {
        float y = (SCREEN_HEIGHT-50-SCREEN_WIDTH+60)/2.0;
        VPImageCropperViewCtrl *imgEditorVC = [[VPImageCropperViewCtrl alloc] initWithImage:image
                                                                                  cropFrame:CGRectMake(30, y, SCREEN_WIDTH-60, SCREEN_WIDTH-60)
                                                                            limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self.navigationController pushViewController:imgEditorVC animated:YES];
    }
}


#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewCtrl *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController.navigationController popViewControllerAnimated:YES];
    [self updateImage:editedImage];
}

- (void)imageCropperDidCancel:(VPImageCropperViewCtrl *)cropperViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - network

- (void)updateImage:(UIImage *)image {
    QiNiuUploadHelper *upload = [[QiNiuUploadHelper alloc] init];
    upload.tostStr = @"正在上传头像";
    [upload uploadFileMulti:@[image] success:^(id responseObject) {
        // 绑定头像
        self.imgAvatorBig.image = image;
        [self updateAvator:[responseObject firstObject]];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)updateAvator:(QiniuFileMo *)fileMo {
    if (_type == AvatorTypeDefault) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:@(TheUser.userMo.id) forKey:@"pkId"];
        [param setObject:STRING(fileMo.qiniuKey) forKey:@"key"];
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] operatorAvatorUpdateParam:param success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"修改成功"];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else if (_type == AvatorTypeMember) {
        [Utils showHUDWithStatus:nil];
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:@(TheCustomer.customerMo.id) forKey:@"id"];
        [param setObject:STRING(fileMo.qiniuKey) forKey:@"key"];
        [[JYUserApi sharedInstance] memberUpdateAvatorParam:param success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"修改成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_UPDATE_URL_SUCCESS object:nil];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

#pragma mark - setter and getter

//修改头像
- (UIImageView *)imgAvatorBig {
    if (!_imgAvatorBig) {
        _imgAvatorBig = [[UIImageView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickChange:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        _imgAvatorBig.userInteractionEnabled = YES;
        [_imgAvatorBig addGestureRecognizer:tap];
    }
    return _imgAvatorBig;
}

@end
