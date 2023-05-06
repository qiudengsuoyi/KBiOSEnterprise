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

@end

@implementation UserController



- (void)viewDidLoad {
    [super viewDidLoad];
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
//    WalletViewController *vc = [[WalletViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    [SVProgressHUD showSuccessWithStatus:@"功能未开放，敬请期待！"];
    
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

@end
