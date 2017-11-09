#import <Foundation/Foundation.h>


@interface WebService : NSObject
- (BOOL)checkApiResult:(id) result;
- (void)createMessage:(NSDictionary *)params callback:(void (^)(NSDictionary * result)) callback;
- (void)clearMessages:(void (^)(NSDictionary * result)) callback;
- (void)deleteMessage:(NSDictionary *)params callback:(void (^)(NSDictionary * result)) callback;
- (void)fetchMessages:(void (^)(NSDictionary * result)) callback;
@end

