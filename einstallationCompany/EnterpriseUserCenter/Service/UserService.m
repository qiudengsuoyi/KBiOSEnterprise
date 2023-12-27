//
//  PersonService.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/29.
//

#import "UserService.h"
#import "EnterpriseNetwork.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "PersonEntity.h"
#import "NSObject+YYModel.h"
#import "EditEnity.h"

@implementation UserService

+ (void)requestPerson:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:ENTERPRISE_PERSON_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            PersonEntity *model = [PersonEntity modelWithDictionary:data[@"data"]];
            if (resultBlock) {
                resultBlock(model,nil);
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

+ (void)requestEditMidify:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:EDIT_PERSON_MODIFY_URL
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

+ (void)requestCheckWX:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:CHECK_WX_LOGIN_URL
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
                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];
                
            }
        }
    }];
}

+ (void)requestBindWX:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:BIND_WX_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:data[@"msg"]];
            if (resultBlock) {
                resultBlock(@"1",nil);
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
@end
