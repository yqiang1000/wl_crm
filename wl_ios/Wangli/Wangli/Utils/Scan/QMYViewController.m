//
//  QMYViewController.m
//  Wangli
//
//  Created by yeqiang on 2018/4/12.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "QMYViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BaseWebViewCtrl.h"
#import <TZImagePickerController/TZImagePickerController.h>

#define Color(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define Qmyalpha 0.2

@interface QMYViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate, TZImagePickerControllerDelegate>//用于处理采集信息的代理
{
    AVCaptureSession * session;//输入输出的中间桥梁
    AVCaptureMetadataOutput * output;
    UIImageView * _QimageView ;
    UIImageView *_QrCodeline ;
    NSTimer *_timer;
    UIImage *_linimg;
    UILabel *lab;
    int index;
    
    NSString *deviceid;
    NSString *passw;
    
    UIButton *_emptyView;
}
@end

@implementation QMYViewController

-(void)dealloc
{
    NSLog(@"释放");
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    index = 0;
    [session startRunning];
    [self createTimer];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码/条码";
    self.naviView.labTitle.textColor = COLOR_B4;
    self.naviView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.naviView.lineView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"相册" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:COLOR_B4 forState:UIControlStateNormal];
    self.leftBtn.hidden = NO;
    [self _initview];
}

- (void)rightAction
{
    index = 0;
    [session startRunning];
}

//- (void)scanCode{
//
//    // iOS 8 后，全部都要授权
//    AVAuthorizationStatus status =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//
//    switch (status) {
//        case AVAuthorizationStatusNotDetermined:{
//            // 许可对话没有出现，发起授权许可
//            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//
//                if (granted) {
//                    //第一次用户接受
//                    //                    QMYViewController *qm = [[QMYViewController alloc] init];
//                    //                    [self.navigationController pushViewController:qm animated:YES];
//
//                    //                    dispatch_async(dispatch_get_main_queue(),^{
//                    //
//                    //                        QMYViewController *qm = [[QMYViewController alloc] init];
//                    //                        [self.navigationController pushViewController:qm animated:NO];
//                    //                    });
//
//                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                        [self scanCode];
//                    });
//                }else{
//                    //用户拒绝
//                    NSLog(@"用户明确地拒绝授权,请打开权限");
//                    dispatch_async(dispatch_get_main_queue(),^{
//
//
//                        [self.navigationController popViewControllerAnimated:YES];
//
//                    });
//                }
//            }];
//            break;
//        }
//        case AVAuthorizationStatusAuthorized:{
//            [self _initview];
//            index = 0;
//            [session startRunning];
//            [self createTimer];
//            break;
//        }
//        case AVAuthorizationStatusDenied:
//        case AVAuthorizationStatusRestricted:
//        {
//
//        }
//            NSLog(@"用户明确地拒绝授权，或者相机设备无法访问,请打开权限");
//
//            [self alertViewAction];
//            // 用户明确地拒绝授权，或者相机设备无法访问
//
//            break;
//        default:
//            break;
//    }
//}

//- (void)alertViewAction{
//
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GET_LANGUAGE_KEY(@"UnableCamera") message:GET_LANGUAGE_KEY(@"UnableCameraHint") delegate:self cancelButtonTitle:GET_LANGUAGE_KEY(@"IKnow") otherButtonTitles:nil];
//    [alert show];
//
//}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)_initview{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
        //获取摄像设备
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //创建输入流
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        //创建输出流
        output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //初始化链接对象
        session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [session setSessionPreset:AVCaptureSessionPresetHigh];
        [session addInput:input];
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
        layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        layer.frame= CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT); //self.view.layer.bounds;
        [self.view.layer insertSublayer:layer atIndex:0];
        //可根据此方法传入相应的扫描框和扫描线图片
        [self initWithScanViewName:@"scanRect" withScanLinaName:@"LineScan" withPickureZoom:1.2];
    }
    else
    {
        NSLog(@"该设备无法使用相机功能");
    }
    
}



-(void)initWithScanViewName:(NSString *)ScvName withScanLinaName:(NSString *)SclName withPickureZoom:(CGFloat)pkz
{
    
    [self setScanImageView:ScvName withZoom:pkz];
    [self setScanLine:SclName withZoom:pkz];
    [self setScanBackView];
}
#pragma mark-method

