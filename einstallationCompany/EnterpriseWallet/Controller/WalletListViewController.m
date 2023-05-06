//
//  WalletListViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/16.
//

#import "WalletListViewController.h"
#import "OrderTableViewCell.h"
#import "WaitTaskDetailController.h"

@interface WalletListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end

@implementation WalletListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    if(self.pageType ==1){
        self.navigationItem.title = @"花费明细";
        self.labelTitle.text =@"花费支付金额";
     
    }else if(self.pageType ==2){
        self.navigationItem.title = @"支付明细";
        self.labelTitle.text =@"已支付金额";
    }else{
        self.navigationItem.title = @"完成未支付订单";}
    
    NSMutableArray *arrList = [NSMutableArray arrayWithCapacity:0];
    for(int i = 0;i<10;i++){
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        KeyValueEntity * keyValueModel = [KeyValueEntity alloc];
        keyValueModel.PictureURL = @"";
        keyValueModel.Value = @"商场海报安装";
        keyValueModel.Color = @"#000000";
        [arr addObject:keyValueModel];
        keyValueModel = [KeyValueEntity alloc];
        keyValueModel.PictureURL = @"";
        keyValueModel.Value = @"商场海报安装商场海报安装商场海报安装商场海报安装商场海报安装商场海报安装商场海报安装";
        keyValueModel.Color = @"#7D7D7D";
        [arr addObject:keyValueModel];
        keyValueModel = [KeyValueEntity alloc];
        keyValueModel.PictureURL = @"";
        keyValueModel.Value = @"商场海报安装";
        keyValueModel.Color = @"#5586DE";
        [arr addObject:keyValueModel];
        [arrList addObject:arr];
        
    }
    self.muKeyValueList = arrList;
    
    self.tbList.dataSource = self;
    self.tbList.delegate = self;
    // 1.设置行高为自动撑开
    self.tbList.rowHeight = UITableViewAutomaticDimension;
    self.tbList.allowsSelection = NO;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbList.estimatedRowHeight = 120;
    self.tbList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbList registerNib:[UINib nibWithNibName:NSStringFromClass([OrderTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderTableViewCell class])];
    self.tbList.allowsSelection = YES;
    [self.tbList reloadData];

    // Do any additional setup after loading the view from its nib.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    WaitTaskDetailController *vc = [[WaitTaskDetailController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.muKeyValueList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderTableViewCell class])];
    if (cell == nil) {
        cell = [[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    NSMutableArray <KeyValueEntity*> *itemModelList = [self.muKeyValueList objectAtIndex:indexPath.row];
    cell.keyValueList = itemModelList;
    CGFloat itemHeight;
    CGFloat totalHeight = 0;
    for (KeyValueEntity *itemModel in itemModelList) {
        itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-180), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
        totalHeight = totalHeight+itemHeight;
    }
    cell.cellConstrainHeight.constant = totalHeight+15;
    [cell setTableOrder];
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
