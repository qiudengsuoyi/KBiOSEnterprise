//
//  TaskOrderViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/21.
//

#import "TaskOrderViewController.h"
#import "TaskTableViewCell.h"
#import "WaitTaskDetailController.h"
#import "TabContentCollectionViewCell.h"
#import <YYKit/YYKit.h>
#import "EnterpriseMainService.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "UITableView+Refresh.h"
#import "YYLrefresh/UITableView+Refresh.h"
#import "UITableView+Refresh.h"
#import "UIView+RefreshData.h"
#import "WaitTaskListController.h"

@interface TaskOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbOrderList;

@end

@implementation TaskOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = self.Title;
    self.muKeyValueList = [NSMutableArray arrayWithCapacity:0];
    self.tbOrderList.dataSource = self;
    self.tbOrderList.delegate = self;
    // 1.设置行高为自动撑开
    self.tbOrderList.rowHeight = UITableViewAutomaticDimension;
    self.tbOrderList.allowsSelection = YES;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbOrderList.estimatedRowHeight = 80;
    self.tbOrderList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbOrderList registerNib:[UINib nibWithNibName:NSStringFromClass([TaskTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TaskTableViewCell class])];
    [self.tbOrderList reloadData];
    [self.tbOrderList configureMJRefreshWithHader:^(NSInteger page) {
        [self requstOrderList:YES];
    } WithFoot:^(NSInteger page) {
        [self requstOrderList:YES];

    }];
    WeakSelf;
    self.tbOrderList.headerRefreshingBlock = ^{
        [weakSelf requstOrderList:YES];
    };
 
}

-(void)viewWillAppear:(BOOL)animated{

}
-(void)viewWillDisappear:(BOOL)animated{

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    WaitTaskListController *vc = [[WaitTaskListController alloc]init];
    vc.InstallState = [self.muKeyValueList objectAtIndex:indexPath.row].InstallState;
    vc.Brand = self.Brand;
    vc.currentMonth = self.currentMonth;
    vc.currentYear = self.currentYear;
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.muKeyValueList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TaskTableViewCell class])];
    if (cell == nil) {
        cell = [[TaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    KeyValueEntity *model = [self.muKeyValueList objectAtIndex:indexPath.row];
    cell.taskModel = model;
    [cell setTableOrder];
    return cell;
    
    
    
}

-(void)requstOrderList:(BOOL)refresh{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    NSString *parentID = [user valueForKey:ENTERPRISE_PARENTID];
    NSString *browsetype = [user valueForKey:ENTERPRISE_BROWSETYPE];
    if(userID.length>0){
    [SVProgressHUD show];
    NSDictionary *dic = @{@"userid":userID,
                          @"ParentID":parentID,
                          @"Browsetype":browsetype,
                          @"CreateYear":self.currentYear,
                          @"CreateMonth":self.currentMonth,
                          @"Brand":[self utf82gbk:self.Brand]
    };
    [EnterpriseMainService requestBrandList:dic
                   andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            if (error) {
                self.view.loadErrorType = [error integerValue];
                return ;
            }
            if (refresh) {
                [self.muKeyValueList removeAllObjects];
            }
            [self.muKeyValueList addObjectsFromArray:data];
                   
                 
                
            if (self.muKeyValueList.count == 0) {
               
                self.tbOrderList.loadErrorType = YYLLoadErrorTypeNoData;
                
            }else{
                self.tbOrderList.loadErrorType = YYLLoadErrorTypeDefalt;
            }
            [self.tbOrderList reloadData];

        }
    }];}

  
}

@end
