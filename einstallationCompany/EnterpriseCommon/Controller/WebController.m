//
//  WebViewViewController.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/6/7.
//

#import "WebController.h"
#import <WebKit/WebKit.h>
#import "SVProgressHUD.h"
#import "Masonry.h"


@interface WebController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation WebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    if(self.pageType == 2){
        self.navigationItem.title = @"培训详情";
    }else{
        self.navigationItem.title = @"公告详情";}
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
  

//    [self.webView clearCacheManually];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    //    self.navigationItem.title = NSLocalizedString(@"MUNLogin_《用户使用协议》",@"《用户使用协议》");
//    self.navigationItem.title = @"用户协议";
    [self addBackItem];
}



-(void)backItemAction:(UIBarButtonItem *)sender{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [SVProgressHUD dismiss];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [SVProgressHUD dismiss];
}


- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc]init];
        _webView.navigationDelegate = self;
        _webView.userInteractionEnabled = YES;
    }
    return _webView;
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
