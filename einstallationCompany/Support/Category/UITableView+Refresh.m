//
//  UITableView+Refresh.m
//  MyUni
//
//  Created by Administrator on 2017/10/17.
//  Copyright © 2017年 tion_Z. All rights reserved.
//

#import "UITableView+Refresh.h"
#import <MJRefresh.h>


@implementation UITableView (Refresh)

- (void)configureMJRefreshWithHader:(MJHeaderBlock)haderblock WithFoot:(MJFooterBlock)footBlock{

    __weak typeof(self) weakSelf = self;
   __block NSInteger pageNumber = 1;
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.mj_header endRefreshing];
        if (haderblock) {
            haderblock(pageNumber=1);
        }
    }];
    [self.mj_header beginRefreshing];
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.mj_footer endRefreshing];
        if (pageNumber ==1) {
            pageNumber = 2;
        }
        if (footBlock) {
            footBlock(pageNumber++);
        }

    }];
    self.mj_header.automaticallyChangeAlpha = YES;
    self.mj_footer.automaticallyChangeAlpha = YES;
    


}
@end
