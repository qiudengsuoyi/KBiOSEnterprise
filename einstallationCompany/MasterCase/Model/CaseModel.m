//
//  CaseModel.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2022/3/14.
//

#import "CaseModel.h"

@implementation CaseModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pictureList" : [PictureModel class]
             };
}
@end
