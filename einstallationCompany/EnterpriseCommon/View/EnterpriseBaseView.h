//
//  RPSBaseView.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnterpriseBaseView : UIView
@property (nonatomic, copy) void(^clickAction)(void);

@end

NS_ASSUME_NONNULL_END
