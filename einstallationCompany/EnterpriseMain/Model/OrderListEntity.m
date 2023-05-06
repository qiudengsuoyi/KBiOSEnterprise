//
//  OrderList.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/20.
//

#import "OrderListEntity.h"

@implementation OrderListEntity
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"resultarr" : [KeyValueEntity class]
             };
}
@end
