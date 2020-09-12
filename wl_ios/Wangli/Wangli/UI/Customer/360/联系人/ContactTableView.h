//
//  ContactTableView.h
//  Wangli
//
//  Created by yeqiang on 2018/5/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactMo.h"

@class ContactTableView;
@protocol ContactTableViewDelegate <NSObject>
@optional
- (void)contactTableView:(ContactTableView *)contactTableView didSelectIndexPath:(NSIndexPath *)indexPath userMo:(id)userMo;

- (void)contactTableView:(ContactTableView *)contactTableView didDeleteIndexPath:(NSIndexPath *)indexPath userMo:(id)userMo;

@end

@interface ContactTableView : UITableView

@property (nonatomic, strong) NSMutableArray *arrData;  // 联系人数据
@property (nonatomic, assign) BOOL canDelete;           // 是否支持删除
@property (nonatomic, assign) BOOL showHeader;          // 是否支持A-Z排序
@property (nonatomic, copy) NSString *headerText;       // 标题
@property (nonatomic, assign) BOOL showIndex;           // 显示右侧索引 default：YES
@property (nonatomic, assign) BOOL hideAllHeader;       // 隐藏所有标题

@property (nonatomic, weak) id <ContactTableViewDelegate> contactDelegate;

@end
