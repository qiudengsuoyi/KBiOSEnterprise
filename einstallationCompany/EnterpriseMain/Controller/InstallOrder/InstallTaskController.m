//
//  InstallOrderViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/24.
//

#import "InstallTaskController.h"
#import "OrderTableViewCell.h"
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

@interface InstallTaskController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate, UITextViewDelegate>
@property NSMutableArray *btnArray;
@property (weak, nonatomic) IBOutlet UITableView *tbOrderList;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView1;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView2;

@property UIView *navView;
@property NSInteger index01;
@property NSInteger index02;
@property NSArray * btName01;
@property NSArray * btName02;
@property NSString * lastID;
@property NSString * searchStr;
@property NSString * status;
@property NSString * datetype;
@property UITextField * searchBar;

@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSIndexPath *deselectIndexpath;
@end

@implementation InstallTaskController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addBackItem];

    self.btName01 = @[@"全部", @"施工中", @"待审核", @"不通过"];
    self.btName02 = @[@"所有任务", @"3天内",@"3天外",@"已过期"];
    self.muKeyValueList = [NSMutableArray arrayWithCapacity:0];
    self.lastID = @"";
    self.searchStr = @"";
    self.status = @"";
    self.datetype = @"";
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
    [self initCollectionView:self.collectionView1];
    [self initCollectionView:self.collectionView2];
  
   
  
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [self collectionView:self.collectionView2 didDeselectItemAtIndexPath:self.selectIndexPath];
    self.selectIndexPath = [NSIndexPath indexPathForRow:self.position inSection:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.position inSection:0];
        
        [self.collectionView2 selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.collectionView2 didSelectItemAtIndexPath:indexPath];
  
    
    //注册键盘出现通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        // 注册键盘隐藏通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [self addControllerView];
    [self.tbOrderList configureMJRefreshWithHader:^(NSInteger page) {
        self.lastID = @"";
        [self requstOrderList:YES];
    } WithFoot:^(NSInteger page) {
        [self requstOrderList:NO];

    }];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [self removeControllerView];
    // 注销键盘出现通知
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        // 注销键盘隐藏通知
        [[NSNotificationCenter defaultCenter]removeObserver: self name:UIKeyboardDidHideNotification object: nil];
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

- (void) initCollectionView:(UICollectionView *)collectionView
{
    //设置CollectionView的属性
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = YES;
    //    [self.view addSubview:self.collectionView];
    //注册Cell
    //    [collectionView registerClass:[TabCollectionViewCell class] forCellWithReuseIdentifier:@"identifier1"];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TabContentCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"identifier1"];
    
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
    
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(80, statusBarHeight+(navHeight-36)/2,SCREENWIDTH -100, 36.0f)];
    self.navView .layer.cornerRadius = 8;
    self.navView .layer.masksToBounds = YES;
    [self.navView .layer setBorderWidth:2];
    [self.navView .layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.navView  setBackgroundColor:[UIColor whiteColor]];
    UIImageView*imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 7, 26, 26)];
    [imageView setImage:[UIImage imageNamed:@"search.png"]];
    [self.navView setTag:21];
    
    self.searchBar = [[UITextField alloc] init];
    self.searchBar.frame = CGRectMake(32, 3, SCREENWIDTH -100, 34);
    

    self.searchBar.textColor = [UIColor blackColor];

    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"搜索我的任务" attributes:
    @{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                 NSFontAttributeName:self.searchBar.font
         }];
    self.searchBar.attributedPlaceholder = attrString;
    
    [self.navView  addSubview:imageView];
    [self.navView  addSubview:self.searchBar];
   
    
    [self.navigationController.view addSubview:self.navView];
    [self.navigationController.view bringSubviewToFront:self.navView];
    
}

-(void)removeControllerView{
    for(id tmpView in [self.navigationController.view subviews])
    {
        
        if([tmpView isKindOfClass:[UIView class]])
        {
            UIView *view = (UIView *) tmpView;
            if(view.tag == 21)   //判断是否满足自己要删除的子视图的条件
            {
                [view removeFromSuperview]; //删除子视图
                
            }
            
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
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
    cell.label.hidden = NO;
    [cell setTableOrder];
 
    return cell;
    
    
    
}




- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.row;
    static NSString *identify = @"identifier1";
    TabContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    //    cell.layer.borderWidth = 1;
    //    cell.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    if(collectionView == self.collectionView1){
        cell.labelContent.font = [UIFont systemFontOfSize:14];
        cell.labelContent.text = [self.btName01 objectAtIndex:index];
        cell.labelContent.backgroundColor = [UIColor colorWithHexString:@"#5586DE"];
    }else{
        cell.labelContent.font = [UIFont systemFontOfSize:12];
        cell.labelContent.text = [self.btName02 objectAtIndex:index];
        cell.labelContent.backgroundColor = [UIColor colorWithHexString:@"#74975F"];
                if ([self.selectIndexPath isEqual:indexPath]) {
                    [self updateCellStatus:cell selected:YES type:1];
                }
    }
    cell.layer.cornerRadius = 4;
    cell.backgroundColor = [UIColor whiteColor];
   
    
    return cell;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == self.collectionView1){
        return 4;
    }else if(collectionView == self.collectionView2){
        return 4;
    }
    return 0;
    
}

