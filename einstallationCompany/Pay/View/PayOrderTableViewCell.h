//
//  PayOrderTableViewCell.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayOrderTableViewCell : UITableViewCell
@property NSString * strContent;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
-(void)setModel;
@end

NS_ASSUME_NONNULL_END
