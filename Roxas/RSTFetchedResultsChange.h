//
//  RSTFetchedResultsChange.h
//  Roxas
//
//  Created by Riley Testut on 8/2/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

extern NSInteger RSTUnknownSectionIndex;

@interface RSTFetchedResultsChange : NSObject <NSCopying>

@property (nonatomic, readonly) NSFetchedResultsChangeType type;

@property (nullable, copy, nonatomic, readonly) NSIndexPath *currentIndexPath;
@property (nullable, copy, nonatomic, readonly) NSIndexPath *destinationIndexPath;

// Defaults to RSTUnknownSectionIndex if not representing a section.
@property (nonatomic, readonly) NSInteger sectionIndex;

- (instancetype)initWithType:(NSFetchedResultsChangeType)type currentIndexPath:(nullable NSIndexPath *)currentIndexPath destinationIndexPath:(nullable NSIndexPath *)destinationIndexPath NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithType:(NSFetchedResultsChangeType)type sectionIndex:(NSInteger)sectionIndex NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
