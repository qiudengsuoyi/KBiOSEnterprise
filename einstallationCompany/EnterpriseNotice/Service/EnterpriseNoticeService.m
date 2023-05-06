//
//  NoticeService.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/30.
//

#import "EnterpriseNoticeService.h"
#import "EnterpriseNetwork.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "NoticeEntity.h"
#import "NSObject+YYModel.h"

@implementation EnterpriseNoticeService

+ (void)requestNoticeList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:NOTICE_LIST_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in data[@"data"]) {
                NoticeEntity *model = [NoticeEntity modelWithJSON:dic];
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
+ (void)requstDetail:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:NOTICE_LIST_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in data[@"data"]) {
                NoticeEntity *model = [NoticeEntity modelWithJSON:dic];
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


@end
