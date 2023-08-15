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
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "EnterpriseWalletService.h"

@interface EnterpriseWalletController ()
@property (weak, nonatomic) IBOutlet UIView *vRecharge;
@property (weak, nonatomic) IBOutlet UIView *vCost;
@property (weak, nonatomic) IBOutlet UILabel *labelMoneyRecharge;
@property (weak, nonatomic) IBOutlet UILabel *labelMoneyCost;
@property (weak, nonatomic) IBOutlet UILabel *labelMoneyResidue;


@end

@implementation EnterpriseWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = @"我的钱包";
    [self requstWallet];
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(action01:)];
    // 2. 将点击事件添加到label上
    [self.vRecharge addGestureRecognizer:labelTapGestureRecognizer];
    self.vRecharge.userInteractionEnabled = YES;
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self action:@selector(action02:)];
    
      // 2. 将点击事件添加到label上
    [self.vCost addGestureRecognizer:labelTapGestureRecognizer];
    self.vCost.userInteractionEnabled = YES;
    

    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)action01:(id)sender {
    ApproveViewController * vc = [ApproveViewController alloc];
    vc.pageType = 1;
    vc.strTitle = @"充值金额";
    vc.strMoney = self.labelMoneyRecharge.text;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)action02:(id)sender {
    ApproveViewController * vc = [ApproveViewController alloc];
    vc.pageType = 2;
    vc.strTitle = @"消费金额";
    vc.strMoney = self.labelMoneyCost.text;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)requstWallet{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
 
    [SVProgressHUD show];
    NSDictionary *dic = @{@"userid":userID};
    [EnterpriseWalletService requestWallet:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
           
            self.labelMoneyRecharge.text = [data[@"taskPrice0"] stringByAppendingString:@"元"];
            self.labelMoneyCost.text = [data[@"taskPrice1"] stringByAppendingString:@"元"];
            self.labelMoneyResidue.text = [data[@"taskPrice2"] stringByAppendingString:@"元"];
           
            
        }
    }];

  
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
