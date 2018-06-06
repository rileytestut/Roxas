//
//  UIKit+ActivityIndicating.m
//  Roxas
//
//  Created by Riley Testut on 4/2/18.
//  Copyright © 2018 Riley Testut. All rights reserved.
//

#import "UIKit+ActivityIndicating.h"

typedef NSString *RSTActivityIndicatingHelperUserInfoKey NS_TYPED_EXTENSIBLE_ENUM;
RSTActivityIndicatingHelperUserInfoKey const RSTActivityIndicatingHelperUserInfoKeyTextColor = @"RSTActivityIndicatingHelperUserInfoKeyTextColor";
RSTActivityIndicatingHelperUserInfoKey const RSTActivityIndicatingHelperUserInfoKeyImage = @"RSTActivityIndicatingHelperUserInfoKeyImage";
RSTActivityIndicatingHelperUserInfoKey const RSTActivityIndicatingHelperUserInfoKeyEnabled = @"RSTActivityIndicatingHelperUserInfoKeyEnabled";
RSTActivityIndicatingHelperUserInfoKey const RSTActivityIndicatingHelperUserInfoKeyCustomView = @"RSTActivityIndicatingHelperUserInfoKeyCustomView";

@import ObjectiveC;

@protocol _RSTActivityIndicating <RSTActivityIndicating>

- (void)startIndicatingActivity;
- (void)stopIndicatingActivity;

@end


NS_ASSUME_NONNULL_BEGIN

@interface RSTActivityIndicatingHelper : NSObject <RSTActivityIndicating>

@property (nonatomic, readonly) id<_RSTActivityIndicating> indicatingObject;

@property (nonatomic, readonly) dispatch_queue_t activityCountQueue;

@property (nonatomic, readonly) NSMutableDictionary<RSTActivityIndicatingHelperUserInfoKey, id> *userInfo;

@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicatorView;

- (instancetype)initWithIndicatingObject:(id<_RSTActivityIndicating>)indicatingObject NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END


@implementation RSTActivityIndicatingHelper
@synthesize activityCount = _activityCount;
@synthesize indicatingActivity = _indicatingActivity;
@synthesize activityIndicatorView = _activityIndicatorView;

+ (instancetype)activityIndicatingHelperForIndicatingObject:(id<_RSTActivityIndicating>)object
{
    @synchronized(object)
    {
        RSTActivityIndicatingHelper *helper = objc_getAssociatedObject(object, @selector(activityIndicatingHelperForIndicatingObject:));
        if (helper == nil)
        {
            helper = [[RSTActivityIndicatingHelper alloc] initWithIndicatingObject:object];
            
            objc_setAssociatedObject(object, @selector(activityIndicatingHelperForIndicatingObject:), helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        return helper;
    }
}

- (instancetype)initWithIndicatingObject:(id<_RSTActivityIndicating>)indicatingObject
{
    self = [super init];
    if (self)
    {
        _indicatingObject = indicatingObject;
        
        _activityCountQueue = dispatch_queue_create("com.rileytestut.Roxas.activityCountQueue", DISPATCH_QUEUE_SERIAL);
        
        _userInfo = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)incrementActivityCount
{
    dispatch_sync(self.activityCountQueue, ^{
        _activityCount++;
        
        if (_activityCount == 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.indicatingActivity = YES;
            });
        }
    });
}

- (void)decrementActivityCount
{
    dispatch_sync(self.activityCountQueue, ^{
        if (_activityCount == 0)
        {
            return;
        }
        
        _activityCount--;
        
        if (_activityCount == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.indicatingActivity = NO;
            });
        }
    });
}

#pragma mark - Getters/Setters -

