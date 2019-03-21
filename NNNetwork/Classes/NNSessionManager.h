//
//  NNSessionManager.h
//  Pods
//
//  Created by NanRuoSi on 2019/2/25.
//

#import <Foundation/Foundation.h>
#import "NNSessionManagerConfiguration.h"
#import <AFNetworking/AFNetworking.h>

/**
 请求ContentType
 
 - NNRequestContentType_Json: application/json
 - NNRequestContentType_FormUrlEncoded: application/x-www-form-urlencoded
 */
typedef NS_ENUM(NSUInteger, NNRequestContentType) {
    NNRequestContentType_Json,
    NNRequestContentType_FormUrlEncoded,
};

/**
 ContentType字符串
 */
extern NSString *NNRequestContentTypeString(NNRequestContentType contentType) ;

/**
 网络请求枚举
 
 - NNRequestMethodGet: Get请求
 - NNRequestMethodPost: Post请求
 - NNRequestMethodPut: Put请求
 - NNRequestMethoNNelete: Delete请求
 - NNRequestMethodPatch: Patch请求
 */
typedef NS_ENUM(NSUInteger, NNRequestMethod) {
    NNRequestMethodGet,
    NNRequestMethodPost,
    NNRequestMethodPut,
    NNRequestMethodDelete,
    NNRequestMethodPatch
};


/**
 NNStock Session Manager
 */
@interface NNSessionManager : NSObject

@property (nonatomic, copy) NSDictionary *(^makeSignBlock)(NSString *method, NSString *url, NSDictionary *params); //!< 加装公共参数/加密/签名
@property (nonatomic, copy) void (^globalSuccessBlock)(id responseObject); //!< 全局成功处理
@property (nonatomic, copy) void (^globalFailureBlock)(int statusCode, NSString *message); //!< 全局失败处理

+ (instancetype)shareManager ;

+ (instancetype)shareManagerWithConfiguration:(NNSessionManagerConfiguration *)config ;

/**
 设置HTTPHeader

 @param value 值
 @param field HTTPHeader
 */
- (void)setValue:(id)value forHTTPHeaderField:(NSString *)field ;

/**
 删除HTTPHeader

 @param field HTTPHeader
 */
- (void)removeHTTPHeaderField:(NSString *)field ;

- (NSURLSessionDataTask *)dataTaskWithMethod:(NNRequestMethod)method requestURL:(NSString *)requestURL params:(NSDictionary *)params successHandler:(void (^)(id responseObject))successHandler failureHandler:(void (^)(NSInteger statusCode, NSString *message))failureHandler ;

@end

@interface NNSessionManager (Deprecated)

/**
 设置HTTPRequestParam
 
 @param value 值
 @param field HTTPRequestParam
 */
- (void)setValue:(id)value forHTTPRequestParamField:(NSString *)field ;

/**
 移除HTTPRequestParam
 
 @param field HTTPRequestParam
 */
- (void)removeHTTPRequestParamField:(NSString *)field ;

@end
