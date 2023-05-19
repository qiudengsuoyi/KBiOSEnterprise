//
//  PayService.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/8/22.
//

#import "PayService.h"
#import "EnterpriseNetwork.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "PayModel.h"
#import "NSObject+YYModel.h"
#import "PayOrderEntity.h"
#import "PayOrderEditEntity.h"

@implementation PayService
+ (void)requestPay:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedOtherManager] requestJsonDataWithPath:PAY_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            PayModel *model = [PayModel modelWithDictionary:data[@"data"]];
            if (resultBlock) {
                resultBlock(model,nil);
            }
        }else{
            if(data){
                [SVProgressHUD showErrorWithStatus:data[@"msg"]];
            }else{
                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];}
        }
    }];
}

+ (void)requestOrderInfo:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:ORDER_INFO_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            PayOrderEntity *model = [PayOrderEntity modelWithDictionary:data[@"data"]];
            if (resultBlock) {
                resultBlock(model,nil);
            }
        }else{
            if(data){
                [SVProgressHUD showErrorWithStatus:data[@"msg"]];
            }else{
                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];}
        }
    }];
}

+ (void)requestConfirmMaster:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:CONFIRM_MASTER_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            if (resultBlock) {
                resultBlock(data[@"msg"],nil);
            }
        }else{
            if(data){
                [SVProgressHUD showErrorWithStatus:data[@"msg"]];
            }else{
                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];}
        }
    }];
}

+ (void)requestOrderEditInfo:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:ORDER_EDIT_INFO_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            PayOrderEditEntity *model = [PayOrderEditEntity modelWithDictionary:data[@"data"]];
            if (resultBlock) {
                resultBlock(model,nil);
            }
        }else{
            if(data){
                [SVProgressHUD showErrorWithStatus:data[@"msg"]];
            }else{
                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];}
        }
    }];
}

+ (void)requestOrderSubmit:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:ORDER_EDIT_SUBMIT_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            PayOrderEditEntity *model = [PayOrderEditEntity modelWithDictionary:data[@"data"]];
            if (resultBlock) {
                resultBlock(model,nil);
            }
        }else{
            if(data){
                [SVProgressHUD showErrorWithStatus:data[@"msg"]];
            }else{
                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];}
        }
    }];
}

+ (void)requestMessage:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:ORDER_MESSAGE_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            if (resultBlock) {
                resultBlock(@1,nil);
            }
        }else{
            if(data){
                [SVProgressHUD showErrorWithStatus:data[@"msg"]];
            }else{
                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];}
        }
    }];
}

+ (void)requestMessageOrder:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:ORDER_MESSAGE_INFO_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSString *dic in data[@"data"]) {
              
                    [arr addObject:dic];
                
            }
            if (resultBlock) {
                resultBlock(arr,nil);
            }
        }else{
            if(data){
                [SVProgressHUD showErrorWithStatus:data[@"msg"]];
            }else{
                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];}
        }
    }];
}
@end
