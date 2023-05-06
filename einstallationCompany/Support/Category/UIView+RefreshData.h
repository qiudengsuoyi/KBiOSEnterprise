//
//  UIView+RefreshData.h
//  ReservedParkingSpace
//
//  Created by Administrator on 2019/8/21.
//  Copyright © 2019 yunqwi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>


typedef NS_ENUM(NSInteger, YYLLoadErrorType){
    YYLLoadErrorTypeDefalt,
    YYLLoadErrorTypeNoNetwork,      //没有网络
    YYLLoadErrorTypeRequest,        //请求接口 后台报错
    YYLLoadErrorTypeNoData,         //当前页面没有数据
};
typedef void(^RERefreshViewRefreshingBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface UIView (RefreshData)

/**
 *  刷新调用的Block
 */
@property(nonatomic, copy) RERefreshViewRefreshingBlock headerRefreshingBlock;




//***********************************错误处理显示页面***********************

/**
 *  设置页面显示的类型
 */
@property(nonatomic, assign) YYLLoadErrorType loadErrorType;

///**
// *  数据是否全部加载完
// */
//@property(nonatomic, assign) BOOL isDataLoaded;

/**
 是否第一次加载
 */
//@property(nonatomic, assign) BOOL isFirstLoading;



/**
 *  没有网络时显示的视图
 */
@property(nonatomic, strong) UIView *refreshNoNetworkView;

/**
 *  访问出错时显示的视图
 */
@property(nonatomic, strong) UIView *refreshRequestErrorView;

/**
 *  没有数据显示的视图
 */
@property(nonatomic, strong) UIView *refreshNoDataView;

@end

NS_ASSUME_NONNULL_END
