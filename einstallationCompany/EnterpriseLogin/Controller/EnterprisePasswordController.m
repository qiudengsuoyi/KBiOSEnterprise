//
//  PasswordViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/5.
//

#import "EnterprisePasswordController.h"
#import "SVProgressHUD.h"
#import "EnterpriseLoginService.h"
#import "APIConst.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface EnterprisePasswordController ()
@property (weak, nonatomic) IBOutlet UITextField *label01;
@property (weak, nonatomic) IBOutlet UITextField *label02;
@property (weak, nonatomic) IBOutlet UITextField *label03;
@property (weak, nonatomic) IBOutlet UIButton *btModify;
@property (weak, nonatomic) IBOutlet UITextField *label04;
@property (weak, nonatomic) IBOutlet UITextField *label05;
@property (weak, nonatomic) IBOutlet UITextField *label06;
@property (weak, nonatomic) IBOutlet UITextField *label07;
@property (weak, nonatomic) IBOutlet UIButton *btCode;
@property (weak, nonatomic) IBOutlet UIButton *btModify02;
@property (weak, nonatomic) IBOutlet UITextField *labelLoginName;

@end

@implementation EnterprisePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = @"修改密码";
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_USERID];
    if(userID.length>0){
        [self initInfo:userID];
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)actionModify01:(id)sender {
    NSString * oldPassword = self.label01.text;
    NSString * newPassword = self.label02.text;
    NSString * newAgainPassword = self.label03.text;
    
    if(oldPassword.length<1){
        [SVProgressHUD showErrorWithStatus:@"原密码不能为空！"];
        return;
    
    }
    if(newPassword.length<1){
        [SVProgressHUD showErrorWithStatus:@"新密码不能为空！"];
        return;
        
    }
    
    if(![newPassword isEqualToString:newAgainPassword]){
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不相同！"];
        return;
    }
    
    [SVProgressHUD show];
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_USERID];
    NSDictionary *dic = @{@"userid":userID,
                          @"type":@"0",
                          @"newpassword":[self getmd5WithString:newPassword],
                          @"oldpassword":[self getmd5WithString:oldPassword],
                          @"phoneNo":@"",
                          @"code":@""
                          };
    [EnterpriseLoginService requestModifyPassword:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            
          
                [SVProgressHUD showSuccessWithStatus:data];
            

        }
    }];

}

-(void) initInfo:(NSString*) userID{
   
    NSDictionary *dic = @{@"userid":userID,};
    [EnterpriseLoginService requestPasswordInfo:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            
            self.labelLoginName.text = data[@"loginname"];
            self.label04.text = data[@"phoneNo"];

        }
    }];
}
- (IBAction)actionModify02:(id)sender {
    NSString * phone = self.label04.text;
    NSString * strCode = self.label05.text;
    NSString * newPassword = self.label06.text;
    NSString * newAgainPassword = self.label07.text;
    NSString * loginName = self.labelLoginName.text;
    if(loginName.length<1){
        [SVProgressHUD showErrorWithStatus:@"登录名不能为空！"];
        return;
    
    }
    if(phone.length!=11){
        [SVProgressHUD showErrorWithStatus:@"电话号码输入错误！"];
        return;
    
    }
    if(strCode.length<1){
        [SVProgressHUD showErrorWithStatus:@"验证码不能为空！"];
        return;
        
    }
    if(newPassword.length<1){
        [SVProgressHUD showErrorWithStatus:@"新密码不能为空！"];
        return;
        
    }
    
    if(![newPassword isEqualToString:newAgainPassword]){
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不相同！"];
        return;
    }
    
    [SVProgressHUD show];
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_USERID];
    NSDictionary *dic = @{@"userid":userID,
                          @"type":@"1",
                          @"loginname":loginName,
                          @"newpassword":[self getmd5WithString:newPassword],
                          @"oldpassword":@"",
                          @"phoneNo":phone,
                          @"code":strCode
                          };
    [EnterpriseLoginService requestModifyPassword:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            
          
                [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
            

        }
    }];
}
- (IBAction)actionCode:(id)sender {
    NSString * phone = self.label04.text;
    if(phone.length!=11){
        [SVProgressHUD showErrorWithStatus:@"电话号码输入错误！"];
        return;
    }
    [SVProgressHUD show];
    NSDictionary *dic = @{@"phoneNo":phone};
    [EnterpriseLoginService requestGetCode:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            [self openCountdown];
        }
    }];
    
}

//倒计时
-(void)openCountdown{
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.btCode setTitle:@"重新发送" forState:UIControlStateNormal];
//                self.codeButton.backgroundColor = [UIColor colorWithHexString:@"#1D97F8"];
                self.btCode.userInteractionEnabled = YES;
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.btCode setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
//                self.codeButton.backgroundColor = [UIColor lightGrayColor];
                self.btCode.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
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
