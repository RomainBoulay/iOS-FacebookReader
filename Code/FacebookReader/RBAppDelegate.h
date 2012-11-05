//
//  RBAppDelegate.h
//  FacebookReader
//
//  Created by Romain Boulay on 10/31/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBAppDelegate : UIResponder <UIApplicationDelegate>

// Core Data :
@property (readonly, retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, retain, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, retain, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/* Clone application delegate managed object context. Can be used in order to used moc in an other thread. Moc is autoreleased. */
- (NSManagedObjectContext*)clonedManagedObjectContext;

// To save context in DB :
- (void)saveContext;

// Path util :
- (NSURL *)applicationDocumentsDirectory;

// Main controllers :
@property (retain, nonatomic) UINavigationController *navigationController;
@property (retain, nonatomic) UISplitViewController *splitViewController;

// Window :
@property (retain, nonatomic) UIWindow *window;

@end
