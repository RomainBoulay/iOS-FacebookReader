//
//  RBMasterViewController.h
//  Luluvise
//
//  Created by Romain Boulay on 10/31/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class RBUserDetailViewController;

@interface RBMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate>

// User detail view controller :
@property (retain, nonatomic) RBUserDetailViewController *detailViewController;

// CORE DATA : Fetch results controller and MOC :
@property (retain, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
