//
//  CaseService.h
//  einstallationCompany
//
//  Created by 云位 on 2022/3/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CaseService : NSObject
+ (void)requestCaseList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestEvaluateList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
@end

NS_ASSUME_NONNULL_END
