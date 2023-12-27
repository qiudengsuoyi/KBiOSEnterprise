//
//  EnterpriseViewController.m
//  einstallationCompany
//

//  Created by 云位 on 2023/8/17.
//

#import "EnterpriseViewController.h"
#import "GrabOrderTabViewController.h"
#import "EnterpriseNavController.h"
#import "InstallTaskController.h"
#import "PayTypeViewController.h"
#import "InstallStatisticViewController.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "EnterpriseLoginController.h"
#import "EnterpriseMainService.h"
#import "WebController.h"
#import "AppDelegate.h"
#import "DialogTwoButtonView.h"
#import "UIView+Extension.h"
#import "EnterpriseNoticeController.h"
#import "einstallationCompany-Bridging-Header.h"
#import "FSPagerView-Swift.h"
#import <WebKit/WebKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MainScrollViewCell.h"
#import <YYKit/YYKit.h>
#import "UITableView+Refresh.h"
#import "YYLrefresh/UITableView+Refresh.h"
#import "UITableView+Refresh.h"
#import "UIView+RefreshData.h"
#import "TaskEnity.h"
#import <MJRefresh/MJRefresh.h>

@interface EnterpriseViewController ()<FSPagerViewDelegate,
FSPagerViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet FSPagerView *pagerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSString * lastID;
@property NSMutableArray<TaskEnity*>*muKeyValueList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation EnterpriseViewController


- (void)configureMJRefresh {
    // 头部设置
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requstMainList:YES];
    }];
    
    // 尾部设置
    self.scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requstMainList:NO];
    }];
}

-(void)requstMainList:(BOOL)refresh{
    if(refresh){
        self.lastID = @"";
    }
    [SVProgressHUD show];
        NSDictionary *dic = @{@"lastid":self.lastID};
        [EnterpriseMainService requestMainList:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
            if (data) {
                if (refresh) {
                       // 结束头部刷新
                       [self.scrollView.mj_header endRefreshing];
                   } else {
                       // 结束尾部刷新
                       [self.scrollView.mj_footer endRefreshing];
                   }
                if (error) {
                    self.view.loadErrorType = [error integerValue];
                    return ;
                }
                if (refresh) {
                    [self.muKeyValueList removeAllObjects];
                }
                TaskEnity *model = [data lastObject];
               
                if (model) {
                    self.lastID = model.recordID;
                    [self.muKeyValueList addObjectsFromArray:data];
                }
                if (self.muKeyValueList.count == 0) {
                    self.tableView.loadErrorType = YYLLoadErrorTypeNoData;
                }else{
                    self.tableView.loadErrorType = YYLLoadErrorTypeDefalt;
                }
                self.tbHeight.constant = 110 * self.muKeyValueList.count;
                [self.tableView reloadData];
                
            }
        }];
    
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self checkVersion];
    [self requstMainNum];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 这个方法是设置导航栏背景颜色，状态栏也会随之变色
 
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.anyObject;
        // 更改状态栏样式为浅色内容（白色文字）
        UIView *statusBar = [[UIView alloc] initWithFrame:windowScene.statusBarManager.statusBarFrame];
        statusBar.backgroundColor = [UIColor colorWithHexString:@"#5787db"];
[self.view addSubview:statusBar];
    } else {
    
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
          if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
              statusBar.backgroundColor = [UIColor colorWithHexString:@"#5787db"];
          }
    }
    self.lastID = @"";
    self.muKeyValueList = [NSMutableArray arrayWithCapacity:0];
    _pagerView.delegate = self;
    _pagerView.dataSource = self;
    _pagerView.automaticSlidingInterval = 3;
   
    _pagerView.isInfinite = YES;
    _pagerView.interitemSpacing = 0;
    [self.pagerView registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 50.0;

    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MainScrollViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MainScrollViewCell class])];

    
    
    UITapGestureRecognizer *labelTapGestureRecognizer1 = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self action:@selector(noticeClick)];
    // 2. 将点击事件添加到label上
    [self.vCircle01 addGestureRecognizer:labelTapGestureRecognizer1];
    self.vCircle01.userInteractionEnabled = YES;

    
    
    UITapGestureRecognizer * labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self action:@selector(labelClick1)];

    [self.vCircle03 addGestureRecognizer:labelTapGestureRecognizer];
    self.vCircle03.userInteractionEnabled = YES; //
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self action:@selector(labelClick4)];
 
    [self.vCircle02 addGestureRecognizer:labelTapGestureRecognizer];
    self.vCircle02.userInteractionEnabled = YES; //
   

    [self requstMainList:YES];
    [self configureMJRefresh];
}

