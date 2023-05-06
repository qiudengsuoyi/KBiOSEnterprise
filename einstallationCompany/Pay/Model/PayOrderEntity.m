//
//  PayOrderModel.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/8/23.
//

#import "PayOrderEntity.h"

@implementation PayOrderEntity
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"datelist" : [NSString class]
             };
}
@end
