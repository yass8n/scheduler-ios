//
//  WebService.m
//  scheduler
//
//  Created by yaseen on 11/9/17.
//  Copyright © 2017 yaseen. All rights reserved.
//

#import "WebService.h"
#import "AFNetworking.h"

@implementation WebService

- (id)init
{
    self = [super init];
    if (self) {
        [Helper showNetworkIndicator];
    }
    return self;
}

- (void)createMessage:(NSDictionary *)params callback:(void (^)(NSDictionary * result)) callback {
    dispatch_queue_t completion_que = dispatch_get_main_queue();
    NSString *urlString = [NSString stringWithFormat:@"%@/messages/create/", apiUrl];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(completion_que, ^{
            callback((NSDictionary*)responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(completion_que, ^{
            callback(nil);
        });
    }];
}

- (void)deleteMessage:(NSDictionary *)params callback:(void (^)(NSDictionary * result)) callback {
    dispatch_queue_t completion_que = dispatch_get_main_queue();
    NSString *urlString = [NSString stringWithFormat:@"%@/messages/delete/", apiUrl];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(completion_que, ^{
            callback((NSDictionary*)responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(completion_que, ^{
            callback(nil);
        });
    }];
}

- (void)clearMessages:(void (^)(NSDictionary * result)) callback {
    dispatch_queue_t completion_que = dispatch_get_main_queue();
    NSString *urlString = [NSString stringWithFormat:@"%@/messages/clear/", apiUrl];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(completion_que, ^{
            callback((NSDictionary*)responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(completion_que, ^{
            callback(nil);
        });
    }];
}

- (void)fetchMessages:(void (^)(NSDictionary * result)) callback {
    dispatch_queue_t completion_que = dispatch_get_main_queue();    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *urlString = [NSString stringWithFormat:@"%@/messages/fetch/", apiUrl];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        dispatch_async(completion_que, ^{
            callback((NSDictionary*)responseObject);
        });
    }];
    [dataTask resume];
}

#pragma mark random functions
- (BOOL)checkApiResult:(id) result {
    [Helper hideNetworkIndicator];
    if (result == nil || [result count]==0){
        [Helper showMessage:@"Something went wrong."
                  withTitle:@"Error" actionBlock:nil];
        return NO;
    }else{
        if ([result isKindOfClass:[NSDictionary class]]){
            NSString* error = result[@"error"];
            if ([error length] > 0){
                [Helper showMessage:error
                          withTitle:@"Error" actionBlock:nil];
                return NO;
            }
        }
        return YES;
    }
}
@end

