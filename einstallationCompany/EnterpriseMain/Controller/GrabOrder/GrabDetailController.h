//
//  GrabOrderDetailViewController.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/18.
//

#import "EnterpriseBaseController.h"
#import "KeyValueEntity.h"
#import "JWStarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GrabDetailController : EnterpriseBaseController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbOrder;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbOrderConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewConstraintHeight;
@property NSMutableArray <KeyValueEntity*> * keyValueList;
@property NSInteger pageType;
@property NSString* recordID;
@property (weak, nonatomic) IBOutlet JWStarView *starView;
@property (weak, nonatomic) IBOutlet UIView *vEvaluate;
@property (weak, nonatomic) IBOutlet UIView *vIssue;
@property (weak, nonatomic) IBOutlet UILabel *tvAudit;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionImageHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionVideo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionVideoHeight;
@property (weak, nonatomic) IBOutlet UIButton *btPicture;


@end

NS_ASSUME_NONNULL_END
