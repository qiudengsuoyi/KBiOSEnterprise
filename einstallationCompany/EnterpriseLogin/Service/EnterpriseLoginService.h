//
//  LoginService.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnterpriseLoginService : NSObject
+ (void)requestLogin:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestGetCode:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;

+ (void)requestRegister:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;

+ (void)requestModifyPassword:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;

+ (void)requestPasswordInfo:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;

@end

NS_ASSUME_NONNULL_END
