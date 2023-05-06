//
//  GrabOrderListViewController.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/17.
//

#import "EnterpriseBaseController.h"
#import "OrderListEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface GrabListViewController : EnterpriseBaseController
@property NSMutableArray<OrderListEntity*>*muKeyValueList;
@property NSString * recordID;
@property NSString * pageType;
@end

NS_ASSUME_NONNULL_END
