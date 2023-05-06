//
//  InstallViewController.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/16.
//

#import "EnterpriseBaseController.h"
#import "KeyValueEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstallViewController : EnterpriseBaseController
@property (weak, nonatomic) IBOutlet UITextField *fSearch;
@property (weak, nonatomic) IBOutlet UITableView *tbList;
@property (weak, nonatomic) IBOutlet UIButton *btSubmit;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelMoney;
@property NSMutableArray<NSMutableArray<KeyValueEntity*> *> * muKeyValueList;
@property NSInteger pageType;
@end

NS_ASSUME_NONNULL_END
