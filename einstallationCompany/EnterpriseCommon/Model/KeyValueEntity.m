//
//  KeyValueModel.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/23.
//

#import "KeyValueEntity.h"

@implementation KeyValueEntity
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Color":@"color",
             @"Value":@"title",
             @"PictureURL":@"icon"
    };
}
@end
