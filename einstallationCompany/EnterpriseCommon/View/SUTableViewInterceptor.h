//
//  SUTableViewInterceptor.h
//  einstallationCompany
//
//  Created by 云位 on 2023/8/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SUTableViewInterceptor : NSObject

@property (nonatomic, weak) id receiver;
@property (nonatomic, weak) id middleMan;

@end


NS_ASSUME_NONNULL_END
