//
//  CaseListViewController.h
//  einstallationCompany
//
//  Created by 云位 on 2022/3/21.
//

#import "EnterpriseBaseController.h"
#import "CaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CaseListViewController : EnterpriseBaseController
@property NSMutableArray<CaseModel *> * dataList;
@property (weak, nonatomic) IBOutlet UITableView *tb;
@property NSString * masterID;
@end

NS_ASSUME_NONNULL_END
