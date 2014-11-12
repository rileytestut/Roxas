//
//  RSTHelperFile.h
//  Hoot
//
//  Created by Riley Testut on 3/16/13.
//  Copyright (c) 2013 Riley Testut. All rights reserved.
//

#import "RSTNavigationController.h"

@import UIKit;

#if defined(__cplusplus)
#define RST_EXTERN extern "C"
#else
#define RST_EXTERN extern
#endif


/*** General ***/

static inline RSTNavigationController *RSTContainInNavigationController(UIViewController *viewController)
{
    RSTNavigationController *navigationController = [[RSTNavigationController alloc] initWithRootViewController:viewController];
    return navigationController;
}


/*** Math ***/

static inline CGFloat RSTDegreesFromRadians(CGFloat radians)
{
    return radians * (180.0 / M_PI);
}

static inline CGFloat RSTRadiansFromDegrees(CGFloat degrees)
{
    return (degrees * M_PI) / 180.0;
}


/*** Logging ***/

// http://stackoverflow.com/questions/969130/how-to-print-out-the-method-name-and-line-number-and-conditionally-disable-nslog
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

#define ELog(error) NSLog(@"%s [Line %d] Error:\n%@\n%@\n%@", __PRETTY_FUNCTION__, __LINE__, [error localizedDescription], [error localizedRecoverySuggestion], [error userInfo])


/*** Private Debugging ***/

// Daniel Eggert, http://www.objc.io/issue-2/low-level-concurrency-apis.html
// Returns average number of nanoseconds needed to perform task
RST_EXTERN uint64_t rst_benchmark(size_t count, void (^block)(void));


/*** Concurrency ***/

RST_EXTERN void rst_dispatch_sync_on_main_thread(dispatch_block_t block);
RST_EXTERN UIBackgroundTaskIdentifier rst_begin_background_task();
RST_EXTERN void rst_end_background_task(UIBackgroundTaskIdentifier backgroundTask);