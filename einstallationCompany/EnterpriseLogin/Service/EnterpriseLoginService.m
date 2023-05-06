//
//  LoginService.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/25.
//

#import "EnterpriseLoginService.h"
#import "EnterpriseNetwork.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "LoginEntity.h"
#import "NSObject+YYModel.h"

@implementation EnterpriseLoginService
+ (void)requestLogin:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:ENTERPRISE_LOGIN_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            LoginEntity *model = [LoginEntity modelWithDictionary:data[@"data"]];
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
+ (void)requestGetCode:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:ENTERPRISE_REGISTER_CODE_URL
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

+ (void)requestRegister:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{

    
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:ENTERPRISE_REGISTER_URL
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


+ (void)requestModifyPassword:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:MODIFY_PASSWORD_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            if (resultBlock) {
                resultBlock(data[@"message"],nil);
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

+ (void)requestPasswordInfo:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:PASSWORD_INFO_URL
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
