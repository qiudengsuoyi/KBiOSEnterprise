//
//  BaseViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/1.
//

#import "EnterpriseBaseController.h"
#import <YYKit/YYKit.h>

@interface EnterpriseBaseController ()<UINavigationControllerDelegate>

@end

@implementation EnterpriseBaseController

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"enterprise_top_nav"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:

    @{NSFontAttributeName:[UIFont systemFontOfSize:16],

    NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#D8D8D8"]
      
    }];
   
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

- (void)addNOBackItem{
    //创建返回按钮
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 25,25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
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
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)jumpViewControllerAndCloseSelf:(UIViewController *)vc{
    NSArray *viewControlles = self.navigationController.viewControllers;
    NSMutableArray *newviewControlles = [NSMutableArray array];
    if ([viewControlles count] > 0) {
        for (int i=0; i < [viewControlles count]-1; i++) {
            [newviewControlles addObject:[viewControlles objectAtIndex:i]];
        }
    }
    [newviewControlles addObject:vc];
    [self.navigationController setViewControllers:newviewControlles animated:YES];
}

-(void)jumpViewControllerAndCloseSelf2:(UIViewController *)vc{
    NSArray *viewControlles = self.navigationController.viewControllers;
    NSMutableArray *newviewControlles = [NSMutableArray array];
    if ([viewControlles count] > 0) {
        for (int i=0; i < [viewControlles count]-2; i++) {
            [newviewControlles addObject:[viewControlles objectAtIndex:i]];
        }
    }
    [newviewControlles addObject:vc];
    [self.navigationController setViewControllers:newviewControlles animated:YES];
}




- (NSString *) utf82gbk:(NSString *)string

{
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
//    NSString *retStr = [string stringByAddingPercentEscapesUsingEncoding:enc];
    
    NSString *retStr = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  



    return  retStr;
}

@end