- (void)labelClick {
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_USERID];
    if(userID.length>0){
        GrabOrderTabViewController * vc = [GrabOrderTabViewController alloc];
    
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录！"];
        EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (void)noticeClick {
    EnterpriseNoticeController * vc = [EnterpriseNoticeController alloc];
        vc.hidesBottomBarWhenPushed = YES;
    vc.pageType = 1;
        [self.navigationController pushViewController:vc animated:YES];
   
}

- (void)labelClick1 {
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_USERID];
    if(userID.length>0){
        InstallTaskController *vc = [[InstallTaskController alloc]init];
        vc.position = 0;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录！"];
        EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (void)labelClick2 {
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_USERID];
    if(userID.length>0){
        InstallTaskController *vc = [[InstallTaskController alloc]init];
        vc.position = 3;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录！"];
        EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (void)labelClick4 {
    
    [SVProgressHUD showInfoWithStatus:@"无发单权限！"];
    
}

- (void)labelClick3 {
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_USERID];
    if(userID.length>0){
        InstallStatisticViewController *vc = [[InstallStatisticViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录！"];
        EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}


-(void)requstMainNum{
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_USERID];
    NSString * parentID = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_PARENTID];
    NSString * browseType = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_BROWSETYPE];
    if(userID.length>0){
        NSDictionary *dic = @{@"userid":userID,
                              @"ParentID":parentID,
                              @"Browsetype":browseType,
                              @"version":[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
        };
        [EnterpriseMainService requestMainNum:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
            if (data) {
                self.mainNumModel = data;
                [self.pagerView reloadData];
  
            }
        }];
    }
    
    
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
        NSString *str = @"itms-apps://itunes.apple.com/cn/app/id1586066452?mt=8"; //更换id即可
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    };
    view.cancelBlock = ^{
        [weakView removeFromSuperview];
        exit(0);
    };
    [window addSubview:view];
}

//版本

-(NSString *)version

{

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    NSString *app_Version       = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    return app_Version;

}

/// 检查版本更新
- (void)checkVersion {
    NSURL * url = [NSURL URLWithString:@"https://itunes.apple.com/cn/lookup?id=1586066452"];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(data!=nil){
            NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if(dataDic!=nil && [dataDic objectForKey:@"results"] ){
                NSArray *results = dataDic[@"results"];
                if (results && results.count > 0) {
                    NSDictionary *response = results.firstObject;
                    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]; // 软件的当前版本
                    NSString *lastestVersion = response[@"version"]; // AppStore 上软件的最新版本
                    if (currentVersion && lastestVersion && ![self isLastestVersion:currentVersion compare:lastestVersion]) {
                        
                        NSString * alertContent = [NSString stringWithFormat:@"发现新版本v%@，为保证软件的正常运行，请及时更新到最新版本！",lastestVersion];
                        // 给出提示是否前往 AppStore 更新
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // UI更新代码
                            [self showTwoDialogView:alertContent withRightButtonTitle:@"立即更新" withLeftButtonTitle:@"我再想想"];
                        });
                        
                        
                    }
                }}}
    }] resume];
}

/// 判断是否最新版本号（大于或等于为最新）
- (BOOL)isLastestVersion:(NSString *)currentVersion compare:(NSString *)lastestVersion {
    if (currentVersion && lastestVersion) {
        // 拆分成数组
        NSMutableArray *currentItems = [[currentVersion componentsSeparatedByString:@"."] mutableCopy];
        NSMutableArray *lastestItems = [[lastestVersion componentsSeparatedByString:@"."] mutableCopy];
        // 如果数量不一样补0
        NSInteger currentCount = currentItems.count;
        NSInteger lastestCount = lastestItems.count;
        if (currentCount != lastestCount) {
            NSInteger count = labs(currentCount - lastestCount); // 取绝对值
            for (int i = 0; i < count; ++i) {
                if (currentCount > lastestCount) {
                    [lastestItems addObject:@"0"];
                } else {
                    [currentItems addObject:@"0"];
                }
            }
        }
        // 依次比较
        BOOL isLastest = YES;
        for (int i = 0; i < currentItems.count; ++i) {
            NSString *currentItem = currentItems[i];
            NSString *lastestItem = lastestItems[i];
            if (currentItem.integerValue != lastestItem.integerValue) {
                isLastest = currentItem.integerValue > lastestItem.integerValue;
                break;
            }
        }
        return isLastest;
    }
    return NO;
}


#pragma mark - FSPagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(FSPagerView *)pagerView{
    return self.mainNumModel.bannerarr.count>0?self.mainNumModel.bannerarr.count:1;
}

- (FSPagerViewCell *)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index{
    FSPagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cell" atIndex:index];
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    NSString * imageURL = [self.mainNumModel.bannerarr objectAtIndex:index];
    if (self.mainNumModel.bannerarr.count==0) {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"banner2"]];
    }else{
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"banner2"]];
    }
    return cell;
}

-(void)pagerView:(FSPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index{

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.muKeyValueList.count;
}

// 设置每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0; // 你可以根据需要设置具体的行高
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainScrollViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MainScrollViewCell class])];
    if (cell == nil) {
        cell = [[MainScrollViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    TaskEnity * task = [self.muKeyValueList objectAtIndex:indexPath.row];
    cell.tvTitle.text = task.Location;
    cell.tvContent.text = task.installtype;
    cell.tvInstallState.text = task.FastTitle;
    cell.tvAdress.text = task.ShopAddress;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
