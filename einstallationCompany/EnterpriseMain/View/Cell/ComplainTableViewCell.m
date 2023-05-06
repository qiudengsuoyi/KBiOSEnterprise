//
//  ComplainTableViewCell.m
//  einstallationCompany
//
//  Created by 云位 on 2022/9/9.
//

#import "ComplainTableViewCell.h"

@implementation ComplainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(KeyValueEntity*)model{
    model = self.itemModel;
  
    self.labelKey.text =[@"投诉时间：" stringByAppendingFormat:@"%@", model.Key];

    self.labelValue.text = [@"" stringByAppendingFormat:@"%@", model.Value];
    NSString *string = self.labelValue.text;
    const CGFloat fontSize = 14.0;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSUInteger length = [string length];
    //设置字体
    UIFont *baseFont = [UIFont systemFontOfSize:fontSize];
    [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(0, length)];//设置所有的字体
    UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
    [attrString addAttribute:NSFontAttributeName value:boldFont range:[string rangeOfString:model.Key]];//设置Text这四个字母的字体为粗体
    self.labelValue.attributedText = attrString;

   

}

@end
