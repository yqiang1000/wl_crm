//
//  AttendanceViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/25.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "AttendanceViewCtrl.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "UIButton+ShortCut.h"
#import "AttachmentCollectionView.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "QiNiuUploadHelper.h"
#import "WSDatePickerView.h"
#import "BottomView.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface AttendanceViewCtrl () <UITextFieldDelegate, UIImagePickerControllerDelegate, AMapLocationManagerDelegate, AttachmentCollectionViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *btnMyLocalation;
@property (nonatomic, strong) UILabel *labMyLocaltion;
@property (nonatomic, strong) UIButton *btnSignType;
@property (nonatomic, strong) UITextField *noteField;
@property (nonatomic, strong) UIButton *btnCommit;
@property (nonatomic, strong) AttachmentCollectionView *collectionView;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, strong) NSMutableArray *dicTypes;
@property (nonatomic, strong) DicMo *typeDic;

@end

@implementation AttendanceViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = (self.signInMo)?@"修改考勤签到":@"考勤签到";
    
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    _mapView.zoomLevel = 16;
    ///把地图添加至view
    [self.view addSubview:_mapView];
    [self.view addSubview:self.bottomView];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self localationAction:nil];
    [self dicTypes];
    
    if (self.signInMo) {
        self.typeDic = [[DicMo alloc] initWithDictionary:self.signInMo.signType error:nil];
        self.collectionView.attachments = self.signInMo.attachments;
        [self.collectionView reloadData];
        self.noteField.text = STRING(self.signInMo.remark);
    } else {
        if (self.dicTypes.count > 0) self.typeDic = [self.dicTypes firstObject];
    }
    [self.btnSignType setTitle:self.typeDic.value forState:UIControlStateNormal];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.noteField resignFirstResponder];
}

#pragma mark - 键盘相关

- (void)onKeyboardWillHide:(NSNotification *)note
{
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
}

- (void)onKeyboardWillShow:(NSNotification *)note
{
    CGRect keyboardFrame;
    [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    float verticalOffset = CGRectGetHeight(keyboardFrame);
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-verticalOffset+160);
    }];
    [self.view layoutIfNeeded];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.noteField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return self.signInMo?NO:YES;
}

#pragma mark - AMapLocationManagerDelegate
// 持续定位
//- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
//    NSLog(@"%@", reGeocode);
//}

#pragma mark - AttachmentCollectionViewDelegate

- (void)attachmentCollectionView:(AttachmentCollectionView *)attachmentCollectionView didSelectedIndexPath:(NSIndexPath *)indexPath {
    if (self.signInMo) return;
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) items:@[@"拍照"] defaultItem:-1 itemClick:^(NSInteger index) {
        if (index == 0) {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied)
            {
                [Utils goToSettingPage:@"请在iPhone的\"设置-隐私-相机\"选项中，允许访问你的相机 "];
            } else {
                if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    picker.delegate = self;
                    picker.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
                    [self presentViewController:picker animated:YES completion:nil];
                    [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar_bg"] forBarMetrics:UIBarMetricsDefault];
                }
            }
        }
    } cancelClick:^(BottomView *obj) {
        if (obj) obj = nil;
    }];
    [bottomView show];
}

#pragma mark - UIImagePickerControllerDelegate
// 选择了图片或者拍照了
- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    __block UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (image) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self setNeedsStatusBarAppearanceUpdate];
        [self.collectionView.attachments addObject:image];
        [self.collectionView updateUI];
    }
    return;
}

// 取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)aPicker {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    
//    if (self.cancelBlock) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }
//    return;
}

#pragma mark - event

- (void)localationAction:(UIButton *)sender {
    __weak typeof(self) weakself = self;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            [Utils showToastMessage:@"定位失败"];
            weakself.labMyLocaltion.text = @"未识别你的位置，请重试";
        }
        if (regeocode) {
            NSLog(@"reGeocode:%@", regeocode);
            weakself.labMyLocaltion.text = regeocode.formattedAddress;
            weakself.latitude = location.coordinate.latitude;
            weakself.longitude = location.coordinate.longitude;
            weakself.provinceName = STRING(regeocode.province);
        }
    }];
}

- (void)signTypeAction:(UIButton *)sender {
    [self.noteField resignFirstResponder];
    if (self.signInMo) return;
    if (_dicTypes.count == 0) {
        [[JYUserApi sharedInstance] getConfigDicByName:@"sign_record_type" success:^(id responseObject) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            if (jsonData) {
                [[NSUserDefaults standardUserDefaults] setObject:jsonData forKey:SIGN_TYPE_DIC];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            NSError *error = nil;
            self.dicTypes = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
            // 默认
            if (!sender) {
                if (self.dicTypes.count > 0) self.typeDic = [self.dicTypes firstObject];
                [self.btnSignType setTitle:self.typeDic.value forState:UIControlStateNormal];
            } else {
                [self selectType];
            }
        } failure:^(NSError *error) {
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        // 默认
        if (sender) [self selectType];
    }
}

- (void)selectType {
    __weak typeof(self) weakself = self;
    NSMutableArray *names = [NSMutableArray new];
    for (DicMo *tmpMo in self.dicTypes) {
        [names addObject:STRING(tmpMo.value)];
    }
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) items:names defaultItem:-1 itemClick:^(NSInteger index) {
        __strong typeof(self) strongself = weakself;
        strongself.typeDic = strongself.dicTypes[index];
        [strongself.btnSignType setTitle:strongself.typeDic.value forState:UIControlStateNormal];
    } cancelClick:^(BottomView *obj) {
        if (obj) obj = nil;
    }];
    [bottomView show];
}

