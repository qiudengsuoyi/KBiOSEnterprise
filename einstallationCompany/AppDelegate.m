//
//  AppDelegate.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/3/28.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>
#import "EnterpriseMainController.h"
#import "UserController.h"
#import "LBLaunchImageAdView.h"
#import "NSObject+LBLaunchImage.h"
#import "InstallTaskController.h"
#import "EnterpriseNoticeController.h"
#import "WXApi.h"
#import "APIConst.h"
#import "WXApiManager.h"
#import "InstallStatisticViewController.h"
#import "PayTypeViewController.h"
#import "GrabOrderTabViewController.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "EnterpriseViewController.h"
#import "SVProgressHUD.h"
#import "EnterpriseLoginController.h"



@interface AppDelegate ()<UITabBarControllerDelegate,UITabBarDelegate,WXApiDelegate>



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // APNs注册，获取deviceToken并上报
    [self registerAPNS:application];
    // 初始化SDK
    [self initCloudPush];
    
    // 监听推送通道打开动作
    [self listenerOnChannelOpened];
    // 监听推送消息到达
    [self registerMessageReceive];
    // 点击通知将App从关闭状态启动时，将通知打开回执上报
    // [CloudPushSDK handleLaunching:launchOptions];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:launchOptions];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"SoundMode"];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"LiveMode"];
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"ByOrder"];
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"checkAgreeBtn"];


    [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
        NSLog(@"log : %@", log);
    }];
    
    //向微信注册,发起支付必须注册
    [WXApi registerApp:WE_CHAT_APPID universalLink:UNIVERSAL_LINK];
//    //2、创建一个数组，放置多有控制器
//    NSArray *vcArray = [NSArray arrayWithObjects:homeNav, workNav,orderNav,ownerNav, nil];
//    //3、创建UITabBarController，将控制器数组设置给UITabBarController
//    self.tabBarVC = [[EnterpriseUITabBarController alloc] init];
//    //设置多个Tab的ViewController到TabBarViewController
//    self.tabBarVC.viewControllers = vcArray;
////    BaseNavigationController * tabBarNav = [[BaseNavigationController alloc] initWithRootViewController: self.tabBarVC];
//    //4、将UITabBarController设置为Window的RootViewController
//    self.window.rootViewController = self.tabBarVC;
//    self.tabBarVC.delegate = self;
//
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    //显示Window
//    [self.window makeKeyAndVisible];
    
    [self setBottomNav];
    self.tabBarVC.delegate = self;
    [self configLBLaunchImageAdView];
    // Override point for customization after application launch.
    return YES;
}

