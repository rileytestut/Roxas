//
//  UIViewController+TransitionState.m
//  Roxas
//
//  Created by Riley Testut on 3/14/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "UIViewController+TransitionState.h"

@implementation UIViewController (TransitionState)

- (BOOL)isAppearing
{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.transitionCoordinator;
    UIViewController *toViewController = [transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    
    BOOL isAppearing = (toViewController == self || toViewController == self.parentViewController);
    return isAppearing;
}

- (BOOL)isDisappearing
{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.transitionCoordinator;
    UIViewController *fromViewController = [transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    BOOL isDisappearing = (fromViewController == self || fromViewController == self.parentViewController);
    return isDisappearing;
}

@end
