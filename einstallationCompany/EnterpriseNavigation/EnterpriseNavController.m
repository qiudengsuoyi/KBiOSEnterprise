//
//  BaseNavigationController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/3/30.
//

#import "EnterpriseNavController.h"
#import <YYKit/YYKit.h>


@interface EnterpriseNavController ()

@end

@implementation EnterpriseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
    
        [appearance setTitleTextAttributes:

        @{NSFontAttributeName:[UIFont systemFontOfSize:16],

        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#D8D8D8"]
          
        }];
        [appearance setBackgroundImage:[UIImage imageNamed:@"enterprise_top_nav"]];
        appearance.shadowColor = [UIColor clearColor];
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        // Fallback on earlier versions
      
        [self.navigationController.navigationBar setTitleTextAttributes:

        @{NSFontAttributeName:[UIFont systemFontOfSize:16],

        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#D8D8D8"]
          
        }];
    }
 
    // Do any additional setup after loading the view from its nib.
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