-(void)setBottomNav{
    NSArray *vcArray;
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_USERID];
    NSString * browseType = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_BROWSETYPE];
    self.tabBarVC = [[EnterpriseUITabBarController alloc] init];
    if(userID.length>0&&browseType.intValue != 3){
        EnterpriseViewController *homeTwoVC = [[EnterpriseViewController alloc] init];
        self.homeTwoNav = [[EnterpriseNavController alloc] initWithRootViewController:homeTwoVC];
            [self setTabBarItem:homeTwoVC.tabBarItem
            Title:@"首页"
            withTitleSize:12.0
            andFoneName:@"Marion-Italic"
            selectedImage:@"enterprise_tab_01"
            withTitleColor:[UIColor colorWithHexString:@"#068FFB"]
            unselectedImage:@"enterprise_tab_01_u"
            withTitleColor:[UIColor colorWithHexString:@"#DFDFDF"]];
        self.homeTwoNav.navigationBar.translucent = NO;
        
        
        InstallStatisticViewController *orderVC = [[InstallStatisticViewController alloc] init];
        self.orderNav = [[EnterpriseNavController alloc] initWithRootViewController:orderVC];
            [self setTabBarItem:orderVC.tabBarItem
            Title:@"安装统计"
            withTitleSize:12.0
            andFoneName:@"Marion-Italic"
            selectedImage:@"enterprise_tab_03"
            withTitleColor:[UIColor colorWithHexString:@"#068FFB"]
            unselectedImage:@"enterprise_tab_03_u"
            withTitleColor:[UIColor colorWithHexString:@"#DFDFDF"]];
        self.orderNav.navigationBar.translucent = NO;
        


        UserController *ownerVC = [[UserController alloc] init];
        self.ownerNav = [[EnterpriseNavController alloc] initWithRootViewController:ownerVC];
        [self setTabBarItem:ownerVC.tabBarItem
        Title:@"我的"
        withTitleSize:12.0
        andFoneName:@"Marion-Italic"
        selectedImage:@"enterprise_tab_04"
        withTitleColor:[UIColor colorWithHexString:@"#068FFB"]
        unselectedImage:@"enterprise_tab_04_u"
        withTitleColor:[UIColor colorWithHexString:@"#DFDFDF"]];
        self.ownerNav.navigationBar.translucent = NO;
        vcArray = [NSArray arrayWithObjects:self.homeTwoNav,self.orderNav,self.ownerNav, nil];
    }else{
        EnterpriseMainController *homeVC = [[EnterpriseMainController alloc] init];
        self.homeNav = [[EnterpriseNavController alloc] initWithRootViewController:homeVC];
        [self setTabBarItem:homeVC.tabBarItem
        Title:@"首页"
        withTitleSize:12.0
        andFoneName:@"Marion-Italic"
        selectedImage:@"enterprise_tab_01"
        withTitleColor:[UIColor colorWithHexString:@"#068FFB"]
        unselectedImage:@"enterprise_tab_01_u"
        withTitleColor:[UIColor colorWithHexString:@"#DFDFDF"]];
        self.homeNav.navigationBar.translucent = NO;



    //    EnterpriseNoticeController *workVC = [[EnterpriseNoticeController alloc] init];
    //    EnterpriseNavController *workNav = [[EnterpriseNavController alloc] initWithRootViewController:workVC];
    //    [self setTabBarItem:workVC.tabBarItem
    //    Title:@"公告"
    //    withTitleSize:12.0
    //    andFoneName:@"Marion-Italic"
    //    selectedImage:@"enterprise_tab_02"
    //    withTitleColor:[UIColor colorWithHexString:@"#068FFB"]
    //    unselectedImage:@"enterprise_tab_02_u"
    //    withTitleColor:[UIColor colorWithHexString:@"#DFDFDF"]];
    //    workNav.navigationBar.translucent = NO;
        
        PayTypeViewController *workVC = [[PayTypeViewController alloc] init];
        self.workNav = [[EnterpriseNavController alloc] initWithRootViewController:workVC];
        [self setTabBarItem:workVC.tabBarItem
        Title:@"发布任务"
        withTitleSize:12.0
        andFoneName:@"Marion-Italic"
        selectedImage:@"enterprise_tab_02"
        withTitleColor:[UIColor colorWithHexString:@"#068FFB"]
        unselectedImage:@"enterprise_tab_02_u"
        withTitleColor:[UIColor colorWithHexString:@"#DFDFDF"]];
        self.workNav.navigationBar.translucent = NO;
      


    //    InstallTaskController *orderVC = [[InstallTaskController alloc] init];
    //    EnterpriseNavController *orderNav = [[EnterpriseNavController alloc] initWithRootViewController:orderVC];
    //    [self setTabBarItem:orderVC.tabBarItem
    //    Title:@"未完成"
    //    withTitleSize:12.0
    //    andFoneName:@"Marion-Italic"
    //    selectedImage:@"enterprise_tab_03"
    //    withTitleColor:[UIColor colorWithHexString:@"#068FFB"]
    //    unselectedImage:@"enterprise_tab_03_u"
    //    withTitleColor:[UIColor colorWithHexString:@"#DFDFDF"]];
    //    orderNav.navigationBar.translucent = NO;

        GrabOrderTabViewController *grabListVC = [[GrabOrderTabViewController alloc] init];
            self.grabListNav = [[EnterpriseNavController alloc] initWithRootViewController:grabListVC];
            [self setTabBarItem:grabListVC.tabBarItem
            Title:@"任务列表"
            withTitleSize:12.0
            andFoneName:@"Marion-Italic"
            selectedImage:@"enterprise_tab_03"
            withTitleColor:[UIColor colorWithHexString:@"#068FFB"]
            unselectedImage:@"enterprise_tab_03_u"
            withTitleColor:[UIColor colorWithHexString:@"#DFDFDF"]];
        self.grabListNav.navigationBar.translucent = NO;


        UserController *ownerVC = [[UserController alloc] init];
        self.ownerNav = [[EnterpriseNavController alloc] initWithRootViewController:ownerVC];
        [self setTabBarItem:ownerVC.tabBarItem
        Title:@"我的"
        withTitleSize:12.0
        andFoneName:@"Marion-Italic"
        selectedImage:@"enterprise_tab_04"
        withTitleColor:[UIColor colorWithHexString:@"#068FFB"]
        unselectedImage:@"enterprise_tab_04_u"
        withTitleColor:[UIColor colorWithHexString:@"#DFDFDF"]];
        self.ownerNav.navigationBar.translucent = NO;
        vcArray = [NSArray arrayWithObjects:self.homeNav, self.workNav,self.grabListNav,self.ownerNav, nil];
    }
    self.tabBarVC.viewControllers = vcArray;
    self.window.rootViewController = self.tabBarVC;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //显示Window
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (void)configLBLaunchImageAdView{
    UIViewController *vc =[[UIViewController alloc]init];
    self.window.rootViewController = vc;
    [NSObject makeLBLaunchImageAdView:^(LBLaunchImageAdView *imgAdView) {
        //设置广告的类型
        imgAdView.getLBlaunchImageAdViewType(FullScreenAdType);
        //设置本地启动图片
        imgAdView.localAdImgName = @"enterprise_load.png";
        //        imgAdView.localAdImgName = @"kaiji_018.png";
        imgAdView.adTime = 3;
        //                imgAdView.imgUrl = @"http://img.zcool.cn/community/01316b5854df84a8012060c8033d89.gif";
        //自定义跳过按钮
        imgAdView.skipBtn.backgroundColor = [UIColor blackColor];
        imgAdView.skipBtn.hidden = YES;
        //各种点击事件的回调
        
        imgAdView.clickBlock = ^(clickType type){
            switch (type) {
                case clickAdType:{
                    NSLog(@"点击广告回调");
                    self.window.rootViewController = self.tabBarVC;
                }
                    break;
                case skipAdType:
                    NSLog(@"点击跳过回调");
                    self.window.rootViewController = self.tabBarVC;
                    break;
                case overtimeAdType:
                    NSLog(@"倒计时完成后的回调");
                    self.window.rootViewController = self.tabBarVC;
                    break;
                default:
                    break;
            }
        };
        
    }];
    
}

