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

@interface PayTypeViewController ()
@property bool xieYiState;
@property (weak, nonatomic) IBOutlet UITextField *labelName;
@property (weak, nonatomic) IBOutlet UITextField *labelPhone;
@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UITextField *installType;
@property (weak, nonatomic) IBOutlet UITextField *labelAddress;
@property (weak, nonatomic) IBOutlet UITextField *labelMoney;
@property (weak, nonatomic) IBOutlet UITextField *labelInstallDate;



@property NSString * province;
@property NSString * city;
@property NSString * Region;
@property NSString * strInstallType;
@property NSString * strInstallDate;
@property NSString * strMoney;
@property NSMutableArray * arrInstallType;
@property (nonatomic, copy) NSArray <NSNumber *> *addressSelectIndexs;
@property NSMutableArray < BRProvinceModel *>* arrAddress;
@end

@implementation PayTypeViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];

    self.navigationItem.title = @"选择发布任务的方式";
    self.arrAddress = [NSMutableArray arrayWithCapacity:0];
    self.province = @"";
    self.city = @"";
    self.Region = @"";
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"enterprise_menu_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(orderListAtion)];
    self.navigationItem.rightBarButtonItem = right;
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布任务列表" style:UIBarButtonItemStylePlain target:self action:@selector(orderListAtion)];
    //    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"#D8D8D8"];
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
    
    labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectInstallDate)];
    // 2. 将点击事件添加到label上
    [self.labelInstallDate addGestureRecognizer:labelTapGestureRecognizer];
    
    self.labelInstallDate.userInteractionEnabled = YES;
    
    [self requstInstallType];
    [self requstReleasePerson];
    [self requstAddress];
   
}



- (IBAction)action03:(id)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
    
    if(userID.length>0){
    NSString *strName = self.labelName.text;
    NSString *strPhone = self.labelPhone.text;
    self.strInstallType = self.installType.text;
    
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
    
    if(self.strInstallType.length<1){
        [SVProgressHUD showErrorWithStatus:@"请选择安装类型！"];
        return;
    }
    
    if(self.labelAddress.text.length<1){
        [SVProgressHUD showErrorWithStatus:@"请输入安装详细地址！"];
        return;
    }
    
    if(self.labelMoney.text.length<1){
        [SVProgressHUD showErrorWithStatus:@"请输入安装价格（元）！"];
        return;
    }
    
    if(self.labelInstallDate.text.length<1){
        [SVProgressHUD showErrorWithStatus:@"请选择安装时间！"];
        return;
    }
    
    if(!self.xieYiState){
        [SVProgressHUD showErrorWithStatus:@"请同意协议！"];
        return;
    }
    
    [self requstOrderReleaseSubmit:@"1"];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录！"];
        EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)action01:(id)sender {
    
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
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
    
    if(userID.length>0){
    NSString *strName = self.labelName.text;
    NSString *strPhone = self.labelPhone.text;
    self.strInstallType = self.installType.text;
    
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
    
    if(self.self.strInstallType.length<1){
        [SVProgressHUD showErrorWithStatus:@"请选择安装类型！"];
        return;
    }
    
    if(self.labelAddress.text.length<1){
        [SVProgressHUD showErrorWithStatus:@"请输入安装详细地址！"];
        return;
    }
    
    if(self.labelMoney.text.length<1){
        [SVProgressHUD showErrorWithStatus:@"请输入安装价格（元）！"];
        return;
    }
    
    if(self.labelInstallDate.text.length<1){
        [SVProgressHUD showErrorWithStatus:@"请选择安装时间！"];
        return;
    }
    
    if(!self.xieYiState){
        [SVProgressHUD showErrorWithStatus:@"请同意协议！"];
        return;
    }
    
    [self requstOrderReleaseSubmit:@"2"];
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


-(void)requstOrderReleaseSubmit:(NSString*) commitType{
    
    self.strInstallType = self.installType.text;
    
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
    
    if(userID.length>0){
    
    [SVProgressHUD show];
    NSDictionary *dic = @{@"userid":userID,
                          @"Fasttype":commitType,
                          @"name":[self utf82gbk:self.labelName.text],
                          @"phone":self.labelPhone.text,
                          @"installtype":[self utf82gbk:self.strInstallType],
                          @"province":[self utf82gbk:self.province],
                          @"city":[self utf82gbk:self.city],
                          @"Region":[self utf82gbk:self.Region],
                          @"ShopAddress":[self utf82gbk:self.labelAddress.text],
                          @"InstallPrice":self.labelMoney.text,
                          @"InstallDate":self.labelInstallDate.text
    };
    [EnterpriseWalletService requestReleaseSubmit:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            if([commitType intValue] == 2||[commitType intValue] == 3||[commitType intValue] == 4){
            PayViewController *vc = [PayViewController alloc];
//            ResultOrderViewController * vc = [ResultOrderViewController alloc];
//            vc.resultType = 1;
//            vc.returnType = 1;
//            vc.strTitle = @"成功发布任务";
//            vc.strContent01 = @"恭喜您已经成功发布任务";
//            vc.strContent02 = @"请保持电话畅通等待和您的进一步沟通";
               
//                GrabOrderTabViewController * vc = [GrabOrderTabViewController alloc];
                vc.recordID = data;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
       
                
            }else if([commitType intValue] == 1){
                PayMessageViewController *vc = [PayMessageViewController alloc];
                vc.recordID = data;
                vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
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


-(void)requstInstallType{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    
    
    if(userID.length>0){
    self.arrInstallType = [NSMutableArray arrayWithCapacity:0];
    if(userID.length>0){
        [SVProgressHUD show];
        NSDictionary *dic = @{@"userid":userID};
        [EnterpriseWalletService requestInstallType:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
            if (data) {
                
                for (NSDictionary *dic in data) {
                    [self.arrInstallType addObject:dic[@"InstallationTypeMiddleName"]];
                }
                
                
            }
        }];}
    
    }
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
    stringPickerView.dataSourceArr = self.arrInstallType;
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
        GrabListViewController * vc = [GrabListViewController alloc];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"暂未登录，请先登录！"];
        EnterpriseLoginController *vc = [[EnterpriseLoginController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [self requstInstallType];
    [self requstReleasePerson];
    [self requstAddress];
}

@end
