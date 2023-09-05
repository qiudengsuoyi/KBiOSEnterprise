//
//  LoginViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/5.
//

#import "EnterpriseLoginController.h"
#import "EnterpriseRegisterController.h"
#import "AppDelegate.h"
#import "EnterpriseLoginService.h"
#import "EnterpriseBaseTextField.h"
#import "IQKeyboardManager.h"
#import "SVProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>
#import "APIConst.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "UserController.h"
#import "EnterpriseViewController.h"
#import "InstallStatisticViewController.h"
#import "PayTypeViewController.h"
#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>
#import "GrabOrderTabViewController.h"
#import "EnterpriseMainController.h"


@interface EnterpriseLoginController ()
@property (strong, nonatomic) EnterpriseUITabBarController *tabBarVC;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) EnterpriseNavController *tabBarNav;
@property (weak, nonatomic) IBOutlet EnterpriseBaseTextField *textPhone;
@property (weak, nonatomic) IBOutlet EnterpriseBaseTextField *textPassword;
@end

@implementation EnterpriseLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = @"用户登录";
    self.textPhone.upperlimitNumber = 20;
    self.textPassword.upperlimitNumber = 20;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (IBAction)actionLogin:(id)sender {
    [self requstLogin];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    [user setValue:@"1" forKey:@"userID"];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionRegister:(id)sender {
    EnterpriseRegisterController *vc = [[EnterpriseRegisterController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)requstLogin{
    NSString * userName = self.textPhone.text;
    NSString * password = self.textPassword.text;
    if(userName.length<1){
        [SVProgressHUD showErrorWithStatus:@"请输入账号！"];
        return;
    }
    if(password.length<6){
        [SVProgressHUD showErrorWithStatus:@"密码不能小于6位！"];
        return;
    }
 
    [SVProgressHUD show];
    NSDictionary *dic = @{@"username":userName,
                          @"password":[self getmd5WithString:password]
                          };
    [EnterpriseLoginService requestLogin:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
           
           
            self.returnModel = data;
            [CloudPushSDK addAlias:[NSString stringWithFormat:@"enterprise%@",self.returnModel.userid] withCallback:^(CloudPushCallbackResult *res) {
                if (res.success) {
                    NSLog(@"addAlias success");
                    NSLog(@"%@", [NSString stringWithFormat:@"enterprise%@",self.returnModel.userid]);
                } else {
                    NSLog(@"addAlias failed, error: %@", res.error);
                }
            }];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setValue:self.returnModel.userid forKey:@"userID"];
            [user setValue:self.returnModel.Browsetype forKey:ENTERPRISE_BROWSETYPE];
            [user setValue:self.returnModel.ParentID forKey:ENTERPRISE_PARENTID];
     
            
            NSMutableArray *vcArray = [NSMutableArray new];
            NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_USERID];
            NSString * browseType = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_BROWSETYPE];
            
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//
//            if(userID.length>0&&browseType.intValue != 3){
//                [vcArray addObject:appDelegate.homeTwoNav];
//                [vcArray addObject:appDelegate.orderNav];
//                [vcArray addObject:appDelegate.ownerNav];
//            }else{
//                [vcArray addObject:appDelegate.homeNav];
//                [vcArray addObject:appDelegate.workNav];
//                [vcArray addObject:appDelegate.grabListNav];
//                [vcArray addObject:appDelegate.ownerNav];
//            }
//            appDelegate.tabBarVC.viewControllers = vcArray;
//            appDelegate.window.rootViewController = appDelegate.tabBarVC;
//            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//            UserController *ownerVC = [[UserController alloc] init];
//            if(userID.length>0&&browseType.intValue != 3){
//                // 设置新的根视图控制器并重置导航堆栈
//                [appDelegate.tabBarVC.tabBarController.viewControllers[2] setViewControllers:@[ownerVC] animated:YES];
//
//            }else{
//                [appDelegate.tabBarVC.tabBarController.viewControllers[3] setViewControllers:@[ownerVC] animated:YES];
//            }
//
//            appDelegate.tabBarVC.selectedIndex = 0;
//            appDelegate.tabBarVC.hidesBottomBarWhenPushed = NO;
//            //显示Window
//            [appDelegate.window makeKeyAndVisible];
            [self setBottomNav];
        
            
            
          
           

        }
    }];

  
}


