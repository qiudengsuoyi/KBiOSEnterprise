//
//  MainNumModel.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/28.
//

#import <Foundation/Foundation.h>
#import "NoticeEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainNumEntity : NSObject
@property NSString * acceptnum;
@property NSString * overtimenum;
@property NSMutableArray <NoticeEntity*> *Noticearr;
@end

NS_ASSUME_NONNULL_END
