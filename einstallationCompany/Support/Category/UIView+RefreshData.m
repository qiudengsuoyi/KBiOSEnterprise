//
//  UIView+RefreshData.m
//  ReservedParkingSpace
//
//  Created by Administrator on 2019/8/21.
//  Copyright © 2019 yunqwi. All rights reserved.
//

#import "UIView+RefreshData.h"
#import "YYLRefreshNoNetworkView.h"
#import "YYLRefreshRequestErrorView.h"
#import "YYLRefreshNoDataView.h"
#import "MASConstraintMaker.h"
#import "View+MASAdditions.h"
#import <UIKit/UIKit.h>
#import "LBLaunchImageAdView.h"
#import "UIColor+YYAdd.h"

static char headerRefreshingBlockKey;
static char footerRefreshingBlockKey;
static char refreshNoNetworkViewKey;
static char refreshRequestErrorViewKey;
static char refreshNoDataViewKey;
static char loadErrorTypeKey;
//static char isFirstLoadingKey;
@implementation UIView (RefreshData)

//@dynamic isDataLoaded, isShowHeaderRefresh, isShowFooterRefresh, loadErrorType, refreshErrorTableView;



//- (void)setIsFirstLoading:(BOOL)isFirstLoading {
//    objc_setAssociatedObject(self, &isFirstLoadingKey, @(isFirstLoading), OBJC_ASSOCIATION_COPY_NONATOMIC);
//}

//- (BOOL)isFirstLoading {
//    return [objc_getAssociatedObject(self, &isFirstLoadingKey) boolValue];
//}

- (UIView *)refreshNoNetworkView {
    YYLRefreshNoNetworkView *rNoNetworkView = objc_getAssociatedObject(self, &refreshNoNetworkViewKey);
    if (!rNoNetworkView) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        rNoNetworkView = [[YYLRefreshNoNetworkView alloc] initWithFrame:frame];
        
        __weak typeof(self) weakSelf = self;
        rNoNetworkView.refreshNoNetworkViewBlock = ^() {
            !weakSelf.headerRefreshingBlock? :weakSelf.headerRefreshingBlock();
        };
        self.refreshNoNetworkView = rNoNetworkView;
    }
    return rNoNetworkView;
}

- (void)setRefreshNoNetworkView:(UIView *)refreshNoNetworkView {
    if (refreshNoNetworkView) {
        objc_setAssociatedObject(self, &refreshNoNetworkViewKey, refreshNoNetworkView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIView *)refreshRequestErrorView {
    YYLRefreshRequestErrorView *rRequestErrorView = objc_getAssociatedObject(self, &refreshRequestErrorViewKey);
    if (!rRequestErrorView) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        rRequestErrorView = [[YYLRefreshRequestErrorView alloc] initWithFrame:frame];
        __weak typeof(self) weakSelf = self;
        rRequestErrorView.refreshRequestErrorViewBlock = ^() {
            !weakSelf.headerRefreshingBlock? :weakSelf.headerRefreshingBlock();
        };
        self.refreshRequestErrorView = rRequestErrorView;
    }
    return rRequestErrorView;
}

- (void)setRefreshRequestErrorView:(YYLRefreshRequestErrorView *)refreshRequestErrorView {
    if (refreshRequestErrorView) {
        objc_setAssociatedObject(self, &refreshRequestErrorViewKey, refreshRequestErrorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIView *)refreshNoDataView {
    UIView *rNoDataView = objc_getAssociatedObject(self, &refreshNoDataViewKey);
    if (!rNoDataView) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        rNoDataView = [[YYLRefreshNoDataView alloc] initWithFrame:frame];
        objc_setAssociatedObject(self, &refreshNoDataViewKey, rNoDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return rNoDataView;
}

- (void)setRefreshNoDataView:(UIView *)refreshNoDataView {
    if (refreshNoDataView) {
        objc_setAssociatedObject(self, &refreshNoDataViewKey, refreshNoDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setHeaderRefreshingBlock:(RERefreshViewRefreshingBlock)headerRefreshingBlock {
    objc_setAssociatedObject(self, &headerRefreshingBlockKey, headerRefreshingBlock, OBJC_ASSOCIATION_COPY);
}

- (RERefreshViewRefreshingBlock)headerRefreshingBlock {
    RERefreshViewRefreshingBlock headerRefreshingBlock = objc_getAssociatedObject(self, &headerRefreshingBlockKey);
    return headerRefreshingBlock;
}

- (void)setFooterRefreshingBlock:(RERefreshViewRefreshingBlock)footerRefreshingBlock {
    objc_setAssociatedObject(self, &footerRefreshingBlockKey, footerRefreshingBlock, OBJC_ASSOCIATION_COPY);
}

- (RERefreshViewRefreshingBlock)footerRefreshingBlock {
    RERefreshViewRefreshingBlock footerRefreshingBlock = objc_getAssociatedObject(self, &footerRefreshingBlockKey);
    return footerRefreshingBlock;
}

- (void)setLoadErrorType:(YYLLoadErrorType)loadErrorType {
    [self removeAllErrorView];
    if (loadErrorType == YYLLoadErrorTypeNoNetwork) {
//        self.isShowFooterRefresh = NO;
        [self addSubview:self.refreshNoNetworkView];
        [self.refreshNoNetworkView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(self.mas_width);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.mas_height);
        }];
        
    } else if (loadErrorType == YYLLoadErrorTypeRequest) {
//        self.isShowFooterRefresh = NO;
        [self addSubview:self.refreshRequestErrorView];
        [self.refreshRequestErrorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(self.mas_width);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.mas_height);
        }];
    } else if (loadErrorType == YYLLoadErrorTypeNoData) {
//        self.isShowFooterRefresh = NO;
        [self addSubview:self.refreshNoDataView];
        [self.refreshNoDataView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(self.mas_width);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.mas_height);
        }];
        
    }
    objc_setAssociatedObject(self, &loadErrorTypeKey, @(loadErrorType), OBJC_ASSOCIATION_ASSIGN);
    
}
- (void)removeAllErrorView{
    if (self.refreshNoNetworkView.superview) [self.refreshNoNetworkView removeFromSuperview];
    if (self.refreshRequestErrorView.superview) [self.refreshRequestErrorView removeFromSuperview];
    if (self.refreshNoDataView.superview) [self.refreshNoDataView removeFromSuperview];
}

- (YYLLoadErrorType)loadErrorType {
    return [objc_getAssociatedObject(self, &loadErrorTypeKey) integerValue];
}
@end
