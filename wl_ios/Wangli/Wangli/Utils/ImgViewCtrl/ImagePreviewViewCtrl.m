//
//  ImagePreviewViewCtrl.m
//  ABCInstitution-Teacher
//
//  Created by dev001 on 2017/12/22.
//  Copyright © 2017年 北京暄暄科技有限公司. All rights reserved.
//

#import "ImagePreviewViewCtrl.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "QiniuFileMo.h"
#import "WSLPhotoZoom.h"
#import "BottomView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImagePreviewViewCtrl ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIScrollView *m_scrollView;
    UIPageControl *m_pageCtrl;
    NSInteger m_defaultIndex;
}

@property (nonatomic, strong) UIView *imgEditView;
@property (nonatomic, strong) UIButton *btnCurr;

@property (nonatomic, strong) NSMutableArray *arrAllImg;
@property (nonatomic, strong) NSMutableArray *arrImgView;
@property (nonatomic, strong) NSMutableArray *arrDelIndex;

@property (nonatomic, copy) ImageBlock imageBlock;


@end

@implementation ImagePreviewViewCtrl

- (instancetype)init
{
    if (self = [super init]) {
        _isIM = NO;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _isIM = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.naviView.labTitle.textColor = [UIColor whiteColor];
    self.rightBtn.hidden = _hidenDelete;
    self.naviView.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.7];
    self.naviView.lineView.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.7];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    //    if (_isIM) {
    //        [self.rightBtn setTitle:@"更多" forState:UIControlStateNormal];
    //        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        self.naviView.labTitle.text = @"预览";
    //    } else {
    //        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        [self.rightBtn setTitle:GET_LANGUAGE_KEY(@"weikeEdit") forState:UIControlStateNormal];
    //        [self.rightBtn setTitle:GET_LANGUAGE_KEY(@"weikeSortFinish") forState:UIControlStateSelected];
    //    }
    [self.rightBtn setImage:[UIImage imageNamed:@"ic_baissc"] forState:UIControlStateNormal];
    self.naviView.labTitle.text = [NSString stringWithFormat:@"%zi/%zi", m_defaultIndex+1, _arrAllImg.count];
    
    [self setupUI];
    [self addGestes];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)addGestes {
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
    [m_scrollView addGestureRecognizer:longPressGesture];
}

- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //        NSLog(@"长按------%ld", m_defaultIndex);
        BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) items:@[@"保存到本地"] defaultItem:-1 itemClick:^(NSInteger index) {
            if (index == 0) [self saveToLocal];
        } cancelClick:^(BottomView *obj) {
            [obj removeFromSuperview];
            obj = nil;
        }];
        [bottomView show];
    }
}

- (void)saveToLocal {
    NSInteger currIndex = m_pageCtrl.currentPage;
    WSLPhotoZoom *currView = (WSLPhotoZoom *)_arrImgView[currIndex];
    UIImage *saveImage = currView.imageView.image;
    if (!saveImage) {
        [Utils showToastMessage:@"图片不能为空"];
        return;
    }
    [Utils showHUDWithStatus:nil];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:saveImage];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"保存图片到相册中失败，错误信息：%@", error.localizedDescription);
                [Utils showToastMessage:@"保存图片到相册发生错误"];
                [Utils dismissHUD];
            } else {
                [Utils dismissHUD];
                [Utils showToastMessage:@"保存成功"];
            }
        });
    }];
}


- (void)clickLeftButton:(UIButton *)sender
{
    if (self.rightBtn.selected) {
        [self clickRightButton:self.rightBtn];
        return;
    }
    if (_imageBlock) {
        _imageBlock(_arrAllImg);
    }
    
    
    //对数组进行降序
    NSArray *result = [_arrDelIndex sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSLog(@"%@~%@",obj1,obj2); //3~4 2~1 3~1 3~2
        
        return [obj2 compare:obj1]; //降序
    }];
    
    NSLog(@"result=%@",result);
    
    if ([_imgPrevCtrlDelegate respondsToSelector:@selector(deleteImageIndexes:)]) {
        [_imgPrevCtrlDelegate deleteImageIndexes:result];
    }
    
    [_arrImgView removeAllObjects];
    [_arrAllImg removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_scrollView setContentOffset:CGPointMake(m_pageCtrl.currentPage*SCREEN_WIDTH, 0) animated:NO];
    });
}

