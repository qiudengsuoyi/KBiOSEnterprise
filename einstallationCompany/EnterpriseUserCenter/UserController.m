//
//  PersonCenterViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/12.
//

#import "UserController.h"
#import "EnterpriseLoginController.h"
#import "EnterpriseRegisterController.h"
#import "EnterprisePasswordController.h"
#import "ModifyController.h"
#import "CustomerViewController.h"
#import "ProtocolViewController.h"
#import "EnterpriseTrainingController.h"
#import "EnterpriseWalletController.h"
#import "SVProgressHUD.h"
#import "UserService.h"
#import "APIConst.h"
#import "MASConstraintMaker.h"
#import "Masonry.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "FeedbackViewController.h"
#import <YYKit/YYKit.h>
#import "WXApi.h"
#import "WXApiManager.h"
#import "PayService.h"


@interface UserController()<UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelNumber;
@property (weak, nonatomic) IBOutlet UIButton *btExit;
@property (weak, nonatomic) IBOutlet UIButton *btModify;
@property (weak, nonatomic) IBOutlet UIView *vCall;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;

@property (weak, nonatomic) IBOutlet UIView *vProtocol;
@property (weak, nonatomic) IBOutlet UIView *vWallet;
@property (weak, nonatomic) IBOutlet UILabel *labelVersion;
@property (weak, nonatomic) IBOutlet UIView *vFeedback;
@property (weak, nonatomic) IBOutlet UIView *vWX;
@property NSString * wxLoginState;
@property (weak, nonatomic) IBOutlet UILabel *labelSignWX;

@end

@implementation UserController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.wxLoginState = @"0";
    NSString * strUserID = [[NSUserDefaults standardUserDefaults] valueForKey:@"userID"];
    
    // 1. 创建一个点击事件，点击时触发labelClick方法
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(modifyPassword)];
    // 2. 将点击事件添加到label上
    [self.vPassword addGestureRecognizer:labelTapGestureRecognizer];
    self.vPassword.userInteractionEnabled = YES;
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(call)];
    // 2. 将点击事件添加到label上
    [self.vCall addGestureRecognizer:labelTapGestureRecognizer];
    self.vCall.userInteractionEnabled = YES;
    
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(userProtocol)];
    // 2. 将点击事件添加到label上
    [self.vProtocol addGestureRecognizer:labelTapGestureRecognizer];
    self.vProtocol.userInteractionEnabled = YES;

    
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(wallet)];
    // 2. 将点击事件添加到label上
    [self.vWallet addGestureRecognizer:labelTapGestureRecognizer];
    self.vWallet.userInteractionEnabled = YES;
    
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(feedback)];
    // 2. 将点击事件添加到label上
    [self.vFeedback addGestureRecognizer:labelTapGestureRecognizer];
    self.vFeedback.userInteractionEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendAuthResp:) name:@"sendAuthResp" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
   
    NSString * strUserID = [[NSUserDefaults standardUserDefaults] valueForKey:@"userID"];
    if(strUserID.length>0){
        [self requstPerson];}
    if(strUserID.length ){
        self.labelName.hidden = NO;
        self.labelNumber.hidden = NO;
        self.btExit.hidden = NO;
        self.btModify.hidden = NO;
        self.vLR.hidden = YES;
        self.ivPhoto.image = [UIImage imageNamed:@"enterprise_face.png"];
       
       
    }else{
        self.labelName.hidden = YES;
        self.labelNumber.hidden = YES;
        self.btExit.hidden = YES;
        self.btModify.hidden = YES;
        self.vLR.hidden = NO;
        self.ivPhoto.image = [UIImage imageNamed:@"enterprise_circle_photo.png"];
      
        
    }
    
    self.labelVersion.text = [NSString stringWithFormat:@"版本：v%@ www.einstall.cn 版权所有",[self version]];
    [self requstCheckWX];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendAuthResp" object:self];
}


//实现监听方法
-(void) sendAuthResp:(NSNotification *)notification
{
    NSString * state = notification.userInfo[@"state"];
    NSString * code = notification.userInfo[@"code"];
    if(state.intValue == 2){
        //请求获取微信openID
        [self requstOpenID:code];
    }
}

-(void)requstOpenID:(NSString*) code{

    [SVProgressHUD show];
    NSDictionary *dic = @{
        @"appid":WE_CHAT_APPID,
        @"code":code,
        @"secret":WECHAT_SECRET,
        @"grant_type":@"authorization_code"
    };
    [PayService requestWXOpenID:dic url:@"https://api.weixin.qq.com" andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            NSString * openID = data;
            [self requstBindWX:openID];
        }
    }];

  
}

