//
//  WalletService.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/27.
//

#import "EnterpriseWalletService.h"
#import "EnterpriseNetwork.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "NSObject+YYModel.h"

@implementation EnterpriseWalletService
+ (void)requestReleaseSubmit:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:RELEASE_SUBMIT_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            if (resultBlock) {
                [SVProgressHUD showSuccessWithStatus:data[@"msg"]];
                resultBlock(data[@"data"][@"recordID"],nil);
            }
        }else{
            
            if(data){
                [SVProgressHUD showErrorWithStatus:data[@"msg"]];
            }else{
//                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];
                
            }
        }
    }];
}

+ (void)requestInstallType:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:INSTALL_TYPE_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            if (resultBlock) {
                resultBlock(data[@"data"],nil);
            }
        }else{
            
            if(data){
                [SVProgressHUD showErrorWithStatus:data[@"msg"]];
            }else{
//                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];
                
            }
        }
    }];
}

+ (void)requestReleasePerson:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:RELEASE_PERSON_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            if (resultBlock) {
                resultBlock(data[@"data"],nil);
            }
        }else{
            if(data){
                [SVProgressHUD showErrorWithStatus:data[@"msg"]];
            }else{
//                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];
                
            }
        }
    }];
}

+ (void)requestWallet:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:WALLET_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            if (resultBlock) {
                resultBlock(data[@"data"],nil);
            }
        }else{
            if(data){
                [SVProgressHUD showErrorWithStatus:data[@"msg"]];
            }else{
//                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];
                
            }
        }
    }];
}

+ (void)requestRechargeOrderList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:WALLET_RECHARGE_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            if (resultBlock) {
                resultBlock(data[@"data"],nil);
            }
        }else{
            if(data){
                [SVProgressHUD showErrorWithStatus:data[@"msg"]];
            }else{
//                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];
                
            }
        }
    }];
}

+ (void)requestCostOrderList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:WALLET_COST_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            if (resultBlock) {
                resultBlock(data[@"data"],nil);
            }
        }else{
            if(data){
                [SVProgressHUD showErrorWithStatus:data[@"msg"]];
            }else{
//                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];
                
            }
        }
    }];
}

@end
