//
//  WalletListViewController.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/16.
//

#import "EnterpriseBaseController.h"
#import "KeyValueEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletListViewController : EnterpriseBaseController
@property (weak, nonatomic) IBOutlet UITableView *tbList;
@property (weak, nonatomic) IBOutlet UIButton *btSearch;
@property (weak, nonatomic) IBOutlet UILabel *labelMoney;
@property NSInteger pageType;
@property NSMutableArray<NSMutableArray<KeyValueEntity*> *> * muKeyValueList;
@end

NS_ASSUME_NONNULL_END
