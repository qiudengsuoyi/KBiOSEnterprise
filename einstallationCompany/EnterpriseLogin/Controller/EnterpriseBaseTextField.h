//
//  BaseTextField.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnterpriseBaseTextField : UITextField
/**
 限制字数
 */
@property (assign, nonatomic) NSInteger upperlimitNumber;
@end

NS_ASSUME_NONNULL_END
