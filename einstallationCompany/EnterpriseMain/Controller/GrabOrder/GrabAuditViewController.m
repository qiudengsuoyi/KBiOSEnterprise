//
//  GrabAuditViewController.m
//  einstallationCompany
//
//  Created by 云位 on 2023/8/28.
//

#import "GrabAuditViewController.h"
#import "DialogTwoButtonView.h"
#import "UIView+Extension.h"
#import "UITableView+Refresh.h"
#import "YYLrefresh/UITableView+Refresh.h"
#import "UITableView+Refresh.h"
#import "UIView+RefreshData.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "GrabTaskTableViewCell.h"
#import "PayOrderEditViewController.h"
#import "GrabDetailController.h"
#import "EnterpriseMainService.h"

@interface GrabAuditViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbOrderList;
@property NSString * clickRecordID;
@property NSString*searchStr;
@property UITextField* searchBar;
@end

@implementation GrabAuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.searchStr = @"";
    self.muKeyValueList = [NSMutableArray arrayWithCapacity:0];
    self.tbOrderList.dataSource = self;
    self.tbOrderList.delegate = self;
    // 1.设置行高为自动撑开
    self.tbOrderList.rowHeight = UITableViewAutomaticDimension;
    self.tbOrderList.allowsSelection = YES;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbOrderList.estimatedRowHeight = 80;
    self.tbOrderList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbOrderList registerNib:[UINib nibWithNibName:NSStringFromClass([GrabTaskTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GrabTaskTableViewCell class])];
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





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    GrabOrderItemListViewController *vc = [[GrabOrderItemListViewController alloc]init];
//    vc.recordID = [self.muKeyValueList objectAtIndex:indexPath.row].recordID;
//    [self.navigationController pushViewController:vc animated:YES];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.muKeyValueList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GrabTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GrabTaskTableViewCell class])];
    if (cell == nil) {
        cell = [[GrabTaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    OrderListEntity *itemModelList = [self.muKeyValueList objectAtIndex:indexPath.row];
    cell.keyValueList = itemModelList.resultarr;
    CGFloat itemHeight;
    CGFloat totalHeight = 0;
    for (KeyValueEntity *itemModel in itemModelList.resultarr) {
        itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-80), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
        totalHeight = totalHeight+itemHeight;
    }
    cell.model = itemModelList;
    cell.cellConstrainHeight.constant = totalHeight+55;
    cell.OrderState = itemModelList.OrderState;
    [cell setTableOrder];
    cell.recordID = itemModelList.recordID;
    WeakSelf;
    cell.detailBlock = ^{
        GrabDetailController *vc = [[GrabDetailController alloc]init];
        vc.recordID = itemModelList.recordID;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.cancelBlock = ^{
        [weakSelf showTwoDialogView:@"是否取消该任务？" withRightButtonTitle:@"是" withLeftButtonTitle:@"否"];
       ;
        self.clickRecordID = itemModelList.recordID;
       
    };
    cell.confirmBlock = ^{
        if([itemModelList.paymentState intValue] == 0){
            GrabDetailController *vc = [[GrabDetailController alloc]init];
            vc.recordID = itemModelList.recordID;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
       
    };
    cell.editBlock = ^{
        if([itemModelList.paymentState intValue] == 0){
            PayOrderEditViewController *vc = [[PayOrderEditViewController alloc]init];
            vc.recordID = itemModelList.recordID;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
       
    };
    return cell;
    
    
    
}

-(void)requstOrderList:(BOOL)refresh{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    [SVProgressHUD show];
    NSDictionary *dic = @{
        @"userid":userID,
        @"Fasttype":self.pageType,
        @"searchStr":[self utf82gbk:self.searchStr]
    };
    [EnterpriseMainService requestFailList:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
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
            }else{
                self.view.loadErrorType = YYLLoadErrorTypeDefalt;
            }
            [self.tbOrderList reloadData];

        }
    }];

  
}

-(void)cancelOrder:(NSString*)recordID{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    [SVProgressHUD show];
    NSDictionary *dic = @{@"userid":userID,
                          @"recordID":recordID
    };
    [EnterpriseMainService requestReleaseCancel:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            NSString *msg = data;
           
            [SVProgressHUD showSuccessWithStatus:msg];
            [self requstOrderList:YES];

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
        [self cancelOrder:self.clickRecordID];
    };
    view.cancelBlock = ^{
        [weakView removeFromSuperview];
    };
    [window addSubview:view];
}

//实现监听方法
-(void) searchTask:(NSNotification *)notification
{
 self.searchStr = notification.userInfo[@"key"];
    [self requstOrderList:YES];
    
}



-(void)viewWillAppear:(BOOL)animated{

    [self.tbOrderList configureMJRefreshWithHader:^(NSInteger page) {
        [self requstOrderList:YES];
    } WithFoot:^(NSInteger page) {
        [self requstOrderList:NO];

    }];
    WeakSelf;
    self.tbOrderList.headerRefreshingBlock = ^{
        [weakSelf requstOrderList:YES];
    };
    
    //注册通知：
    /***
    * addObserver:观察者-消息接收方
    * selector:处理通知的方法名
    * name:通知的名字-一定要和你需要的通知名字一样
    ***/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTask:) name:@"searchTask" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchTask" object:self];
}

@end
