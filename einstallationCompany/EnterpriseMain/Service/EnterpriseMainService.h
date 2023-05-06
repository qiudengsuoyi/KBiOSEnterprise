//
//  MainService.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/29.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface EnterpriseMainService : NSObject

+ (void)requestMainNum:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestWaitOrderList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestWaitOrderDetail:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestWaitOrderItemDetail:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestInstallOrderItemDetail:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;

+ (void)requestAcceptWaitOrder:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestOrderPicture:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestNoPayMoneyList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestInstallOrderList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestGrabOrderList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestInstallOrderStatisticDetail:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestBrandList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestReleaseList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestReleaseItemList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestReleaseCancel:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestReleaseConfirmMaster:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestComplain:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestComplainModify:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;

@end

NS_ASSUME_NONNULL_END
