//
//  GrabOrderItemListViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/27.
//

#import "GrabSingleListViewController.h"
#import "TaskClassOneTableViewCell.h"
#import "PayTypeViewController.h"
#import "UITableView+Refresh.h"
#import "YYLrefresh/UITableView+Refresh.h"
#import "UITableView+Refresh.h"
#import "UIView+RefreshData.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "EnterpriseMainService.h"
#import "ResultController.h"
#import "DialogTwoButtonView.h"
#import "UIView+Extension.h"
#import "PayViewController.h"
#import "CaseListViewController.h"


@interface GrabSingleListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tbOrderList;
@property UITextField * searchBar;
@property NSString * clickMasterID;
@property NSString * clickRecordID;
@end

@implementation GrabSingleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = @"师傅列表";
    self.muKeyValueList = [NSMutableArray arrayWithCapacity:0];
    self.tbOrderList.dataSource = self;
    self.tbOrderList.delegate = self;
    // 1.设置行高为自动撑开
    self.tbOrderList.rowHeight = UITableViewAutomaticDimension;
    self.tbOrderList.allowsSelection = YES;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbOrderList.estimatedRowHeight = 80;
    self.tbOrderList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbOrderList registerNib:[UINib nibWithNibName:NSStringFromClass([TaskClassOneTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TaskClassOneTableViewCell class])];
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

   
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.muKeyValueList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskClassOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TaskClassOneTableViewCell class])];
    if (cell == nil) {
        cell = [[TaskClassOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    OrderListEntity *itemModelList = [self.muKeyValueList objectAtIndex:indexPath.row];
    cell.keyValueList = itemModelList.resultarr;
    CGFloat itemHeight;
    CGFloat totalHeight = 0;
    for (KeyValueEntity *itemModel in itemModelList.resultarr) {
        itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-160), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
        totalHeight = totalHeight+itemHeight;
    }
    cell.cellConstrainHeight.constant = totalHeight+65;
    [cell setTableOrder];
    WeakSelf;
    cell.confirmBlock = ^{
        [weakSelf showTwoDialogView:@"是否确认指派该师傅？" withRightButtonTitle:@"是" withLeftButtonTitle:@"否"];
        self.clickMasterID = itemModelList.masterid;
        self.clickRecordID = itemModelList.recordID;
       
    };
    cell.caseBlock = ^{
        CaseListViewController *vc = [CaseListViewController alloc];
        vc.masterID = itemModelList.masterid;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

-(void)requstOrderList:(BOOL)refresh{
    [SVProgressHUD show];
    NSDictionary *dic = @{@"recordID":self.recordID};
    [EnterpriseMainService requestReleaseItemList:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            if (error) {
                self.view.loadErrorType = [error integerValue];
                return ;
            }
            [self.muKeyValueList removeAllObjects];
            OrderListEntity *model = [data lastObject];
                if (model) {
                    [self.muKeyValueList addObjectsFromArray:data];;
                }
            if (self.muKeyValueList.count == 0) {
                self.view.loadErrorType = YYLLoadErrorTypeNoData;
            }
            [self.tbOrderList reloadData];

        }
    }];

  
}

-(void)requstConfirmMaster:(NSString*)masterID recordID:(NSString*)recordID{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    [SVProgressHUD show];
    NSDictionary *dic = @{
        @"userid":userID,
        @"recordID":recordID,
        @"masterid":masterID
    };
    [EnterpriseMainService requestReleaseConfirmMaster:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            NSString *msg = data;
            ResultController * vc = [ResultController alloc];
            vc.resultType = 1;
            vc.resultType = 1;
            vc.strTitle = @"指派成功";
            vc.strContent01 = msg;
            vc.hidesBottomBarWhenPushed = YES;
            [self jumpViewControllerAndCloseSelf:vc];

            

        }
    }];

  
}

- (void)showTwoDialogView:(NSString *) strContent withRightButtonTitle:(NSString *) strRightButtonName
     withLeftButtonTitle:(NSString *) strLeftButtonName{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    DialogTwoButtonView *view = [DialogTwoButtonView LoadView_FromXib];
    view.frame = window.frame;
    view.laContent.text = strContent;
    [view.btLeft setTitle:strLeftButtonName forState:UIControlStateNormal];
    [view.btRight setTitle:strRightButtonName forState:UIControlStateNormal];
        CGFloat itemHeight = [(NSString *)strContent boundingRectWithSize:CGSizeMake((SCREENWIDTH-80), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    view.constraintViewHeight.constant = 220+itemHeight;
    __weak typeof(view) weakView = view;
    view.confirmBlock  = ^{
        [weakView removeFromSuperview];
        PayViewController *vc = [PayViewController alloc];
        vc.recordID = self.recordID;
        vc.masterID = self.clickMasterID;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
//        [self requstConfirmMaster:self.clickMasterID recordID:self.clickRecordID];
    };
    view.cancelBlock = ^{
        [weakView removeFromSuperview];
    };
    [window addSubview:view];
}

@end