- (void)btnCommitClick:(UIButton *)sender {
    NSArray *images = self.collectionView.attachments;
    if (images.count > 0) {
        QiNiuUploadHelper *upload = [[QiNiuUploadHelper alloc] init];
        [upload uploadFileMulti:images success:^(id responseObject) {
            [self signToServer:responseObject];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [Utils showToastMessage:@"未上传照片"];
    }
}

- (void)signToServer:(NSArray *)arrImgs {
    if ([self.labMyLocaltion.text isEqualToString:@"未识别你的位置，请重试"]) {
        self.labMyLocaltion.text = @"";
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSString *location = @"";
    if ([self.labMyLocaltion.text isEqualToString:@"正在定位..."] ||
        self.labMyLocaltion.text.length == 0 ||
        [self.labMyLocaltion.text isEqualToString:@"未识别你的位置，请重试"]) {
        [Utils showToastMessage:@"当前未获取你的位置，请在半小时内补签修改地址"];
        location = @"";
    } else {
        location = self.labMyLocaltion.text;
    }
    [param setObject:location forKey:@"address"];
    [param setObject:STRING(self.noteField.text) forKey:@"remark"];
    [param setObject:STRING(self.provinceName) forKey:@"provinceName"];
    [param setObject:@(self.longitude) forKey:@"longitude"];
    [param setObject:@(self.latitude) forKey:@"latitude"];
    if (self.typeDic) [param setObject:[self.typeDic toDictionary] forKey:@"signType"];
    
    NSMutableArray *arr = [NSMutableArray new];
    for (QiniuFileMo *tmpMo in arrImgs) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[tmpMo toDictionary]];
        [dic setObject:@"" forKey:@"url"];
        [dic setObject:@"" forKey:@"thumbnail"];
        [arr addObject:dic];
    }
    if (arr.count > 0) [param setObject:arr forKey:@"attachments"];
    if (self.signInMo) {
        [param setObject:@(self.signInMo.id) forKey:@"id"];
        [param setObject:STRING(self.signInMo.createdDate) forKey:@"signInDate"];
    } else {
        [param setObject:[[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"signInDate"];
    }
    
    if (self.signInMo) {
        [[JYUserApi sharedInstance] updateSignInParam:param success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"修改成功"];
//            if (self.updateSuccess) self.updateSuccess(STRING(self.labMyLocaltion.text));
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [[JYUserApi sharedInstance] createSignInParam:param success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:[self.typeDic.key isEqualToString:@"signIn"]?@"签到成功":@"签退成功"];
            if (self.updateSuccess) self.updateSuccess(STRING(self.labMyLocaltion.text));
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

#pragma mark - setter getter

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = COLOR_B0;
        
        UIView *firstView = [UIView new];
        firstView.backgroundColor = COLOR_B4;
        [_bottomView addSubview:firstView];
        UIView *secondView = [UIView new];
        secondView.backgroundColor = COLOR_B4;
        [_bottomView addSubview:secondView];
        
        UIView *line1 = [Utils getLineView];
        UIView *line2 = [Utils getLineView];
        UIView *line3 = [Utils getLineView];
        [_bottomView addSubview:line1];
        [_bottomView addSubview:line2];
        [_bottomView addSubview:line3];
        
        UILabel *labType = [[UILabel alloc] init];
        labType.text = @"打卡类型";
        labType.textColor = COLOR_B1;
        labType.font = FONT_F15;
        [_bottomView addSubview:labType];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"批注";
        lab.textColor = COLOR_B1;
        lab.font = FONT_F15;
        [_bottomView addSubview:lab];
        
        [_bottomView addSubview:self.btnMyLocalation];
        [_bottomView addSubview:self.labMyLocaltion];
        [_bottomView addSubview:self.noteField];
        [_bottomView addSubview:self.collectionView];
        [_bottomView addSubview:self.btnCommit];
        [_bottomView addSubview:self.btnSignType];
        
        [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_bottomView);
        }];
        
        [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(firstView.mas_bottom).offset(10);
            make.left.right.bottom.equalTo(_bottomView);
        }];
        
        [_btnMyLocalation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(firstView).offset(15);
            make.left.equalTo(firstView).offset(15);
        }];
        
        [_labMyLocaltion mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(firstView).offset(35);
            make.top.equalTo(_btnMyLocalation.mas_bottom).offset(10);
            make.right.equalTo(firstView).offset(-35);
            make.bottom.equalTo(firstView).offset(-15);
        }];
        
        [labType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(secondView).offset(15);
            make.left.equalTo(secondView).offset(15);
        }];
        
        [_btnSignType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(labType.mas_right).offset(10);
            make.right.lessThanOrEqualTo(secondView).offset(-15);
            make.centerY.equalTo(labType);
            make.height.equalTo(labType);
        }];
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labType.mas_bottom).offset(15);
            make.height.equalTo(@0.5);
            make.left.equalTo(secondView).offset(15);
            make.right.equalTo(secondView).offset(-15);
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line1.mas_bottom).offset(15);
            make.left.equalTo(secondView).offset(15);
        }];
        
        [_noteField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lab.mas_right).offset(10);
            make.right.equalTo(secondView).offset(-15);
            make.centerY.equalTo(lab);
        }];
        
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lab.mas_bottom).offset(15);
            make.height.equalTo(@0.5);
            make.left.equalTo(secondView).offset(15);
            make.right.equalTo(secondView).offset(-15);
        }];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line2.mas_bottom).offset(15);
            make.height.equalTo(@80.0);
            make.left.equalTo(secondView).offset(15);
            make.right.equalTo(secondView).offset(-15);
        }];
        
        [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_collectionView.mas_bottom).offset(20);
            make.height.equalTo(@0.5);
            make.left.right.equalTo(secondView);
        }];
        
        [_btnCommit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(secondView);
            make.bottom.equalTo(_bottomView).offset(-KMagrinBottom);
            make.height.equalTo(@44.0);
            make.top.equalTo(line3.mas_bottom);
        }];
    }
    return _bottomView;
}

