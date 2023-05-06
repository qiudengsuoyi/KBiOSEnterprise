//
//  TrainingViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/12.
//

#import "EnterpriseTrainingController.h"
#import "NoticeTableViewCell.h"


@interface EnterpriseTrainingController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation EnterpriseTrainingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    self.navigationItem.title = @"培训中心";
    self.noticeList = [NSMutableArray arrayWithCapacity:0];
    NoticeEntity * noticeModel ;
    for(int i = 0;i<10;i++){
        noticeModel = [NoticeEntity alloc];
        [self.noticeList addObject:noticeModel];
    }
    
    self.tbNotice.dataSource = self;
    self.tbNotice.delegate = self;
    // 1.设置行高为自动撑开
    self.tbNotice.rowHeight = UITableViewAutomaticDimension;
    self.tbNotice.allowsSelection = NO;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbNotice.estimatedRowHeight = (SCREENWIDTH-60)*0.17;
    self.tbNotice.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbNotice.allowsSelection = YES;
    [self.tbNotice registerNib:[UINib nibWithNibName:NSStringFromClass([NoticeTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([NoticeTableViewCell class])];
    [self.tbNotice reloadData];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.noticeList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoticeTableViewCell class])];
    if (cell == nil) {
        cell = [[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([NoticeTableViewCell class])] ;
    }
    NoticeEntity* itemModelList = [self.noticeList objectAtIndex:indexPath.row];
    cell.model = itemModelList;
//    [cell setTableOrder];
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