//设置扫描这该区域
-(void) setScanBackView
{
    
    //    static BOOL first = YES;
    //    if (!first) {
    //        return;
    //    }
    //    first = NO;
    CGFloat MaxY = CGRectGetMaxY(_QimageView.frame);
    [output setRectOfInterest:CGRectMake(_QimageView.frame.origin.y/self.view.frame.size.height, _QimageView.frame.origin.x/self.view.frame.size.width, _QimageView.frame.size.height/SCREEN_HEIGHT, _QimageView.frame.size.width/SCREEN_WIDTH)];
    
    //    上方遮盖层
    UIView * upView = [[UIView alloc] initWithFrame:CGRectMake(0, self.naviView.frame.size.height,self.view.frame.size.width,_QimageView.frame.origin.y - self.naviView.frame.size.height)];
    upView.backgroundColor = [UIColor blackColor];
    upView.alpha = Qmyalpha;
    [self.view addSubview:upView];
    
    //左侧遮盖层
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, _QimageView.frame.origin.y, _QimageView.frame.origin.x, _QimageView.frame.size.height)];
    leftView.backgroundColor = [UIColor blackColor];
    leftView.alpha = Qmyalpha;
    [self.view addSubview:leftView];
    //右侧遮盖层
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) + _QimageView.frame.size.width, leftView.frame.origin.y, leftView.frame.size.width, leftView.frame.size.height)];
    rightView.backgroundColor = [UIColor blackColor];
    rightView.alpha = Qmyalpha;
    [self.view addSubview:rightView];
    //下方遮盖曾
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY, self.view.frame.size.width, SCREEN_HEIGHT-MaxY)];
    downView.backgroundColor = [UIColor blackColor];
    downView.alpha = Qmyalpha;
    [self.view addSubview:downView];
    
    //中间透明
    UIView * centerView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMinY(leftView.frame), _QimageView.frame.size.width, _QimageView.frame.size.height)];
    centerView.backgroundColor = [UIColor clearColor];
    centerView.layer.borderColor = COLOR_68C7A7.CGColor;
    centerView.layer.borderWidth = 0.5;
    [self.view addSubview:centerView];
    CGFloat height = 4;
    CGFloat width = 17;
    CGRect size1 = CGRectMake(0, 0, width, height);
    CGRect size2 = CGRectMake(0, 0, height, width);
    CGRect size3 = CGRectMake(CGRectGetWidth(centerView.frame)-width, 0, width, height);
    CGRect size4 = CGRectMake(CGRectGetWidth(centerView.frame)-height, 0, height, width);
    CGRect size5 = CGRectMake(0, CGRectGetHeight(centerView.frame)-height, width, height);
    CGRect size6 = CGRectMake(0, CGRectGetHeight(centerView.frame)-width, height, width);
    CGRect size7 = CGRectMake(CGRectGetWidth(centerView.frame)-width, CGRectGetHeight(centerView.frame)-height, width, height);
    CGRect size8 = CGRectMake(CGRectGetWidth(centerView.frame)-height, CGRectGetHeight(centerView.frame)-width, height, width);
    
    NSArray *array = @[[NSValue valueWithCGRect:size1],
                       [NSValue valueWithCGRect:size2],
                       [NSValue valueWithCGRect:size3],
                       [NSValue valueWithCGRect:size4],
                       [NSValue valueWithCGRect:size5],
                       [NSValue valueWithCGRect:size6],
                       [NSValue valueWithCGRect:size7],
                       [NSValue valueWithCGRect:size8]];
    
    for (int i = 0; i < array.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:[array[i] CGRectValue]];
        view.backgroundColor = COLOR_68C7A7;
        [centerView addSubview:view];
    }
    
    UIButton *kaideng = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-38)/2.0, downView.frame.origin.y+40,38, 38)];
    [kaideng setImage:[UIImage imageNamed:@"scan-open2"] forState:UIControlStateNormal];
    [self.view addSubview:kaideng];
    [kaideng addTarget:self action:@selector(torchOnOrOff:) forControlEvents:UIControlEventTouchUpInside];
}

