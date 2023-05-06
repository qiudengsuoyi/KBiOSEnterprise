//
//  RechargeViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/8.
//

#import "RechargeViewController.h"
#import "RechargeTableViewCell.h"

@interface RechargeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbOrderList;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    NSMutableArray *arrList = [NSMutableArray arrayWithCapacity:0];
    for(int i = 0;i<10;i++){
    
       
        [arrList addObject:@"品牌名称：阿迪达斯"];

    
    }
    self.muKeyValueList = arrList;

    
    self.tbOrderList.dataSource = self;
    self.tbOrderList.delegate = self;
    // 1.设置行高为自动撑开
    self.tbOrderList.rowHeight = UITableViewAutomaticDimension;
    self.tbOrderList.allowsSelection = YES;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbOrderList.estimatedRowHeight = 80;
    self.tbOrderList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbOrderList registerNib:[UINib nibWithNibName:NSStringFromClass([RechargeTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RechargeTableViewCell class])];
    [self.tbOrderList reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    
}
-(void)viewWillDisappear:(BOOL)animated{
   
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

   
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.muKeyValueList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RechargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RechargeTableViewCell class])];
    if (cell == nil) {
        cell = [[RechargeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    
    return cell;
    
    
    
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
