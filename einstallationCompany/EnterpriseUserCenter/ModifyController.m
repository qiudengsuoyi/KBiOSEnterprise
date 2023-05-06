//
//  EditViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/10.
//

#import "ModifyController.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "UserService.h"
#import "UploadViewController.h"
#import "BRAddressPickerView.h"
#import "SVProgressHUD.h"
#import "EnterpriseLoginService.h"


@interface ModifyController ()
@property (weak, nonatomic) IBOutlet UITextField *textAccount;
@property (weak, nonatomic) IBOutlet UITextField *textPhone;
@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UITextField *textIDCard;
@property (weak, nonatomic) IBOutlet UITextField *textCode;

@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UIButton *btGetCode;

@property NSString *strCode;

@property (nonatomic, copy) NSArray <NSNumber *> *addressSelectIndexs;
@end

@implementation ModifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = @"编辑资料";
    [self requstEdit];

}



-(void)requstEdit{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
    [SVProgressHUD show];
    NSDictionary *dic = @{@"userid":userID};
    [UserService requestPerson:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            self.model = data;
            self.textIDCard.text = self.model.BusinessLicense;
            self.textUserName.text = self.model.username;
            self.cityTF.text = self.model.companyname;
            self.textAccount.text = self.model.loginname;
        
           
        }
    }];

  
}
- (IBAction)btUpIDCard:(id)sender {
    
    UploadViewController *vc = [[UploadViewController alloc]init];
    vc.url = self.model.BusinessLicenseImg;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionSubmit:(id)sender {
    self.model.phone = self.textPhone.text;
    self.model.username = self.textUserName.text;
    self.model.BusinessLicense = self.textIDCard.text;
    self.model.loginname = self.textAccount.text;
    self.strCode = self.textCode.text;
        
        if(self.model.loginname.length<1){
            [SVProgressHUD showErrorWithStatus:@"请输入登录名！"];
            return;
        }
    if(self.model.phone.length!=11){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的电话号码！"];
        return;
    }
    if(self.model.username.length<1){
        [SVProgressHUD showErrorWithStatus:@"请输入您的真实名字！"];
        return;
    }
    
    if(self.model.BusinessLicense.length<10){
        [SVProgressHUD showErrorWithStatus:@"请输入企业营业执照！"];
        return;
    }
    

    

    
    if(self.strCode.length<1){
        [SVProgressHUD showErrorWithStatus:@"请输入验证码！"];
        return;
    }
    
    
    [SVProgressHUD show];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    NSDictionary *dic = @{@"userid":userID,
                          @"phone":self.model.phone,
                          @"username":[self utf82gbk:self.model.username],
                          @"loginname":self.model.loginname,
                          @"companyname":[self utf82gbk:self.model.companyname],
                          @"BusinessLicense":[self utf82gbk:self.model.IDNumber],
                          @"code":self.strCode
    };
    [UserService requestEditMidify:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            [SVProgressHUD showSuccessWithStatus:@"信息修改成功！"];
        }
    }];
}

- (IBAction)actionGetCode:(id)sender {
    self.model.phone = self.textPhone.text;
   
    
    if(self.model.phone.length!=11){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的电话号码！"];
        return;
    }
    
    
    [SVProgressHUD show];
    NSDictionary *dic = @{@"phoneNo":self.textPhone.text};
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
                [self.btGetCode setTitle:@"重新发送" forState:UIControlStateNormal];
//                self.codeButton.backgroundColor = [UIColor colorWithHexString:@"#1D97F8"];
                self.btGetCode.userInteractionEnabled = YES;
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.btGetCode setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
//                self.codeButton.backgroundColor = [UIColor lightGrayColor];
                self.btGetCode.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}


@end
