//
//  BaseViewController.h
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnterpriseBaseController : UIViewController
- (void)addBackItem;

- (void)addNOBackItem;

-(void)backItemAction:(UIBarButtonItem *)sender;

-(void)jumpViewControllerAndCloseSelf:(UIViewController *)vc;


- (NSString *) utf82gbk:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
