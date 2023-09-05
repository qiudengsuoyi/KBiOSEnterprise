//
//  GrabAuditViewController.h
//  einstallationCompany
//
//  Created by 云位 on 2023/8/28.
//

#import "EnterpriseBaseController.h"
#import "OrderListEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface GrabAuditViewController : EnterpriseBaseController
@property NSMutableArray<OrderListEntity*>*muKeyValueList;
@property NSString * recordID;
@property NSString * pageType;
@end

NS_ASSUME_NONNULL_END
