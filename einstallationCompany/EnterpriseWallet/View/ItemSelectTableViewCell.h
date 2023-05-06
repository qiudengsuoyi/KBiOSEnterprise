//
//  ItemSelectTableViewCell.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/16.
//

#import <UIKit/UIKit.h>
#import "KeyValueEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemSelectTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbOrder;
@property NSMutableArray<KeyValueEntity*> * keyValueList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellConstrainHeight;
-(void)setTableOrder;
@end

NS_ASSUME_NONNULL_END
