//
//  UIImage+Manipulation.h
//  Hoot
//
//  Created by Riley Testut on 9/23/14.
//  Copyright (c) 2014 TMT. All rights reserved.
//

@import UIKit;

@interface UIImage (Manipulation)

// Resizing
- (UIImage *)imageByResizingToSize:(CGSize)size;
- (UIImage *)imageByResizingToFitSize:(CGSize)size;
- (UIImage *)imageByResizingToFillSize:(CGSize)size;

// Rounded Corners
- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius;
- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius inset:(UIEdgeInsets)inset;

@end
