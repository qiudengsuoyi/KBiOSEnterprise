//
//  MainScrollViewCell.h
//  einstallationCompany
//
//  Created by 云位 on 2023/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainScrollViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tvTitle;
@property (weak, nonatomic) IBOutlet UILabel *tvContent;
@property (weak, nonatomic) IBOutlet UILabel *tvInstallState;
@property (weak, nonatomic) IBOutlet UILabel *tvAdress;

@end

NS_ASSUME_NONNULL_END