- (void)clickRightButton:(UIButton *)sender
{
    //    if (_isIM) {
    //        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //        UIAlertAction *cancel = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    //        }];
    //        UIAlertAction *ok1 = [UIAlertAction actionWithTitle:@"录制白板" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            if (_arrImgView.count <= 0) return;
    //            UIImage *image = ((UIImageView *)_arrImgView[0]).image;
    //            if (image == nil) return;
    //
    ////            ChatWBViewController *ctrl = [[ChatWBViewController alloc] initWithImage:image];
    ////            ctrl.delegate = self;
    ////            ctrl.isPortrait = YES;
    ////            if (IS_IPAD && [alert respondsToSelector:@selector(popoverPresentationController)]) {
    ////                alert.popoverPresentationController.sourceView = self.rightBtn; //必须加
    ////                alert.popoverPresentationController.sourceRect = self.rightBtn.bounds;
    ////            }
    ////            [self presentViewController:ctrl animated:YES completion:nil];
    //        }];
    //        UIAlertAction *ok2 = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            if (_arrImgView.count <= 0) return;
    //            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    //            if (author == ALAuthorizationStatusNotDetermined)
    //            {
    //                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
    //
    //                }];
    //            }
    //
    //            UIImage *image = ((UIImageView *)_arrImgView[0]).image;
    //            if (image == nil) return;
    //            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    //        }];
    //        [alert addAction:cancel];
    //        [alert addAction:ok1];
    //        [alert addAction:ok2];
    //
    //        if (IS_IPAD && [alert respondsToSelector:@selector(popoverPresentationController)]) {
    //            alert.popoverPresentationController.sourceView = self.rightBtn; //必须加
    //            alert.popoverPresentationController.sourceRect = self.rightBtn.bounds;
    //        }
    //        [self presentViewController:alert animated:YES completion:nil];
    //        return;
    //    }
    //
    //编辑or完成
    //    [UIView animateWithDuration:0.2 animations:^{
    ////        [_imgEditView updateConstraints:^(MASConstraintMaker *make) {
    ////            make.bottom.equalTo(self.view).offset(sender.selected ? 60 : 0);
    ////        }];
    ////        [self.view layoutIfNeeded];
    //    }];
    
    //    sender.selected = !sender.selected;
    
    //    if (sender.selected) {
    //        m_scrollView.scrollEnabled = NO;
    //        UIImageView *selectImageView = (UIImageView *)_arrImgView[m_defaultIndex];
    //         _drawingBoardView = [[RunsDrawingBoardView alloc] initWithFrame:[self getRectFromImageView:selectImageView]];
    //        _drawingBoardView.drawEnable = YES;
    //        _drawingBoardView.delegate = self;
    //        _drawingBoardView.brushModel.color = [UIColor redColor];
    ////        [selectImageView addSubview:_drawingBoardView];
    //        [self.view insertSubview:_drawingBoardView belowSubview:self.naviView];
    //    }else{
    //        m_scrollView.scrollEnabled = YES;
    //        //TODO save image
    //        [self saveNewImage];
    ////        [_drawingBoardView removeFromSuperview];
    ////        _drawingBoardView = nil;
    //    }
    
    //删除功能
    NSInteger currIndex = m_pageCtrl.currentPage;
    WSLPhotoZoom *currView = (WSLPhotoZoom *)_arrImgView[currIndex];
    [self.arrDelIndex addObject:@(currView.imageView.tag-8989)];
    
    if (_arrImgView.count == 1) {
        [self clickLeftButton:nil];
        return;
    }
    
    UIView *lastView = nil;
    UIView *nextView = nil;
    if (currIndex > 0) {
        lastView = _arrImgView[currIndex-1];
    }
    if (currIndex < _arrImgView.count-1)  {
        nextView = _arrImgView[currIndex+1];
    }
    
    if (nextView != nil) {
        [nextView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView == nil) make.left.equalTo(m_scrollView);
            else make.left.equalTo(lastView.mas_right);
            make.top.width.height.equalTo(m_scrollView);
            if (currIndex == _arrImgView.count-1) make.right.equalTo(m_scrollView);
        }];
    }
    else {
        [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(m_scrollView);
        }];
    }
    
    [_arrImgView removeObjectAtIndex:currIndex];
    [_arrAllImg removeObjectAtIndex:currIndex];
    [currView removeFromSuperview];
    
    if (currIndex == _arrAllImg.count) m_pageCtrl.currentPage = currIndex-1;
    m_pageCtrl.numberOfPages = _arrAllImg.count;
    
    self.naviView.labTitle.text = [NSString stringWithFormat:@"%zi/%zi", m_pageCtrl.currentPage+1, _arrAllImg.count];
}

