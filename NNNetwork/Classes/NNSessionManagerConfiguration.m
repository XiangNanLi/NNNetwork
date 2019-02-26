//
//  NNSessionManagerConfiguration.m
//  Pods
//
//  Created by NanRuoSi on 2019/2/26.
//

#import "NNSessionManagerConfiguration.h"

@implementation NNSessionManagerConfiguration

+ (instancetype)defaultConfig {
    NNSessionManagerConfiguration *config = [[NNSessionManagerConfiguration alloc] init];
    return config;
}

- (NSURLSessionConfiguration *)sessionConfig {
    if (!_sessionConfig) {
        _sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    return _sessionConfig;
}

- (AFSecurityPolicy *)securityPolicy {
    if (!_securityPolicy) {
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
        _securityPolicy.allowInvalidCertificates = YES;
        _securityPolicy.validatesDomainName = NO;
    }
    return _securityPolicy;
}

- (AFHTTPRequestSerializer *)requestSerializer {
    if (!_requestSerializer) {
        _requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _requestSerializer;
}

- (AFHTTPResponseSerializer *)responseSerializer {
    if (!_responseSerializer) {
        _responseSerializer = [AFJSONResponseSerializer serializer];
        _responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/html", @"application/javascript", nil];
    }
    return _responseSerializer;
}

@end
