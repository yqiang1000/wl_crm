//
//  VPImageCropperViewCtrl.m
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import "VPImageCropperViewCtrl.h"

#define SCALE_FRAME_Y 100.0f
#define BOUNDCE_DURATION 0.3f

@interface VPImageCropperViewCtrl ()

@property (nonatomic, retain) UIImage *oldImage;//原始图片
@property (nonatomic, retain) UIImage *originalImage;
@property (nonatomic, retain) UIImage *editedImage;

@property (nonatomic, retain) UIImageView *showImgView;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UIImageView *ratioView;

@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, assign) CGRect largeFrame;
@property (nonatomic, assign) CGFloat limitRatio;

@property (nonatomic, assign) CGRect latestFrame;

@end

@implementation VPImageCropperViewCtrl

- (void)dealloc {
    self.originalImage = nil;
    self.showImgView = nil;
    self.editedImage = nil;
    self.overlayView = nil;
    self.ratioView = nil;
    self.delegate = nil;
}

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio {
    self = [super init];
    if (self) {
        
        self.cropFrame = cropFrame;
        self.limitRatio = limitRatio;
        self.originalImage = originalImage;
        self.oldImage = originalImage;
        
        [self initView];
        [self initControlBtn];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self initView];
//    [self initControlBtn];
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - 横竖屏监听

- (void)changeRotate:(NSNotification*)noti {
    float y = (SCREEN_HEIGHT-_cropFrame.size.height)*0.5-50;
    float x = (SCREEN_WIDTH - _cropFrame.size.width)*0.5;
    self.cropFrame = CGRectMake(x, y, _cropFrame.size.width, _cropFrame.size.height);
    [self initView];
}

- (void)initView {
    if (_showImgView == nil) {
        self.showImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.showImgView setMultipleTouchEnabled:YES];
        [self.showImgView setUserInteractionEnabled:YES];
        [self.showImgView setImage:self.originalImage];
        [self.showImgView setUserInteractionEnabled:YES];
        [self.showImgView setMultipleTouchEnabled:YES];
        
        [self addGestureRecognizers];
        [self.view addSubview:self.showImgView];
    }
    
    float width = self.oldImage.size.width;
    float height = self.oldImage.size.height;
    if (width > SCREEN_WIDTH || height > SCREEN_HEIGHT) {
        float rate1 = SCREEN_WIDTH / width;
        float rate2 = SCREEN_HEIGHT / height;
        float rate = rate1 < rate2 ? rate1 : rate2;
        self.originalImage = [Utils imageByScalingToSize:CGSizeMake(_originalImage.size.width*rate, _originalImage.size.height*rate) source:self.oldImage];
    }

    // scale to fit the screen
    CGFloat oriWidth = SCREEN_WIDTH;
    CGFloat oriHeight = self.originalImage.size.height * (oriWidth / self.originalImage.size.width);
    
    CGFloat oriX = 0 + (SCREEN_WIDTH - oriWidth) / 2;
    CGFloat oriY = 0 + (SCREEN_HEIGHT - oriHeight) / 2;
    self.showImgView.frame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
    
    oriWidth = _cropFrame.size.width;
    oriHeight = self.originalImage.size.height * (oriWidth / self.originalImage.size.width);
    oriX = _cropFrame.origin.x;
    oriY = self.cropFrame.origin.y + (oriWidth - oriHeight) / 2;
    self.oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
    self.latestFrame = self.oldFrame;
    self.largeFrame = CGRectMake(0, 0, self.limitRatio * self.oldFrame.size.width, self.limitRatio * self.oldFrame.size.height);
    
    if (_overlayView == nil) {
        self.overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.overlayView.alpha = .5f;
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.userInteractionEnabled = NO;
        self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.overlayView];
        [_overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
        }];
    }
    _overlayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    CGRect clipFrame = _cropFrame;
    clipFrame.origin.x -= 6;
    clipFrame.origin.y -= 6;
    clipFrame.size.width += 12;
    clipFrame.size.height += 12;
    
    if (_ratioView == nil) {
        self.ratioView = [[UIImageView alloc] initWithFrame:clipFrame];
        self.ratioView.autoresizingMask = UIViewAutoresizingNone;
        //    self.ratioView.clipsToBounds = YES;
        //    self.ratioView.layer.cornerRadius = _cropFrame.size.width / 2.0;
        self.ratioView.image = [[UIImage imageNamed:@"clippingBox"] stretchableImageWithLeftCapWidth:28 topCapHeight:28];
        [self.view addSubview:self.ratioView];
    }
    else self.overlayView.layer.mask = nil;
    _ratioView.frame = clipFrame;
    
    [self overlayClipping];
    
    CGRect newFrame = self.showImgView.frame;
    newFrame = [self handleScaleOverflow:newFrame];
    newFrame = [self handleBorderOverflow:newFrame];
    self.showImgView.frame = newFrame;
    self.latestFrame = newFrame;
}

- (void)initControlBtn {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = SYSTEM_FONT_BOLD(15);
    title.text = GET_LANGUAGE_KEY(@"裁剪");
    
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.width.equalTo(@200);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50.0f, 100, 50)];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.titleLabel.textColor = [UIColor whiteColor];
    [cancelBtn setTitle:GET_LANGUAGE_KEY(@"取消") forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [cancelBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cancelBtn.titleLabel setNumberOfLines:0];
    [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.width.equalTo(@100);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100.0f, self.view.frame.size.height - 50.0f, 100, 50)];
    confirmBtn.backgroundColor = [UIColor clearColor];
    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
    [confirmBtn setTitle:GET_LANGUAGE_KEY(@"保存") forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [confirmBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
    [confirmBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [confirmBtn.titleLabel setNumberOfLines:0];
    [confirmBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.width.equalTo(@100);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)cancel:(id)sender {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(VPImageCropperDelegate)]) {
        [self.delegate imageCropperDidCancel:self];
    }
}

- (void)confirm:(id)sender {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(VPImageCropperDelegate)]) {
        [self.delegate imageCropper:self didFinished:[self getSubImage]];
    }
}

