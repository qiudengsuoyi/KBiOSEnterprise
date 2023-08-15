//
//  OrderList.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/20.
//

#import <Foundation/Foundation.h>
#import "KeyValueEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderListEntity : NSObject
@property NSString * recordID;
@property NSString * OrderState;
@property NSString * paymentState;
@property NSString * InstallState;
@property NSString * orderno;
@property NSString *lastid;
@property NSString *lasti;
@property NSString *ReportPrice;
@property NSString *masterid;
@property NSMutableArray<KeyValueEntity*> * resultarr;
@property bool clickVisible;
@end

NS_ASSUME_NONNULL_END
