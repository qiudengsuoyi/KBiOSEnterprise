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
#import "TZTestCell.h"
#import "TZImagePickerController.h"
#import "UIView+TZLayout.h"
#import "UIView+Extension.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"
#import "WSPlaceholderTextView.h"
#import "ResultOrderViewController.h"
#import "PayService.h"
#import "PayOrderEditEntity.h"

@interface PayTypeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UITextViewDelegate>{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    NSInteger SelectedPostion;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (weak, nonatomic) IBOutlet UICollectionView *imagecollectionView;
@property NSMutableArray <NSString*> * arrProgressData;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
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
@end

@implementation PayTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelDetail.placeholder = @"请填写您需要的服务\n可以尝试如下填写：\n店铺有三张海报需要安装；\n店铺有三个灯箱需要安装；\n店铺的门头需要安装；";
    self.labelHint.text = @"请填写您需要的服务\n可以尝试如下填写：\n店铺有三张海报需要安装；\n店铺有三个灯箱需要安装；\n店铺的门头需要安装；";
    self.labelDetail.delegate = self;
    
    self.navigationItem.title = @"选择发布任务的方式";

    self.arrAddress = [NSMutableArray arrayWithCapacity:0];
    self.province = @"";
    self.city = @"";
    self.Region = @"";
    self.arrProgressData = [NSMutableArray arrayWithCapacity:0];
    [self.arrProgressData addObject:@"0"];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];

   
    
    
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"enterprise_menu_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(orderListAtion)];
//    self.navigationItem.rightBarButtonItem = right;
    
 
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
    
    [self requstInstallType];
    [self requstSelectConfig];
    [self requstReleasePerson];
    [self requstAddress];
    [self configCollectionView];
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


