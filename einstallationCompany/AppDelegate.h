//
//  AppDelegate.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/3/28.
//

#import <UIKit/UIKit.h>
#import "EnterpriseUITabBarController.h"
#import "EnterpriseNavController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) EnterpriseUITabBarController *tabBarVC;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) EnterpriseNavController *tabBarNav;
@end