-(CGRect) getRectFromImageView:(UIImageView *) imageView
{
    CGFloat imageWidth = imageView.image.size.width;
    CGFloat imageHeight = imageView.image.size.height;
    CGFloat viewWidth = imageView.bounds.size.width;
    CGFloat viewHeight = imageView.bounds.size.height;
    float widthScale = 0;
    float heightScale = 0;
    widthScale = viewWidth/imageWidth;
    heightScale = viewHeight/imageHeight;
    float scale = MIN(widthScale, heightScale);
    return CGRectMake((viewWidth - imageWidth * scale)/2, (viewHeight - imageHeight * scale)/2, imageWidth * scale, imageHeight * scale);
}

-(void) saveNewImage
{
    //    UIImageView *selectImageView = (UIImageView *)_arrImgView[m_defaultIndex];
    //    UIImage *newImage = [self addImage:selectImageView toImage:[_drawingBoardView saveViewToImage]];
    //    _arrAllImg[m_defaultIndex] = newImage;
    //    selectImageView.image = newImage;
}

-(UIImage *) imageViewSnap:(UIImageView *) imageView
{
    UIGraphicsBeginImageContext(CGSizeMake(100, 100));
    
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image1;
}

//- (UIImage *)addImage:(UIImageView *) imageView toImage:(UIImage *)image2 {
//
//    UIImage *image1 = imageView.image;
//    if (image1 == nil && image2 == nil) {
//        return nil;
//    }
//    else if (image1 == nil) return image2;
//    else if (image2 == nil) return image1;
//
//    CGRect image1Rect = [self getRectFromImageView:imageView];
//
//    UIGraphicsBeginImageContext(image1Rect.size);
//
//    // Draw image1
//    [image1 drawInRect:CGRectMake(0, 0, image1Rect.size.width, image1Rect.size.height)];
//
//    // Draw image2
//    [image2 drawInRect:CGRectMake(0, 0, image1Rect.size.width, image1Rect.size.height)];
//
//    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//
//    return resultingImage;
//}

- (id)initWithArrImage:(NSArray *)arrImg
             currIndex:(NSInteger)currIndex
             dataBlock:(ImageBlock) imgBlock
{
    if (self = [super init])
    {
        _isIM = NO;
        m_defaultIndex = currIndex;
        _arrAllImg = [NSMutableArray new];
        for (id tmpMo in arrImg) {
            if ([tmpMo isKindOfClass:[QiniuFileMo class]]) {
                [_arrAllImg addObject:STRING(((QiniuFileMo *)tmpMo).url)];
            } else if ([tmpMo isKindOfClass:[UIImage class]]) {
                [_arrAllImg addObject:tmpMo];
            }
        }
        _imageBlock = imgBlock;
    }
    
    return self;
}

//图片url集合
- (id)initWithArrImage:(NSArray *)arrImg
             currIndex:(NSInteger)currIndex
{
    if (self = [super init])
    {
        _isIM = NO;
        m_defaultIndex = currIndex;
        _arrAllImg = [NSMutableArray new];
        for (id tmpMo in arrImg) {
            if ([tmpMo isKindOfClass:[QiniuFileMo class]]) {
                [_arrAllImg addObject:STRING(((QiniuFileMo *)tmpMo).url)];
            } else if ([tmpMo isKindOfClass:[UIImage class]]) {
                [_arrAllImg addObject:tmpMo];
            }
        }
    }
    
    return self;
}

