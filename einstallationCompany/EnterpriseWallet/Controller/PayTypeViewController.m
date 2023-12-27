//
//  PayTypeViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/16.
//

#import "PayTypeViewController.h"
#import "BillViewController.h"
#import "ResultController.h"
#import "EnterpriseWalletController.h"
#import "CustomerViewController.h"
#import "ProtocolViewController.h"
#import "APIConst.h"
#import "BRAddressPickerView.h"
#import "SVProgressHUD.h"
#import "BRStringPickerView.h"
#import "EnterpriseWalletService.h"
#import "BRDatePickerView.h"
#import "GrabListViewController.h"
#import <YYKit/YYKit.h>
#import "EnterpriseCommonService.h"
#import "PayViewController.h"
#import "PayMessageViewController.h"
#import "EnterpriseLoginController.h"
#import "ReleaseOrderDetailViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"
#import "WSPlaceholderTextView.h"
#import "ResultOrderViewController.h"
#import "PayService.h"
#import "PayOrderEditEntity.h"
#import "GrabUploadViewController.h"

@interface PayTypeViewController ()<UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate>
@property bool xieYiState;
@property (weak, nonatomic) IBOutlet WSPlaceholderTextView * labelDetail;
@property (weak, nonatomic) IBOutlet UITextField *labelName;
@property (weak, nonatomic) IBOutlet UITextField *labelPhone;
@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UITextField *installType;
@property (weak, nonatomic) IBOutlet UITextField *labelAddress;
@property (weak, nonatomic) IBOutlet UITextField *labelMoney;
@property (weak, nonatomic) IBOutlet UITextField *labelInstallDate;
@property (weak, nonatomic) IBOutlet UITextField *labelLogistics;

@property (weak, nonatomic) IBOutlet UILabel *labelHint;


@property NSString * province;
@property NSString * city;
@property NSString * Region;
@property NSString * strInstallType;
@property NSString * strInstallDate;
@property NSString * strMoney;
@property NSMutableArray * arrInstallType;
@property NSMutableArray * arrTool;
@property NSMutableArray * arrInstall;
@property NSMutableArray * arrTime;
@property NSMutableArray * arrMaterials;
@property NSMutableArray * arrLogistics;
@property (nonatomic, copy) NSArray <NSNumber *> *addressSelectIndexs;
@property NSMutableArray < BRProvinceModel *>* arrAddress;

@property NSInteger uploadCount;
@property NSInteger uploadSuccessCount;
@property NSInteger uploadFailCount;
@property NSInteger uploadHandleCount;
@property NSString *annexNo;
@end

