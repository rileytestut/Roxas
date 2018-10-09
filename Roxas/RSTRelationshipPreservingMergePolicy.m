//
//  RSTRelationshipPreservingMergePolicy.m
//  Roxas
//
//  Created by Riley Testut on 7/16/18.
//  Copyright © 2018 Riley Testut. All rights reserved.
//

#import "RSTRelationshipPreservingMergePolicy.h"

#import "NSConstraintConflict+Conveniences.h"

@implementation RSTRelationshipPreservingMergePolicy

- (instancetype)init
{
    self = [super initWithMergeType:NSMergeByPropertyObjectTrumpMergePolicyType];
    return self;
}

- (BOOL)resolveConstraintConflicts:(NSArray<NSConstraintConflict *> *)conflicts error:(NSError * _Nullable __autoreleasing *)error
{
    BOOL success = [super resolveConstraintConflicts:conflicts error:error];
    
    for (NSConstraintConflict *conflict in conflicts)
    {
        NSManagedObject *persistingObject = conflict.persistingObject;
        NSManagedObject *temporaryObject = conflict.temporaryObject;

        NSDictionary<NSString *, id> *persistedSnapshot = conflict.persistedObjectSnapshot;
        NSDictionary<NSString *, id> *temporarySnapshot = conflict.temporaryObjectSnapshot;
        
        if (persistingObject == nil || temporaryObject == nil || persistedSnapshot == nil || temporarySnapshot == nil)
        {
            continue;
        }
        
        [persistingObject.entity.relationshipsByName enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSRelationshipDescription *relationship, BOOL *stop) {
            if ([relationship isToMany])
            {
                // Superclass already handles to-many relationships correctly, so ignore this relationship.
                return;
            }
            
            if ([persistingObject valueForKey:name] != nil)
            {
                // We only need to fix relationships that have become nil after merging, so ignore this relationship.
                return;
            }
            
            NSManagedObject *relationshipObject = nil;
            
            NSManagedObject *previousRelationshipObject = persistedSnapshot[name];
            if (previousRelationshipObject != nil && ![previousRelationshipObject isEqual:[NSNull null]])
            {                
                if (temporarySnapshot[name] == nil)
                {
                    if (temporaryObject.changedValues[name] == nil)
                    {
                        // Previously non-nil, updated to nil, but was _not_ explicitly set to nil, so restore previous relationship.
                        relationshipObject = previousRelationshipObject;
                    }
                    else
                    {
                        // Same as above, but _was_ explicitly set to nil, so no need to fix anything.
                    }
                }
                else
                {
                    // Previously non-nil, updated to non-nil, so restore previous relationship (since the new relationship has been deleted).
                    relationshipObject = previousRelationshipObject;
                }
            }
            else
            {
                NSManagedObject *object = temporarySnapshot[name];
                if (object != nil)
                {
                    // Previously nil, updated to non-nil, so restore updated relationship.
                    relationshipObject = object;
                }
            }
            
            if (relationshipObject == nil || [relationshipObject isEqual:[NSNull null]])
            {
                return;
            }
            
            [persistingObject setValue:relationshipObject forKey:name];
            
            NSRelationshipDescription *inverseRelationship = relationship.inverseRelationship;
            if (inverseRelationship != nil && ![inverseRelationship isToMany])
            {
                // We need to also update to-one inverse relationships.
                [relationshipObject setValue:persistingObject forKey:inverseRelationship.name];
            }
        }];
    }
    
    return success;
}

@end
