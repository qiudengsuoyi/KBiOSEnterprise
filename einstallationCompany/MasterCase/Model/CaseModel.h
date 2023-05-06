//
//  CaseModel.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2022/3/14.
//

#import <Foundation/Foundation.h>
#import "PictureModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CaseModel : NSObject
@property NSString * caseID;
@property NSString * caseTitle;
@property NSString * caseType;//区分最后一张图片
@property NSMutableArray<PictureModel*> *pictureList;
@end

NS_ASSUME_NONNULL_END