@implementation PayTypeViewController
- (IBAction)actionUpload:(id)sender {
    GrabUploadViewController *vc = [[GrabUploadViewController alloc]init];
    vc.annexNo = _annexNo;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    if(self.annexNo == nil){
        self.annexNo = [self currentTimeStr];
    }
    self.labelDetail.placeholder = @"请填写您需要的服务";
    self.labelHint.text = @"可以尝试如下填写：\n店铺有三张海报需要安装；\n店铺有三个灯箱需要安装；\n店铺的门头需要安装；";
    self.labelDetail.delegate = self;
    self.uploadCount = 0;
    self.navigationItem.title = @"选择发布任务的方式";
    
    self.arrAddress = [NSMutableArray arrayWithCapacity:0];
    self.province = @"";
    self.city = @"";
    self.Region = @"";
 
    self.labelMoney.delegate = self;
    self.xieYiState = NO;
    
    self.labelName.layer.borderWidth = 0.5;
    self.labelName.layer.borderColor = [UIColor grayColor].CGColor;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, 20)];
    self.labelName.leftView = paddingView;
    self.labelName.leftViewMode = UITextFieldViewModeAlways;
    
    self.labelPhone.layer.borderWidth = 0.5;
    self.labelPhone.layer.borderColor = [UIColor grayColor].CGColor;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, 20)];
    self.labelPhone.leftView = paddingView;
    self.labelPhone.leftViewMode = UITextFieldViewModeAlways;
    
    self.cityTF.layer.borderWidth = 0.5;
    self.cityTF.layer.borderColor = [UIColor grayColor].CGColor;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, 20)];
    self.cityTF.leftView = paddingView;
    self.cityTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.installType.layer.borderWidth = 0.5;
    self.installType.layer.borderColor = [UIColor grayColor].CGColor;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, 20)];
    self.installType.leftView = paddingView;
    self.installType.leftViewMode = UITextFieldViewModeAlways;
    
    
    self.labelAddress.layer.borderWidth = 0.5;
    self.labelAddress.layer.borderColor = [UIColor grayColor].CGColor;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, 20)];
    self.labelAddress.leftView = paddingView;
    self.labelAddress.leftViewMode = UITextFieldViewModeAlways;
    
    self.labelMoney.layer.borderWidth = 0.5;
    self.labelMoney.layer.borderColor = [UIColor grayColor].CGColor;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, 20)];
    self.labelMoney.leftView = paddingView;
    self.labelMoney.leftViewMode = UITextFieldViewModeAlways;
    
    self.labelInstallDate.layer.borderWidth = 0.5;
    self.labelInstallDate.layer.borderColor = [UIColor grayColor].CGColor;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, 20)];
    self.labelInstallDate.leftView = paddingView;
    self.labelInstallDate.leftViewMode = UITextFieldViewModeAlways;
    
    self.labelLogistics.layer.borderWidth = 0.5;
    self.labelLogistics.layer.borderColor = [UIColor grayColor].CGColor;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, 20)];
    self.labelLogistics.leftView = paddingView;
    self.labelLogistics.leftViewMode = UITextFieldViewModeAlways;
    
    self.labelDetail.layer.borderWidth = 0.5;
    self.labelDetail.layer.borderColor = [UIColor grayColor].CGColor;
    //    self.labelDetail.backgroundColor = [UIColor whiteColor];
    
    
    
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(labelClick)];
    // 2. 将点击事件添加到label上
    [self.labelXieYi addGestureRecognizer:labelTapGestureRecognizer];
    self.labelXieYi.userInteractionEnabled = YES;
    
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self action:@selector(labelClick)];
    // 2. 将点击事件添加到label上
    [self.ivXieYi addGestureRecognizer:labelTapGestureRecognizer];
    self.ivXieYi.userInteractionEnabled = YES;
    
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self action:@selector(labelClick1)];
    // 2. 将点击事件添加到label上
    [self.labelXieYi02 addGestureRecognizer:labelTapGestureRecognizer];
    self.labelXieYi02.userInteractionEnabled = YES;
    
    
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCity)];
    // 2. 将点击事件添加到label上
    [self.cityTF addGestureRecognizer:labelTapGestureRecognizer];
    
    self.cityTF.userInteractionEnabled = YES;
    
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectInstallType)];
    // 2. 将点击事件添加到label上
    [self.installType addGestureRecognizer:labelTapGestureRecognizer];
    
    self.installType.userInteractionEnabled = YES;
    
    
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLogistics)];
    // 2. 将点击事件添加到label上
    [self.labelLogistics addGestureRecognizer:labelTapGestureRecognizer];
    
    self.labelLogistics.userInteractionEnabled = YES;
    
    
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectInstallDate)];
    // 2. 将点击事件添加到label上
    [self.labelInstallDate addGestureRecognizer:labelTapGestureRecognizer];
    
    self.labelInstallDate.userInteractionEnabled = YES;
    
    
    [self requstSelectConfig];
    [self requstReleasePerson];
    [self requstAddress];
    // 在某个对象的初始化或合适的地方添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:NOTIFICATION_TASK_NAME
                                               object:nil];
    
}

- (void)handleNotification:(NSNotification *)notification {
    // 在这里执行需要在收到通知时执行的操作
    NSString * recordID = notification.userInfo[@"recordID"];
    [self requstOrderInfo:recordID];
}




