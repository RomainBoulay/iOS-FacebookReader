//
//  RBAppDelegate.m
//  Luluvise
//
//  Created by Romain Boulay on 10/31/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import "RBAppDelegate.h"

#import "RBMasterViewController.h"
#import "RBUserDetailViewController.h"
#import "RBAddUserServerConnection.h"

@implementation RBAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Create DB if needed :
    [self.managedObjectContext save:nil] ;
    
    // Register for notifications
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(managedObjectContextSaved:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];    

    
    // init window:
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone UI
        RBMasterViewController *masterViewController = [[[RBMasterViewController alloc] initWithNibName:@"RBMasterViewController_iPhone" bundle:nil] autorelease];
        self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
        self.window.rootViewController = self.navigationController;
        masterViewController.managedObjectContext = self.managedObjectContext;
    } else {
        // iPad UI
        RBMasterViewController *masterViewController = [[[RBMasterViewController alloc] initWithNibName:@"RBMasterViewController_iPad" bundle:nil] autorelease];
        UINavigationController *masterNavigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
        
        RBUserDetailViewController *detailViewController = [[[RBUserDetailViewController alloc] initWithNibName:@"RBUserDetailViewController_iPad" bundle:nil] autorelease];
        UINavigationController *detailNavigationController = [[[UINavigationController alloc] initWithRootViewController:detailViewController] autorelease];
    	
    	masterViewController.detailViewController = detailViewController;
        
        self.splitViewController = [[[UISplitViewController alloc] init] autorelease];
        self.splitViewController.delegate = detailViewController;
        self.splitViewController.viewControllers = @[masterNavigationController, detailNavigationController];
        
        self.window.rootViewController = self.splitViewController;
        masterViewController.managedObjectContext = self.managedObjectContext;
    }
    
    [self.window makeKeyAndVisible];
    
    // Get data from network :
    [self refreshData];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


#pragma mark - Data
- (void)refreshData {
    // Ask WS to get info for 100001114785800 user
    [[RBAddUserServerConnection sharedInstance] getUserWithFacebookUsername:@"100001114785800"];
    
    // Add myself on table view :
    [[RBAddUserServerConnection sharedInstance] getUserWithFacebookUsername:@"romain.boulay"];
}

#pragma mark - Core Data stack
#pragma mark Core data
- (NSManagedObjectContext*)clonedManagedObjectContext
{
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Luluvise.sqlite"];
    
	if (!self.managedObjectContext || !self.persistentStoreCoordinator || !storeURL)
		return nil;
    
	// Persistent store coordinator
	NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
	// Create moc
	NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
	moc.persistentStoreCoordinator = storeCoordinator;
	
	// Get back current store
	NSPersistentStore *currentStore = [self.persistentStoreCoordinator persistentStoreForURL:storeURL];
	
	// Configure store coordinator
	[storeCoordinator addPersistentStoreWithType:currentStore.type
								   configuration:currentStore.configurationName
											 URL:storeURL
										 options:currentStore.options
										   error:nil];
    
	// Memory
	[storeCoordinator release];
    
	return [moc autorelease];
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        _managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Luluvise" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Luluvise.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}


#pragma mark NSManagedObjectContext notifications
- (void)managedObjectContextSaved:(NSNotification*)aNotification
{
	if (aNotification.object == _managedObjectContext)
		return;
    
	// Merge data
	[_managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
											 withObject:aNotification
										  waitUntilDone:YES];
    
	// Save modifications
	[_managedObjectContext performSelectorOnMainThread:@selector(save:)
											 withObject:nil
										  waitUntilDone:YES];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Memory
- (void)dealloc
{
    [_window release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [_navigationController release];
    [_splitViewController release];
    [super dealloc];
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@end
