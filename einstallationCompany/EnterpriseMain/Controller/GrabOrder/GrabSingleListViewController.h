//
//  GrabOrderItemListViewController.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/27.
//

#import "EnterpriseBaseController.h"
#import "OrderListEntity.h"
NS_ASSUME_NONNULL_BEGIN

@interface GrabSingleListViewController : EnterpriseBaseController
@property NSMutableArray<OrderListEntity*>*muKeyValueList;
@property NSString * recordID;
@property NSString *masterID;
@end

NS_ASSUME_NONNULL_END
