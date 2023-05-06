//
//  CommonService.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnterpriseCommonService : NSObject
+ (void)requestAddress:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
@end

NS_ASSUME_NONNULL_END
