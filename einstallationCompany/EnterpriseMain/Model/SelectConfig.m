//
//  SelectConfig.m
//  einstallationCompany
//
//  Created by 云位 on 2023/8/16.
//

#import "SelectConfig.h"

@implementation SelectConfig
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list1" : [NSString class],
        @"list2" : [NSString class],
        @"list3" : [NSString class],
        @"list4" : [NSString class],
        @"list5" : [NSString class]
    };
}
@end
