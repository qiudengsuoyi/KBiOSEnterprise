//
//  Network.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/26.
//





#import "AFHTTPSessionManager.h"
#import "UIView+RefreshData.h"


typedef NS_ENUM(NSInteger, RequestType) {
    TypeIsGET,
    TypeIsPOST,
    TypeIsPUT,
    TypeIsDelete
};

@interface EnterpriseNetwork : AFHTTPSessionManager<UIAlertViewDelegate>


+ (EnterpriseNetwork *)sharedManager;
+ (EnterpriseNetwork *)sharedOtherManager;

+(NSDictionary*)dictionaryWithJsonString:(NSString*)jsonString;
/**
 请求
 
 @param path url
 @param params 请求参数
 @param type 请求类型
 @param block 返回
 */
- (void)requestJsonDataWithPath:(NSString *)path
                     withParams:(id)params
                 withMethodType:(RequestType)type
                       andBlock:(void (^)(id data, id error))block;
@end
