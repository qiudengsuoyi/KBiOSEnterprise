//
//  EvaluateListViewController.h
//  einstallationCompany
//
//  Created by 云位 on 2023/8/17.
//

#import "EnterpriseBaseController.h"
#import "OrderListEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface EvaluateListViewController : EnterpriseBaseController
@property NSMutableArray<OrderListEntity *> * dataList;
@property (weak, nonatomic) IBOutlet UITableView *tb;
@property NSString * masterID;
@end

NS_ASSUME_NONNULL_END