//小数转换
-(CGFloat) conversionFloat:(CGFloat) ofloat
{
    NSString * str =[NSString stringWithFormat:@"%.1f",ofloat ];
    CGFloat a  = str.floatValue;
    return a;
}
//根据传入图片设置扫描框
-(void) setScanImageView:(NSString *) imageName withZoom:(CGFloat) imageZoom
{
    //    CGFloat new = [self conversionFloat:imageZoom];
    UIImage * img = [UIImage imageNamed:imageName];
    //    CGFloat x = (self.view.frame.size.width- img.size.width*new)/2;
    //
    //    CGFloat y = self.view.frame.size.height/2-img.size.height*new+40;
    
    CGFloat imgWidth = SCREEN_WIDTH - 100;
    if (IS_IPAD) {
        imgWidth = 400;
    }
    
    CGFloat x = (self.view.frame.size.width- imgWidth)/2;
    
    CGFloat y = (SCREEN_HEIGHT-imgWidth) / 2.0;
    
    UIImageView * imgView = [[UIImageView alloc] initWithImage:img];
    
    imgView.frame = CGRectMake(x, y, imgWidth, imgWidth);
    _QimageView = imgView;
    [self.view addSubview:imgView];
    
    UILabel *TX_lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imgView.frame), CGRectGetMaxY(imgView.frame)+18, imgWidth, 40)];
    TX_lab.text = @"将二维码放入框中，即可自动扫描";
    TX_lab.textColor =[UIColor whiteColor];
    TX_lab.font = [UIFont systemFontOfSize:11];
    TX_lab.textAlignment = NSTextAlignmentCenter;
    TX_lab.numberOfLines = 1;
    TX_lab.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:TX_lab];
}
//根据传入图片设置扫码线
-(void) setScanLine:(NSString *) lineImageName withZoom:(CGFloat) imageZoom
{
    _linimg = [UIImage imageNamed:lineImageName];
    _QrCodeline = [[ UIImageView alloc ] initWithImage:_linimg];
    _QrCodeline.frame = CGRectMake(_QimageView.frame.origin.x , _QimageView.frame.origin.y, _QimageView.frame.size.width, _linimg.size.height*imageZoom);
    
    [ self.view addSubview : _QrCodeline ];
}
- ( void )moveUpAndDownLine

{
    CGFloat QY = _QimageView.frame.origin.y;
    CGFloat QMY = CGRectGetMaxY(_QimageView.frame);
    CGFloat Y= _QrCodeline . frame . origin . y ;
    if (Y == QY ){
        
        [UIView beginAnimations: @"asa" context: nil ];
        
        [UIView setAnimationDuration: 1.5 ];
        _QrCodeline.transform = CGAffineTransformMakeTranslation(0,_QimageView.frame.size.height-4);
        [UIView commitAnimations];
        
    } else if (Y == QMY-4){
        
        [UIView beginAnimations: @"asa" context: nil ];
        
        [UIView setAnimationDuration: 1.5 ];
        _QrCodeline.transform = CGAffineTransformMakeTranslation(0, 0);
        [UIView commitAnimations];
    }
    
}

- ( void )createTimer

{
    //创建一个时间计数
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector (moveUpAndDownLine) userInfo: nil repeats: YES ];
    }
    
}

- ( void )stopTimer

{
    
    if ([_timer isValid] == YES ) {
        
        [_timer invalidate];
        
        _timer = nil ;
        
    }
    
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection

{
    [session stopRunning];
    NSString *stringValue;
    
    if ([metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    [self scanResult:stringValue];
}


-(void) shuruAction{
    
    NSLog(@"点击");
}


- (void)clickRightButton:(UIButton *)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *phoots, NSArray *assets, BOOL result) {
            if ([phoots firstObject]) {
                UIImage *img = (UIImage *)phoots.firstObject;
                NSString *result = [self readQRCodeFromImage:img];
                [self scanResult:result];
            }
        }];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
    
}


#pragma mark 读取图片二维码
- (NSString *)readQRCodeFromImage:(UIImage *)pickImage {
    NSString *content = @"" ;
    //取出选中的图片
    NSData *imageData = UIImagePNGRepresentation(pickImage);
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    //创建探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    NSArray *feature = [detector featuresInImage:ciImage];
    
    //取出探测到的数据
    for (CIQRCodeFeature *result in feature) {
        content = result.messageString;
    }
    //进行处理(音效、网址分析、页面跳转等)
    return content;
}

