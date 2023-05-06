//
//  WaitOrderItemTableViewCell.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/24.
//

#import <UIKit/UIKit.h>
#import "KeyValueEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaitTaskItemTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property NSMutableArray<KeyValueEntity*> * keyValueList;
@property (weak, nonatomic) IBOutlet UITableView *tbOrder;
-(void)setTableOrder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellConstrainHeight;
@end

NS_ASSUME_NONNULL_END
