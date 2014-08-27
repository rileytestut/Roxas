//
//  RSTHelperFile.m
//  Hoot
//
//  Created by Riley Testut on 3/16/13.
//  Copyright (c) 2013 Riley Testut. All rights reserved.
//

#import "RSTHelperFile.h"

UIBackgroundTaskIdentifier rst_begin_background_task(void);

void rst_dispatch_sync_on_main_thread(dispatch_block_t block)
{
    if ([NSThread isMainThread])
    {
        if (block)
        {
            block();
        }
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

UIBackgroundTaskIdentifier rst_begin_background_task(void)
{
    __block UIBackgroundTaskIdentifier backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
        backgroundTask = UIBackgroundTaskInvalid;
    }];
    
    return backgroundTask;
};

void rst_end_background_task(UIBackgroundTaskIdentifier backgroundTask)
{
    [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
    backgroundTask = UIBackgroundTaskInvalid;
}