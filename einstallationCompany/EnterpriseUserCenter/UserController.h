//
//  PersonCenterViewController.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/12.
//

#import "EnterpriseBaseController.h"
#import "PersonEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserController : EnterpriseBaseController
@property (weak, nonatomic) IBOutlet UIView *vPassword;
@property (weak, nonatomic) IBOutlet UIView *vLR;
@property PersonEntity * returnModel;
@end

NS_ASSUME_NONNULL_END