-(void)setBottomNav{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *vcArray;
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_USERID];
    NSString * browseType = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_BROWSETYPE];
    self.tabBarVC = [[EnterpriseUITabBarController alloc] init];
    if(userID.length>0&&browseType.intValue != 3){
        EnterpriseViewController *homeTwoVC = [[EnterpriseViewController alloc] init];
        EnterpriseNavController *homeTwoNav = [[EnterpriseNavController alloc] initWithRootViewController:homeTwoVC];
            [self setTabBarItem:homeTwoVC.tabBarItem
            Title:@"首页"
            withTitleSize:12.0
            andFoneName:@"Marion-Italic"
            selectedImage:@"enterprise_tab_01"
            withTitleColor:[UIColor colorWithHexString:@"#068FFB"]
            unselectedImage:@"enterprise_tab_01_u"
            withTitleColor:[UIColor colorWithHexString:@"#DFDFDF"]];
        homeTwoNav.navigationBar.translucent = NO;
        
        
        InstallStatisticViewController *orderVC = [[InstallStatisticViewController alloc] init];
        EnterpriseNavController *orderNav = [[EnterpriseNavController alloc] initWithRootViewController:orderVC];
            [self setTabBarItem:orderVC.tabBarItem
            Title:@"安装统计"
            withTitleSize:12.0
            andFoneName:@"Marion-Italic"
            selectedImage:@"enterprise_tab_03"
            withTitleColor:[UIColor colorWithHexString:@"#068FFB"]
            unselectedImage:@"enterprise_tab_03_u"
            withTitleColor:[UIColor colorWithHexString:@"#DFDFDF"]];
        orderNav.navigationBar.translucent = NO;
        


        UserController *ownerVC = [[UserController alloc] init];
        EnterpriseNavController * ownerNav = [[EnterpriseNavController alloc] initWithRootViewController:ownerVC];
        [self setTabBarItem:ownerVC.tabBarItem
        Title:@"我的"
        withTitleSize:12.0
        andFoneName:@"Marion-Italic"
        selectedImage:@"enterprise_tab_04"
        withTitleColor:[UIColor colorWithHexString:@"#068FFB"]
        unselectedImage:@"enterprise_tab_04_u"
        withTitleColor:[UIColor colorWithHexString:@"#DFDFDF"]];
        ownerNav.navigationBar.translucent = NO;
        vcArray = [NSArray arrayWithObjects:homeTwoNav,orderNav,ownerNav, nil];
    }else{
        EnterpriseMainController *homeVC = [[EnterpriseMainController alloc] init];
        EnterpriseNavController *homeNav = [[EnterpriseNavController alloc] initWithRootViewController:homeVC];
        [self setTabBarItem:homeVC.tabBarItem
        Title:@"首页"
        withTitleSize:12.0
        andFoneName:@"Marion-Italic"
        selectedImage:@"enterprise_tab_01"
        withTitleColor:[UIColor colorWithHexString:@"#068FFB"]
        unselectedImage:@"enterprise_tab_01_u"
        withTitleColor:[UIColor colorWithHexString:@"#DFDFDF"]];
        homeNav.navigationBar.translucent = NO;


        
        PayTypeViewController *workVC = [[PayTypeViewController alloc] init];
        EnterpriseNavController * workNav = [[EnterpriseNavController alloc] initWithRootViewController:workVC];
        [self setTabBarItem:workVC.tabBarItem
        Title:@"发布任务"
        withTitleSize:12.0
        andFoneName:@"Marion-Italic"
        selectedImage:@"enterprise_tab_02"
        withTitleColor:[UIColor colorWithHexString:@"#068FFB"]
        unselectedImage:@"enterprise_tab_02_u"
        withTitleColor:[UIColor colorWithHexString:@"#DFDFDF"]];
        workNav.navigationBar.translucent = NO;
      


        GrabOrderTabViewController *grabListVC = [[GrabOrderTabViewController alloc] init];
        EnterpriseNavController * grabListNav = [[EnterpriseNavController alloc] initWithRootViewController:grabListVC];
            [self setTabBarItem:grabListVC.tabBarItem
            Title:@"任务列表"
            withTitleSize:12.0
            andFoneName:@"Marion-Italic"
            selectedImage:@"enterprise_tab_03"
            withTitleColor:[UIColor colorWithHexString:@"#068FFB"]
            unselectedImage:@"enterprise_tab_03_u"
            withTitleColor:[UIColor colorWithHexString:@"#DFDFDF"]];
        grabListNav.navigationBar.translucent = NO;


        UserController *ownerVC = [[UserController alloc] init];
        EnterpriseNavController *ownerNav = [[EnterpriseNavController alloc] initWithRootViewController:ownerVC];
        [self setTabBarItem:ownerVC.tabBarItem
        Title:@"我的"
        withTitleSize:12.0
        andFoneName:@"Marion-Italic"
        selectedImage:@"enterprise_tab_04"
        withTitleColor:[UIColor colorWithHexString:@"#068FFB"]
        unselectedImage:@"enterprise_tab_04_u"
        withTitleColor:[UIColor colorWithHexString:@"#DFDFDF"]];
        ownerNav.navigationBar.translucent = NO;
        vcArray = [NSArray arrayWithObjects:homeNav, workNav,grabListNav,ownerNav, nil];
    }
   
    appDelegate.tabBarVC.viewControllers = vcArray;
    appDelegate.window.rootViewController = appDelegate.tabBarVC;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    appDelegate.tabBarVC.selectedIndex = 0;
    appDelegate.tabBarVC.hidesBottomBarWhenPushed = NO;
    //显示Window
    [self.window makeKeyAndVisible];

}

