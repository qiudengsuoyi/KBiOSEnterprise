//
//  MainNumModel.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/28.
//

#import "MainNumEntity.h"

@implementation MainNumEntity
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Noticearr" : [NoticeEntity class],
        @"bannerarr":[NSString class],
        @"rollarr":[NSString class]
    };
}
@end
