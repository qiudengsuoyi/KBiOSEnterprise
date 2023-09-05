//
//  InstallStatisticViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/8.
//

#import "InstallStatisticViewController.h"
#import "BrandTableViewCell.h"
#import "TaskOrderViewController.h"
#import <YYKit/YYKit.h>
#import "EnterpriseMainService.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "UITableView+Refresh.h"
#import "YYLrefresh/UITableView+Refresh.h"
#import "UITableView+Refresh.h"
#import "UIView+RefreshData.h"
#import "BRDatePickerView.h"
#import "EnterpriseLoginController.h"


@interface InstallStatisticViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbOrderList;
@property NSString * currentYear;
@property NSString * currentMonth;
@property UILabel * labelTime;
@property UITextField * searchBar;
@property NSDate * currentDate;
@end

@implementation InstallStatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.muKeyValueList = [NSMutableArray arrayWithCapacity:0];
    self.tbOrderList.dataSource = self;
    self.tbOrderList.delegate = self;
    // 1.设置行高为自动撑开
    self.tbOrderList.rowHeight = UITableViewAutomaticDimension;
    self.tbOrderList.allowsSelection = YES;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbOrderList.estimatedRowHeight = 80;
    self.tbOrderList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbOrderList registerNib:[UINib nibWithNibName:NSStringFromClass([BrandTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BrandTableViewCell class])];
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
    
    NSDate *date = [NSDate date];//这个是NSDate类型的日期，所要获取的年月日都放在这里；
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|
    NSCalendarUnitDay;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    
    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    //然后就可以从d中获取具体的年月日了；
    self.currentYear = [NSString stringWithFormat:@"%ld",(long)[d year]];
    self.currentMonth = [NSString stringWithFormat:@"%ld",(long)[d month]];
    
    
    
    
    
}
-(void)selectDate{
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    datePickerView.pickerMode = BRDatePickerModeYM;
    datePickerView.title = @"时间";
    datePickerView.selectDate = self.currentDate;
    datePickerView.minDate = [NSDate br_setYear:1900 month:1 day:1];
    datePickerView.maxDate = [NSDate date];
    datePickerView.isAutoSelect = NO;
    // 指定不可选择的日期
    datePickerView.nonSelectableDates = @[[NSDate br_setYear:2020 month:8 day:1], [NSDate br_setYear:2020 month:9 day:10]];
    datePickerView.keyView = self.view; // 将组件 datePickerView 添加到 self.view 上，默认是添加到 keyWindow 上
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        self.currentDate = selectDate;
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|
        NSCalendarUnitDay;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
        
        NSDateComponents *d = [cal components:unitFlags fromDate:self.currentDate];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
        //然后就可以从d中获取具体的年月日了；
        self.currentYear = [NSString stringWithFormat:@"%ld",(long)[d year]];
        self.currentMonth = [NSString stringWithFormat:@"%ld",(long)[d month]];
        
        self.labelTime.text = [NSString stringWithFormat:@"%@年%@月",self.currentYear,self.currentMonth];
        NSLog(@"selectValue=%@", selectValue);
        NSLog(@"selectDate=%@", selectDate);
        NSLog(@"---------------------------------");
        [self.tbOrderList configureMJRefreshWithHader:^(NSInteger page) {
            [self requstOrderList:YES];
        } WithFoot:^(NSInteger page) {
            [self requstOrderList:YES];
            
        }];
    };
    
    // 设置年份背景
    
    UILabel *yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 216)];
    yearLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    yearLabel.backgroundColor = [UIColor clearColor];
    yearLabel.textAlignment = NSTextAlignmentCenter;
    yearLabel.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2f];
    yearLabel.font = [UIFont boldSystemFontOfSize:100.0f];
    self.currentYear = self.currentDate ? @(self.currentDate.br_year).stringValue : @([NSDate date].br_year).stringValue;
    
    yearLabel.text = self.currentYear;
    [datePickerView.alertView addSubview:yearLabel];
    // 滚动选择器，动态更新年份
    datePickerView.changeBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        yearLabel.text = selectDate ? @(selectDate.br_year).stringValue : @"";
        
        
    };
    
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    customStyle.pickerColor = [UIColor clearColor];
    datePickerView.pickerStyle = customStyle;
    
    [datePickerView show];
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

