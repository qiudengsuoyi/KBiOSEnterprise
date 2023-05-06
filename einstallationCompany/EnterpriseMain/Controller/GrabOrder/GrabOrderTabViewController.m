//
//  GrabOrderTabViewController.m
//  einstallationCompany
//
//  Created by 云位 on 2023/4/23.
//

#import "GrabOrderTabViewController.h"
#import "SGPagingView.h"
#import "GrabListViewController.h"
#import "UIColor+YYAdd.h"
#import "CommonSize.h"
#import "YYCGUtilities.h"

@interface GrabOrderTabViewController ()
@property UITextField* searchBar;
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentCollectionView;
@end

@implementation GrabOrderTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self addBackItem];
    NSArray *titleArr = @[@"悬赏任务", @"竞标任务"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.indicatorAdditionalWidth = 20;
    configure.indicatorScrollStyle = SGIndicatorScrollStyleDefault; // 指示器滚动模式
    configure.indicatorColor = [UIColor colorWithHexString:@"#068FFB"];
    configure.titleSelectedColor = [UIColor colorWithHexString:@"#068FFB"];
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, 40.f) delegate:self titleNames:titleArr configure:configure];
    //     _pageTitleView.isTitleGradientEffect = NO;
    _pageTitleView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:_pageTitleView];
    
    GrabListViewController *vc = [[GrabListViewController alloc]init];
    vc.pageType = @"3";
    GrabListViewController *vc1 = [[GrabListViewController alloc]init];
    vc1.pageType = @"4";
    CGFloat ContentCollectionViewHeight = kScreenHeight- 40.f-[CommonSize navigationBar_Height];
    self.pageContentCollectionView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0.f,40.f,kScreenWidth, ContentCollectionViewHeight) parentVC:self childVCs:@[vc,vc1]];
    _pageContentCollectionView.delegatePageContentScrollView = self;
//    [_pageContentCollectionView setPageContentScrollViewCurrentIndex:0];
    //       [_pageContentCollectionView setCircularWithDirection:CircularDirectionTypeLeftRightTop withCornerRadii:10.f];
    [self.view addSubview:_pageContentCollectionView];
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


- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex{
    [self.pageContentCollectionView setPageContentScrollViewCurrentIndex:selectedIndex];
    
}
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex{
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(80, statusBarHeight+(navHeight-36)/2,SCREENWIDTH -100, 36.0f)];
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
    [view.layer setBorderWidth:2];
    [view.layer setBorderColor:[UIColor whiteColor].CGColor];
    [view setBackgroundColor:[UIColor whiteColor]];
    UIImageView*imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 7, 26, 26)];
    [imageView setImage:[UIImage imageNamed:@"search.png"]];
    [view setTag:20];
    
    self.searchBar = [[UITextField alloc] init];
    self.searchBar.frame = CGRectMake(32, 3, 200, 34);
    
    self.searchBar.textColor = [UIColor blackColor];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"搜索我的任务" attributes:
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
            UIView *view = (UIView *) tmpView;
            if(view.tag == 20)   //判断是否满足自己要删除的子视图的条件
            {
                [view removeFromSuperview]; //删除子视图
                
            }
            
        }
    }
    
}







-(void)keyboardDidShow:(NSNotification *) notification{
    NSLog(@"键盘打开了");
}
-(void)keyboardDidHide: (NSNotification *) notification{
    NSLog(@"键盘关闭了");
 
    NSDictionary *dict = @{@"key":self.searchBar.text};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchTask" object:nil userInfo: dict];
    
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
