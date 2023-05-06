//
//  DialogTwoButton.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/7/22.
//

#import "DialogTwoButtonView.h"
#import <WebKit/WebKit.h>
#import "UIViewController+GetCurrentUIVC.h"

@implementation DialogTwoButtonView

- (IBAction)actionLeft:(id)sender {
        self.cancelBlock();
}


- (IBAction)actionRight:(id)sender {
    self.confirmBlock();
}

@end

