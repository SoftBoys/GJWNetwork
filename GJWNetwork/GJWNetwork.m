//
//  GJWNetwork.m
//  GJWNetworkDemo
//
//  Created by dfhb@rdd on 16/7/21.
//  Copyright © 2016年 guojunwei. All rights reserved.
//

#import "GJWNetwork.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface GJWHTTPSessionManager : AFHTTPSessionManager
+ (instancetype)shareInstance;
@end
@implementation GJWHTTPSessionManager

+ (instancetype)shareInstance {
    static GJWHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([GJWNetwork baseUrl]) {
            manager = [[GJWHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[GJWNetwork baseUrl]]];
        } else {
            manager = [GJWHTTPSessionManager manager];
        }
    });
    return manager;
}

@end

void GJWLog(NSString *format) {
#ifdef DEBUG
    //    va_list argptr;
    //    va_start(argptr, format);
    NSLog(format, nil);
    //    va_end(argptr);
#endif
}

static NSString *gjw_baseUrl = nil;

static NSDictionary *gjw_httpHeads = nil;
static GJWRequestType gjw_requestType = kGJWRequestTypeJSON;
static GJWResponseType gjw_responseType = kGJWResponseTypeJSON;
@implementation GJWNetwork

+ (void)updateBaseUrl:(NSString *)baseUrl {
    gjw_baseUrl = baseUrl;
}
+ (NSString *)baseUrl {
    return gjw_baseUrl;
}


+ (void)configHttpHeaders:(NSDictionary *)httpHeads {
    gjw_httpHeads = httpHeads;
}
+ (void)configRequestType:(GJWRequestType)requestType responseType:(GJWResponseType)responseType {
    gjw_requestType = requestType;
    gjw_responseType = responseType;
}
+ (void)cancelAllRequest {
    for (NSURLSessionTask *task in [self manager].tasks) {
        [task cancel];
    }
//    [[self manager].operationQueue cancelAllOperations];
}

+ (GJWHTTPSessionManager *)manager {
    // 开启转圈圈
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    GJWHTTPSessionManager *manager = [GJWHTTPSessionManager shareInstance];
    
    // 设置超时时间
    manager.requestSerializer.timeoutInterval = 10;
    
    // 最多同时请求三个
    manager.operationQueue.maxConcurrentOperationCount = 3;
    
    // 设置请求头
    if ([gjw_httpHeads isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in [gjw_httpHeads allKeys]) {
            if ([key isKindOfClass:[NSString class]] && key.length) {
                [manager.requestSerializer setValue:gjw_httpHeads[key] forHTTPHeaderField:key];
            }
        }
    }
    
    //
    switch (gjw_requestType) {
        case kGJWRequestTypeJSON:
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case kGJWRequestTypePlainText:
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
            
        default:
            break;
    }
    
    //
    switch (gjw_responseType) {
        case kGJWResponseTypeJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case kGJWResponseTypeXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case kGJWResponseTypeData:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
            
        default:
            break;
    }
    
    return manager;
}

+ (GJWURLSessionTask *)getWithUrl:(NSString *)url success:(GJWResponseSuccess)success fail:(GJWResponseFail)fail {
    return [self getWithUrl:url param:nil success:success fail:fail];
}
+ (GJWURLSessionTask *)getWithUrl:(NSString *)url param:(NSDictionary *)param success:(GJWResponseSuccess)success fail:(GJWResponseFail)fail {
    return [self _requestWithUrl:url httpMethod:1 param:param success:success fail:fail];
}
+ (GJWURLSessionTask *)postWithUrl:(NSString *)url param:(NSDictionary *)param success:(GJWResponseSuccess)success fail:(GJWResponseFail)fail {
    return [self _requestWithUrl:url httpMethod:2 param:param success:success fail:fail];
}


+ (GJWURLSessionTask *)_requestWithUrl:(NSString *)url httpMethod:(NSInteger)method param:(NSDictionary *)param success:(GJWResponseSuccess)success fail:(GJWResponseFail)fail {
    GJWHTTPSessionManager *manager = [self manager];
    
    if (![url isKindOfClass:[NSString class]] || url == nil) {
        GJWLog(@"url不对");
        return nil;
    }
    
    NSString *absolutePath = [[NSURL URLWithString:url relativeToURL:[NSURL URLWithString:[self baseUrl]]] absoluteString];

    if (absolutePath.length == 0) {
        GJWLog(@"url不对");
        return nil;
    }
    GJWURLSessionTask *task = nil;
    if (method == 1) {
        task = [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self successWithTask:task response:responseObject callBack:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self failWithTask:task error:error callBack:fail];
        }];
    } else if (method == 2) {
        task = [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self successWithTask:task response:responseObject callBack:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self failWithTask:task error:error callBack:fail];
        }];
    }
    
    
    return task;
}

+ (GJWURLSessionTask *)postImage:(UIImage *)image name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType url:(NSString *)url param:(NSDictionary *)param success:(GJWResponseSuccess)success fail:(GJWResponseFail)fail {
    GJWHTTPSessionManager *manager = [self manager];
    
    if (![url isKindOfClass:[NSString class]] || url == nil) {
        GJWLog(@"url不对");
        return nil;
    }
    
    NSString *absolutePath = [[NSURL URLWithString:url relativeToURL:[NSURL URLWithString:[self baseUrl]]] absoluteString];
    
    if (absolutePath.length == 0) {
        GJWLog(@"url不对");
        return nil;
    }
    
    GJWURLSessionTask *task = nil;
    task = [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = [self dataWithImage:image];
        NSString *newName = name ? name:@"file";
        NSString *newFileName = fileName ? fileName : @"multipart/form-data";
        [formData appendPartWithFileData:data name:newName fileName:newFileName mimeType:mimeType];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self successWithTask:task response:responseObject callBack:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self failWithTask:task error:error callBack:fail];
    }];
    return task;
}
+ (NSData *)dataWithImage:(UIImage *)image {
    if ([image isKindOfClass:[UIImage class]]) {
        return UIImageJPEGRepresentation(image, 1);
    } else if ([image isKindOfClass:[NSData class]]) {
        return (NSData *)image;
    }
    return nil;
}
+ (void)successWithTask:(GJWURLSessionTask *)task response:(id)response callBack:(GJWResponseSuccess)success {
    if (success) {
        success(task, [self tryToParseData:response]);
//        [task cancel];
    }
}
+ (void)failWithTask:(GJWURLSessionTask *)task error:(NSError *)error callBack:(GJWResponseFail)fail {
    
    if (fail) {
        fail(task, error);
//        [task cancel];
    }
}
// 尝试解析数据
+ (id)tryToParseData:(id)responseData {
    if ([responseData isKindOfClass:[NSData class]]) {
        
        NSError *error = nil;
        id response = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        if (error == nil) {
            return response;
        }
    }
    return responseData;
}

+ (NSArray<NSURLSessionTask *> *)manageTasks {
    return [self manager].tasks;
}
@end
