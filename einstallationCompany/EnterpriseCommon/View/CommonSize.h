//
//  CommonSize.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2023/4/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonSize : NSObject

/**
 是否是刘海屏

 @return yes/no
 */
+ (BOOL)isHairHead;


/**
 状态栏高度

 @return 状态栏高度
 */
+ (CGFloat)statusBar_Height;


/**
 导航栏高度

 @return 导航栏高度
 */
+ (CGFloat)navigationBar_Height;


/**
 标签栏高度

 @return 标签栏高度
 */
+ (CGFloat)tabBar_Height;
@end

NS_ASSUME_NONNULL_END
