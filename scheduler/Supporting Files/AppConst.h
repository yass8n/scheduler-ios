#ifndef AppConst_h
#define AppConst_h

#import <Foundation/Foundation.h>

extern NSString* const apiUrl;

extern BOOL PRODUCTION;

typedef void (^ CompletionBlock)(void);


#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#endif