- (UIActivityIndicatorView *)activityIndicatorView
{
    @synchronized(self)
    {
        if (_activityIndicatorView == nil)
        {
            _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        return _activityIndicatorView;
    }
}

- (void)setIndicatingActivity:(BOOL)indicatingActivity
{
    // Always start/stop animation regardless of whether indicatingActivity is a new value.
    // This is in case the animation has been started/stopped externally (such as when reusing table/collection view cells).
    if (indicatingActivity)
    {
        [self.activityIndicatorView startAnimating];
    }
    else
    {
        [self.activityIndicatorView stopAnimating];
    }
    
    if (indicatingActivity == _indicatingActivity)
    {
        return;
    }
    
    _indicatingActivity = indicatingActivity;
    
    if (indicatingActivity)
    {
        [self.indicatingObject startIndicatingActivity];
    }
    else
    {
        [self.indicatingObject stopIndicatingActivity];
    }
}

@end


NS_ASSUME_NONNULL_BEGIN

@interface UIButton (_ActivityIndicating) <_RSTActivityIndicating>
@property (nonatomic, readonly) RSTActivityIndicatingHelper *activityIndicatingHelper;
@end

NS_ASSUME_NONNULL_END


@implementation UIButton (_ActivityIndicating)

- (void)startIndicatingActivity
{
    UIColor *textColor = [self titleColorForState:UIControlStateNormal];
    self.activityIndicatingHelper.userInfo[RSTActivityIndicatingHelperUserInfoKeyTextColor] = textColor;
    
    UIImage *image = [self imageForState:UIControlStateNormal];
    self.activityIndicatingHelper.userInfo[RSTActivityIndicatingHelperUserInfoKeyImage] = image;
    
    BOOL enabled = [self isUserInteractionEnabled];
    self.activityIndicatingHelper.userInfo[RSTActivityIndicatingHelperUserInfoKeyEnabled] = @(enabled);
    
    [self setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self setImage:nil forState:UIControlStateNormal];
    [self setUserInteractionEnabled:NO];
    
    [self addSubview:self.activityIndicatingHelper.activityIndicatorView];
    
    [NSLayoutConstraint activateConstraints:@[[self.activityIndicatingHelper.activityIndicatorView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                                              [self.activityIndicatingHelper.activityIndicatorView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]]];
}

- (void)stopIndicatingActivity
{
    [self.activityIndicatingHelper.activityIndicatorView removeFromSuperview];
    
    UIColor *textColor = self.activityIndicatingHelper.userInfo[RSTActivityIndicatingHelperUserInfoKeyTextColor];
    [self setTitleColor:textColor forState:UIControlStateNormal];
    
    UIImage *image = self.activityIndicatingHelper.userInfo[RSTActivityIndicatingHelperUserInfoKeyImage];
    [self setImage:image forState:UIControlStateNormal];
    
    BOOL enabled = [self.activityIndicatingHelper.userInfo[RSTActivityIndicatingHelperUserInfoKeyEnabled] boolValue];
    [self setUserInteractionEnabled:enabled];
    
    self.activityIndicatingHelper.userInfo[RSTActivityIndicatingHelperUserInfoKeyTextColor] = nil;
    self.activityIndicatingHelper.userInfo[RSTActivityIndicatingHelperUserInfoKeyImage] = nil;
    self.activityIndicatingHelper.userInfo[RSTActivityIndicatingHelperUserInfoKeyEnabled] = nil;
}

#pragma mark - <RSTActivityIndicating> -

- (void)incrementActivityCount
{
    [self.activityIndicatingHelper incrementActivityCount];
}

- (void)decrementActivityCount
{
    [self.activityIndicatingHelper decrementActivityCount];
}

#pragma mark - Getters/Setters -

- (void)setIndicatingActivity:(BOOL)indicatingActivity
{
    self.activityIndicatingHelper.indicatingActivity = indicatingActivity;
}

- (BOOL)isIndicatingActivity
{
    return [self.activityIndicatingHelper isIndicatingActivity];
}

- (NSUInteger)activityCount
{
    return self.activityIndicatingHelper.activityCount;
}

- (RSTActivityIndicatingHelper *)activityIndicatingHelper
{
    return [RSTActivityIndicatingHelper activityIndicatingHelperForIndicatingObject:self];
}

- (UIActivityIndicatorView *)rst_activityIndicatorView
{
    return self.activityIndicatingHelper.activityIndicatorView;
}

@end


NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (_ActivityIndicating) <_RSTActivityIndicating>
@property (nonatomic, readonly) RSTActivityIndicatingHelper *activityIndicatingHelper;
@end

NS_ASSUME_NONNULL_END


@implementation UIBarButtonItem (_ActivityIndicating)

- (void)startIndicatingActivity
{
    UIView *customView = [[UIView alloc] init];
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    [customView addSubview:self.activityIndicatingHelper.activityIndicatorView];
    
    [NSLayoutConstraint activateConstraints:@[[self.rst_activityIndicatorView.leadingAnchor constraintEqualToAnchor:customView.leadingAnchor constant:8],
                                              [self.rst_activityIndicatorView.trailingAnchor constraintEqualToAnchor:customView.trailingAnchor constant:-8],
                                              [self.rst_activityIndicatorView.topAnchor constraintEqualToAnchor:customView.topAnchor],
                                              [self.rst_activityIndicatorView.bottomAnchor constraintEqualToAnchor:customView.bottomAnchor]]];
    
    self.activityIndicatingHelper.userInfo[RSTActivityIndicatingHelperUserInfoKeyEnabled] = @(self.enabled);
    self.activityIndicatingHelper.userInfo[RSTActivityIndicatingHelperUserInfoKeyCustomView] = self.customView;
    
    self.enabled = NO;
    self.customView = customView;
}

- (void)stopIndicatingActivity
{
    BOOL enabled = [self.activityIndicatingHelper.userInfo[RSTActivityIndicatingHelperUserInfoKeyEnabled] boolValue];
    self.enabled = enabled;
    
    UIView *customView = self.activityIndicatingHelper.userInfo[RSTActivityIndicatingHelperUserInfoKeyCustomView];
    self.customView = customView;
    
    self.activityIndicatingHelper.userInfo[RSTActivityIndicatingHelperUserInfoKeyEnabled] = nil;
    self.activityIndicatingHelper.userInfo[RSTActivityIndicatingHelperUserInfoKeyCustomView] = nil;
}

#pragma mark - <RSTActivityIndicating> -

- (void)incrementActivityCount
{
    [self.activityIndicatingHelper incrementActivityCount];
}

- (void)decrementActivityCount
{
    [self.activityIndicatingHelper decrementActivityCount];
}

#pragma mark - Getters/Setters -

- (void)setIndicatingActivity:(BOOL)indicatingActivity
{
    self.activityIndicatingHelper.indicatingActivity = indicatingActivity;
}

- (BOOL)isIndicatingActivity
{
    return [self.activityIndicatingHelper isIndicatingActivity];
}

- (NSUInteger)activityCount
{
    return self.activityIndicatingHelper.activityCount;
}

- (RSTActivityIndicatingHelper *)activityIndicatingHelper
{
    return [RSTActivityIndicatingHelper activityIndicatingHelperForIndicatingObject:self];
}

- (UIActivityIndicatorView *)rst_activityIndicatorView
{
    return self.activityIndicatingHelper.activityIndicatorView;
}

@end


NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (_ActivityIndicating) <_RSTActivityIndicating>
@property (nonatomic, readonly) RSTActivityIndicatingHelper *activityIndicatingHelper;
@end

NS_ASSUME_NONNULL_END


@implementation UIImageView (_ActivityIndicating)

- (void)startIndicatingActivity
{
    [self addSubview:self.activityIndicatingHelper.activityIndicatorView];
    
    [NSLayoutConstraint activateConstraints:@[[self.activityIndicatingHelper.activityIndicatorView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                                              [self.activityIndicatingHelper.activityIndicatorView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]]];
}

- (void)stopIndicatingActivity
{
    [self.activityIndicatingHelper.activityIndicatorView removeFromSuperview];
}

#pragma mark - <RSTActivityIndicating> -

- (void)incrementActivityCount
{
    [self.activityIndicatingHelper incrementActivityCount];
}

- (void)decrementActivityCount
{
    [self.activityIndicatingHelper decrementActivityCount];
}

#pragma mark - Getters/Setters -

- (void)setIndicatingActivity:(BOOL)indicatingActivity
{
    self.activityIndicatingHelper.indicatingActivity = indicatingActivity;
}

- (BOOL)isIndicatingActivity
{
    return [self.activityIndicatingHelper isIndicatingActivity];
}

- (NSUInteger)activityCount
{
    return self.activityIndicatingHelper.activityCount;
}

- (RSTActivityIndicatingHelper *)activityIndicatingHelper
{
    return [RSTActivityIndicatingHelper activityIndicatingHelperForIndicatingObject:self];
}

- (UIActivityIndicatorView *)rst_activityIndicatorView
{
    return self.activityIndicatingHelper.activityIndicatorView;
}

@end


NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (_ActivityIndicating) <_RSTActivityIndicating>
@property (nonatomic, readonly) RSTActivityIndicatingHelper *activityIndicatingHelper;
@end

NS_ASSUME_NONNULL_END


@implementation UIApplication (_ActivityIndicating)

- (void)startIndicatingActivity
{
    self.networkActivityIndicatorVisible = YES;
}

- (void)stopIndicatingActivity
{
    self.networkActivityIndicatorVisible = NO;
}

#pragma mark - <RSTActivityIndicating> -

- (void)incrementActivityCount
{
    [self.activityIndicatingHelper incrementActivityCount];
}

- (void)decrementActivityCount
{
    [self.activityIndicatingHelper decrementActivityCount];
}

#pragma mark - Getters/Setters -

- (void)setIndicatingActivity:(BOOL)indicatingActivity
{
    self.activityIndicatingHelper.indicatingActivity = indicatingActivity;
}

- (BOOL)isIndicatingActivity
{
    return [self.activityIndicatingHelper isIndicatingActivity];
}

- (NSUInteger)activityCount
{
    return self.activityIndicatingHelper.activityCount;
}

- (RSTActivityIndicatingHelper *)activityIndicatingHelper
{
    return [RSTActivityIndicatingHelper activityIndicatingHelperForIndicatingObject:self];
}

@end

