//
//  RPSBaseView.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/7/22.
//

#import "EnterpriseBaseView.h"

@implementation EnterpriseBaseView

- (instancetype)init{
    
    if ( self = [super init]) {
        self.userInteractionEnabled = YES;
        [self addUITapGestureRecognizer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self addUITapGestureRecognizer];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    [self addUITapGestureRecognizer];
}

- (void)addUITapGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap:)];
    [self addGestureRecognizer:tap];
}

- (void)doTap:(UITapGestureRecognizer *)tap{
    if (self.clickAction) {
        self.clickAction();
    }
}

@end
