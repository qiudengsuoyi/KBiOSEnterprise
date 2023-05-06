//
//  CommonSize.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2023/4/23.
//

#import "CommonSize.h"

@implementation CommonSize

+ (CGFloat)statusBar_Height{
    return [CommonSize isHairHead] ? 44.f : 20.f;
}

+ (CGFloat)navigationBar_Height{
    return [CommonSize isHairHead] ? 88.f : 64.f;
}

+ (CGFloat)tabBar_Height{
    return [CommonSize isHairHead] ? 83.f : 49.f;
}

+ (BOOL)isHairHead {
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return [CommonSize safeAreaInset].left > 0.0f;
    }else { // ios12 非刘海屏状态栏 20.0f
        return [CommonSize safeAreaInset].top > 20.0f;
    }
}

+ (UIEdgeInsets)safeAreaInset {
    if (@available(iOS 11.0, *)) {
        if ([UIApplication sharedApplication].keyWindow) {
            return [UIApplication sharedApplication].keyWindow.safeAreaInsets;
        }
    }
    return UIEdgeInsetsZero;
}
@end
