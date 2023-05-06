//
//  UIView+Extension.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/7/22.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

/// 从 XIB 中加载视图
+ (instancetype)LoadView_FromXib;
@end