- (void)setupUI
{
    m_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    m_scrollView.pagingEnabled = YES;
    m_scrollView.delegate = self;
    m_scrollView.showsHorizontalScrollIndicator = NO;
    [self.view insertSubview:m_scrollView belowSubview:self.naviView];
    [m_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(UIEdgeInsetsZero);
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    if (_arrAllImg.count > 1)
    {
        m_pageCtrl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 20)];
        m_pageCtrl.currentPageIndicatorTintColor = [UIColor whiteColor];
        m_pageCtrl.pageIndicatorTintColor = [UIColor blackColor];
        m_pageCtrl.numberOfPages = _arrAllImg.count;
        m_pageCtrl.userInteractionEnabled = NO;
        [m_pageCtrl addTarget:self action:@selector(pageCtrlClick) forControlEvents:UIControlEventValueChanged];
        m_pageCtrl.hidden = YES;
        [self.view addSubview:m_pageCtrl];
        
        [m_pageCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-40);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@20);
        }];
    }
    
    UIView *lastView = nil;
    for (int i=0; i<_arrAllImg.count; i++)
    {
        WSLPhotoZoom * photoZoomView = [[WSLPhotoZoom alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        photoZoomView.imageNormalWidth = self.view.frame.size.width;
        photoZoomView.imageNormalHeight = self.view.frame.size.height;
        photoZoomView.imageView.tag = 8989+i;
        photoZoomView.backgroundColor =[UIColor blackColor];
        
        
        photoZoomView.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [m_scrollView addSubview:photoZoomView];
        
        [photoZoomView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView == nil) make.left.equalTo(m_scrollView);
            else make.left.equalTo(lastView.mas_right);
            make.top.width.height.equalTo(m_scrollView);
            if (i == _arrAllImg.count-1) make.right.equalTo(m_scrollView);
        }];
        lastView = photoZoomView;
        [self.arrImgView addObject:photoZoomView];
        if ([_arrAllImg[i] isKindOfClass:[UIImage class]]) {
            photoZoomView.imageView.image = _arrAllImg[i];
            continue;
        }
        
        [Utils showHUDWithStatus:nil];
        [photoZoomView.imageView sd_setImageWithURL:[NSURL URLWithString:_arrAllImg[i]]
                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                              [Utils dismissHUD];
                                          }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [Utils dismissHUD];
        });
    }
    
    
    //    UIView *lastView = nil;
    //    for (int i=0; i<_arrAllImg.count; i++)
    //    {
    //        UIImageView *imgView1 = [[UIImageView alloc] init];
    //        imgView1.tag = 8989 + i;
    //        imgView1.contentMode = UIViewContentModeScaleAspectFit;
    //        imgView1.userInteractionEnabled = YES;
    //        [m_scrollView addSubview:imgView1];
    //        [imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
    //            if (lastView == nil) make.left.equalTo(m_scrollView);
    //            else make.left.equalTo(lastView.mas_right);
    //            make.top.width.height.equalTo(m_scrollView);
    //            if (i == _arrAllImg.count-1) make.right.equalTo(m_scrollView);
    //        }];
    //        lastView = imgView1;
    //        [self.arrImgView addObject:imgView1];
    //        if ([_arrAllImg[i] isKindOfClass:[UIImage class]]) {
    //            imgView1.image = _arrAllImg[i];
    //
    //            continue;
    //        }
    //
    //        [Utils showHUDWithStatus:nil];
    //        [imgView1 sd_setImageWithURL:[NSURL URLWithString:_arrAllImg[i]]
    //                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //                               [Utils dismissHUD];
    //                           }];
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [Utils dismissHUD];
    //        });
    //    }
    
    m_pageCtrl.currentPage = m_defaultIndex;
    
    if (!_isIM) {
        [self.view addSubview:self.imgEditView];
        [_imgEditView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(60);
            make.height.equalTo(@60);
        }];
    }
}

