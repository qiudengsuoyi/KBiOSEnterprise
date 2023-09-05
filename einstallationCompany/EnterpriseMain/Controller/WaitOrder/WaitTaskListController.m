//
//  WaitOrderListViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/23.
//

#import "WaitTaskListController.h"
#import "OrderTableViewCell.h"
#import "WaitTaskSingleListController.h"
#import "EnterpriseMainService.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "UITableView+Refresh.h"
#import "YYLrefresh/UITableView+Refresh.h"
#import "UITableView+Refresh.h"
#import "UIView+RefreshData.h"
#import "WaitTaskDetailController.h"


@interface WaitTaskListController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbOrderList;
@property NSString * lastID;
@property  UITextField * searchBar;
@end

@implementation WaitTaskListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.muKeyValueList = [NSMutableArray arrayWithCapacity:0];
    self.lastID = @"";
    self.tbOrderList.dataSource = self;
    self.tbOrderList.delegate = self;
    // 1.设置行高为自动撑开
    self.tbOrderList.rowHeight = UITableViewAutomaticDimension;
    self.tbOrderList.allowsSelection = NO;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbOrderList.estimatedRowHeight = 120;
    self.tbOrderList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbOrderList registerNib:[UINib nibWithNibName:NSStringFromClass([OrderTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderTableViewCell class])];
    self.tbOrderList.allowsSelection=YES;
    [self.tbOrderList reloadData];
    [self.tbOrderList configureMJRefreshWithHader:^(NSInteger page) {
        self.lastID = @"";
        [self requstOrderList:YES];
    } WithFoot:^(NSInteger page) {
        [self requstOrderList:NO];

    }];
    WeakSelf;
    self.tbOrderList.headerRefreshingBlock = ^{
        weakSelf.lastID = @"";
        [weakSelf requstOrderList:YES];
    };
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self addControllerView];
    //注册键盘出现通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        // 注册键盘隐藏通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

}
-(void)viewWillDisappear:(BOOL)animated{
    [self removeControllerView];
    // 注销键盘出现通知
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        // 注销键盘隐藏通知
        [[NSNotificationCenter defaultCenter]removeObserver: self name:UIKeyboardDidHideNotification object: nil];

  
}


-(void)addControllerView{
    //获取状态栏的高度
    CGFloat statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
    }
    else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    NSLog(@"状态栏高度：%f",statusBarHeight);
    
    //获取导航栏的高度
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    NSLog(@"导航栏高度：%f",navHeight);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, statusBarHeight+(navHeight-36)/2,SCREENWIDTH -130, 36.0f)];
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
    [view.layer setBorderWidth:2];
    [view.layer setBorderColor:[UIColor whiteColor].CGColor];
    [view setBackgroundColor:[UIColor whiteColor]];
    UIImageView*imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 7, 26, 26)];
    [imageView setImage:[UIImage imageNamed:@"search.png"]];
    [view setTag:20];
    
   self.searchBar = [[UITextField alloc] init];
    self.searchBar.frame = CGRectMake(32, 3, SCREENWIDTH -150, 34);

    self.searchBar.textColor = [UIColor blackColor];
  
    NSString *placeholderText;
    if(self.pageType ==1){
        
        placeholderText = @"搜索待接受任务";
        
    }else{
        placeholderText = @"搜索我的任务";
        
    }
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholderText attributes:
    @{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                 NSFontAttributeName:self.searchBar.font
         }];
    self.searchBar.attributedPlaceholder = attrString;
    [view addSubview:imageView];
    [view addSubview:self.searchBar];
    
    
    [self.navigationController.view addSubview:view];
    
}

-(void)removeControllerView{
    for(id tmpView in [self.navigationController.view subviews])
    {
        
        if([tmpView isKindOfClass:[UIView class]])
        {
            UIView *view = (UIView *) tmpView;
            if(view.tag == 20)   //判断是否满足自己要删除的子视图的条件
            {
                [view removeFromSuperview]; //删除子视图
                
            }
            
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderListEntity *itemModelList= [self.muKeyValueList objectAtIndex:indexPath.row];
    WaitTaskDetailController *vc = [[WaitTaskDetailController alloc]init];
    vc.pageType = 2;
    vc.recordID = [self.muKeyValueList objectAtIndex:indexPath.row].recordID;
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.muKeyValueList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderTableViewCell class])];
    if (cell == nil) {
        cell = [[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
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

-(void)requstOrderList:(BOOL)refresh{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
    NSString *parentID = [user valueForKey:ENTERPRISE_PARENTID];
    NSString *browsetype = [user valueForKey:ENTERPRISE_BROWSETYPE];
    [SVProgressHUD show];
    NSDictionary *dic = @{@"userid":userID,
                          @"ParentID":parentID,
                          @"Browsetype":browsetype,
                          @"CreateYear":self.currentYear,
                          @"CreateMonth":self.currentMonth,
                          @"Brand":[self utf82gbk:self.Brand],
                          @"lastid":self.lastID,
                          @"InstallState":self.InstallState,
                          @"searchStr":[self utf82gbk:self.searchBar.text]
    };
    [EnterpriseMainService requestWaitOrderList:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
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
                    self.lastID = model.recordID;
                    [self.muKeyValueList addObjectsFromArray:data];;
                }
            if (self.muKeyValueList.count == 0) {
                self.view.loadErrorType = YYLLoadErrorTypeNoData;
            }else{
                self.view.loadErrorType = YYLLoadErrorTypeDefalt;
            }
            [self.tbOrderList reloadData];

        }else{
            self.view.loadErrorType = YYLLoadErrorTypeNoData;
        }
    }];

  
}
-(void)keyboardDidShow:(NSNotification *) notification{
    NSLog(@"键盘打开了");
}
-(void)keyboardDidHide: (NSNotification *) notification{
    NSLog(@"键盘关闭了");
   
        [self.tbOrderList configureMJRefreshWithHader:^(NSInteger page) {
            self.lastID = @"";
            [self requstOrderList:YES];
        } WithFoot:^(NSInteger page) {
            [self requstOrderList:NO];

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
