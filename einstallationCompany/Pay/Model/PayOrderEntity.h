//
//  PayOrderModel.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/8/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayOrderEntity : NSObject
@property NSString *InstallPrice;
@property NSString *outTradeNo;
@property NSMutableArray<NSString*> *datelist;

@end

NS_ASSUME_NONNULL_END
