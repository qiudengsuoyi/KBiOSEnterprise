//
//  GrabOrderDetailViewController.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/18.
//

#import "EnterpriseBaseController.h"
#import "KeyValueEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface GrabDetailController : EnterpriseBaseController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbOrder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbOrderConstraintHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *btConfirm;
@property NSMutableArray <KeyValueEntity*> * keyValueList;
@property NSInteger pageType;

@end

NS_ASSUME_NONNULL_END