-(NSString *)version

{

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    NSString *app_Version       = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    return app_Version;

}


- (IBAction)actionLogin:(id)sender {
    EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)actionRegister:(id)sender {
    EnterpriseRegisterController *vc = [[EnterpriseRegisterController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)modifyPassword {
    EnterprisePasswordController *vc = [[EnterprisePasswordController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)call {
    CustomerViewController *vc = [[CustomerViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)userProtocol {
    ProtocolViewController *vc = [[ProtocolViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.url = ENTERPRISE_CONST_PROTOCOL_URL;
    vc.titleName = @"用户协议";
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)training {
    EnterpriseTrainingController *vc = [[EnterpriseTrainingController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)wallet {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    if(userID ==nil){
        [SVProgressHUD showSuccessWithStatus:@"请先登陆！"];
    }else{
        EnterpriseWalletController *vc = [[EnterpriseWalletController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];}
//    [SVProgressHUD showSuccessWithStatus:@"功能未开放，敬请期待！"];
    
}

- (void)feedback {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    if(userID ==nil){
        [SVProgressHUD showSuccessWithStatus:@"请先登陆！"];
    }else{
        FeedbackViewController *vc = [[FeedbackViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];}
//    [SVProgressHUD showSuccessWithStatus:@"功能未开放，敬请期待！"];
    
}

- (void)bindWX {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    if(userID ==nil){
        [SVProgressHUD showSuccessWithStatus:@"请先登陆！"];
    }else{
        SendAuthReq* req =[[SendAuthReq alloc]init];
        req.scope = @"snsapi_userinfo"; // 只能填 snsapi_userinfo
        req.state = @"2";
            //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req completion:^(BOOL success) {
            if(success){
                   
            }}];
    }

    
}

- (void)haveBindWX {
  

    [SVProgressHUD showSuccessWithStatus:@"微信已绑定！"];
}



- (IBAction)actionExit:(id)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [CloudPushSDK removeAlias:[NSString stringWithFormat:@"enterprise%@",[user valueForKey:@"userID"]] withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"removeAlias success");
        } else {
            NSLog(@"removeAlias failed, error: %@", res.error);
        }
    }];
    [user setValue:@"" forKey:@"userID"];
    EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}



- (IBAction)modifyPerson:(id)sender {
    ModifyController *vc = [[ModifyController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)requstPerson{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];

    if(userID.length>0){
    [SVProgressHUD show];
    NSDictionary *dic = @{@"userid":userID};
    [UserService requestPerson:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            self.returnModel = data;
            self.labelName.text = self.returnModel.username;
            self.labelNumber.text = self.returnModel.companyname;
           
            
            
        }
    }];}

  
}

-(void)requstCheckWX{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];

    if(userID.length>0){
    NSDictionary *dic = @{@"userid":userID};
    [UserService requestCheckWX:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            self.wxLoginState = data[@"wxLoginState"];
            if(self.wxLoginState.intValue == 1){
                UITapGestureRecognizer* labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                                     initWithTarget:self action:@selector(haveBindWX)];
                // 2. 将点击事件添加到label上
                [self.vWX addGestureRecognizer:labelTapGestureRecognizer];
                self.vWX.userInteractionEnabled = YES;
                self.labelSignWX.text = @"(已绑定)";
                self.labelSignWX.textColor = [UIColor colorWithHexString:@"#5586DE"];
            }else{
                self.labelSignWX.text = @"(未绑定)";
                UITapGestureRecognizer* labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                                     initWithTarget:self action:@selector(bindWX)];
                // 2. 将点击事件添加到label上
                [self.vWX addGestureRecognizer:labelTapGestureRecognizer];
                self.vWX.userInteractionEnabled = YES;
            }
            
            
        }
    }];}

  
}

-(void)requstBindWX:(NSString*)openID{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];

    if(userID.length>0){
    NSDictionary *dic = @{
        @"userid":userID,
        @"openid":openID,
    };
    [UserService requestBindWX:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            UITapGestureRecognizer* labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                                 initWithTarget:self action:@selector(haveBindWX)];
            // 2. 将点击事件添加到label上
            [self.vWX addGestureRecognizer:labelTapGestureRecognizer];
            self.vWX.userInteractionEnabled = YES;
            self.labelSignWX.text = @"(已绑定)";
            self.labelSignWX.textColor = [UIColor colorWithHexString:@"#5586DE"];
        }
    }];}

  
}

@end
