//
//  CaseService.m
//  einstallationCompany
//
//  Created by 云位 on 2022/3/21.
//

#import "CaseService.h"
#import "EnterpriseNetwork.h"
#import "PictureModel.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "NSObject+YYModel.h"
#import "CaseModel.h"

@implementation CaseService

+ (void)requestCaseList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock{
    [[EnterpriseNetwork sharedManager] requestJsonDataWithPath:CASE_LIST_URL
                                             withParams:params
                                         withMethodType:TypeIsPOST andBlock:^(id data, id error) {
        
        if ([data[@"code"]integerValue] == 1) {
            NSMutableArray *arr = [NSMutableArray array];
            NSMutableArray<PictureModel*> *arrChild;
            PictureModel * pictureModel;
            for (NSDictionary *dic in data[@"data"][@"CompleteProjectarr"]) {
                arrChild = [NSMutableArray array];
                CaseModel *model = [CaseModel alloc];
                model.caseID = dic[@"id"];
                model.caseTitle = dic[@"CompleteProjectTilte"];
                for (NSDictionary *childItem in dic[@"imagearr"]) {
                    pictureModel = [PictureModel alloc];
                    pictureModel.images = childItem[@"images"];
                    pictureModel.thumbnail = childItem[@"images"];
                    pictureModel.position = childItem[@"i"];
                    [arrChild addObject:pictureModel];
                }
                model.pictureList = arrChild;
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
                [SVProgressHUD showErrorWithStatus:@"服务器出错，请稍后再试"];}
        }
    }];
}
@end
