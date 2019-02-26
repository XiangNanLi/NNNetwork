//
//  NNViewController.m
//  NNNetwork
//
//  Created by Nan on 02/26/2019.
//  Copyright (c) 2019 Nan. All rights reserved.
//

#import "NNViewController.h"
#import "NNNetwork.h"

static NNSessionManager *manager = nil;
@interface NNViewController ()

@end

@implementation NNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NNSessionManagerConfiguration *config = [NNSessionManagerConfiguration defaultConfig];
    config.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [NNSessionManager shareManagerWithConfiguration:config];
        }
    });
    
    [manager setValue:@"ios" forHTTPRequestParamField:@"appId"];
    [manager setValue:@"None" forHTTPRequestParamField:@"appcode"];
    [manager setValue:@"100" forHTTPRequestParamField:@"vcode"];
    [manager setValue:@"1" forHTTPRequestParamField:@"ver"];
    [manager setValue:@"None" forHTTPRequestParamField:@"client_id"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [manager dataTaskWithMethod:(NNRequestMethodPost) requestURL:@"https://user.service.guxiansheng.cn/index.php?c=login&a=index&site=user" params:@{@"password":@"None", @"username":@"None"} successHandler:^(id responseObject) {
        NSLog(@"%@", responseObject);
    } failureHandler:^(NSInteger statusCode, NSString *message) {
        NSLog(@"%ld %@", statusCode, message);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
