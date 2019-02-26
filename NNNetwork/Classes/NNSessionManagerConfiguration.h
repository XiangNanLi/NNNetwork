//
//  NNSessionManagerConfiguration.h
//  Pods
//
//  Created by NanRuoSi on 2019/2/26.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface NNSessionManagerConfiguration : NSObject

+ (instancetype)defaultConfig ;

@property (nonatomic, strong, nonnull) NSURLSessionConfiguration *sessionConfig;

@property (nonatomic, strong, nonnull) AFSecurityPolicy *securityPolicy;

@property (nonatomic, strong, nonnull) AFHTTPRequestSerializer *requestSerializer;

@property (nonatomic, strong, nonnull) AFHTTPResponseSerializer *responseSerializer;

@end
