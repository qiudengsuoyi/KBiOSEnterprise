//
//  ComplainModifyViewController.m
//  einstallationCompany
//
//  Created by 云位 on 2022/9/11.
//

#import "ComplainModifyViewController.h"
#import "WSPlaceholderTextView.h"
#import "SVProgressHUD.h"
#import "APIConst.h"
#import "EnterpriseMainService.h"
#import "DialogOneView.h"
#import "UIView+Extension.h"

@interface ComplainModifyViewController ()
@property (weak, nonatomic) IBOutlet WSPlaceholderTextView *etComplain;


@end

@implementation ComplainModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = @"修改投诉";
    self.etComplain.placeholder = @"请输入投诉信息";
    self.etComplain.text = self.complainContent;
    self.etComplain.layer.borderWidth = 0.5;
    self.etComplain.layer.borderColor = [UIColor grayColor].CGColor;
}


- (IBAction)actionComplain:(id)sender {
    if(self.etComplain.text.length<1){
        [SVProgressHUD showErrorWithStatus:@"请输入投诉信息"];
        return;
    }
    if([self.etComplain.text isEqualToString:self.complainContent]){
        [SVProgressHUD showErrorWithStatus:@"投诉未更改！"];
        return;
    }
    NSDictionary *dic = @{
        @"cid":self.complainID,
        @"ComplaintContent":[self utf82gbk:self.etComplain.text]
    };
    [EnterpriseMainService requestComplainModify:dic andResultBlock:^(id  _Nonnull data, id  _Nonnull error) {
        if (data) {
            if([data[@"code"] intValue] == 1){
                [self showOneDialogView:data[@"msg"] withRightButtonTitle:@"确定"];
            }
        }
    }];
}

- (void)showOneDialogView:(NSString *) strContent withRightButtonTitle:(NSString *) strRightButtonName{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    DialogOneView *view = [DialogOneView LoadView_FromXib];
    view.frame = window.frame;
    view.laContent.text = strContent;
    [view.btRight setTitle:strRightButtonName forState:UIControlStateNormal];
    CGFloat itemHeight = [(NSString *)strContent boundingRectWithSize:CGSizeMake((SCREENWIDTH-80), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    view.constraintViewHeight.constant = 220+itemHeight;
    __weak typeof(view) weakView = view;
    view.confirmBlock  = ^{
        [self.navigationController popViewControllerAnimated:YES];
        [weakView removeFromSuperview];
    };
    
    [window addSubview:view];
}

@end
