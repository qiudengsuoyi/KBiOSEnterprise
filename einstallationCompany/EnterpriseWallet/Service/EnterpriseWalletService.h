//
//                       _oo0oo_
//                      o8888888o
//                      88" . "88
//                      (| -_- |)
//                      0\  =  /0
//                    ___/`---'\___
//                  .' \\|     |// '.
//                 / \\|||  :  |||// \
//                / _||||| -:- |||||- \
//               |   | \\\  -  /// |   |
//               | \_|  ''\---/''  |_/ |
//               \  .-\__  '-'  ___/-. /
//             ___'. .'  /--.--\  `. .'___
//          ."" '<  `.___\_<|>_/___.' >' "".
//         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//         \  \ `_.   \_ __\ /__ _/   .-` /  /
//     =====`-.____`.___ \_____/___.-`___.-'=====
//                       `=---='
//
//
//     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//               佛祖保佑         永无BUG
//
//
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnterpriseWalletService : NSObject
+ (void)requestReleaseSubmit:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestInstallType:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;
+ (void)requestReleasePerson:(NSDictionary *)params andResultBlock:(void (^)(id data, id error))resultBlock;

@end

NS_ASSUME_NONNULL_END
