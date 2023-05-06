//
//  PayMessageViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/8/25.
//

#import "PayMessageViewController.h"
#import "PayService.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "PayViewController.h"

@interface PayMessageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *bt01;
@property (weak, nonatomic) IBOutlet UIButton *bt02;
@property (weak, nonatomic) IBOutlet UIButton *bt03;

@end

@implementation PayMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = @"短信通知";
    [self requstOrderMessageInfo];
}

- (IBAction)action01:(id)sender {
    [self requstOrderSubmit:@"1"];
}

- (IBAction)action02:(id)sender {
    [self requstOrderSubmit:@"2"];
}

- (IBAction)action03:(id)sender {
    [self requstOrderSubmit:@"3"];
}

-(void)requstOrderMessageInfo{
  
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
    
    [SVProgressHUD show];
    NSDictionary *dic = @{@"userid":userID};
    [PayService requestMessageOrder:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            NSMutableArray *arr = data;
            if(arr.count>1){
                [self.bt01 setTitle:[arr objectAtIndex:0] forState:UIControlStateNormal];
                [self.bt02 setTitle:[arr objectAtIndex:1] forState:UIControlStateNormal];
                [self.bt03 setTitle:[arr objectAtIndex:2] forState:UIControlStateNormal];
            }
            
        }
    }];
    
    
}

-(void)requstOrderSubmit:(NSString*) payType{
    
  
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
    
    [SVProgressHUD show];
    NSDictionary *dic = @{@"userid":userID,
                          @"recordID":self.recordID,
                          @"smsType":payType
    };
    [PayService requestMessage:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            PayViewController *vc = [PayViewController alloc];
            vc.recordID = self.recordID;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }];
    
    
}
@end
