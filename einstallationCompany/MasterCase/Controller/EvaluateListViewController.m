//
//  EvaluateListViewController.m
//  einstallationCompany
//
//  Created by 云位 on 2023/8/17.
//

#import "EvaluateListViewController.h"
#import "ListBaseCell.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "UITableView+Refresh.h"
#import "YYLrefresh/UITableView+Refresh.h"
#import "UITableView+Refresh.h"
#import "UIView+RefreshData.h"
#import "CaseService.h"

@interface EvaluateListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation EvaluateListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价列表";
    self.dataList = [NSMutableArray arrayWithCapacity:0];
    [self addBackItem];
    
 

    self.tb.dataSource = self;
    self.tb.delegate = self;
    // 1.设置行高为自动撑开
    self.tb.rowHeight = UITableViewAutomaticDimension;
    self.tb.allowsSelection = NO;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tb.estimatedRowHeight = 120;
    self.tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tb.allowsSelection = YES;
    [self.tb registerNib:[UINib nibWithNibName:NSStringFromClass([ListBaseCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ListBaseCell class])];
    [self.tb reloadData];

   

}

- (void)viewWillAppear:(BOOL)animated{
    WeakSelf;
    [self.tb configureMJRefreshWithHader:^(NSInteger page) {
        [self requstDataList:YES];
    } WithFoot:^(NSInteger page) {
        [self requstDataList:YES];

    }];
    self.tb.headerRefreshingBlock = ^{
        [weakSelf requstDataList:YES];
    };
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    WebViewViewController *vc = [[WebViewViewController alloc]init];
//    vc.pageType = 1;
//    vc.url = [self.dataList objectAtIndex:indexPath.row].url;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ListBaseCell class])];
    if (cell == nil) {
        cell = [[ListBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ListBaseCell class])] ;
    }

    OrderListEntity * model = [self.dataList objectAtIndex:indexPath.row];
   
    
    cell.orderList = model;
    [cell setTableOrder];

   
    return cell;
    
    
    
}

-(void)requstDataList:(BOOL)refresh{
  
    [SVProgressHUD show];
    NSDictionary *dic = @{@"masterid":self.masterID};
    [CaseService requestEvaluateList:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            if (error) {
                self.view.loadErrorType = [error integerValue];
                return ;
            }
            if (refresh) {
                [self.dataList removeAllObjects];
            }
            OrderListEntity *model = [data lastObject];
                if (model) {
                    [self.dataList addObjectsFromArray:data];;
                }
            if (self.dataList.count == 0) {
                self.view.loadErrorType = YYLLoadErrorTypeNoData;
            }else{
                self.view.loadErrorType = YYLLoadErrorTypeDefalt;
            }
            [self.tb reloadData];

        }else{
            self.view.loadErrorType = YYLLoadErrorTypeNoData;
        }
    }];

  
}


@end