- (void)btnOperationClick:(UIButton *)sender {
    
}
//{
//    switch (sender.tag) {
//        case EditImgType_Pen:
//            break;
//        case EditImgType_Undo:
//            [_drawingBoardView undo:YES];
//            break;
//        case EditImgType_Redo:
//            [_drawingBoardView redo];
//            break;
//        case EditImgType_White:
//        case EditImgType_Black:
//        case EditImgType_Red:
//        case EditImgType_Yellow:
//        case EditImgType_Green:
//        {
//            [self setWhiteBoardColor:(int)sender.tag];
//            if (_btnCurr == sender) return;
//            _btnCurr.selected = NO;
//            sender.selected = YES;
//            _btnCurr = sender;
//            break;
//        }
//        default:
//            break;
//    }
//}

//-(void) setWhiteBoardColor:(EditImgType) imgType
//{
//    switch (imgType) {
//        case EditImgType_White:
//            _drawingBoardView.brushModel.color = COLOR_B7;
//            break;
//
//        case EditImgType_Black:
//            _drawingBoardView.brushModel.color = COLOR_000000;
//            break;
//
//        case EditImgType_Red:
//            _drawingBoardView.brushModel.color = [UIColor redColor];
//            break;
//
//        case EditImgType_Yellow:
//            _drawingBoardView.brushModel.color = [UIColor yellowColor];
//            break;
//
//        case EditImgType_Green:
//            _drawingBoardView.brushModel.color = [UIColor greenColor];
//            break;
//
//        default:
//            break;
//    }
//}

//点击pagecontrol
-(void)pageCtrlClick
{
    //    m_pageCtrl.currentPage = m_pageCtrl.currentPage;
    //    CGPoint ponit = CGPointMake(m_pageCtrl.currentPage*SCREEN_WIDTH, 0.0f);
    //    [m_scrollView setContentOffset:ponit];
}

/*********************************************************************
 函数名称 : scrollViewDidEndDecelerating
 函数描述 : 系统回调函数，控制pagecontrol 变化
 参数 :
 返回值 :
 作者 : qian_hongyan
 *********************************************************************/

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat scrollx = scrollView.contentOffset.x;
    
    for (int i=0; i < _arrAllImg.count; i++)
    {
        if( scrollx == (SCREEN_WIDTH * i))
        {
            m_pageCtrl.currentPage = i;
        }
    }
    
    // 重置老的缩放图片
    if (m_defaultIndex >=0 && m_defaultIndex < self.arrAllImg.count) {
        //重置上一个缩放过的视图
        WSLPhotoZoom * zoomView  = (WSLPhotoZoom *)scrollView.subviews[m_defaultIndex];
        [zoomView pictureZoomWithScale:1.0];
    }
    
    m_defaultIndex = m_pageCtrl.currentPage;
    
    self.naviView.labTitle.text = [NSString stringWithFormat:@"%zi/%zi", m_pageCtrl.currentPage+1, _arrAllImg.count];
}

- (NSMutableArray *)arrImgView
{
    if (_arrImgView == nil) {
        _arrImgView = [NSMutableArray array];
    }
    
    return _arrImgView;
}

- (NSMutableArray *)arrDelIndex
{
    if (_arrDelIndex == nil) {
        _arrDelIndex = [NSMutableArray array];
    }
    
    return _arrDelIndex;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //    [self removeLoadingView];
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    [Utils showToastMessage:GET_LANGUAGE_KEY(@"imageSaveSuccess")];
}

#pragma mark - ChatWBViewControllerDelegate
- (void)sendVideo:(NSString *)url andImage:(UIImage *)image duration:(long) duration
{
    if ([_imgPrevCtrlDelegate respondsToSelector:@selector(sendVideo:andImage:duration:)]) {
        [_imgPrevCtrlDelegate sendVideo:url andImage:image duration:duration];
    }
}

