//
//  PersonService.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/29.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface UserService : NSObject
+ (void)requestPerson:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestEditMidify:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestCheckWX:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+(void)requestBindWX:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
@end

NS_ASSUME_NONNULL_END
