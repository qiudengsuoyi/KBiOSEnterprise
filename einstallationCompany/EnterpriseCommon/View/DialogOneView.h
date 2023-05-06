//
//  DialogOneView.h
//  einstallationCompany
//
//  Created by 云位 on 2022/9/11.
//

#import "EnterpriseBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DialogOneView : EnterpriseBaseView
@property (weak, nonatomic) IBOutlet UILabel *laContent;
@property (weak, nonatomic) IBOutlet UIButton *btRight;
@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;
@property (nonatomic, strong) NSString * strRightButtonName;
@property (nonatomic, copy) void (^confirmBlock)(void);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewHeight;
@end

NS_ASSUME_NONNULL_END
