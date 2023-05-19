//
//  MainService.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/29.
//

#import "EnterpriseMainService.h"
#import "EnterpriseNetwork.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "LoginEntity.h"
#import "NSObject+YYModel.h"
#import "OrderListEntity.h"
#import "KeyValueEntity.h"
#import "PictureListEntity.h"
#import "MainNumEntity.h"


@implementation EnterpriseMainService
+ (void)requestMainNum:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:ENTERPRISE_MAIN_NUM_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            MainNumEntity *model = [MainNumEntity modelWithJSON:data[@"data"]];
            if (resultBlock) {
                resultBlock(model,nil);
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

+ (void)requestWaitOrderList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:BRAND_LIST_DETAIL_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in data[@"data"]) {
                OrderListEntity *model = [OrderListEntity modelWithJSON:dic];
                if (model) {
                    [arr addObject:model];
                }
            }
            if (resultBlock) {
                resultBlock(arr,nil);
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

+ (void)requestGrabOrderEvaluate:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:GRAB_ORDER_EVALUATE_URL
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
                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];
                
            }
        }
    }];
}

+ (void)requestWaitOrderDetail:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:WAIT_ORDER_DETAIL_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in data[@"data"]) {
                OrderListEntity *model = [OrderListEntity modelWithJSON:dic];
                if (model) {
                    [arr addObject:model];
                }
            }
            if (resultBlock) {
                resultBlock(arr,nil);
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

+ (void)requestWaitOrderItemDetail:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:WAIT_ORDER_ITEM_DETAIL_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in data[@"data"]) {
                KeyValueEntity *model = [KeyValueEntity modelWithJSON:dic];
                if (model) {
                    [arr addObject:model];
                }
            }
            if (resultBlock) {
                resultBlock(arr,nil);
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

+ (void)requestGrabOrderItemDetail:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:GRAB_ORDER_ITEM_DETAIL_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            if (resultBlock) {
                resultBlock(data,nil);
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


+ (void)requestInstallOrderStatisticDetail:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:INSTALL_ORDER_STATISTIC_LIST_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in data[@"data"]) {
                KeyValueEntity *model = [KeyValueEntity modelWithJSON:dic];
                if (model) {
                    [arr addObject:model];
                }
            }
            if (resultBlock) {
                resultBlock(arr,nil);
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

+ (void)requestBrandList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:BRAND_LIST_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in data[@"data"]) {
                KeyValueEntity *model = [KeyValueEntity modelWithJSON:dic];
                if (model) {
                    [arr addObject:model];
                }
            }
            if (resultBlock) {
                resultBlock(arr,nil);
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

+ (void)requestInstallOrderItemDetail:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:INSRTALL_ORDER_ITEM_DETAIL_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
          
            if (resultBlock) {
                resultBlock(data,nil);
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

+ (void)requestAcceptWaitOrder:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:WAIT_ORDER_ACCEPT_URL
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
//                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];
                
            }
        }
    }];
}

+ (void)requestOrderPicture:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:ORDER_PICTURE_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
                PictureListEntity *model = [PictureListEntity modelWithJSON:data[@"data"]];
              
            
            if (resultBlock) {
                resultBlock(model,nil);
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

+ (void)requestNoPayMoneyList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:WALLET_NO_PAY_LIST_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in data[@"data"]) {
                OrderListEntity *model = [OrderListEntity modelWithJSON:dic];
                if (model) {
                    [arr addObject:model];
                }
            }
            if (resultBlock) {
                resultBlock(arr,nil);
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

+ (void)requestInstallOrderList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:INSTALL_ORDER_LIST_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
         if ([data[@"code"]integerValue] == 1) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in data[@"data"]) {
                OrderListEntity *model = [OrderListEntity modelWithJSON:dic];
                if (model) {
                    [arr addObject:model];
                }
            }
            if (resultBlock) {
                resultBlock(arr,nil);
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
+ (void)requestGrabOrderList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:INSTALL_ORDER_LIST_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in data[@"data"]) {
                OrderListEntity *model = [OrderListEntity modelWithJSON:dic];
                if (model) {
                    [arr addObject:model];
                }
            }
            if (resultBlock) {
                resultBlock(arr,nil);
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

+ (void)requestReleaseList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:RELEASE_LIST_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in data[@"data"]) {
                OrderListEntity *model = [OrderListEntity modelWithJSON:dic];
                if (model) {
                    [arr addObject:model];
                }
            }
            if (resultBlock) {
                resultBlock(arr,nil);
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
+ (void)requestReleaseItemList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:RELEASE_ITEM_LIST_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in data[@"data"]) {
                OrderListEntity *model = [OrderListEntity modelWithJSON:dic];
                if (model) {
                    [arr addObject:model];
                }
            }
            if (resultBlock) {
                resultBlock(arr,nil);
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

+ (void)requestReleaseCancel:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:RELEASE_CANCEL_URL
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
//                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];
                
            }
        }
    }];
}

+ (void)requestReleaseConfirmMaster:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:RELEASE_CONFIRM_MASTER_URL

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
//                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];
                
            }
        }
    }];
}

+ (void)requestComplain:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:ADD_COMPLAIN_URL

                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            if (resultBlock) {
                resultBlock(data,nil);
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

+ (void)requestComplainModify:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:MODIFY_COMPLAIN_URL

                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            if (resultBlock) {
                resultBlock(data,nil);
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