- (UIButton *)btnMyLocalation {
    if (!_btnMyLocalation) {
        _btnMyLocalation = [[UIButton alloc] init];
        [_btnMyLocalation setImage:[UIImage imageNamed:@"m_location"] forState:UIControlStateNormal];
        [_btnMyLocalation setTitle:@"我的位置" forState:UIControlStateNormal];
        _btnMyLocalation.titleLabel.font = FONT_F17;
        [_btnMyLocalation setTitleColor:COLOR_B2 forState:UIControlStateNormal];
        [_btnMyLocalation imageLeftWithTitleFix:5];
        [_btnMyLocalation sizeToFit];
        [_btnMyLocalation addTarget:self action:@selector(localationAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnMyLocalation;
}

- (UILabel *)labMyLocaltion {
    if (!_labMyLocaltion) {
        _labMyLocaltion = [UILabel new];
        _labMyLocaltion.font = FONT_F15;
        _labMyLocaltion.textColor = COLOR_B1;
        _labMyLocaltion.numberOfLines = 0;
        _labMyLocaltion.text = @"正在定位...";
    }
    return _labMyLocaltion;
}

- (UIButton *)btnSignType {
    if (!_btnSignType) {
        _btnSignType = [[UIButton alloc] init];
        _btnSignType.titleLabel.font = FONT_F15;
        [_btnSignType setTitleColor:COLOR_B2 forState:UIControlStateNormal];
        [_btnSignType addTarget:self action:@selector(signTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_btnSignType sizeToFit];
        [_btnSignType setTitle:@"签到" forState:UIControlStateNormal];
    }
    return _btnSignType;
}

- (UITextField *)noteField {
    if (!_noteField) {
        _noteField = [[UITextField alloc] init];
        _noteField.placeholder = @"请在此输入批注内容";
        _noteField.font = FONT_F14;
        _noteField.backgroundColor = COLOR_B4;
        _noteField.delegate = self;
        _noteField.returnKeyType = UIReturnKeyDone;
        _noteField.delegate = self;
    }
    return _noteField;
}

- (UIButton *)btnCommit {
    if (!_btnCommit) {
        _btnCommit = [[UIButton alloc] init];
        [_btnCommit setTitle:@"提交" forState:UIControlStateNormal];
        [_btnCommit setTitleColor:COLOR_C1 forState:UIControlStateNormal];
        _btnCommit.backgroundColor = COLOR_B4;
        [_btnCommit addTarget:self action:@selector(btnCommitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCommit;
}

- (AttachmentCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(80, 80);
        layout.minimumLineSpacing = 10;
        _collectionView = [[AttachmentCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.count = 9;
        _collectionView.lastImgName = @"m_camera";
        _collectionView.attachmentCollectionViewDelegate = self;
    }
    return _collectionView;
}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
//        [_locationManager setLocatingWithReGeocode:YES];
        
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //   定位超时时间，最低2s，此处设置为2s
        _locationManager.locationTimeout =2;
        //   逆地理请求超时时间，最低2s，此处设置为2s
        _locationManager.reGeocodeTimeout = 2;
        
    }
    return _locationManager;
}

- (NSMutableArray *)dicTypes {
    if (!_dicTypes) {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:SIGN_TYPE_DIC] options:NSJSONReadingAllowFragments error:nil];
        NSArray *tmpArr = (NSArray *)jsonObject;
        NSError *error = nil;
        _dicTypes = [DicMo arrayOfModelsFromDictionaries:tmpArr error:&error];
        if (!_dicTypes) _dicTypes = [NSMutableArray new];
        if (_dicTypes.count > 0) self.typeDic = [_dicTypes firstObject];
    }
    return _dicTypes;
}

@end
