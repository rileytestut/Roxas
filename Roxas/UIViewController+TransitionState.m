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
    UIViewController *fromViewController = [transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    BOOL isAppearing = (toViewController == self || toViewController == self.parentViewController);
    return isAppearing && ![fromViewController isKindOfClass:[UIAlertController class]];
}

- (BOOL)isDisappearing
{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.transitionCoordinator;
    UIViewController *fromViewController = [transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    
    BOOL isDisappearing = (fromViewController == self || fromViewController == self.parentViewController);
    return isDisappearing && ![toViewController isKindOfClass:[UIAlertController class]];;
}

@end
