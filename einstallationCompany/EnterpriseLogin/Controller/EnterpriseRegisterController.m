//
//  RegisterViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/5.
//

#import "EnterpriseRegisterController.h"
#import "EnterpriseLoginController.h"
#import "PictureCodeView.h"
#import "SVProgressHUD.h"
#import "ProtocolViewController.h"
#import "EnterpriseLoginService.h"
#import "APIConst.h"
#import <CommonCrypto/CommonDigest.h>



@interface EnterpriseRegisterController ()
@property (weak, nonatomic) IBOutlet UITextField *textAccount;
@property (weak, nonatomic) IBOutlet UITextField *textPhone;
@property (weak, nonatomic) IBOutlet UITextField *vCode;
@property (weak, nonatomic) IBOutlet PictureCodeView *vChildCode;

@property (weak, nonatomic) IBOutlet UIButton *btGetCode;
@property (weak, nonatomic) IBOutlet UITextField *textPictureCode;
@property (weak, nonatomic) IBOutlet UILabel *labelXieYi1;

@property (weak, nonatomic) IBOutlet UITextField *textPassword;

@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UIImageView *ivXieYi;
@property bool xieYiState;
@property (weak, nonatomic) IBOutlet UILabel *labelXieYi;
@property (weak, nonatomic) IBOutlet UITextField *labelName;

@end

@implementation EnterpriseRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = @"用户注册";
    self.xieYiState = NO;
    // 1. 创建一个点击事件，点击时触发labelClick方法
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(labelClick)];
    // 2. 将点击事件添加到label上
    [self.ivXieYi addGestureRecognizer:labelTapGestureRecognizer];
    self.ivXieYi.userInteractionEnabled = YES;
    
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(labelClick1)];
    // 2. 将点击事件添加到label上
    [self.labelXieYi1 addGestureRecognizer:labelTapGestureRecognizer];
    self.labelXieYi1.userInteractionEnabled = YES;
    
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(labelClick)];
    // 2. 将点击事件添加到label上
    [self.labelXieYi addGestureRecognizer:labelTapGestureRecognizer];
    self.labelXieYi.userInteractionEnabled = YES;
}

- (void)labelClick {
    if(!self.xieYiState){
        self.ivXieYi.image = [UIImage imageNamed:@"item_select.png"];
        self.xieYiState = YES;
    }else{
        self.ivXieYi.image = [UIImage imageNamed:@"item_select_u.png"];
        self.xieYiState = NO;
    }
    
}

- (void)labelClick1{
    [self labelClick];
    ProtocolViewController *vc = [[ProtocolViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.url = ENTERPRISE_CONST_PROTOCOL_URL;
    vc.titleName = @"用户协议";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (IBAction)actionRegister:(id)sender {
    
    
    NSString * strAccount = self.textAccount.text;
    NSString * strPhone = self.textPhone.text;
    NSString * strPassword = self.textPassword.text;
    NSString * strUserName = self.textUserName.text;
    NSString * strPictureCode = self.vChildCode.CodeStr.lowercaseString;
    NSString * strPictureTextCode = self.textPictureCode.text.lowercaseString;
    NSString * strName = self.labelName.text;
   

    strUserName = [self utf82gbk:strUserName];
    
    if(strAccount.length<6){
        [SVProgressHUD showErrorWithStatus:@"账号不能小于6位！"];
        return;
    }
    

    
    if(strPassword.length<6){
        [SVProgressHUD showErrorWithStatus:@"密码不能小于6位！"];
        return;
    }
    
    if(strUserName.length<1){
        [SVProgressHUD showErrorWithStatus:@"请输入企业名称！"];
        return;
    }
    if(strPhone.length!=11){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的电话！"];
        return;
    }
    
    if(strName.length<1){
        [SVProgressHUD showInfoWithStatus:@"请输入联系人名称"];
        return;
    }
    
    if(![strPictureCode isEqualToString:strPictureTextCode]){
        [SVProgressHUD showErrorWithStatus:@"图形验证码不正确！"];
        return;
    }
    if(self.vCode.text.length<1){
        [SVProgressHUD showErrorWithStatus:@"请输入短信验证码！"];
        return;
    }
    
    if(!self.xieYiState){
        [SVProgressHUD showInfoWithStatus:@"请勾选协议"];
        return;
    }
    
    
    [SVProgressHUD show];
    NSDictionary *dic = @{@"username":self.textAccount.text,
                          @"password":[self getmd5WithString:self.textPassword.text],
                          @"companyname":strUserName,
                          @"phoneNo":self.textPhone.text,
                          @"EnterpriseUserName":[self utf82gbk:strName],
                          @"code":self.vCode.text
                          
    };
    [EnterpriseLoginService requestRegister:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            [SVProgressHUD showInfoWithStatus:data];
    
        }
    }];
    
    
}

- (IBAction)actionLogin:(id)sender {
    EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionGetCode:(id)sender {
    NSString * strAccount = self.textAccount.text;
    NSString * strPhone = self.textPhone.text;
    NSString * strPassword = self.textPassword.text;
    NSString * strUserName = self.textUserName.text;
    NSString * strPictureCode = self.vChildCode.CodeStr;
    NSString * strPictureTextCode = self.textPictureCode.text;
    
    if(strAccount.length<6){
        [SVProgressHUD showErrorWithStatus:@"账号不能小于6位！"];
        return;
    }
    
    if(strPassword.length<6){
        [SVProgressHUD showErrorWithStatus:@"密码不能小于6位！"];
        return;
    }
    
    if(strUserName.length<1){
        [SVProgressHUD showErrorWithStatus:@"请输入企业名称！"];
        return;
    }
    
    if(strPhone.length!=11){
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
