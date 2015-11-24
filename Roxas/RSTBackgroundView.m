//
//  RSTBackgroundView.m
//  Roxas
//
//  Created by Riley Testut on 11/21/15.
//  Copyright © 2015 Riley Testut. All rights reserved.
//

#import "RSTBackgroundView.h"

@interface RSTBackgroundView ()

@property (nonnull, nonatomic, readwrite) IBOutlet UILabel *textLabel;
@property (nonnull, nonatomic, readwrite) IBOutlet UILabel *detailTextLabel;
@property (nonnull, nonatomic, readwrite) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonnull, nonatomic, readwrite) IBOutlet UIImageView *imageView;
@property (nonnull, nonatomic, readwrite) IBOutlet UIStackView *stackView;

@end

@implementation RSTBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    NSArray *views = [[NSBundle bundleForClass:self.class] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    
    UIView *nibView = [views firstObject];
    nibView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    nibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:nibView];
    
    self.activityIndicatorView.hidden = YES;
    self.imageView.hidden = YES;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomTV)
    {
        self.stackView.spacing = 15;
        self.detailTextLabel.font = [UIFont fontWithDescriptor:[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline] size:0.0];
    }
}

@end
