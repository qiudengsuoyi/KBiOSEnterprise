//
//  WalletViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/16.
//

#import "EnterpriseWalletController.h"
#import "WalletListViewController.h"
#import "InstallViewController.h"
#import "ApproveViewController.h"
#import "ResultController.h"
#import "RechargeViewController.h"

@interface EnterpriseWalletController ()
@property (weak, nonatomic) IBOutlet UIButton *bt01;
@property (weak, nonatomic) IBOutlet UIButton *bt02;
@property (weak, nonatomic) IBOutlet UIButton *bt03;
@property (weak, nonatomic) IBOutlet UIButton *bt04;
@property (weak, nonatomic) IBOutlet UIView *v01;
@property (weak, nonatomic) IBOutlet UIView *v02;
@property (weak, nonatomic) IBOutlet UIView *v03;
@property (weak, nonatomic) IBOutlet UIView *v04;

@end

@implementation EnterpriseWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = @"我的钱包";
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(action01:)];
    // 2. 将点击事件添加到label上
    [self.v01 addGestureRecognizer:labelTapGestureRecognizer];
    self.v01.userInteractionEnabled = YES;
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self action:@selector(action02:)];
    
      // 2. 将点击事件添加到label上
    [self.v02 addGestureRecognizer:labelTapGestureRecognizer];
    self.v02.userInteractionEnabled = YES;
    
    
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self action:@selector(action03:)];
    // 2. 将点击事件添加到label上
    [self.v03 addGestureRecognizer:labelTapGestureRecognizer];
    self.v03.userInteractionEnabled = YES;
  
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self action:@selector(action04:)];
    // 2. 将点击事件添加到label上
    [self.v04 addGestureRecognizer:labelTapGestureRecognizer];
    self.v04.userInteractionEnabled = YES;
 
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)action01:(id)sender {
    ResultController * vc = [ResultController alloc];
    vc.resultType = 1;
    vc.strTitle = @"充值成功";
    vc.strContent01 = @"恭喜您已经成功充值";
    vc.hidesBottomBarWhenPushed = YES;
    [self jumpViewControllerAndCloseSelf:vc];
}
- (IBAction)action02:(id)sender {
    RechargeViewController *vc = [[RechargeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)action03:(id)sender {
    WalletListViewController *vc = [[WalletListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.pageType = 1;
    [self.navigationController pushViewController:vc animated:YES];

  }
- (IBAction)action04:(id)sender {
    ApproveViewController *vc = [[ApproveViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.pageType = 2;
    [self.navigationController pushViewController:vc animated:YES];
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
