//
//  DialogTwoButton.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/7/22.
//
#import "EnterpriseBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DialogTwoButtonView : EnterpriseBaseView
@property (weak, nonatomic) IBOutlet UILabel *laContent;
@property (weak, nonatomic) IBOutlet UIButton *btLeft;
@property (weak, nonatomic) IBOutlet UIButton *btRight;
@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;
@property (nonatomic, copy) void (^cancelBlock)(void);
@property (nonatomic, strong) NSString * strRightButtonName;
@property (nonatomic, strong) NSString * strLeftButtonName;
@property (nonatomic, copy) void (^confirmBlock)(void);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewHeight;
@end

NS_ASSUME_NONNULL_END
