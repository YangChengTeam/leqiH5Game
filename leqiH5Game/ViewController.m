//
//  ViewController.m
//  leqiH5Game
//
//  Created by zhangkai on 2018/6/21.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "ViewController.h"
#import "GameWebView.h"
#import "Common.h"

@interface ViewController ()<WKNavigationDelegate>

@property (nonatomic, copy) NSString *gameUrl;
@property (nonatomic, strong) GameWebView *gameWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _gameUrl = GAME_URL;
    _gameWebView = [[GameWebView alloc] init];
    _gameWebView.navigationDelegate = self;
    [self.view addSubview:_gameWebView];
    
    [_gameWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_gameUrl]]];
}

- (void)viewDidLayoutSubviews {
    _gameWebView.frame = self.view.bounds;
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
