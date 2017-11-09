//
//  WebService.h
//  Genie
//
//  Created by Yaseen Aniss on 4/6/16.
//  Copyright © 2016 Genie. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WebService : NSObject
- (BOOL)checkApiResult:(id) result;
- (void)createMessage:(NSDictionary *)params callback:(void (^)(NSDictionary * result)) callback;
@end

