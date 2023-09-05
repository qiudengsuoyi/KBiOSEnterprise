//
//  ResultOrderViewController.m
//  einstallationCompany
//
//  Created by 云位 on 2023/8/20.
//

#import "ResultOrderViewController.h"
#import "GrabOrderTabViewController.h"
#import "AppDelegate.h"

@interface ResultOrderViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vConstraintHeight;
@property (weak, nonatomic) IBOutlet UIImageView *ivResult;
@end

@implementation ResultOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItemSelf];
    self.navigationItem.title = @"发布成功";
    self.ivResult.image = [UIImage imageNamed:@"enterprise_result_01"];
    self.vConstraintHeight.constant = (SCREENWIDTH-140)/505*694+200;
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
    [self.navigationController popViewControllerAnimated:NO];
}


- (IBAction)actionList:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.tabBarVC.selectedIndex = 2;
}



- (IBAction)actionGrab:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}


@end