#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(collectionView == self.collectionView1){
        return 1;
    }else if(collectionView == self.collectionView2){
        return 1;
    }
    return 0;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    if(collectionView == self.collectionView1){
        return CGSizeMake((SCREENWIDTH-90)/4, 35);//可以根据indexpath
    }else {
        return CGSizeMake((SCREENWIDTH-90)/4, 30);//可以根据indexpath
    }
    
}

#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);//（上、左、下、右）
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.collectionView1){
        self.index01 = (indexPath.section)*3+indexPath.row;
        TabContentCollectionViewCell *cell = (TabContentCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        //选中之后的cell变颜色
        [self updateCellStatus:cell selected:YES type:0];
        [self.tbOrderList configureMJRefreshWithHader:^(NSInteger page) {
            self.lastID = @"";
            switch (indexPath.row) {
                case 0:
                    {
                        self.status = @"";
                
                    }
                    break;
                case 1:
                    {
                        self.status = @"1";
                       
                    }
                    break;
                case 2:
                    {
                        self.status = @"2";
                       
                    }
                    break;
                case 3:
                    {
                        self.status = @"3";
                       
                    }
                    break;
                default:
                    break;
            };
            [self requstOrderList:YES];
        } WithFoot:^(NSInteger page) {
            [self requstOrderList:NO];

        }];
        
    
        
    }
    else{
        self.selectIndexPath = indexPath;
        self.index02 = (indexPath.section)*3+indexPath.row;
        TabContentCollectionViewCell *cell = (TabContentCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        //选中之后的cell变颜色
        [self updateCellStatus:cell selected:YES type:1];
        
        [self.tbOrderList configureMJRefreshWithHader:^(NSInteger page) {
            self.lastID = @"";
            switch (indexPath.row) {
                case 0:
                    {
                        self.datetype = @"";
                
                    }
                    break;
                case 1:
                    {
                        self.datetype = @"1";
                       
                    }
                    break;
                case 2:
                    {
                        self.datetype = @"2";
                    }
                    break;
                case 3:
                    {
                        self.datetype = @"3";
                    }
                    break;
                default:
                    break;
            };
            [self requstOrderList:YES];
        } WithFoot:^(NSInteger page) {
            [self requstOrderList:NO];

        }];
       
    }
}


// 改变cell的背景颜色
-(void)updateCellStatus:(TabContentCollectionViewCell *)cell selected:(BOOL)selected type:(NSInteger) type
{
    if(type == 0){
        cell.labelContent.backgroundColor = selected ? [UIColor colorWithHexString:@"#DE6D55"]:[UIColor colorWithHexString:@"#5586DE"];
    }else{
        cell.labelContent.backgroundColor = selected ? [UIColor colorWithHexString:@"#DE6D55"]:[UIColor colorWithHexString:@"#74975F"];
    }
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TabContentCollectionViewCell *cell = (TabContentCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if(collectionView == self.collectionView1){
        [self updateCellStatus:cell selected:NO type:0];
    }else{
        self.deselectIndexpath = indexPath;
        TabContentCollectionViewCell *cell = (TabContentCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell == nil) { // 如果重用之后拿不到cell,就直接返回
               return;
           }
        [self updateCellStatus:cell selected:NO type:1];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.collectionView1){
        
    }else{
        TabContentCollectionViewCell *currentCell = (TabContentCollectionViewCell *)cell;
    if (self.deselectIndexpath && [self.deselectIndexpath isEqual:indexPath]) {
        [self updateCellStatus:currentCell selected:NO type:1];
        
    }
    
    if ([self.selectIndexPath isEqual:indexPath]) {
        [self updateCellStatus:currentCell selected:YES type:0];
    }}
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
                          @"lastid":self.lastID,
                          @"searchStr":[self utf82gbk:self.searchBar.text],
                          @"InstallState":self.status,
                          @"datetype":self.datetype
    };
    [EnterpriseMainService requestInstallOrderList:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
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

        }
    }];}else{
        [self.muKeyValueList removeAllObjects];
        [self.tbOrderList reloadData];
    }

  
}





@end
