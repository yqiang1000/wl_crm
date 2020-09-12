//
//  TrendsMoreCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrendsMoreCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *labText;

- (void)loadData:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