-(void)keyboardDidShow:(NSNotification *) notification{
    NSLog(@"键盘打开了");
}
-(void)keyboardDidHide: (NSNotification *) notification{
    NSLog(@"键盘关闭了");
    if(self.searchBar.text.length>0){
        [self.tbOrderList configureMJRefreshWithHader:^(NSInteger page) {
            [self requstOrderList:YES];
        } WithFoot:^(NSInteger page) {
            [self requstOrderList:YES];
            
        }];
    }
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30, statusBarHeight+(navHeight-36)/2,SCREENWIDTH -180, 36.0f)];
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
    [view.layer setBorderWidth:2];
    [view.layer setBorderColor:[UIColor whiteColor].CGColor];
    [view setBackgroundColor:[UIColor whiteColor]];
    UIImageView*imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 7, 26, 26)];
    [imageView setImage:[UIImage imageNamed:@"search.png"]];
    [view setTag:20];
    
    self.searchBar = [[UITextField alloc] init];
    self.searchBar.frame = CGRectMake(32, 3, SCREENWIDTH-100, 34);
    
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"搜索安装品牌" attributes:
                                      @{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                        NSFontAttributeName:self.searchBar.font
                                      }];
    self.searchBar.attributedPlaceholder = attrString;
    
    self.searchBar.textColor = [UIColor blackColor];
    [view addSubview:imageView];
    [view addSubview:self.searchBar];
    
    self.labelTime = [[UILabel alloc] init];
    self.labelTime.layer.cornerRadius = 8;
    self.labelTime.layer.masksToBounds = YES;
    self.labelTime.backgroundColor =[UIColor whiteColor];
    self.labelTime.textAlignment = NSTextAlignmentCenter;
    self.labelTime.textColor = [UIColor grayColor];
    self.labelTime.frame = CGRectMake(SCREENWIDTH-140, statusBarHeight+(navHeight-36)/2, 110, 34);
    self.labelTime.text = [NSString stringWithFormat:@"%@年%@月",self.currentYear,self.currentMonth];
    [self.labelTime setTag:20];
    [self.navigationController.view addSubview:self.labelTime];
    
    [self.navigationController.view addSubview:view];
    
    UITapGestureRecognizer *tapGestureRecognizer01 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDate)];
    // 2. 将点击事件添加到label上
    [self.labelTime addGestureRecognizer:tapGestureRecognizer01];
    
    self.labelTime.userInteractionEnabled = YES;
    
}

-(void)removeControllerView{
    for(id tmpView in [self.navigationController.view subviews])
    {
        //找到要删除的子视图的对象
        if([tmpView isKindOfClass:[UIImageView class]])
        {
            UIImageView *imgView = (UIImageView *)tmpView;
            if(imgView.tag == 30)   //判断是否满足自己要删除的子视图的条件
            {
                [imgView removeFromSuperview]; //删除子视图
                
            }
            
        }
  
        
        if([tmpView isKindOfClass:[UIView class]])
        {
            UILabel *view = (UILabel *) tmpView;
            if(view.tag == 20)   //判断是否满足自己要删除的子视图的条件
            {
                [view removeFromSuperview]; //删除子视图
                
            }
            
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskOrderViewController *vc = [[TaskOrderViewController alloc]init];
    vc.currentMonth = self.currentMonth;
    vc.currentYear = self.currentYear;
    vc.Brand = [self.muKeyValueList
                objectAtIndex:indexPath.row].Value;
    vc.Title = [NSString stringWithFormat:@"%@%@年%@月",[self.muKeyValueList
                                                       objectAtIndex:indexPath.row].Value,self.currentYear,self.currentMonth];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.muKeyValueList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BrandTableViewCell class])];
    if (cell == nil) {
        cell = [[BrandTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    KeyValueEntity *model = [self.muKeyValueList objectAtIndex:indexPath.row];
    cell.model = model;
    [cell setBrand];
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
                              @"Brand":[self utf82gbk:self.searchBar.text]
        };
        [EnterpriseMainService requestInstallOrderStatisticDetail:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
            if (data) {
                if (error) {
                    self.view.loadErrorType = [error integerValue];
                    return ;
                }
                if (refresh) {
                    [self.muKeyValueList removeAllObjects];
                }
                
                
                
                [self.muKeyValueList addObjectsFromArray:data];;
                
                if (self.muKeyValueList.count == 0) {
                    
                    self.tbOrderList.loadErrorType = YYLLoadErrorTypeNoData;
                    
                }else{
                    self.tbOrderList.loadErrorType = YYLLoadErrorTypeDefalt;
                }
                [self.tbOrderList reloadData];
                
            }
        }];}else{
            self.tbOrderList.loadErrorType = YYLLoadErrorTypeNoData;
        }
    
    
}



@end
