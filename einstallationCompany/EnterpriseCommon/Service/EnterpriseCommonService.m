//
//  CommonService.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/7/9.
//

#import "EnterpriseCommonService.h"
#import "EnterpriseNetwork.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "NSObject+YYModel.h"

@implementation EnterpriseCommonService
+ (void)requestAddress:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:ADDRESS_URL
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