- (IBAction)action03:(id)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    if(self.annexNo == nil || self.annexNo.length == 0){
        self.annexNo = [self currentTimeStr];
    }
    
    if(userID.length>0){
        NSString *strName = self.labelName.text;
        NSString *strPhone = self.labelPhone.text;
        self.strInstallType = self.installType.text;
        if(self.strInstallType.length<1){
            [SVProgressHUD showErrorWithStatus:@"请选择安装类型！"];
            return;
        }
        
        if(self.labelInstallDate.text.length<1){
            [SVProgressHUD showErrorWithStatus:@"请选择安装时间！"];
            return;
        }
        if(strName.length<1){
            [SVProgressHUD showErrorWithStatus:@"请输入您的名字！"];
            return;
        }
        
        if(strPhone.length<1){
            [SVProgressHUD showErrorWithStatus:@"请输入您的电话！"];
            return;
        }
        
        
        if(self.city.length<1){
            [SVProgressHUD showErrorWithStatus:@"请先选择城市！"];
            return;
        }
        
        
        
        if(self.labelAddress.text.length<1){
            [SVProgressHUD showErrorWithStatus:@"请输入安装详细地址！"];
            return;
        }
        if(self.labelLogistics.text.length<1){
            [SVProgressHUD showErrorWithStatus:@"请选择收货方式！"];
            return;
        }
        
        if(self.labelDetail.text.length<1 ){
            [SVProgressHUD showErrorWithStatus:@"请输入安装需求！"];
            return;
        }
        
        
        
        if(!self.xieYiState){
            [SVProgressHUD showErrorWithStatus:@"请同意协议！"];
            return;
        }
//        [self.btSumbit02 setEnabled:NO];
//        [self.btSubmit03 setEnabled:NO];
        self.uploadFailCount = 0;
        [self requstOrderReleaseSubmit:@"4"];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录！"];
        EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)action01:(id)sender {
    if(self.annexNo == nil || self.annexNo.length == 0){
        self.annexNo = [self currentTimeStr];
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
    
    if(userID.length>0){
        NSString *strPhone = self.labelPhone.text;
        if(strPhone.length<1){
            [SVProgressHUD showErrorWithStatus:@"请输入您的电话！"];
            return;
        }
        [self requstOrderReleaseSubmit:@"0"];
    }else{
        [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录！"];
        EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (IBAction)action02:(id)sender {
    if(self.annexNo == nil || self.annexNo.length == 0){
        self.annexNo = [self currentTimeStr];
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
    
    if(userID.length>0){
        NSString *strName = self.labelName.text;
        NSString *strPhone = self.labelPhone.text;
        self.strInstallType = self.installType.text;
        if(self.strInstallType.length<1){
            [SVProgressHUD showErrorWithStatus:@"请选择安装类型！"];
            return;
        }
        
        if(self.labelInstallDate.text.length<1){
            [SVProgressHUD showErrorWithStatus:@"请选择安装时间！"];
            return;
        }
        if(strName.length<1){
            [SVProgressHUD showErrorWithStatus:@"请输入您的名字！"];
            return;
        }
        
        if(strPhone.length<1){
            [SVProgressHUD showErrorWithStatus:@"请输入您的电话！"];
            return;
        }
        
        
        if(self.city.length<1){
            [SVProgressHUD showErrorWithStatus:@"请先选择城市！"];
            return;
        }
        
        
        
        if(self.labelAddress.text.length<1){
            [SVProgressHUD showErrorWithStatus:@"请输入安装详细地址！"];
            return;
        }
        if(self.labelLogistics.text.length<1){
            [SVProgressHUD showErrorWithStatus:@"请选择收货方式！"];
            return;
        }
        
        if(self.labelDetail.text.length<1 ){
            [SVProgressHUD showErrorWithStatus:@"请输入安装需求！"];
            return;
        }
        
        if(self.labelMoney.text.length<1){
            [SVProgressHUD showErrorWithStatus:@"请输入安装价格（元）！"];
            return;
        }
        
        
        
        if(!self.xieYiState){
            [SVProgressHUD showErrorWithStatus:@"请同意协议！"];
            return;
        }
//        [self.btSumbit02 setEnabled:NO];
//        [self.btSubmit03 setEnabled:NO];
        self.uploadFailCount = 0;
        [self requstOrderReleaseSubmit:@"3"];
    }else{
        
        [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录！"];
        EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)labelClick{
    if(!self.xieYiState){
        self.ivXieYi.image = [UIImage imageNamed:@"item_select.png"];
        self.xieYiState = YES;
    }else{
        self.ivXieYi.image = [UIImage imageNamed:@"item_select_u.png"];
        self.xieYiState = NO;
    }
}

-(void)labelClick1{
    if(!self.xieYiState){
        self.ivXieYi.image = [UIImage imageNamed:@"item_select.png"];
        self.xieYiState = YES;
    }else{
        self.ivXieYi.image = [UIImage imageNamed:@"item_select_u.png"];
        self.xieYiState = NO;
    }
    
    ProtocolViewController *vc = [[ProtocolViewController alloc]init];
    vc.url = ENTERPRISE_CONST_PROTOCOL_01_URL;
    vc.titleName = @"呼叫协议";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)requstOrderInfo:(NSString *) recordID{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    [SVProgressHUD show];
    NSDictionary *dic = @{@"recordID":recordID};
    [PayService requestOrderEditInfo:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        PayOrderEditEntity * model = data;
        self.installType.text = model.installtype;
        self.labelInstallDate.text = model.InstallDate;
        self.labelName.text = model.name;
        self.labelPhone.text = model.phone;
        
        self.labelAddress.text = model.ShopAddress;
        self.labelLogistics.text = model.receivingMethod;
        self.labelMoney.text = model.InstallPrice;
        self.labelDetail.text = model.photographyRequirements;
        self.cityTF.text = [NSString stringWithFormat:@"%@ %@ %@",model.province,model.city,model.Region];
        self.province = model.province;
        self.city = model.city;
        self.Region = model.Region;
        self.strInstallDate = model.InstallDate;
        self.strInstallType = model.installtype;
    }];
}

-(void)requstOrderReleaseSubmit:(NSString*) commitType{
    
    self.strInstallType = self.installType.text;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
    
    if(userID.length>0){
        
        [SVProgressHUD show];
        NSDictionary *dic = @{
            @"AnnexNo":self.annexNo,
            @"userid":userID,
            @"Fasttype":commitType,
            @"name":[self utf82gbk:self.labelName.text],
            @"phone":self.labelPhone.text,
            @"installtype":[self utf82gbk:self.strInstallType],
            @"province":[self utf82gbk:self.province],
            @"city":[self utf82gbk:self.city],
            @"Region":[self utf82gbk:self.Region],
            @"ShopAddress":[self utf82gbk:self.labelAddress.text],
            @"InstallPrice":self.labelMoney.text,
            @"InstallDate":self.labelInstallDate.text,
            @"receivingMethod":[self utf82gbk:self.labelLogistics.text],
            @"photographyRequirements":[self utf82gbk:self.labelDetail.text]
        };
        [EnterpriseWalletService requestReleaseSubmit:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
//            self.btSubmit03.enabled = YES;
//            self.btSumbit02.enabled = YES;
            if (data) {
                
            self.annexNo = [self currentTimeStr];
                if([commitType intValue] == 1||[commitType intValue] == 2||[commitType intValue] == 3||[commitType intValue] == 4){
                    
                    self.installType.text = @"";
                    self.labelInstallDate.text = @"";
                    
                    
                    self.labelAddress.text = @"";
                    self.labelLogistics.text =@"";
                    self.labelMoney.text =@"";
                    self.labelDetail.text = @"";
                    self.cityTF.text = @"";
                    self.province = @"";
                    self.city = @"";
                    self.Region = @"";
              
            
                    
                    ResultOrderViewController * vc = [ResultOrderViewController alloc];
                    
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    //                GrabOrderTabViewController * vc = [GrabOrderTabViewController alloc];
                    //                [self.navigationController pushViewController:vc animated:YES];
                    //                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    //                appDelegate.tabBarVC.selectedIndex = 1;
                    
                }else if([commitType intValue] == 0){
                    [SVProgressHUD showSuccessWithStatus:data[@"msg"]];
                }
                
            }
        }];
    }else{
        [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录！"];
        EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}




-(void)requstSelectConfig{
    
    [SVProgressHUD show];
    [EnterpriseWalletService requestSelectConfig:nil andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            self.arrTool = [NSMutableArray arrayWithCapacity:0];
            for (NSString *item in data[@"list1"]) {
                [self.arrTool addObject:item];
            }
            self.arrTime = [NSMutableArray arrayWithCapacity:0];
            for (NSString *item in data[@"list2"]) {
                [self.arrTime addObject:item];
            }
            self.arrInstall = [NSMutableArray arrayWithCapacity:0];
            for (NSString *item in data[@"list6"]) {
                [self.arrInstall addObject:item];
            }
            self.arrMaterials = [NSMutableArray arrayWithCapacity:0];
            for (NSString *item in data[@"list4"]) {
                [self.arrMaterials addObject:item];
            }
            self.arrLogistics = [NSMutableArray arrayWithCapacity:0];
            for (NSString *item in data[@"list5"]) {
                [self.arrLogistics addObject:item];
            }
            
            
        }
    }];
}

-(void)requstReleasePerson{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
    
    if(userID.length>0){
        
        [SVProgressHUD show];
        NSDictionary *dic = @{@"userid":userID};
        [EnterpriseWalletService requestReleasePerson:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
            if (data) {
                
                self.labelName.text = data[@"name"];
                self.labelPhone.text = data[@"phone"];
                
                
            }
        }];}else{
            self.labelName.text = @"";
            self.labelPhone.text = @"";
        }
}

-(void)requstAddress{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    self.arrInstallType = [NSMutableArray arrayWithCapacity:0];
    if(userID.length>0){
        [SVProgressHUD show];
        NSDictionary *dic = @{@"userid":userID};
        [EnterpriseCommonService requestAddress:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
            if (data) {
                BRProvinceModel * provinceModel;
                BRCityModel* cityModel;
                BRAreaModel*areaModel;
                NSInteger i = 0;
                for (NSDictionary *province in data[@"cityarr"]) {
                    
                    NSMutableArray <BRCityModel*>* citylist = [NSMutableArray arrayWithCapacity:0];
                    NSInteger j = 0;
                    for (NSDictionary *city in province[@"children"]) {
                        
                        NSMutableArray <BRAreaModel*>*  townlist = [NSMutableArray arrayWithCapacity:0];
                        NSInteger k = 0;
                        for (NSDictionary *town in city[@"children"]) {
                            areaModel =  [BRAreaModel alloc];
                            areaModel.code = town[@"value"];
                            areaModel.name = town[@"label"];
                            [townlist addObject:areaModel];
                            k = k+1;
                        }
                        cityModel =  [BRCityModel alloc];
                        cityModel.code = city[@"value"];
                        cityModel.name = city[@"label"];
                        cityModel.arealist = townlist;
                        cityModel.index = j;
                        [citylist addObject:cityModel];
                        j = j+1;
                    }
                    provinceModel =  [BRProvinceModel alloc];
                    provinceModel.code = province[@"value"];
                    provinceModel.name = province[@"label"];
                    provinceModel.index = i;
                    provinceModel.citylist = citylist;
                    [self.arrAddress addObject:provinceModel];
                    i = i +1;
                }
                
                
            }
        }];}
    
}

-(void)selectCity{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    if(userID.length>0){
        
        BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]init];
        addressPickerView.dataSourceArr = self.arrAddress;
        addressPickerView.pickerMode = BRAddressPickerModeArea;
        addressPickerView.title = @"请选择地区";
        addressPickerView.selectIndexs = self.addressSelectIndexs;
        addressPickerView.isAutoSelect = YES;
        addressPickerView.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
            self.addressSelectIndexs = @[@(province.index), @(city.index), @(area.index)];
            self.province = province.name;
            self.city = city.name;
            self.Region = area.name;
            self.cityTF.text = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
        };
        
        [addressPickerView show];
    }else{
        [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录！"];
        EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

-(void)selectInstallType{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    if(userID.length>0){
        BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
        stringPickerView.pickerMode = BRStringPickerComponentSingle;
        stringPickerView.title = @"安装类型";
        stringPickerView.dataSourceArr = self.arrInstall;
        stringPickerView.selectIndex = 0;
        stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
            self.strInstallType = resultModel.value;
            self.installType.text = resultModel.value;
        };
        
        [stringPickerView show];}else{
            [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录！"];
            EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
}

-(void)selectInstallDate{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    if(userID.length>0){
        // 1.创建日期选择器
        BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
        // 2.设置属性
        datePickerView.pickerMode = BRDatePickerModeYMD;
        datePickerView.title = @"选择年月日";
        // datePickerView.selectValue = @"2019-10-30";
        datePickerView.minDate = [NSDate br_setYear:1949 month:3 day:12];
        datePickerView.isAutoSelect = YES;
        datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            NSLog(@"选择的值：%@", selectValue);
            self.labelInstallDate.text = selectValue;
        };
        
        
        
        // 3.显示
        [datePickerView show];}else{
            [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录！"];
            EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    
}

-(void)orderListAtion{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
    
    if(userID.length>0){
        
        //        GrabOrderTabViewController * vc = [GrabOrderTabViewController alloc];
        //
        //    [self.navigationController pushViewController:vc animated:YES];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.tabBarVC.selectedIndex = 2;
    }else{
        [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录！"];
        EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
- (void)viewWillAppear:(BOOL)animated{

    [self requstReleasePerson];
    [self requstAddress];
}



-(void)selectLogistics{
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    stringPickerView.title = @"收货方式";
    stringPickerView.dataSourceArr = self.arrLogistics;
    stringPickerView.selectIndex = 0;
    stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        self.labelLogistics.text = resultModel.value;
    };
    [stringPickerView show];
}

- (void)textViewDidChange:(WSPlaceholderTextView *)textView // 此处取巧，把代理方法参数类型直接改成自定义的WSTextView类型，为了可以使用自定义的placeholder属性，省去了通过给控制器WSTextView类型属性这样一步。
{
    if (textView.hasText) { // textView.text.length
        textView.placeholder = @"";
        
    }
}



//获取当前时间戳
- (NSString *)currentTimeStr{

    NSTimeInterval currentTimeStampInMilliseconds = [[NSDate date] timeIntervalSince1970] * 1000.0;
    NSString *timeStampStringInMilliseconds = [NSString stringWithFormat:@"%.0f", currentTimeStampInMilliseconds];
    return timeStampStringInMilliseconds;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //    限制只能输入数字
    BOOL isHaveDian = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            if([textField.text length] == 0){
                if(single == '.') {
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }}


@end
