//
//  UITableView+FetchedResultsChanges.m
//  Roxas
//
//  Created by Riley Testut on 10/21/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "UITableView+FetchedResultsChanges.h"

@implementation UITableView (FetchedResultsChanges)

- (void)rst_addChange:(RSTFetchedResultsChange *)change withRowAnimation:(UITableViewRowAnimation)rowAnimation
{
    switch (change.type)
    {
        case NSFetchedResultsChangeInsert:
        {
            if (change.sectionIndex != RSTUnknownSectionIndex)
            {
                [self insertSections:[NSIndexSet indexSetWithIndex:change.sectionIndex] withRowAnimation:rowAnimation];
            }
            else
            {
                [self insertRowsAtIndexPaths:@[change.destinationIndexPath] withRowAnimation:rowAnimation];
            }
            
            break;
        }
            
        case NSFetchedResultsChangeDelete:
        {
            if (change.sectionIndex != RSTUnknownSectionIndex)
            {
                [self deleteSections:[NSIndexSet indexSetWithIndex:change.sectionIndex] withRowAnimation:rowAnimation];
            }
            else
            {
                [self deleteRowsAtIndexPaths:@[change.currentIndexPath] withRowAnimation:rowAnimation];
            }
            
            break;
        }
            
        case NSFetchedResultsChangeMove:
        {
            // According to documentation:
            // Move is reported when an object changes in a manner that affects its position in the results.  An update of the object is assumed in this case, no separate update message is sent to the delegate.
            [self reloadRowsAtIndexPaths:@[change.currentIndexPath] withRowAnimation:rowAnimation];
            
            [self moveRowAtIndexPath:change.currentIndexPath toIndexPath:change.destinationIndexPath];
            break;
        }
            
        case NSFetchedResultsChangeUpdate:
        {
            [self reloadRowsAtIndexPaths:@[change.currentIndexPath] withRowAnimation:rowAnimation];
            break;
        }
    }
}

@end
