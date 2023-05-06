//
//  KeyValueModel.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyValueEntity : NSObject
@property NSString *Key;
@property NSString *Value;
@property NSString *ValueHint;
@property NSString *Color;
@property NSString *State;
@property NSString *PictureURL;
@property NSString *num;
@property NSString *InstallState;
@property NSString *ModelID;
@end

NS_ASSUME_NONNULL_END