- (void)overlayClipping
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //CGMutablePathRef path = CGPathCreateMutable();
    
    int radius = 0;//_cropFrame.size.width/2.0;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.overlayView.frame cornerRadius:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:_cropFrame cornerRadius:radius];
    
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    maskLayer.path = path.CGPath;
    maskLayer.fillRule =kCAFillRuleEvenOdd;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    maskLayer.opacity = 1.0;
    
    //[self.overlayView.layer addSublayer:maskLayer];
    
    // Left side of the ratio view
//    CGPathAddRect(path, nil, CGRectMake(0, 0,
//                                        self.ratioView.frame.origin.x,
//                                        self.overlayView.frame.size.height));
//    // Right side of the ratio view
//    CGPathAddRect(path, nil, CGRectMake(
//                                        self.ratioView.frame.origin.x + self.ratioView.frame.size.width,
//                                        0,
//                                        self.overlayView.frame.size.width - self.ratioView.frame.origin.x - self.ratioView.frame.size.width,
//                                        self.overlayView.frame.size.height));
//    // Top side of the ratio view
//    CGPathAddRect(path, nil, CGRectMake(0, 0,
//                                        self.overlayView.frame.size.width,
//                                        self.ratioView.frame.origin.y));
//    // Bottom side of the ratio view
//    CGPathAddRect(path, nil, CGRectMake(0,
//                                        self.ratioView.frame.origin.y + self.ratioView.frame.size.height,
//                                        self.overlayView.frame.size.width,
//                                        self.overlayView.frame.size.height - self.ratioView.frame.origin.y + self.ratioView.frame.size.height));
//    maskLayer.path = path;
    
    self.overlayView.layer.mask = maskLayer;
    //CGPathRelease(path);
}

// register all gestures
- (void) addGestureRecognizers
{
    // add pinch gesture
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    // add pan gesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

// pinch gesture handler
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = self.showImgView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImgView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

// pan gesture handler
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = self.showImgView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // calculate accelerator
        CGFloat absCenterX = self.cropFrame.origin.x + self.cropFrame.size.width / 2;
        CGFloat absCenterY = self.cropFrame.origin.y + self.cropFrame.size.height / 2;
        CGFloat scaleRatio = self.showImgView.frame.size.width / self.cropFrame.size.width;
        CGFloat acceleratorX = 1 - ABS(absCenterX - view.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - view.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x * acceleratorX, view.center.y + translation.y * acceleratorY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // bounce to original frame
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImgView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

- (CGRect)handleScaleOverflow:(CGRect)newFrame {
    // bounce to original frame
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
    if (newFrame.size.width < self.oldFrame.size.width) {
        newFrame = self.oldFrame;
    }
    if (newFrame.size.width > self.largeFrame.size.width) {
        newFrame = self.largeFrame;
    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
    return newFrame;
}

- (CGRect)handleBorderOverflow:(CGRect)newFrame {
    // horizontally
    if (newFrame.origin.x > self.cropFrame.origin.x) newFrame.origin.x = self.cropFrame.origin.x;
    if (CGRectGetMaxX(newFrame) < self.cropFrame.origin.x+self.cropFrame.size.width) {
        newFrame.origin.x = self.cropFrame.origin.x + self.cropFrame.size.width - newFrame.size.width;
    }
    // vertically
    if (newFrame.origin.y > self.cropFrame.origin.y) newFrame.origin.y = self.cropFrame.origin.y;
    if (CGRectGetMaxY(newFrame) < self.cropFrame.origin.y + self.cropFrame.size.height) {
        newFrame.origin.y = self.cropFrame.origin.y + self.cropFrame.size.height - newFrame.size.height;
    }
    // adapt horizontally rectangle
    if (self.showImgView.frame.size.width > self.showImgView.frame.size.height && newFrame.size.height <= self.cropFrame.size.height) {
        newFrame.origin.y = self.cropFrame.origin.y + (self.cropFrame.size.height - newFrame.size.height) / 2;
    }
    return newFrame;
}

-(UIImage *)getSubImage{
    CGRect squareFrame = self.cropFrame;
    CGFloat scaleRatio = self.latestFrame.size.width / self.originalImage.size.width;
    CGFloat x = (squareFrame.origin.x - self.latestFrame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - self.latestFrame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.height / scaleRatio;
    if (self.latestFrame.size.width < self.cropFrame.size.width) {
        CGFloat newW = self.originalImage.size.width;
        CGFloat newH = newW * (self.cropFrame.size.height / self.cropFrame.size.width);
        x = 0; y = y + (h - newH) / 2;
        w = newH; h = newH;
    }
    if (self.latestFrame.size.height < self.cropFrame.size.height) {
        CGFloat newH = self.originalImage.size.height;
        CGFloat newW = newH * (self.cropFrame.size.width / self.cropFrame.size.height);
        x = x + (w - newW) / 2; y = 0;
        w = newH; h = newH;
    }
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = self.originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end
