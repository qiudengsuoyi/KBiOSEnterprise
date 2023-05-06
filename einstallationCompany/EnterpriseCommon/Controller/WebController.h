//
//  WebViewViewController.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/7.
//

#import "EnterpriseBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebController : EnterpriseBaseController
@property (nonatomic, copy) NSString *url;
@property NSInteger pageType;
@end

NS_ASSUME_NONNULL_END
