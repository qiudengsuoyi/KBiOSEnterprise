//
//  FeedbackListViewController.m
//  einstallationCompany
//
//  Created by 云位 on 2023/10/23.
//

#import "FeedbackListViewController.h"
#import "FeedbackTableViewCell.h"
#import "OrderListEntity.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "EnterpriseLoginService.h"
#import "UITableView+Refresh.h"
#import "YYLrefresh/UITableView+Refresh.h"
#import "UITableView+Refresh.h"
#import "UIView+RefreshData.h"

@interface FeedbackListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbOrderList;
@property NSMutableArray<OrderListEntity*>*muKeyValueList;
@end

@implementation FeedbackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = @"反馈列表";
    self.muKeyValueList = [NSMutableArray arrayWithCapacity:0];
    self.tbOrderList.dataSource = self;
    self.tbOrderList.delegate = self;
    // 1.设置行高为自动撑开
    self.tbOrderList.rowHeight = UITableViewAutomaticDimension;
    self.tbOrderList.allowsSelection = NO;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbOrderList.estimatedRowHeight = 120;
    self.tbOrderList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbOrderList registerNib:[UINib nibWithNibName:NSStringFromClass([FeedbackTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FeedbackTableViewCell class])];
    self.tbOrderList.allowsSelection=YES;
    [self.tbOrderList reloadData];
    [self.tbOrderList configureMJRefreshWithHader:^(NSInteger page) {
        [self requstFeedbackList:YES];
    } WithFoot:^(NSInteger page) {
        [self requstFeedbackList:YES];

    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.muKeyValueList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FeedbackTableViewCell class])];
    if (cell == nil) {
        cell = [[FeedbackTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    OrderListEntity *itemModelList= [self.muKeyValueList objectAtIndex:indexPath.row];
    cell.orderList = itemModelList;
    CGFloat itemHeight;
    CGFloat totalHeight = 0;
    for (KeyValueEntity *itemModel in itemModelList.resultarr) {
        itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-180), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
        totalHeight = totalHeight+itemHeight;
    }
    cell.cellConstrainHeight.constant = totalHeight+15;
    [cell setTableOrder];
 
    return cell;
    
    
    
}

-(void)requstFeedbackList:(BOOL)refresh{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];

    if(userID.length>0){
    [SVProgressHUD show];
    NSDictionary *dic = @{@"userid":userID,
                          @"usertype":@"1"
    };
    [EnterpriseLoginService requstFeedbackList:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
    
              if (error) {
                  self.view.loadErrorType = [error integerValue];
                  return ;
              }
              if (refresh) {
                  [self.muKeyValueList removeAllObjects];
              }
              OrderListEntity *model = [data lastObject];
                  if (model) {
                
                      [self.muKeyValueList addObjectsFromArray:data];;
                  }
              if (self.muKeyValueList.count == 0) {
                 
                  self.view.loadErrorType = YYLLoadErrorTypeNoData;
                  
              }else{
                  self.view.loadErrorType = YYLLoadErrorTypeDefalt;
              }
              [self.tbOrderList reloadData];
        }
    }];}else{
        [self.muKeyValueList removeAllObjects];
        [self.tbOrderList reloadData];
    }

  
}



@end