- (void)configCollectionView {
    _imagecollectionView.alwaysBounceVertical = YES;
    _imagecollectionView.backgroundColor = [UIColor whiteColor];
    _imagecollectionView.dataSource = self;
    _imagecollectionView.delegate = self;
    _imagecollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_imagecollectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

- (IBAction)action03:(id)sender {
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
    

    [self requstOrderReleaseSubmit:@"3"];}else{

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
                          @"InstallDate":self.labelInstallDate.text,
                          @"receivingMethod":[self utf82gbk:self.labelLogistics.text],
                          @"photographyRequirements":[self utf82gbk:self.labelDetail.text]
    };
    [EnterpriseWalletService requestReleaseSubmit:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            if([commitType intValue] == 2||[commitType intValue] == 3||[commitType intValue] == 4){

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
                [self->_selectedPhotos removeAllObjects];
                [self->_selectedAssets removeAllObjects];
                [self.imagecollectionView reloadData];
                
            ResultOrderViewController * vc = [ResultOrderViewController alloc];

                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
//                GrabOrderTabViewController * vc = [GrabOrderTabViewController alloc];
//                [self.navigationController pushViewController:vc animated:YES];
//                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                appDelegate.tabBarVC.selectedIndex = 1;
                
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
            for (NSString *item in data[@"list3"]) {
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
    [self requstInstallType];
    [self requstReleasePerson];
    [self requstAddress];
}


- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:self pushPhotoPickerVc:YES];

    
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    
    // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = YES;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 100; // 视频最大拍摄时间
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    imagePickerVc.autoSelectCurrentWhenDone = NO;
    
    // imagePickerVc.photoWidth = 1600;
    // imagePickerVc.photoPreviewMaxWidth = 1600;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
//     imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
//     imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
//     imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
     imagePickerVc.navigationBar.translucent = NO;
     if (@available(iOS 13.0, *)) {
         UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
         barAppearance.backgroundColor = imagePickerVc.navigationBar.barTintColor;
         barAppearance.titleTextAttributes = imagePickerVc.navigationBar.titleTextAttributes;
         imagePickerVc.navigationBar.standardAppearance = barAppearance;
         imagePickerVc.navigationBar.scrollEdgeAppearance = barAppearance;
     }
    

    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    /*
     [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
     [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
     }];
     */
    /*
     [imagePickerVc setAssetCellDidSetModelBlock:^(TZAssetCell *cell, UIImageView *imageView, UIImageView *selectImageView, UILabel *indexLabel, UIView *bottomView, UILabel *timeLength, UIImageView *videoImgView) {
     cell.contentView.clipsToBounds = YES;
     cell.contentView.layer.cornerRadius = cell.contentView.tz_width * 0.5;
     }];
     */
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = YES; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = YES;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    //    NSInteger left = 30;
    //    NSInteger widthHeight = self.view.tz_width - 2 * left;
    //    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    //    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    //    imagePickerVc.scaleAspectFillCrop = YES;
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    // imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */
    
    // Deprecated, Use statusBarStyle
    // imagePickerVc.isStatusBarDefault = NO;
//    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
    // 设置拍照时是否需要定位，仅对选择器内部拍照有效，外部拍照的，请拷贝demo时手动把pushImagePickerController里定位方法的调用删掉
    // imagePickerVc.allowCameraLocation = NO;
    
    // 自定义gif播放方案
    //    [[TZImagePickerConfig sharedInstance] setGifImagePlayBlock:^(TZPhotoPreviewView *view, UIImageView *imageView, NSData *gifData, NSDictionary *info) {
    //        FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
    //        FLAnimatedImageView *animatedImageView;
    //        for (UIView *subview in imageView.subviews) {
    //            if ([subview isKindOfClass:[FLAnimatedImageView class]]) {
    //                animatedImageView = (FLAnimatedImageView *)subview;
    //                animatedImageView.frame = imageView.bounds;
    //                animatedImageView.animatedImage = nil;
    //            }
    //        }
    //        if (!animatedImageView) {
    //            animatedImageView = [[FLAnimatedImageView alloc] initWithFrame:imageView.bounds];
    //            animatedImageView.runLoopMode = NSDefaultRunLoopMode;
    //            [imageView addSubview:animatedImageView];
    //        }
    //        animatedImageView.animatedImage = animatedImage;
    //    }];
    
    // 设置首选语言 / Set preferred language
    // imagePickerVc.preferredLanguage = @"zh-Hans";
    
    // 设置languageBundle以使用其它语言 / Set languageBundle to use other language
    // imagePickerVc.languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"tz-ru" ofType:@"lproj"]];
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        [mediaTypes addObject:(NSString *)kUTTypeImage];
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
            
            
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}


- (void)deleteBtnClik:(UIButton *)sender {
    if ([self collectionView:self.imagecollectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
        self.arrProgressData = [NSMutableArray array];
        for(int i =0;i<=self->_selectedAssets.count;i++){
            [self.arrProgressData addObject:@"0"];
            
        }
        [_selectedPhotos removeObjectAtIndex:sender.tag];
        [_selectedAssets removeObjectAtIndex:sender.tag];
        [self.imagecollectionView reloadData];
        return;
    }
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [_imagecollectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_imagecollectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self->_imagecollectionView reloadData];
    }];
}


// The picker should dismiss itself; when it dismissed these handle will be called.
// You can also set autoDismiss to NO, then the picker don't dismiss itself.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = YES;
    self.arrProgressData = [NSMutableArray array];
    for(int i =0;i<=self->_selectedAssets.count;i++){
        [self.arrProgressData addObject:@"0"];
        
    }
    
    [_imagecollectionView reloadData];
    // _imagecollectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    for (PHAsset *phAsset in assets) {
        NSLog(@"location:%@",phAsset.location);
    }
    // 3. 获取原图的示例，用队列限制最大并发为1，避免内存暴增
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    for (NSInteger i = 0; i < assets.count; i++) {
        PHAsset *asset = assets[i];
        // 图片上传operation，上传代码请写到operation内的start方法里，内有注释
//        TZImageUploadOperation *operation = [[TZImageUploadOperation alloc] initWithAsset:asset completion:^(UIImage * photo, NSDictionary *info, BOOL isDegraded) {
//            if (isDegraded) return;
//            NSLog(@"图片获取&上传完成");
//        } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
//            NSLog(@"获取原图进度 %f", progress);
//        }];
//        [self.operationQueue addOperation:operation];
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    tzImagePickerVc.sortAscendingByModificationDate = YES;
    [tzImagePickerVc showProgressHUD];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSDictionary *meta = [info objectForKey:UIImagePickerControllerMediaMetadata];
        [[TZImageManager manager] savePhotoWithImage:image meta:meta location:nil completion:^(PHAsset *asset, NSError *error){
            [tzImagePickerVc hideProgressHUD];
            if (error) {
                NSLog(@"图片保存失败 %@",error);
            } else {
                TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                //                if (NO) { // 允许裁剪,去裁剪
                //                    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                //                        [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                //                    }];
                //                    imagePicker.allowPickingImage = YES;
                //                    imagePicker.needCircleCrop = NO;
                //                    imagePicker.circleCropRadius = 100;
                //                    [self presentViewController:imagePicker animated:YES completion:nil];
                //                } else {
                [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                //                }
            }
        }];
    } else if ([type isEqualToString:@"public.movie"]) {
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
            [[TZImageManager manager] saveVideoWithUrl:videoUrl location:nil completion:^(PHAsset *asset, NSError *error) {
                [tzImagePickerVc hideProgressHUD];
                if (!error) {
                    TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                    [[TZImageManager manager] getPhotoWithAsset:assetModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                        if (!isDegraded && photo) {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:photo];
                        }
                    }];
                }
            }];
        }
    }
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    self.arrProgressData = [NSMutableArray array];
    for(int i =0;i<=self->_selectedAssets.count;i++){
        [self.arrProgressData addObject:@"0"];
        
    }
    [_imagecollectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (PHAsset *asset in assets) {
        fileName = [asset valueForKey:@"filename"];
        // NSLog(@"图片名字:%@",fileName);
    }
}

