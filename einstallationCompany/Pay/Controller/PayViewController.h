//
//  PayViewController.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/8/15.
//

#import "EnterpriseBaseController.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WechatAuthSDK.h"
#import "PayOrderEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayViewController : EnterpriseBaseController<WXApiManagerDelegate,WechatAuthAPIDelegate>
@property PayOrderEntity * payOrderModel;
@property NSString * recordID;
@property NSString * masterID;
@end

NS_ASSUME_NONNULL_END
