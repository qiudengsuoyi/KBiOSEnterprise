//
//  GrabOrderTableViewCell.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/28.
//

#import "GrabTaskTableViewCell.h"
#import "OrderItemTableViewCell.h"
#import "GrabSingleListViewController.h"
#import "UIViewController+GetCurrentUIVC.h"
#import <YYKit/YYKit.h>
#import "PayViewController.h"
#import "PayOrderEditViewController.h"

@implementation GrabTaskTableViewCell

- (IBAction)actionEdit:(id)sender {
    if (self.editBlock) {
        self.editBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.btEdit.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CAShapeLayer * mask  = [[CAShapeLayer alloc] init];
    mask.lineCap = kCALineCapSquare;
    mask.path = path.CGPath;
    self.btEdit.layer.mask = mask;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.keyValueList.count;
    
}

-(void)setTableOrder{
    self.tbOrder.dataSource = self;
    self.tbOrder.delegate = self;
    // 1.设置行高为自动撑开
    self.tbOrder.rowHeight = UITableViewAutomaticDimension;
    self.tbOrder.allowsSelection = NO;
    //2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
    self.tbOrder.estimatedRowHeight = 40;
    self.tbOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbOrder registerNib:[UINib nibWithNibName:NSStringFromClass([OrderItemTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderItemTableViewCell class])];
    [self.tbOrder reloadData];
    [self.bt03 setTitle:self.model.applytype forState:UIControlStateNormal];
    [self.bt01 setTitle:self.model.applytype forState:UIControlStateNormal];
    self.btEdit.hidden = YES;
            self.btEdit.hidden = YES;
            switch ([self.OrderState intValue]) {
                case 0:
                    self.bt01.hidden = NO;
                    self.bt02.hidden = NO;
                    self.bt03.hidden = YES;
                    
                    break;
                case 1:
                    self.bt01.hidden = YES;
                    self.bt02.hidden = YES;
                    self.bt03.hidden = NO;
                 
                    self.bt03.backgroundColor = [UIColor darkGrayColor];
                    [self.bt03 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    break;
              
                    
                    
                default:
                    self.bt01.hidden = YES;
                    self.bt02.hidden = YES;
                    self.bt03.hidden = NO;
                
                    self.bt03.backgroundColor = [UIColor colorWithHexString:@"#DE6D55"];
                    [self.bt03 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    break;
            }
            
            
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderItemTableViewCell class])];
    if (cell == nil) {
        cell = [[OrderItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    KeyValueEntity *itemModel = [self.keyValueList objectAtIndex:indexPath.row];
    cell.itemModel = itemModel;
    CGFloat itemHeight = [(NSString *)itemModel.Value boundingRectWithSize:CGSizeMake((SCREENWIDTH-160), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+15;
    cell.vConstraintHeight.constant = itemHeight;
    
    [cell setModel: cell.itemModel];
    return cell;
    
}

- (IBAction)actionCancel:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (IBAction)actionConfirm:(id)sender {
    
        if (self.confirmBlock) {
            self.confirmBlock();
        }
}


- (IBAction)actionDetail:(id)sender {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
       
        
   
}



@end