#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
    
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.height.constant = ceil((_selectedPhotos.count + 1)/3.0f)*((SCREENWIDTH-90)/3.0f);
    return _selectedPhotos.count + 1;
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.item == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"Image_add.png"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
        cell.progressView.hidden = YES;
    } else {
        cell.progressView.hidden = NO;
        cell.imageView.image = _selectedPhotos[indexPath.item];
        cell.asset = _selectedAssets[indexPath.item];
        cell.deleteBtn.hidden = NO;
    }
    [cell.progressView setProgress:[[self.arrProgressData objectAtIndex:indexPath.row] floatValue]];
    
    
    cell.gifLable.hidden = YES;
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
    
    
}

#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    
    return UIEdgeInsetsMake(5, 5, 5, 5);//（上、左、下、右）
    
    
}


-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    
    return CGSizeMake((SCREENWIDTH-120)/3, (SCREENWIDTH-120)/3);;
    
}


#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == _selectedPhotos.count) {
        NSString *takePhotoTitle = @"拍照";
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhotoTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhoto];
        }];
        [alertVc addAction:takePhotoAction];
        UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pushTZImagePickerController];
        }];
        [alertVc addAction:imagePickerAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:cancelAction];
        UIPopoverPresentationController *popover = alertVc.popoverPresentationController;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        if (popover) {
            popover.sourceView = cell;
            popover.sourceRect = cell.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
        [self presentViewController:alertVc animated:YES completion:nil];
        
    }
    else { // preview photos or video / 预览照片或者视频
        PHAsset *asset = _selectedAssets[indexPath.item];
        BOOL isVideo = NO;
        isVideo = asset.mediaType == PHAssetMediaTypeVideo;
        if ([[asset valueForKey:@"filename"] containsString:@"GIF"] && YES) {
            TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
            vc.model = model;
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        } else if (isVideo && !YES) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.item];
            imagePickerVc.maxImagesCount = 9;
            imagePickerVc.allowPickingGif = NO;
            imagePickerVc.autoSelectCurrentWhenDone = NO;
            imagePickerVc.allowPickingOriginalPhoto = YES;
            imagePickerVc.allowPickingMultipleVideo = NO;
            imagePickerVc.showSelectedIndex = NO;
            imagePickerVc.isSelectOriginalPhoto = YES;
            imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                
                self->_selectedPhotos = [NSMutableArray arrayWithArray:photos];
                self->_selectedAssets = [NSMutableArray arrayWithArray:assets];
                self->_isSelectOriginalPhoto = YES;
                self.arrProgressData = [NSMutableArray array];
                for(int i =0;i<=self->_selectedAssets.count;i++){
                    [self.arrProgressData addObject:@"0"];
                    
                }
                [self->_imagecollectionView reloadData];
                self->_imagecollectionView.contentSize = CGSizeMake(0, ((self->_selectedPhotos.count + 2) / 3 ) * (self->_margin + self->_itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
    
    
    
    
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


//取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
@end
