//
//  RSTFetchedResultsChange.m
//  Roxas
//
//  Created by Riley Testut on 8/2/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "RSTFetchedResultsChange.h"

NSInteger RSTUnknownSectionIndex = -1;

@implementation RSTFetchedResultsChange

- (instancetype)initWithType:(NSFetchedResultsChangeType)type currentIndexPath:(NSIndexPath *)currentIndexPath destinationIndexPath:(NSIndexPath *)destinationIndexPath
{
    self = [super init];
    if (self)
    {
        _type = type;
        
        _currentIndexPath = [currentIndexPath copy];
        _destinationIndexPath = [destinationIndexPath copy];
        
        _sectionIndex = RSTUnknownSectionIndex;
    }
    
    return self;
}

- (instancetype)initWithType:(NSFetchedResultsChangeType)type sectionIndex:(NSInteger)sectionIndex
{
    self = [super init];
    if (self)
    {
        _type = type;
        _sectionIndex = sectionIndex;
    }
    
    return self;
}

#pragma mark - <NSCopying> -

- (instancetype)copyWithZone:(NSZone *)zone
{
    RSTFetchedResultsChange *change = nil;
    
    if (self.sectionIndex != RSTUnknownSectionIndex)
    {
        change = [[RSTFetchedResultsChange alloc] initWithType:self.type sectionIndex:self.sectionIndex];
    }
    else
    {
        change = [[RSTFetchedResultsChange alloc] initWithType:self.type currentIndexPath:self.currentIndexPath destinationIndexPath:self.destinationIndexPath];
    }
    
    return change;
}

@end
