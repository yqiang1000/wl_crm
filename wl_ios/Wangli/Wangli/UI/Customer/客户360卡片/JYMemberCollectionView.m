//
//  JYMemberCollectionView.m
//  Wangli
//
//  Created by yeqiang on 2019/3/18.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "JYMemberCollectionView.h"
#import "JYMemberCollectionCell.h"

static NSString *identifier = @"JYMemberCollectionCell";

@interface JYMemberCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    CGFloat _dragStartX;
    CGFloat _dragEndX;
}
    
@property (nonatomic, assign, readwrite) NSInteger selectedIndex;
    
@end

@implementation JYMemberCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
//        self.delegate = self;
//        self.dataSource = self;
        self.pagingEnabled = YES;
        self.backgroundColor = COLOR_B4;
//        [self registerClass:[JYMemberCollectionCell class] forCellWithReuseIdentifier:identifier];
    }
    return self;
}

//#pragma mark - UICollectionViewDataSource
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.cardData.count;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    JYMemberCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    cell.contentView.backgroundColor = indexPath.item % 2 == 0 ? COLOR_B0 : COLOR_C2;
//    CustomerMo *model = self.cardData[indexPath.item];
//    [cell loadData:model str:[NSString stringWithFormat:@"%lld", indexPath.item]];
//    NSLog(@"cellforItem显示。%lld", indexPath.item);
//    return cell;
//}
//    
//    //手指拖动开始
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    _dragStartX = scrollView.contentOffset.x;
//}
//
//    //手指拖动停止
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    _dragEndX = scrollView.contentOffset.x;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self fixCellToCenter];
//    });
//}
//
//    //配置cell居中
//- (void)fixCellToCenter {
//    //最小滚动距离
//    float dragMiniDistance = self.bounds.size.width/20.0f;
//    if (_dragStartX -  _dragEndX >= dragMiniDistance) {
//        _selectedIndex -= 1;//向右
//    }else if(_dragEndX -  _dragStartX >= dragMiniDistance){
//        _selectedIndex += 1;//向左
//    }
//    NSInteger maxIndex = [self numberOfItemsInSection:0] - 1;
//    _selectedIndex = _selectedIndex <= 0 ? 0 : _selectedIndex;
//    _selectedIndex = _selectedIndex >= maxIndex ? maxIndex : _selectedIndex;
//    [self scrollToCenter];
//}
//
//// 滚动到中间
//- (void)scrollToCenter {
//    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//}
//
//#pragma mark - UICollectionViewDelegate
//
//#pragma mark - UICollectionViewDelegateFlowLayout
//
//
//#pragma mark - lazy
//
//- (NSMutableArray *)cardData {
//    if (!_cardData) {
//        _cardData = [NSMutableArray new];
//    }
//    return _cardData;
//}


@end
