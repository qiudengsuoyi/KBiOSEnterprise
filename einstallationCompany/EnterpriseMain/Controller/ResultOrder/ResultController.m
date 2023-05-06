//
//  ResultOrderViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/4/24.
//

#import "ResultController.h"
#import "GrabOrderTabViewController.h"

@interface ResultController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vConstraintHeight;
@property (weak, nonatomic) IBOutlet UIImageView *ivResult;
@property (weak, nonatomic) IBOutlet UILabel *label01;
@property (weak, nonatomic) IBOutlet UILabel *label02;

@end

@implementation ResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.returnType == 1){
        [self addBackItemSelf];
        
    }else{
            [self addBackItem];
        }
    self.vConstraintHeight.constant = (SCREENWIDTH-140)/505*694+100;
    self.label01.text = self.strContent01;
    self.label02.text = self.strContent02;
    self.navigationItem.title = self.strTitle;
    if(self.resultType == 1){
        self.ivResult.image = [UIImage imageNamed:@"enterprise_result_01"];
    }else{
        self.ivResult.image = [UIImage imageNamed:@"enterprise_result_02"];
    }
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)addBackItemSelf{
    //创建返回按钮
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 25,25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];;
    //创建UIBarButtonSystemItemFixedSpace
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = 15;
    //将两个BarButtonItem都返回给NavigationItem
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarBtn];
    
}

-(void)backItem{
    
    GrabOrderTabViewController * vc = [GrabOrderTabViewController alloc];
    vc.hidesBottomBarWhenPushed = YES;
    [self jumpViewControllerAndCloseSelf:vc];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
