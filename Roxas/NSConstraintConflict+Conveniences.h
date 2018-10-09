//
//  NSConstraintConflict+Conveniences.h
//  Roxas
//
//  Created by Riley Testut on 10/4/18.
//  Copyright © 2018 Riley Testut. All rights reserved.
//

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface NSConstraintConflict (Conveniences)

// The NSManagedObject instance that will be persisted to disk.
@property (nullable, nonatomic, readonly) NSManagedObject *persistingObject;

@property (nullable, nonatomic, readonly) NSManagedObject *persistedObject;
@property (nullable, nonatomic, readonly) NSManagedObject *temporaryObject;

@property (nullable, nonatomic, readonly) NSDictionary<NSString *, id> *persistedObjectSnapshot;
@property (nullable, nonatomic, readonly) NSDictionary<NSString *, id> *temporaryObjectSnapshot;

@end

NS_ASSUME_NONNULL_END
