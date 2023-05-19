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
@property NSMutableArray <KeyValueEntity*> * keyValueList;
@property NSInteger pageType;
@property NSString* recordID;
@property (weak, nonatomic) IBOutlet JWStarView *starView;
@property (weak, nonatomic) IBOutlet UIView *vEvaluate;


@end

NS_ASSUME_NONNULL_END
