//
//  JGGImageView.h
//  Wangli
//
//  Created by yeqiang on 2018/7/13.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseImageView.h"

#pragma mark - JGGImageView

@interface JGGImageView : UICollectionView

@property (nonatomic, strong) NSMutableArray *arrImgs;
//@property (nonatomic, strong) NSMutableArray *arrUrls;

@end

#pragma mark - JGGCell

@interface JGGCell : UICollectionViewCell

@property (nonatomic, strong) BaseImageView *imgView;
@property (nonatomic, strong) NSIndexPath *indexPath;
- (void)showImage:(id)image;

@end
