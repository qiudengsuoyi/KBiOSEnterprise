//
//  ApproveViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/16.
//

#import "ApproveViewController.h"
#import "ItemClassOneTableViewCell.h"
#import "WalletListViewController.h"

@interface ApproveViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *fSearch;

@end

@implementation ApproveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    NSMutableArray *arrList = [NSMutableArray arrayWithCapacity:0];
    if(self.pageType ==1){
    self.navigationItem.title = @"申请审批情景";
        
  
    for(int i = 0;i<5;i++){
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        KeyValueEntity * keyValueModel = [KeyValueEntity alloc];
        keyValueModel.Value = @"2021年5月11日申请支付1300000元";
        keyValueModel.Color = @"#000000";
        [arr addObject:keyValueModel];
        keyValueModel = [KeyValueEntity alloc];
        keyValueModel.Value = @"已审批通过，未支付";
        keyValueModel.Color = @"#5586DE";
        [arr addObject:keyValueModel];
        keyValueModel = [KeyValueEntity alloc];
        keyValueModel.Value = @"";
        keyValueModel.Color = @"#000000";
        [arr addObject:keyValueModel];
        [arrList addObject:arr];
        
        arr = [NSMutableArray arrayWithCapacity:0];
        keyValueModel = [KeyValueEntity alloc];
        keyValueModel.Value = @"2021年5月11日申请支付1300000元";
        keyValueModel.Color = @"#000000";
        [arr addObject:keyValueModel];
        keyValueModel = [KeyValueEntity alloc];
        keyValueModel.Value = @"为审批通过，未支付";
        keyValueModel.Color = @"#DB1020";
        [arr addObject:keyValueModel];
        keyValueModel = [KeyValueEntity alloc];
        keyValueModel.Value = @"未通过原因：开票信息填写错误，请重新开票";
        keyValueModel.Color = @"#DB1020";
        keyValueModel.State = @"1";
        [arr addObject:keyValueModel];
        [arrList addObject:arr];
        
    }}else{
        self.navigationItem.title = @"已支付";
        for(int i = 0;i<5;i++){
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            KeyValueEntity * keyValueModel = [KeyValueEntity alloc];
            keyValueModel.Value = @"2021年5月11日申请支付1300000元";
            keyValueModel.Color = @"#000000";
            [arr addObject:keyValueModel];
            keyValueModel = [KeyValueEntity alloc];
            keyValueModel.Value = @"已审批通过，已支付";
            keyValueModel.Color = @"#53A535";
            [arr addObject:keyValueModel];
            keyValueModel = [KeyValueEntity alloc];
            keyValueModel.Value = @"";
            keyValueModel.Color = @"#000000";
            [arr addObject:keyValueModel];
            [arrList addObject:arr];
            
            
        }
        
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
    [self.tbList registerNib:[UINib nibWithNibName:NSStringFromClass([ItemClassOneTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ItemClassOneTableViewCell class])];
    self.tbList.allowsSelection = YES;
    [self.tbList reloadData];

    // Do any additional setup after loading the view from its nib.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.pageType ==1){
        WalletListViewController *vc = [[WalletListViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.pageType = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        WalletListViewController *vc = [[WalletListViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.pageType = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
 
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.muKeyValueList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ItemClassOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ItemClassOneTableViewCell class])];
    if (cell == nil) {
        cell = [[ItemClassOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
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
