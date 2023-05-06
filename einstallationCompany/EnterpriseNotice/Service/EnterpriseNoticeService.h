//
//  NoticeService.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnterpriseNoticeService : NSObject
+ (void)requestNoticeList:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requstDetail:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
@end

NS_ASSUME_NONNULL_END
