//
//  WaitOrderItemListViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/24.
//

#import "WaitTaskSingleListController.h"
#import "WaitTaskItemTableViewCell.h"
#import "ResultController.h"

@interface WaitTaskSingleListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbOrderList;
@end

@implementation WaitTaskSingleListController
- (IBAction)actionAccept:(id)sender {
    ResultController * vc = [ResultController alloc];
    vc.resultType = 1;
    vc.strTitle = @"成功接受订单";
    vc.strContent01 = @"恭喜您已经成功接受订单";
    vc.strContent02 = @"请保持电话畅通等待E安装执行部与您进一步沟通";
    [self jumpViewControllerAndCloseSelf:vc];
    
}
- (IBAction)actionRefuse:(id)sender {
    ResultController * vc = [ResultController alloc];
    vc.resultType = 2;
    vc.strTitle = @"拒绝接受订单";
    vc.strContent01 = @"很遗憾您拒绝了订单";
    vc.strContent02 = @"期待下次能和您再次合作";
    [self jumpViewControllerAndCloseSelf:vc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    NSMutableArray *arrList = [NSMutableArray arrayWithCapacity:0];
    for(int i = 0;i<10;i++){
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        KeyValueEntity * keyValueModel = [KeyValueEntity alloc];
        keyValueModel.PictureURL = @"";
        keyValueModel.Value = @"商场海报安装";
        keyValueModel.Color = @"#000000";
        keyValueModel.State = @"1";
        keyValueModel.ValueHint = @"(12个安装任务)";
        [arr addObject:keyValueModel];
        keyValueModel = [KeyValueEntity alloc];
        keyValueModel.PictureURL = @"";
        keyValueModel.Value = @"商场海报安装商场海报安装商场海报安装商";
        keyValueModel.Color = @"#7D7D7D";
        [arr addObject:keyValueModel];
        keyValueModel = [KeyValueEntity alloc];
        keyValueModel.PictureURL = @"";
        keyValueModel.Value = @"ONLY";
        keyValueModel.Color = @"#5586DE";
        [arr addObject:keyValueModel];
        
        keyValueModel = [KeyValueEntity alloc];
        keyValueModel.PictureURL = @"";
        keyValueModel.Value = @"500元";
        keyValueModel.Color = @"#7D7D7D";
        [arr addObject:keyValueModel];
        
        keyValueModel = [KeyValueEntity alloc];
        keyValueModel.PictureURL = @"";
        keyValueModel.Value = @"POP安装";
        keyValueModel.Color = @"#7D7D7D";
        [arr addObject:keyValueModel];
        [arrList addObject:arr];
    
    }
    self.muKeyValueList = arrList;
    
    self.tbOrderList.dataSource = self;
    self.tbOrderList.delegate = self;
    // 1.设置行高为自动撑开
    self.tbOrderList.rowHeight = UITableViewAutomaticDimension;
    self.tbOrderList.allowsSelection = NO;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbOrderList.estimatedRowHeight = 120;
    self.tbOrderList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbOrderList registerNib:[UINib nibWithNibName:NSStringFromClass([WaitTaskItemTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WaitTaskItemTableViewCell class])];
    [self.tbOrderList reloadData];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self addControllerView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self removeControllerView];
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
    
    UITextField * searchBar = [[UITextField alloc] init];
    searchBar.tintColor = [UIColor darkGrayColor];
    searchBar.frame = CGRectMake(32, 3, SCREENWIDTH -150, 34);
    searchBar.placeholder = @"搜索待接受任务";
    searchBar.textColor = [UIColor blackColor];
    [view addSubview:imageView];
    [view addSubview:searchBar];
   
    
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
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.muKeyValueList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WaitTaskItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WaitTaskItemTableViewCell class])];
    if (cell == nil) {
        cell = [[WaitTaskItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    NSMutableArray <KeyValueEntity*> *itemModelList = [self.muKeyValueList objectAtIndex:indexPath.row];
    cell.keyValueList = itemModelList;
    CGFloat itemHeight;
    CGFloat totalHeight = 0;
    for (KeyValueEntity *itemModel in itemModelList) {
        itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-180), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
        totalHeight = totalHeight+itemHeight;
    }
    cell.cellConstrainHeight.constant = totalHeight+15;
    [cell setTableOrder];
    return cell;
    
    
    
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