- (void)setTabBarItem:(UITabBarItem *)tabbarItem
                Title:(NSString *)title
        withTitleSize:(CGFloat)size
          andFoneName:(NSString *)foneName
        selectedImage:(NSString *)selectedImage
       withTitleColor:(UIColor *)selectColor
      unselectedImage:(NSString *)unselectedImage
       withTitleColor:(UIColor *)unselectColor{
    
    //设置图片
    tabbarItem = [tabbarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor} forState:UIControlStateNormal];

    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor} forState:UIControlStateSelected];
    
 
   
    UITabBar *tabBar = [UITabBar appearance];
    [tabBar setTintColor:selectColor];
    [tabBar setUnselectedItemTintColor:unselectColor];
    [tabBar setBarTintColor:[UIColor colorWithHexString:@"#333333"]];
    
    [tabBar setBackgroundColor:[UIColor colorWithHexString:@"#333333"]];
    tabBar.translucent = NO;
  
}

-(NSString*)getmd5WithString:(NSString *)string
{
    const char *original_str = [string UTF8String];
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5(original_str, strlen(original_str), result);
        NSMutableString *hash = [NSMutableString string];
        for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        {
            /*
             %02X是格式控制符：‘x’表示以16进制输出，‘02’表示不足两位，前面补0；
             */
            [hash appendFormat:@"%02X", result[i]];
        }
        NSString *mdfiveString = [hash uppercaseString];
        return mdfiveString;
}


- (void)addBackItem{
    //创建返回按钮
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 25,25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];;
    //创建UIBarButtonSystemItemFixedSpace
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = 15;
    //将两个BarButtonItem都返回给NavigationItem
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarBtn];
    
}

-(void)backItemAction:(UIBarButtonItem *)sender{
    [self setBottomNav];
    
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
