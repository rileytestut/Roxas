//
//  RSTCellContentChange.m
//  Roxas
//
//  Created by Riley Testut on 8/2/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "RSTCellContentChange.h"

NSInteger RSTUnknownSectionIndex = -1;

RSTCellContentChangeType RSTCellContentChangeTypeFromFetchedResultsChangeType(NSFetchedResultsChangeType type)
{
    switch (type)
    {
        case NSFetchedResultsChangeInsert: return RSTCellContentChangeInsert;
        case NSFetchedResultsChangeDelete: return RSTCellContentChangeDelete;
        case NSFetchedResultsChangeMove:   return RSTCellContentChangeMove;
        case NSFetchedResultsChangeUpdate: return RSTCellContentChangeUpdate;
    }
}

NSFetchedResultsChangeType NSFetchedResultsChangeTypeFromCellContentChangeType(RSTCellContentChangeType type)
{
    switch (type)
    {
        case RSTCellContentChangeInsert: return NSFetchedResultsChangeInsert;
        case RSTCellContentChangeDelete: return NSFetchedResultsChangeDelete;
        case RSTCellContentChangeMove:   return NSFetchedResultsChangeMove;
        case RSTCellContentChangeUpdate: return NSFetchedResultsChangeUpdate;
    }
}

@implementation RSTCellContentChange

- (instancetype)initWithType:(RSTCellContentChangeType)type currentIndexPath:(NSIndexPath *)currentIndexPath destinationIndexPath:(NSIndexPath *)destinationIndexPath
{
    self = [super init];
    if (self)
    {
        _type = type;
        
        _currentIndexPath = [currentIndexPath copy];
        _destinationIndexPath = [destinationIndexPath copy];
        
        _sectionIndex = RSTUnknownSectionIndex;
        
        _rowAnimation = UITableViewRowAnimationAutomatic;
    }
    
    return self;
}

- (instancetype)initWithType:(RSTCellContentChangeType)type sectionIndex:(NSInteger)sectionIndex
{
    self = [super init];
    if (self)
    {
        _type = type;
        _sectionIndex = sectionIndex;
        
        _rowAnimation = UITableViewRowAnimationAutomatic;
    }
    
    return self;
}

#pragma mark - <NSCopying> -

- (instancetype)copyWithZone:(NSZone *)zone
{
    RSTCellContentChange *change = nil;
    
    if (self.sectionIndex != RSTUnknownSectionIndex)
    {
        change = [[RSTCellContentChange alloc] initWithType:self.type sectionIndex:self.sectionIndex];
    }
    else
    {
        change = [[RSTCellContentChange alloc] initWithType:self.type currentIndexPath:self.currentIndexPath destinationIndexPath:self.destinationIndexPath];
    }
    
    return change;
}

@end
