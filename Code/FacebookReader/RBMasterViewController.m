//
//  RBMasterViewController.m
//  FacebookReader
//
//  Created by Romain Boulay on 10/31/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import "RBMasterViewController.h"

#import "RBUserDetailViewController.h"
#import "UserCell.h"
#import "RBRefreshUserServerConnection.h"
#import "RBAddUserServerConnection.h"

@interface RBMasterViewController ()
@property(nonatomic, retain) UITableViewCell* loadedCell;
@property(nonatomic, retain) UITextField* textField ;
@property(nonatomic, retain) UIAlertView* alert ;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation RBMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);            
        }
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Add edit button in nav bar :
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewUser:)] autorelease];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Listen to picture update notifications :
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pictureRefreshed:)
                                                 name:PICTURE_CONTENT_DOWNLOADED
                                               object:nil];
}

// Handle orientation for iOS < 6 :
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark Adding a user
- (void)insertNewUser:(id)sender {
    // open a alert with text field,  OK and cancel button
	self.alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"RBMasterViewController.addUser.title", @"Add User title")
                                       message:NSLocalizedString(@"RBMasterViewController.addUser.title", @"Add User title")
                                      delegate:self
                             cancelButtonTitle:NSLocalizedString(@"RBMasterViewController.addUser.cancel", @"Cancel adding user button text")
                             otherButtonTitles:NSLocalizedString(@"RBMasterViewController.addUser.ok", @"Add user button text"), nil] autorelease];
	
    // Make pop-up if needed
	if(!self.textField) {
		self.textField = [[[UITextField alloc] initWithFrame:CGRectMake(14, 50, 255, 27)] autorelease];
		_textField.delegate = self ;
        _textField.keyboardAppearance = UIKeyboardAppearanceAlert ;
		
		_textField.borderStyle = UITextBorderStyleBezel;
		_textField.textColor = [UIColor blackColor];
		_textField.textAlignment = UITextAlignmentCenter;
		_textField.font = [UIFont systemFontOfSize:14.0];
		_textField.backgroundColor = [UIColor whiteColor];
		_textField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		
		_textField.keyboardType = UIKeyboardTypeEmailAddress;	// use the default type input method (entire keyboard)
		_textField.returnKeyType = UIReturnKeyDone;
		_textField.delegate = self;
		_textField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	}
    
    self.textField.placeholder = NSLocalizedString(@"RBMasterViewController.textField.placeholder", @"Text Field Placeholder");
    self.textField.text = @"";
    
    // Launch Alert View :
	[alert addSubview:self.textField];
	[alert show];
    self.alert = nil ;
    
    // Make keyboard appears
    [_textField performSelector:@selector(becomeFirstResponder)
                                withObject:nil
                                afterDelay:0.1];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	// Do nothing on cancellation :
	if (alertView.cancelButtonIndex == buttonIndex) 
        return ;
	
	// Get the text entered :
	for (UIView* v in alertView.subviews){
		if ([v isKindOfClass:[UITextField class]]){

            // Customize keyboard appearance:
			((UITextField*)v).keyboardAppearance = UIKeyboardAppearanceAlert;
            
            // Ask Facebook for user id :
            [[RBAddUserServerConnection sharedInstance] getUserWithFacebookUsername:((UITextField*)v).text];            
			break;
		}
	}
}



#pragma mark TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self alertView:alert clickedButtonAtIndex:alert.firstOtherButtonIndex] ;
	[alert dismissWithClickedButtonIndex:alert.firstOtherButtonIndex
								animated:YES] ;
	return YES ;
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	id cell = [aTableView dequeueReusableCellWithIdentifier:UserCell_ID];
	
	// If no cell is available, create a new one
	if (!cell)
	{
		// Load cell
		[[UserCell cellNib] instantiateWithOwner:self
                                         options:nil];
		
		cell = [_loadedCell retain];
		self.loadedCell = nil;
		[cell autorelease];
	}
	
	return cell;
}

- (void)tableView:(UITableView*)aTableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self configureCell:cell atIndexPath:indexPath];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}





- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get selected user :
    User *user = (User*)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    // refresh Data
    [[RBRefreshUserServerConnection sharedInstance] refreshWithFacebookUsername:user.username];
    
    // Configure and init next view :
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController = [[[RBUserDetailViewController alloc] initWithNibName:@"RBUserDetailViewController_iPhone" bundle:nil] autorelease];
	    }
        self.detailViewController.user = user;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        self.detailViewController.user = user;
    }
}



#pragma mark - Network
- (void)pictureRefreshed:(NSNotification*)aNotif {
    // Get facebook ID from picture refreshed :
    NSNumber* userRefreshedFacebookID = [aNotif.userInfo objectForKeyOrNil:@"facebookID"];
    if (!userRefreshedFacebookID)
        return ;
    
    // Get user managed object :
    User* u = [User userWithUID:userRefreshedFacebookID];
    
    if (u) {
        // Get index path of associated cell :
        NSIndexPath* indexPath = [_fetchedResultsController indexPathForObject:u];
        if (indexPath) {
            // update cell :
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
        }
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([User class])
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Sort list by name :
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:NAME_USER_COREDATA_KEY
                                                                    ascending:YES] autorelease];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"] autorelease];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (!cell || !indexPath)
        return ;
    
    // Configure cell to customize UI :
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UserCell* userCell = (UserCell*)cell ;
    [userCell configureCellWithUser:(User*)object];
}


#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window)
    {
        self.view = nil;
        [self viewDidUnload];
    }
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.loadedCell = nil ;
    self.textField = nil ;
    self.alert = nil ;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_detailViewController release];
    [_fetchedResultsController release];
    [_managedObjectContext release];
    [super dealloc];
}

@synthesize alert ;

@end
