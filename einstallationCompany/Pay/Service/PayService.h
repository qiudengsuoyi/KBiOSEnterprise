//
//  PayService.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayService : NSObject
+ (void)requestPay:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestOrderInfo:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;

+ (void)requestOrderEditInfo:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;

+ (void)requestOrderSubmit:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;

+ (void)requestMessage:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;

+ (void)requestMessageOrder:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;

@end

NS_ASSUME_NONNULL_END
