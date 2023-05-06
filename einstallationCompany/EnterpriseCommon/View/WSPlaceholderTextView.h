//
//  WSPlaceholderTextView.h
//  einstallationCompany
//
//  Created by 云位 on 2022/9/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSPlaceholderTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end

NS_ASSUME_NONNULL_END
