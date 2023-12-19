//
//  PayViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/8/15.
//

#import "PayViewController.h"
#import "ResultController.h"
#import "SVProgressHUD.h"
#import "PayService.h"
#import "APIConst.h"
#import "WXApi.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "PayModel.h"
#import "PayOrderTableViewCell.h"
#import "WXApiManager.h"
#import "GrabOrderTabViewController.h"


@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labelMoney;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbHeight;
@property (weak, nonatomic) IBOutlet UITableView *tbOrderList;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = @"订单支付";
    [WXApiManager sharedManager].delegate = self;
    self.tbOrderList.dataSource = self;
    self.tbOrderList.delegate = self;
    // 1.设置行高为自动撑开
    self.tbOrderList.rowHeight = UITableViewAutomaticDimension;
    self.tbOrderList.allowsSelection = NO;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbOrderList.estimatedRowHeight = 120;
    self.tbOrderList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbOrderList registerNib:[UINib nibWithNibName:NSStringFromClass([PayOrderTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PayOrderTableViewCell class])];
    self.tbOrderList.allowsSelection=NO;
 
}

- (IBAction)actionPay:(id)sender {
    [self requstPay];
//    [self confirmMaster];
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadData];
}

-(void)requstPay{
    [SVProgressHUD show];
    NSString * userID = [[NSUserDefaults standardUserDefaults] valueForKey:ENTERPRISE_USERID];
    NSDictionary *dic = @{@"userid":userID,
                          @"InstallPrice":self.payOrderModel.InstallPrice,
                          @"outTradeNo":self.payOrderModel.outTradeNo,
                          @"masterid":self.masterID == nil ? @"0":self.masterID
                          };
    [PayService requestPay:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            PayModel * payModel = data;
            //调起微信支付
            
            PayReq * req            = [[PayReq alloc] init];
            req.partnerId           = payModel.partnerID;
            req.prepayId            = payModel.prepayID;
            req.nonceStr            = payModel.nonceStr;
            req.timeStamp           = payModel.timestamp.intValue;
            req.package             = payModel.package;
            req.sign                = payModel.sign;

            [WXApi sendReq:req completion:^(BOOL success) {
                if(success){
                    
                       
                }}];

            
            
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.payOrderModel.datelist.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PayOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PayOrderTableViewCell class])];
    if (cell == nil) {
        cell = [[PayOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    NSString *strContent = [self.payOrderModel.datelist objectAtIndex:indexPath.row];
    cell.strContent = strContent;
    [cell setModel];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.f;
}

-(void)loadData{
    [SVProgressHUD show];
    NSDictionary *dic = @{@"recordID":self.recordID,
                          @"masterid":self.masterID == nil ? @"0":self.masterID
    };
    [PayService requestOrderInfo:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            self.payOrderModel = data;
            self.tbHeight.constant = self.payOrderModel.datelist.count*30.f;
            [self.tbOrderList reloadData];
            self.labelMoney.text = [NSString stringWithFormat:@"%@元",self.payOrderModel.InstallPrice];
            
        
            
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

-(void)confirmMaster{
    [SVProgressHUD show];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user valueForKey:ENTERPRISE_USERID];
    NSDictionary *dic = @{@"recordID":self.recordID,
                          @"masterid":self.masterID == nil ? @"0":self.masterID,
                          @"userid":userID
    };
    [PayService requestConfirmMaster:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            [SVProgressHUD showSuccessWithStatus:data];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
       
        
        switch (resp.errCode) {
            case WXSuccess:
               
                break;
                
            default:
              
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        
    }else {
    }
}

@end
