//
//  UITableView+Refresh.h
//  MyUni
//
//  Created by Administrator on 2017/10/17.
//  Copyright © 2017年 tion_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MJHeaderBlock)(NSInteger page);
typedef void(^MJFooterBlock)(NSInteger page);
@interface UITableView (Refresh)
- (void)configureMJRefreshWithHader:(MJHeaderBlock)haderblock WithFoot:(MJFooterBlock)footBlock;
@end
