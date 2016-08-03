//
//  RSTFetchedResultsChangeOperation.m
//  Roxas
//
//  Created by Riley Testut on 8/2/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "RSTFetchedResultsChangeOperation.h"

#import "RSTFetchedResultsChange.h"

@implementation RSTFetchedResultsChangeOperation

- (instancetype)initWithChange:(RSTFetchedResultsChange *)change collectionView:(UICollectionView *)collectionView
{
    self = [super init];
    if (self)
    {
        _change = [change copy];
        _collectionView = collectionView;
    }

    return self;
}

- (void)main
{
    switch (self.change.type)
    {
        case NSFetchedResultsChangeInsert:
        {
            if (self.change.sectionIndex != RSTUnknownSectionIndex)
            {
                [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:self.change.sectionIndex]];
            }
            else
            {
                [self.collectionView insertItemsAtIndexPaths:@[self.change.destinationIndexPath]];
            }
            
            break;
        }
            
        case NSFetchedResultsChangeDelete:
        {
            if (self.change.sectionIndex != RSTUnknownSectionIndex)
            {
                [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:self.change.sectionIndex]];
            }
            else
            {
                [self.collectionView deleteItemsAtIndexPaths:@[self.change.currentIndexPath]];
            }
            
            break;
        }
            
        case NSFetchedResultsChangeMove:
        {
            // According to documentation:
            // Move is reported when an object changes in a manner that affects its position in the results.  An update of the object is assumed in this case, no separate update message is sent to the delegate.
            [self.collectionView reloadItemsAtIndexPaths:@[self.change.currentIndexPath]];
            
            [self.collectionView moveItemAtIndexPath:self.change.currentIndexPath toIndexPath:self.change.destinationIndexPath];
            break;
        }
            
        case NSFetchedResultsChangeUpdate:
        {
            [self.collectionView reloadItemsAtIndexPaths:@[self.change.currentIndexPath]];
            break;
        }
    }
}

@end