// 处理结果

- (void)scanResult:(NSString *)stringValue {
    if (stringValue == nil || stringValue.length == 0) {
        [_emptyView removeFromSuperview];
        _emptyView = nil;
        _emptyView = [[UIButton alloc] init];
        [_emptyView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        [_emptyView addTarget:self action:@selector(reScanClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_emptyView];
        [session stopRunning];
        [self stopTimer];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"未发现二维码";
        lab.textColor = COLOR_B4;
        lab.font = FONT_F16;
        [_emptyView addSubview:lab];
        
        UILabel *lab1 = [[UILabel alloc] init];
        lab1.text = @"轻触屏幕继续扫描";
        lab1.textColor = COLOR_B4;
        lab1.font = FONT_F11;
        [_emptyView addSubview:lab1];
        
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.naviView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_QimageView.mas_centerY).offset(-10);
            make.centerX.equalTo(self.view);
        }];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_QimageView.mas_centerY).offset(10);
            make.centerX.equalTo(self.view);
        }];
        
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(equmname:)]) {
        [_delegate equmname:stringValue];
        [self removeQMYViewCtrl];
        return;
    }
    
    //切割字符串
    if ([stringValue containsString:@"abcpen.com"]) {
        if ([stringValue containsString:@"loginByScanning"]) {
            if ([stringValue containsString:@"role="]) {
                NSRange range = [stringValue rangeOfString:@"role="];
                NSString *role = [stringValue substringWithRange:NSMakeRange(range.location+range.length, 1)];
                if ([role integerValue] != 1) {
                    [Utils showToastMessage:@"无效二维码"];
                }
                else {

                }
            }
            else {
                [Utils showToastMessage:@"无效二维码"];
            }
            
            [self removeQMYViewCtrl];
        }
        else if ([stringValue containsString:@"loginByWebScanning"]) {
            
            [self removeQMYViewCtrl];
            return;
        } else if ([stringValue containsString:@"imGroupId="]){
            
            [self removeQMYViewCtrl];
            return;
        }
    } else {
        BaseWebViewCtrl *vc = [[BaseWebViewCtrl alloc] init];
//        http://127.0.0.1:8080/barcodeSearch?code=150220E101&token=Bearer%20eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxMzgxOTcxNzY4OCIsImF1dGgiOiJST0xFX09QRVJBVE9SIiwiZXhwIjoxNTM1MDI0NTY1fQ.IWYTWK1cFCSDFa4PXXuqO2NIgSe5xtyF7ocXXwEeDd4Nm_okV05txsR8zsap7VBiQTWBw06q0yLyGVYzMYyNHw
        NSString *urlStr = [NSString stringWithFormat:@"%@code=%@&token=%@", BARCODE_SEARCH, stringValue, [Utils token]];
        vc.urlStr = urlStr;
        vc.titleStr = @"批次查询";
        [self.navigationController pushViewController:vc animated:YES];
        [self removeQMYViewCtrl];
    }
}

- (void)removeQMYViewCtrl {
    // 去掉扫码控制器
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *ctrls = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        [ctrls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[QMYViewController class]]) {
                [ctrls removeObject:obj];
                *stop = YES;
            }
        }];
        self.navigationController.viewControllers = ctrls;
    });
}

//调用系统的开灯关灯功能
- (void)torchOnOrOff:(UIButton*)bu
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if (device.torchMode == AVCaptureTorchModeOff) {
        [device setTorchMode: AVCaptureTorchModeOn];
        [bu setImage:[UIImage imageNamed:@"scan-open"] forState:UIControlStateNormal];
    }else{
        [device setTorchMode: AVCaptureTorchModeOff];
        
        [bu setImage:[UIImage imageNamed:@"scan-open2"] forState:UIControlStateNormal];
    }
    [device unlockForConfiguration];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //    [session startRunning];
    [self stopTimer];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)AzAction{
    
}

- (void)reScanClick:(UIButton *)sender {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    [session startRunning];
    [self createTimer];
}

@end
