//
//  ViewController.m
//  leqiH5Game
//
//  Created by zhangkai on 2018/6/21.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "ViewController.h"

#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>

#import "GameWebView.h"
#import "Common.h"

@interface ViewController ()<WKNavigationDelegate>

@property (nonatomic, copy) NSString *gameUrl;
@property (nonatomic, strong) GameWebView *gameWebView;
@property (nonatomic, weak) IBOutlet UIImageView *gameImageView;
@property (nonatomic, weak) IBOutlet UITextField *gameProcessTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _gameUrl = GAME_URL;
    _gameWebView = [[GameWebView alloc] init];
    _gameWebView.navigationDelegate = self;
    _gameWebView.customUserAgent = [NSString stringWithFormat:@"iOS-%@", [self getSysytemInfo]];
    [_gameWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.view addSubview:_gameWebView];
    
    
    [_gameWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_gameUrl]]];
    
    [self.view bringSubviewToFront:_gameImageView];
    [self.view bringSubviewToFront:_gameProcessTextField];
}


- (NSString *)getSysytemInfo {
    UIDevice *device = [UIDevice currentDevice];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *model = [NSString stringWithCString:systemInfo.machine
                                         encoding:NSUTF8StringEncoding];

    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    idfa = [[idfa stringByReplacingOccurrencesOfString:@"-"
                                            withString:@""] lowercaseString];
    return [NSString stringWithFormat:@"%@-%@-%@-%@",
            idfa,
            device.name,
            model,
            device.systemVersion
            ];
}

- (void)viewDidLayoutSubviews {
    _gameWebView.frame = self.view.bounds;
    _gameImageView.frame = self.view.bounds;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
     [_gameWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_gameUrl]]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        _gameProcessTextField.text = [NSString stringWithFormat:@"加载%d%%...",
                                      (int)(_gameWebView.estimatedProgress * 100)];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    _gameProcessTextField.text = @"加载完成";
    _gameProcessTextField.hidden = YES;
    _gameImageView.hidden = YES;
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSURL *url = navigationAction.request.URL;
    NSString *urlStr = url.absoluteString;
    [self pay:urlStr withUrl:url];
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)pay:(NSString *)urlStr withUrl:(NSURL *)url {
    NSLog(@"%@", urlStr);
    if ([urlStr containsString:@"alipay://"] || [urlStr containsString:@"weixin://"]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
