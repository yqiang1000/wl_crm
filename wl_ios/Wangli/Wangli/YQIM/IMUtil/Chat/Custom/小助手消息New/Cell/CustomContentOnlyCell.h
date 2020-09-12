//
//  CustomContentOnlyCell.h
//  Wangli
//
//  Created by yeqiang on 2020/5/28.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "RootHelpCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomContentOnlyCell : RootHelpCell

@property (nonatomic, strong) MLLinkLabel *labTitle;
@property (nonatomic, strong) MLLinkLabel *labTime;
@property (nonatomic, strong) MLLinkLabel *labContent;

@end

NS_ASSUME_NONNULL_END
