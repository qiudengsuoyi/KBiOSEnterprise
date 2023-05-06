//
//  NoticeTableViewCell.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/5.
//

#import <UIKit/UIKit.h>
#import "NoticeEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property NoticeEntity * model;
-(void)setNotice:(NoticeEntity*)model;
@end

NS_ASSUME_NONNULL_END
