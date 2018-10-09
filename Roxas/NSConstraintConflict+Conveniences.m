//
//  NSConstraintConflict+Conveniences.m
//  Roxas
//
//  Created by Riley Testut on 10/4/18.
//  Copyright © 2018 Riley Testut. All rights reserved.
//

#import "NSConstraintConflict+Conveniences.h"

@interface NSManagedObject (Persisted)
@end

@implementation NSManagedObject (Persisted)

- (BOOL)isPersisted
{
    BOOL isPersisted = ![self.objectID isTemporaryID] && ![self isInserted];
    return isPersisted;
}

@end

@implementation NSConstraintConflict (Conveniences)

- (NSManagedObject *)persistingObject
{
    NSManagedObject *persistingObject = self.databaseObject;
    
    if (persistingObject == nil)
    {
        for (NSManagedObject *object in self.conflictingObjects)
        {
            if (object.managedObjectContext != nil && ![object isDeleted])
            {
                persistingObject = object;
                break;
            }
        }
    }
    
    return persistingObject;
}

- (NSManagedObject *)persistedObject
{
    NSManagedObject *persistedObject = self.databaseObject;
    
    if (persistedObject == nil)
    {
        for (NSManagedObject *object in self.conflictingObjects)
        {
            if ([object isPersisted])
            {
                persistedObject = object;
                break;
            }
        }
    }
    
    return persistedObject;
}

- (NSManagedObject *)temporaryObject
{
    NSManagedObject *temporaryObject = nil;
    
    for (NSManagedObject *object in self.conflictingObjects)
    {
        if (![object isPersisted])
        {
            temporaryObject = object;
            break;
        }
    }
    
    return temporaryObject;
}

- (NSDictionary<NSString *, id> *)persistedObjectSnapshot
{
    __block NSDictionary<NSString *, id> *persistedObjectSnapshot = self.databaseSnapshot;
    
    if (persistedObjectSnapshot == nil)
    {
        [self.conflictingObjects enumerateObjectsUsingBlock:^(NSManagedObject * _Nonnull object, NSUInteger index, BOOL * _Nonnull stop) {
            if ([object isPersisted])
            {
                NSDictionary<NSString *, id> *snapshot = self.conflictingSnapshots[index];
                persistedObjectSnapshot = snapshot;
                
                *stop = YES;
            }
        }];
    }
    
    return persistedObjectSnapshot;
}

- (NSDictionary<NSString *, id> *)temporaryObjectSnapshot
{
    __block NSDictionary<NSString *, id> *temporaryObjectSnapshot = nil;
    
    [self.conflictingObjects enumerateObjectsUsingBlock:^(NSManagedObject * _Nonnull object, NSUInteger index, BOOL * _Nonnull stop) {
        if (![object isPersisted])
        {
            NSDictionary<NSString *, id> *snapshot = self.conflictingSnapshots[index];
            
            if (![snapshot isEqual:[NSNull null]])
            {
                temporaryObjectSnapshot = snapshot;
            }
            
            *stop = YES;
        }
    }];
    
    return temporaryObjectSnapshot;
}

@end
