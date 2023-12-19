//
//  GrabPictureViewController.h
//  einstallationCompany
//
//  Created by 云位 on 2023/9/14.
//

#import "EnterpriseBaseController.h"
#import "PictureListEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface GrabPictureViewController : EnterpriseBaseController<UICollectionViewDataSource,UICollectionViewDelegate>
@property NSString * recordID;
@property PictureListEntity *pictureListModel;

@end

NS_ASSUME_NONNULL_END
