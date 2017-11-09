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

#pragma mark random functions
- (BOOL)checkApiResult:(id) result {
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

