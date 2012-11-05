//
//  RBCoreDataHelpers.h
//  FacebookReader
//
//  Created by Romain Boulay on 11/1/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBCoreDataHelpers : NSObject

// Insert new entity
+ (id)insertEntityNamed:(NSString*)entityName withDictionary:(NSDictionary*)aDictionary inContext:(NSManagedObjectContext*)aMoc;

// Get 1 managed object :
+ (id)managedObjectForEntityName:(NSString*)entityName predicate:(NSPredicate*)aPredicate context:(NSManagedObjectContext*)aMoc ;

// Get all managed object for given entity name
+ (NSArray*)managedObjectsForEntityName:(NSString*)entityName context:(NSManagedObjectContext*)aMoc ;

@end
