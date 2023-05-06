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

@interface EnterpriseLoginController ()
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
    // Do any additional setup after loading the view from its nib.
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
                [self.navigationController popToRootViewControllerAnimated:YES];
          
           

        }
    }];

  
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