/**
 * 当选中控制器时回调
 */
- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_USERID];
    //选中的ViewController实例
    UIViewController *selectVC = tabBarController.selectedViewController;
    NSLog(@"选中的index: %zd， 选中的ViewController: %@", tabBarController.selectedIndex, selectVC);
    if(tabBarController.selectedIndex == 1){
       
        if(userID.length>0){
            
        }else{
            
            
            [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录！"];
            EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            UINavigationController *navController = (UINavigationController *)selectVC;
                        [navController pushViewController:vc animated:YES];
            
        }
    }else if(tabBarController.selectedIndex == 2){
        if(userID.length>0){
            
        }else{
            
    
            [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录！"];
            EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            UINavigationController *navController = (UINavigationController *)selectVC;
                        [navController pushViewController:vc animated:YES];
            
            
        }
    }
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

- (void)initCloudPush {
    // SDK初始化
    [CloudPushSDK asyncInit:@"333571434" appSecret:@"569b237522d04edbb6f9139426f6fbab" callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}

/**
 *    注册苹果推送，获取deviceToken用于推送
 *
 *    @param application
 */
- (void)registerAPNS:(UIApplication *)application {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
    }
    else {
        // iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
}
/*
 *  苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success. %@",deviceToken);
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
}
/*
 *  苹果推送注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}


/**
 *    注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}
/**
 *    处理到来推送消息
 *
 *    @param     notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
}

#pragma mark Channel Opened
/**
 *    注册推送通道打开监听
 */
- (void)listenerOnChannelOpened {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelOpened:)
                                                 name:@"CCPDidChannelConnectedSuccess"
                                               object:nil];
}

/**
 *    推送通道打开回调
 *
 *    @param     notification
 */
- (void)onChannelOpened:(NSNotification *)notification {
    NSLog(@"Receive message title: %s", "消息通道建立成功");

}


/*
 *  App处于启动状态时，通知打开回调
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    NSLog(@"Receive one notification.");
    // 取得APNS通知内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    // 内容
    NSString *content = [aps valueForKey:@"alert"];
    // badge数量
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    // 播放声音
    NSString *sound = [aps valueForKey:@"sound"];
    // 取得Extras字段内容
    NSString *Extras = [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, Extras);
    // iOS badge 清0
    application.applicationIconBadgeNumber = 0;
    // 通知打开回执上报
    // [CloudPushSDK handleReceiveRemoteNotification:userInfo];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:userInfo];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler
{
   
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}


@end
