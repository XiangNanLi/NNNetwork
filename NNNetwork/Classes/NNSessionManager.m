//
//  NNSessionManager.m
//  Pods
//
//  Created by NanRuoSi on 2019/2/25.
//

#import "NNSessionManager.h"

#pragma mark ContentType字符串
NSString *NNRequestContentTypeString(NNRequestContentType contentType) {
    NSString *contentTypeStr = nil;
    switch (contentType) {
        case NNRequestContentType_Json:
            contentTypeStr = @"application/json";
            break;
            
        case NNRequestContentType_FormUrlEncoded:
            contentTypeStr = @"application/x-www-form-urlencoded";
            break;
            
        default:
            contentTypeStr = @"application/json";
            break;
    }
    return contentTypeStr;
}

#pragma mark 请求的Method
NSString *NNRequestMethodString(NNRequestMethod requestMethod) {
    NSString *httpMethodStr = nil;
    switch (requestMethod) {
        case NNRequestMethodGet:
            httpMethodStr = @"GET";
            break;
            
        case NNRequestMethodPost:
            httpMethodStr = @"POST";
            break;
            
        case NNRequestMethodPut:
            httpMethodStr = @"PUT";
            break;
            
        case NNRequestMethodDelete:
            httpMethodStr = @"DELETE";
            break;
            
        case NNRequestMethodPatch:
            httpMethodStr = @"PATCH";
            break;
            
        default:
            httpMethodStr = @"GET";
            break;
    }
    return httpMethodStr;
}

@interface NNSessionManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSMutableDictionary *HTTPRequestParams DEPRECATED_ATTRIBUTE; //!< 请求的公共参数

@end

@implementation NNSessionManager

+ (instancetype)shareManager {
    NNSessionManager *manager = [NNSessionManager shareManagerWithConfiguration:[NNSessionManagerConfiguration defaultConfig]];
    return manager;
}

+ (instancetype)shareManagerWithConfiguration:(NNSessionManagerConfiguration *)config {
    NNSessionManager *manager = [[NNSessionManager alloc] initWithConfiguration:config];
    return manager;
}

- (instancetype)initWithConfiguration:(NNSessionManagerConfiguration *)config {
    if (self = [super init]) {
        if (!config) {
            config = [NNSessionManagerConfiguration defaultConfig];
        }
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config.sessionConfig];
        
        self.sessionManager.securityPolicy = config.securityPolicy;
        self.sessionManager.requestSerializer = config.requestSerializer;
        self.sessionManager.responseSerializer = config.responseSerializer;
    }
    return self;
}

- (NSURLSessionDataTask *)dataTaskWithMethod:(NNRequestMethod)method requestURL:(NSString *)requestURL params:(NSDictionary *)params successHandler:(void (^)(id responseObject))successHandler failureHandler:(void (^)(NSInteger statusCode, NSString *message))failureHandler {
    // 请求方法
    NSString *requestMethod = NNRequestMethodString(method);
    
    // 请求参数
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:(params ? params : @{})];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    // 加装全局参数
    if (self.HTTPRequestParams) {
        [newParams addEntriesFromDictionary:self.HTTPRequestParams];
    }
#pragma clang diagnostic pop
    // 由外部指定参数加密或签名
    if (self.makeSignBlock) {
        newParams = [self.makeSignBlock(requestMethod, requestURL, newParams) mutableCopy];
    }
    
    // 组装请求
    NSError *error = nil;
    NSURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:NNRequestMethodString(method) URLString:requestURL parameters:newParams error:&error];
    if (error) { // 组装请求失败
        if (failureHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failureHandler(error.code, error.description);
            });
        }
        return nil;
    }
    __weak typeof(self) weak_self = self;
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) { // 按照请求成功处理
            NSError *error = nil;
            id responseDict = responseObject;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                responseDict = responseObject;
            } else if ([responseObject isKindOfClass:[NSData class]]) {
                responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
                // 成功处理
                if (error) {
                    responseDict = responseObject;
                }
            } else {
                responseDict = responseObject;
            }
            // 全局成功处理
            if (weak_self.globalSuccessBlock) {
                weak_self.globalSuccessBlock(responseDict);
            }
            // 成功处理
            if (successHandler) {
                successHandler(responseDict);
            }
        } else {
            // 返回状态码和错误码
            NSInteger statusCode = -1;
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                statusCode = httpResponse.statusCode;
            } else {
                NSString *errorCode = @"";
                if (error.localizedDescription != nil) {
                    NSString *pattern = @"[0-9]\\d{1,3}";
                    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
                    NSArray *results = [regular matchesInString:error.localizedDescription options:0 range:NSMakeRange(0, error.localizedDescription.length)];
                    for (NSTextCheckingResult *result in results) {
                        errorCode = [error.localizedDescription substringWithRange:result.range];
                    }
                    statusCode = [errorCode intValue];
                }
            }
            
            // 错误信息
            NSString *errorMessage = [error localizedDescription];
            if (failureHandler) {
                failureHandler(statusCode, errorMessage);
            }
        }
    }];
    NSLog(@"%@", task);
    [task resume];
    return task;
}

#pragma mark - UtilMethod
#pragma mark 设置HTTPHeader
- (void)setValue:(id)value forHTTPHeaderField:(NSString *)field {
    [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

#pragma mark 删除HTTPHeader
- (void)removeHTTPHeaderField:(NSString *)field {
    [self.sessionManager.requestSerializer setValue:nil forHTTPHeaderField:field];
}

@end

@implementation NNSessionManager (Deprecated)

#pragma mark 设置HTTPRequestParam
- (void)setValue:(id)value forHTTPRequestParamField:(NSString *)field {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (!self.HTTPRequestParams) {
        self.HTTPRequestParams = [NSMutableDictionary dictionary];
    }
    if (value) {
        [self.HTTPRequestParams setObject:value forKey:field];
    }
#pragma clang diagnostic pop
}

#pragma mark 移除HTTPRequestParam
- (void)removeHTTPRequestParamField:(NSString *)field {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    [self.HTTPRequestParams removeObjectForKey:field];
#pragma clang diagnostic pop
}

@end
