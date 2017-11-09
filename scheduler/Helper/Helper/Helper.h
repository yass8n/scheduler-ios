//
//  Helper.h
//  scheduler
//
//  Created by yaseen on 11/9/17.
//  Copyright © 2017 yaseen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject
+ (NSString*) myDateToFormat:(NSDate *)date withFormat:(NSString*)format;
+ (NSDate*) UTCtoNSDate:(NSString*)utc;
+ (void)showMessage:(NSString*)message withTitle:(NSString *)title actionBlock:(CompletionBlock)block;
@end
