//
//  AttachmentCollectionView.h
//  Wangli
//
//  Created by yeqiang on 2018/5/30.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CountChangeBlock)(NSInteger x);
@class AttachmentCollectionView;
@protocol AttachmentCollectionViewDelegate <NSObject>
@optional
- (void)attachmentCollectionView:(AttachmentCollectionView *)attachmentCollectionView didSelectedIndexPath:(NSIndexPath *)indexPath;

@end

@interface AttachmentCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) NSString *lastImgName;
// 禁止删除 default：NO
@property (nonatomic, assign) BOOL forbidDelete;

@property (nonatomic, copy) CountChangeBlock countChange;

@property (nonatomic, weak) id <AttachmentCollectionViewDelegate> attachmentCollectionViewDelegate;

- (void)updateUI;

@end
