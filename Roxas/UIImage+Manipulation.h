//
//  UIImage+Manipulation.h
//  Hoot
//
//  Created by Riley Testut on 9/23/14.
//  Copyright (c) 2014 TMT. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UIImageMetadataOrientation)
{
    UIImageMetadataOrientationUp               = 1,
    UIImageMetadataOrientationDown             = 3,
    UIImageMetadataOrientationLeft             = 8,
    UIImageMetadataOrientationRight            = 6,
    UIImageMetadataOrientationUpMirrored       = 2,
    UIImageMetadataOrientationDownMirrored     = 4,
    UIImageMetadataOrientationLeftMirrored     = 5,
    UIImageMetadataOrientationRightMirrored    = 7,
};

RST_EXTERN UIImageMetadataOrientation UIImageMetadataOrientationFromImageOrientation(UIImageOrientation imageOrientation);
RST_EXTERN UIImageOrientation UIImageOrientationFromMetadataOrientation(UIImageMetadataOrientation metadataOrientation);

@interface UIImage (Manipulation)

// Resizing
- (UIImage *)imageByResizingToSize:(CGSize)size;
- (UIImage *)imageByResizingToFitSize:(CGSize)size;
- (UIImage *)imageByResizingToFillSize:(CGSize)size;

// Rounded Corners
- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius;
- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius inset:(UIEdgeInsets)inset;

@end

NS_ASSUME_NONNULL_END
