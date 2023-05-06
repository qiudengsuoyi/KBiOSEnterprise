//
//  NoticeViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/5.
//

#import "EnterpriseNoticeController.h"
#import "NoticeTableViewCell.h"
#import "WebController.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "UITableView+Refresh.h"
#import "YYLrefresh/UITableView+Refresh.h"
#import "UITableView+Refresh.h"
#import "UIView+RefreshData.h"
#import "EnterpriseNoticeService.h"


@interface EnterpriseNoticeController ()<UITableViewDelegate,UITableViewDataSource>
@property NSString * lastID;
@end

@implementation EnterpriseNoticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.lastID = @"";
    self.navigationItem.title = @"平台公告";
    self.noticeList = [NSMutableArray arrayWithCapacity:0];


    self.tbNotice.dataSource = self;
    self.tbNotice.delegate = self;
    // 1.设置行高为自动撑开
    self.tbNotice.rowHeight = UITableViewAutomaticDimension;
    self.tbNotice.allowsSelection = NO;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbNotice.estimatedRowHeight = (SCREENWIDTH-60)*0.17;
    self.tbNotice.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbNotice.allowsSelection = YES;
    [self.tbNotice registerNib:[UINib nibWithNibName:NSStringFromClass([NoticeTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([NoticeTableViewCell class])];
    [self.tbNotice reloadData];
    [self.tbNotice configureMJRefreshWithHader:^(NSInteger page) {
        self.lastID = @"";
        [self requstNoticeList:YES];
    } WithFoot:^(NSInteger page) {
        [self requstNoticeList:NO];

    }];
    WeakSelf;
    self.tbNotice.headerRefreshingBlock = ^{
        weakSelf.lastID = @"";
        [weakSelf requstNoticeList:YES];
    };
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WebController *vc = [[WebController alloc]init];
    vc.pageType = 1;
    vc.url = [self.noticeList objectAtIndex:indexPath.row].url;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.noticeList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoticeTableViewCell class])];
    if (cell == nil) {
        cell = [[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([NoticeTableViewCell class])] ;
    }
    NoticeEntity* itemModelList = [self.noticeList objectAtIndex:indexPath.row];
    cell.model = itemModelList;
    [cell setNotice:itemModelList];
    return cell;
    
    
    
}

-(void)requstNoticeList:(BOOL)refresh{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
 
    [SVProgressHUD show];
    NSDictionary *dic = @{@"type":@"0",
                          @"lastid":self.lastID};
    [EnterpriseNoticeService requestNoticeList:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {

            if (error) {
                self.view.loadErrorType = [error integerValue];
                return ;
            }
            if (refresh) {
                [self.noticeList removeAllObjects];
            }
            NoticeEntity *model = [data lastObject];
                if (model) {
                    self.lastID = model.recordID;
                    [self.noticeList addObjectsFromArray:data];;
                }
            if (self.noticeList.count == 0) {
                self.view.loadErrorType = YYLLoadErrorTypeNoData;
            }
            [self.tbNotice reloadData];

        }else{
            self.view.loadErrorType = YYLLoadErrorTypeNoData;
        }
    }];

  
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