#pragma mark - get&set
- (UIView *)imgEditView {
    return nil;
}
//{
//    if (_imgEditView == nil) {
//        _imgEditView = [UIView new];
//        _imgEditView.backgroundColor = [UIColor whiteColor];
//
//        UIButton *btnPen = [self createButton:@"imgedit_pen" strSelImg:@"imgedit_pen" tag:EditImgType_Pen];
//        [_imgEditView addSubview:btnPen];
//        [btnPen makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_imgEditView).offset(22);
//            make.centerY.equalTo(_imgEditView);
//        }];
//
//        UIView *lineView = [Utils getLineView];
//        [_imgEditView addSubview:lineView];
//        [lineView makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(btnPen.mas_right).offset(15);
//            make.centerY.equalTo(_imgEditView);
//            make.size.equalTo(CGSizeMake(1, 18));
//        }];
//
//        UIButton *btnRed = [self createButton:@"color_red" strSelImg:@"color_red_select" tag:EditImgType_Red];
//        [_imgEditView addSubview:btnRed];
//        [btnRed makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(_imgEditView);
//        }];
//        btnRed.selected = YES;
//        _btnCurr = btnRed;
//
//        float distance = SCREEN_WIDTH < 375 ? 15 : 27;
//        UIButton *btnBlack = [self createButton:@"color_black" strSelImg:@"color_black_select" tag:EditImgType_Black];
//        [_imgEditView addSubview:btnBlack];
//        [btnBlack makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_imgEditView);
//            make.right.equalTo(btnRed.mas_left).offset(-distance);
//        }];
//
//        UIButton *btnWhite = [self createButton:@"color_white" strSelImg:@"color_white_select" tag:EditImgType_White];
//        [_imgEditView addSubview:btnWhite];
//        [btnWhite makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_imgEditView);
//            make.right.equalTo(btnBlack.mas_left).offset(-distance);
//        }];
//
//        UIButton *btnYellow = [self createButton:@"color_yellow" strSelImg:@"color_yellow_select" tag:EditImgType_Yellow];
//        [_imgEditView addSubview:btnYellow];
//        [btnYellow makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_imgEditView);
//            make.left.equalTo(btnRed.mas_right).offset(distance);
//        }];
//
//        UIButton *btnGreen = [self createButton:@"color_green" strSelImg:@"color_green_select" tag:EditImgType_Green];
//        [_imgEditView addSubview:btnGreen];
//        [btnGreen makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_imgEditView);
//            make.left.equalTo(btnYellow.mas_right).offset(distance);
//        }];
//
//        UIButton *btnUndo = [self createButton:@"imgedit_back1_1" strSelImg:nil tag:EditImgType_Undo];
//        btnUndo.enabled = _drawingBoardView.canUndo;
//        [_imgEditView addSubview:btnUndo];
//        [btnUndo setImage:[UIImage imageNamed:@"imgedit_back1_2"] forState:UIControlStateDisabled];
//        [btnUndo makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_imgEditView);
//            make.right.equalTo(_imgEditView).offset(-15);
//        }];
//
//        UIButton *btnRedo = [self createButton:@"imgedit_revoke1_1" strSelImg:nil tag:EditImgType_Redo];
//        btnRedo.enabled = _drawingBoardView.canRedo;
//        [_imgEditView addSubview:btnRedo];
//        [btnRedo setImage:[UIImage imageNamed:@"imgedit_revoke1_2"] forState:UIControlStateDisabled];
//        [btnRedo makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_imgEditView);
//            make.right.equalTo(btnUndo.mas_left).offset(-15);
//        }];
//    }
//
//    return _imgEditView;
//}

//- (UIButton *)createButton:(NSString *)strImg strSelImg:(NSString *)strSelImg tag:(EditImgType)tag
//{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
////    [button setImage:[UIImage imageNamed:strImg] forState:UIControlStateNormal];
////    if (strSelImg.length > 0) [button setImage:[UIImage imageNamed:strSelImg] forState:UIControlStateSelected];
////    [button addTarget:self action:@selector(btnOperationClick:) forControlEvents:UIControlEventTouchUpInside];
////    button.tag = tag;
//    return button;
//}

#pragma mark - RunsDrawingBoardViewDelegate
-(void) redoUndoChange
{
    //    UIButton *redoBtn = [_imgEditView viewWithTag:EditImgType_Redo];
    //    UIButton *undoBtn = [_imgEditView viewWithTag:EditImgType_Undo];
    //    redoBtn.enabled = _drawingBoardView.canRedo;
    //    undoBtn.enabled = _drawingBoardView.canUndo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//实现隐藏方法
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
