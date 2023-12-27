//
//  EnterpriseViewController.h
//  einstallationCompany
//

//  Created by 云位 on 2023/8/17.
//

#import "EnterpriseBaseController.h"
#import "MainNumEntity.h"


NS_ASSUME_NONNULL_BEGIN

@interface EnterpriseViewController : EnterpriseBaseController


@property (weak, nonatomic) IBOutlet UIView *view01;
@property (weak, nonatomic) IBOutlet UIView *vCircle01;
@property (weak, nonatomic) IBOutlet UIView *vCircle02;
@property (weak, nonatomic) IBOutlet UIView *vCircle03;
@property MainNumEntity * mainNumModel;

@end

NS_ASSUME_NONNULL_END
