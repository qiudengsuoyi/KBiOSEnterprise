//
//  PayModel.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayModel : NSObject
@property NSString *timestamp;
@property NSString *nonceStr;
@property NSString *prepayID;
@property NSString *package;
@property NSString *appID;
@property NSString *partnerID;
@property NSString *sign;

@end

NS_ASSUME_NONNULL_END
