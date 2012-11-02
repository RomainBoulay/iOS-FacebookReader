//
//  RBCoreDataHelpers.m
//  Luluvise
//
//  Created by Romain Boulay on 11/1/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import "RBCoreDataHelpers.h"

@implementation RBCoreDataHelpers


+ (NSArray*)managedObjectsForEntityName:(NSString*)entityName context:(NSManagedObjectContext*)aMoc {
    if (!entityName | !aMoc) {
        NSLog(@"RBCoreDataHelpers, managedObjectsForEntityName:context:\n Problem in given parameters");
        return nil;
    }
    
    // Create the fetch request to get user matching the ID.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityName
                                        inManagedObjectContext:aMoc]];
    
    NSError *error = nil ;
    NSArray *users = [aMoc executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release] ;
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return nil ;
    }
    
    return users;
}


+ (id)managedObjectForEntityName:(NSString*)entityName predicate:(NSPredicate*)aPredicate context:(NSManagedObjectContext*)aMoc {
    if (!entityName | !aMoc) {
        NSLog(@"RBCoreDataHelpers, managedObjectForEntityName. Problem in given parameters");
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityName
                                        inManagedObjectContext:aMoc]];
    [fetchRequest setPredicate:aPredicate];
    fetchRequest.fetchLimit = 1 ;
    
    NSError *error = nil ;
    NSArray *users = [aMoc executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release] ;
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return nil ;
    }
    
    if ([users count])
        return [users objectAtIndex:0];
    
    return nil ;
}


+ (id)insertEntityNamed:(NSString*)entityName withDictionary:(NSDictionary*)aDictionary inContext:(NSManagedObjectContext*)aMoc{
    if (!entityName | !aMoc) {
        NSLog(@"RBCoreDataHelpers, insertEntityNamed. Problem in given parameters");
        return nil;
    }
    
    NSManagedObjectContext* mo = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                               inManagedObjectContext:aMoc] ;
    
    if ([mo respondsToSelector:@selector(configureWithDictionary:)])
        [mo performSelector:@selector(configureWithDictionary:) withObject:aDictionary];
    
    return mo;
}


@end
