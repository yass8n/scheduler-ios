//
//  Helper.m
//  scheduler
//
//  Created by yaseen on 11/9/17.
//  Copyright © 2017 yaseen. All rights reserved.
//

#import "Helper.h"
#import <objc/runtime.h>
#import "UIAlertController+Window.h"

@implementation Helper
static int networkIndicatorCount = 0;

+ (NSString*) myDateToFormat:(NSDate *)date withFormat:(NSString*)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

+ (NSString*) stringFromDate:(NSDate*)date withFormat:(NSString*)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

+ (NSDate*) UTCtoNSDate:(NSString*)utc {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat dateFromString:utc];
}

+ (void)showMessage:(NSString*)message withTitle:(NSString *)title actionBlock:(CompletionBlock)block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (block != nil){
            block();
        }
    }]];
    [alert show]; //only shows if not already showing
}

+ (void)showNetworkIndicator {
    networkIndicatorCount++;
    if (networkIndicatorCount > 0){
        [UIApplication sharedApplication].
        networkActivityIndicatorVisible = YES;
    }
}

+ (void)hideNetworkIndicator {
    networkIndicatorCount--;
    if (networkIndicatorCount <= 0){
        networkIndicatorCount = 0;
        [UIApplication sharedApplication].
        networkActivityIndicatorVisible = NO;
    }
}
@end

