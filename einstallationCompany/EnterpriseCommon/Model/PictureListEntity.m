//
//  PictureListModel.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/30.
//

#import "PictureListEntity.h"

@implementation PictureListEntity
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"imagsarr" : [PictureEntity class],
             @"imagsarr1" : [PictureEntity class],
             @"imagsarr2" : [PictureEntity class]
             };
}

@end
