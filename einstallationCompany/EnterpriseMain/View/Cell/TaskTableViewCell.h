//
//  TaskTableViewCell.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/8.
//

#import <UIKit/UIKit.h>
#import "KeyValueEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskTableViewCell : UITableViewCell
@property KeyValueEntity * taskModel;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelNum;

-(void)setTableOrder;
@end

NS_ASSUME_NONNULL_END
