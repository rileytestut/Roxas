//
//  RSTRelationshipPreservingMergePolicy.m
//  Roxas
//
//  Created by Riley Testut on 7/16/18.
//  Copyright © 2018 Riley Testut. All rights reserved.
//

#import "RSTRelationshipPreservingMergePolicy.h"

@implementation RSTRelationshipPreservingMergePolicy

- (instancetype)init
{
    self = [super initWithMergeType:NSMergeByPropertyObjectTrumpMergePolicyType];
    return self;
}

- (BOOL)resolveConstraintConflicts:(NSArray<NSConstraintConflict *> *)conflicts error:(NSError * _Nullable __autoreleasing *)error
{
    NSMutableDictionary<NSManagedObjectID *, NSDictionary<NSString *, NSManagedObject *> *> *relationshipsByObjectID = [NSMutableDictionary dictionary];
    
    for (NSConstraintConflict *conflict in conflicts)
    {
        NSManagedObject *databaseObject = conflict.databaseObject;
        if (databaseObject == nil)
        {
            // Limit merge policy logic to database-level violations.
            continue;
        }
        
        NSMutableDictionary<NSString *, NSManagedObject *> *relationships = [NSMutableDictionary dictionary];
        
        NSManagedObject *managedObject = conflict.conflictingObjects.firstObject;
        [managedObject.entity.relationshipsByName enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSRelationshipDescription *relationship, BOOL *stop) {
            if ([relationship isToMany])
            {
                // Superclass already handles to-many relationships correctly, so ignore this relationship.
                return;
            }
            
            if (managedObject.changedValues[name] != nil)
            {
                // If this relationship has been explicitly changed, we will let the superclass logic handle it.
                return;
            }
            
            NSManagedObject *relationshipObject = [databaseObject valueForKey:name];
            relationships[name] = relationshipObject;
        }];
        
        relationshipsByObjectID[databaseObject.objectID] = relationships;
    }
    
    BOOL success = [super resolveConstraintConflicts:conflicts error:error];
    
    for (NSConstraintConflict *conflict in conflicts)
    {
        NSManagedObject *databaseObject = conflict.databaseObject;
        if (databaseObject == nil)
        {
            // Limit merge policy logic to database-level violations.
            continue;
        }
        
        NSManagedObject *managedObject = conflict.databaseObject;
        [managedObject.entity.relationshipsByName enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSRelationshipDescription *relationship, BOOL *stop) {
            NSManagedObject *relationshipObject = relationshipsByObjectID[databaseObject.objectID][name];
            if (relationshipObject == nil)
            {
                return;
            }
            
            if ([relationshipObject isEqual:[NSNull null]])
            {
                [databaseObject setValue:nil forKey:name];
            }
            else
            {
                [databaseObject setValue:relationshipObject forKey:name];
                
                NSRelationshipDescription *inverseRelationship = relationship.inverseRelationship;
                if (inverseRelationship != nil && ![inverseRelationship isToMany])
                {
                    // We need to also update to-one inverse relationships.
                    [relationshipObject setValue:databaseObject forKey:inverseRelationship.name];
                }
            }
        }];
    }
    
    return success;
}

@end
