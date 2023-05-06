//
//  Network.m
//  com.chengdushanghai.einstallation
//
//  Created by 云位 on 2021/5/26.
//


#import "EnterpriseNetwork.h"
#import <AFNetworking.h>
#import "APIConst.h"
#import "SVProgressHUD.h"
#import "NSString+YYAdd.h"
#import "YYReachability.h"


@implementation EnterpriseNetwork
{
    BOOL _isShowNetworkPower;
}
+ (EnterpriseNetwork *)sharedManager {
    static EnterpriseNetwork *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[EnterpriseNetwork alloc] initWithBaseURL:[NSURL URLWithString:ENTERPRISE_SERVER_HOST]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html",@"application/text",@"multipart/form-data", nil];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return manager;
}


+ (EnterpriseNetwork *)sharedOtherManager {
    static EnterpriseNetwork *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[EnterpriseNetwork alloc] initWithBaseURL:[NSURL URLWithString:ENTERPRISE_SERVER_OTHER_HOST]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html",@"application/text",@"multipart/form-data", nil];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return manager;
}


- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        self.requestSerializer = [AFHTTPRequestSerializer serializer] ;
        
        //        self.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        self.requestSerializer.timeoutInterval = 30.f;
        [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        //        self.securityPolicy.allowInvalidCertificates = YES;
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy = securityPolicy;
        
    }
    return self;
}

- (void)cancelRequest
{
    if ([self.tasks count] > 0) {
        NSLog(@"返回时取消网络请求");
        [self.tasks makeObjectsPerformSelector:@selector(cancel)];
        //NSLog(@"tasks = %@",manager.tasks);
    }
}
/**
 请求
 
 @param path url
 @param params 请求参数
 @param type 请求类型
 @param block 返回
 */
- (void)requestJsonDataWithPath:(NSString *)path
                     withParams:(id)params
                 withMethodType:(RequestType)type
                       andBlock:(void (^)(id data, id error))block{
    if (!path|| ![path isNotBlank]) {
        if ([SVProgressHUD isVisible])[SVProgressHUD dismiss];
        return;
    }
    
    if(!YYReachability.reachability.reachable){
        if ([SVProgressHUD isVisible])[SVProgressHUD dismiss];
        //        [SVProgressHUD showErrorWithStatus:@"当前网络不可用"];
        if (!_isShowNetworkPower) {
            [self dealNetworkPower];
        }
        block(nil,@(YYLLoadErrorTypeNoNetwork));
        return;
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user valueForKey:@"token"];
    if ([token isNotBlank]) {
        [self.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    }
    __weak typeof(self) weakSelf = self;
    switch (type) {
        case TypeIsGET:{
            
            [self GET:path parameters:params headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([SVProgressHUD isVisible])[SVProgressHUD dismiss];
                block(responseObject,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if ([SVProgressHUD isVisible])[SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:error.code == -1001 ? @"连接服务器超时！" : @"服务器出错，请稍后再试！"];
                block(nil,@(YYLLoadErrorTypeRequest));
            }];
        }
            break;
        case TypeIsPOST:{
            NSLog(@"%@",path);
            [self POST:path parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    NSString* str = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:gbkEncoding];
                
              
           
                if ([SVProgressHUD isVisible])[SVProgressHUD dismiss];
                block([EnterpriseNetwork dictionaryWithJsonString:str],nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if ([SVProgressHUD isVisible])[SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:error.code == -1001 ? @"连接服务器超时！" : @"服务器出错，请稍后再试！"];
                block(nil,@(YYLLoadErrorTypeRequest));
            }];
        }
            break;
        case TypeIsPUT:{
            [self PUT:path parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                block(responseObject,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                block(nil,error);
                
                [SVProgressHUD showErrorWithStatus:error.code == -1001 ? @"连接服务器超时" : [weakSelf tipFromError:error]];
            }];
        }
            
        default:
            break;
    }
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError =nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
#pragma mark Tip M
- (NSString *)tipFromError:(NSError *)error{
    if (error && error.userInfo) {
        NSMutableString *tipStr = [[NSMutableString alloc] init];
        if ([error.userInfo objectForKey:@"msg"]) {
            if([[error.userInfo objectForKey:@"msg"] isKindOfClass: [NSNull class]]){
                //                [tipStr appendString: @"请求失败"];
            }
            else{
                [tipStr appendString:[error.userInfo objectForKey:@"msg"]];
            }
        }else{
            if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                tipStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            }else{
                [tipStr appendFormat:@"ErrorCode%ld", (long)error.code];
            }
        }
        return tipStr;
    }
    return nil;
}


// 处理网络问题
- (void)dealNetworkPower
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法访问网络"
                                                        message:@"我们无法访问您的网络，请尝试打开<无线局域网>、<蜂窝移动网络>，或者单击<前往设置>->进入<无线数据>，将其设为<无线局域网与蜂窝移动数据>，并重返回云位订吧！"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"前往设置", nil];
    alertView.tag = 1000;
    //    [alertView addButtonWithTitle:@"123"];
    [alertView show];
    _isShowNetworkPower = YES;
}

#pragma mark - delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            NSLog(@"前往设置");
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }else{
            _isShowNetworkPower = YES;
        }
    }
}



+(NSDictionary*)dictionaryWithJsonString:(NSString*)jsonString {
    
    if(jsonString ==nil) {
        
        return nil;
        
    }
    
    NSData*jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError*err;
    
    NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:jsonData
                        
                                                       options:NSJSONReadingMutableContainers
                        
                                                         error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
    }
    

    

    
    return dic;
    
}


@end
