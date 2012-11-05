//
//  RBUserDetailViewController.m
//  FacebookReader
//
//  Created by Romain Boulay on 10/31/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import "RBUserDetailViewController.h"
#import "RBRefreshUserServerConnection.h"
#import "RBWebViewController.h"

@interface RBUserDetailViewController ()
@property (retain, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation RBUserDetailViewController

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

#pragma mark - Setter
- (void)setUser:(id)newUser
{
    if (user != newUser) {
        [user release];
        user = [newUser retain];

        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

#pragma mark - View lifecycle
- (void)displayPicture {
    if (self.user) {
        self.pictureImageView.image = [UIImage imageWithContentsOfFile:self.user.picturePath];
    }
}

- (void)configureView
{
    // Update the user interface for the given user.
    if (self.user) {
        self.scrollView.hidden = NO ;
        
        self.usernameLabel.text = self.user.name;
        [self displayPicture];
        
        self.firstNameLabel.text = ([user.firstName length]) ? user.firstName : NSLocalizedString(@"RBUserDetailViewController.default", @"Default text when attribute is nil.") ;
        self.nameLabel.text = ([user.lastName length]) ? user.lastName : NSLocalizedString(@"RBUserDetailViewController.default", @"Default text when attribute is nil.") ;
        self.genderLabel.text = ([user.gender length]) ? user.gender : NSLocalizedString(@"RBUserDetailViewController.default", @"Default text when attribute is nil.") ;
        self.localeLabel.text = ([user.locale length]) ? user.locale : NSLocalizedString(@"RBUserDetailViewController.default", @"Default text when attribute is nil.") ;
        self.idLabel.text = (user.uid) ? [user.uid stringValue] : NSLocalizedString(@"RBUserDetailViewController.default", @"Default text when attribute is nil.") ;
        
        self.profileButton.hidden = !([user.link length]) ;
        
        // Change background color :
        if ([self.user.gender isEqualToString:@"male"]) 
            self.scrollView.backgroundColor = MALE_COLOR;
        else if ([self.user.gender isEqualToString:@"female"]) 
            self.scrollView.backgroundColor = FEMALE_COLOR;
        else
            self.scrollView.backgroundColor = [UIColor whiteColor];
        
        // Profile button :
        if ([self.user.gender isEqualToString:@"male"])
            [self.profileButton setTitle:NSLocalizedString(@"RBUserDetailViewController.profileButton.male", @"Button caption")
                                forState:UIControlStateNormal] ;
        else if ([self.user.gender isEqualToString:@"female"])
            [self.profileButton setTitle:NSLocalizedString(@"RBUserDetailViewController.profileButton.female", @"Button caption")
                                forState:UIControlStateNormal] ;
        else
            [self.profileButton setTitle:NSLocalizedString(@"RBUserDetailViewController.profileButton.unknown", @"Button caption")
                                forState:UIControlStateNormal] ;
        
        // Make scrollview touchable :
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.scrollView.frame)+2);
    }
    else {
        self.scrollView.hidden = YES ;
    }
}

// Handle orientation for iOS < 6 :
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add refresh button on nav bar :
    UIBarButtonItem *refreshButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"RBUserDetailViewController.refresh", @"")
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(refreshUser:)] autorelease];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    
    // Listen to network notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userRefreshed:)
                                                 name:USER_REFRESHED_NOTIFICATION
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pictureRefreshed:)
                                                 name:PICTURE_CONTENT_DOWNLOADED
                                               object:nil];
    
    // Add "go to profile" button
    self.profileButton = [[[BUIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.localeCaptionLabel.frame) + 10, 280, 36)] autorelease];
    [self.profileButton addTarget:self
                           action:@selector(goToProfile:)
                 forControlEvents:UIControlEventTouchUpInside];
    self.profileButton.autoresizingMask = self.contentView.autoresizingMask ;
    [self.contentView addSubview:self.profileButton];
    
    // Localization :
    self.firstNameCaptionLabel.text = NSLocalizedString(@"RBUserDetailViewController.firstNameCaptionLabel", @"first name caption") ;
    self.nameCaptionLabel.text = NSLocalizedString(@"RBUserDetailViewController.nameCaptionLabel", @"name caption") ;
    self.genderCaptionLabel.text = NSLocalizedString(@"RBUserDetailViewController.genderCaptionLabel", @"gender caption") ;
    self.localeCaptionLabel.text =  NSLocalizedString(@"RBUserDetailViewController.localeCaptionLabel", @"locale caption") ;
    self.idCaptionLabel.text = NSLocalizedString(@"RBUserDetailViewController.idCaptionLabel", @"ID caption") ;
    
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Configure view on appearance :
    [self configureView];
}


#pragma mark - UI Actions
- (IBAction)goToProfile:(id)sender {
    // Push a web view to current user profile URL :
    RBWebViewController* webViewController = [[RBWebViewController alloc] initWithNibName:@"RBWebViewController" bundle:nil];
    webViewController.urlString = user.link ;
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController release] ;
}

- (void)refreshUser:(id)sender {
    // user asks to refresh datas :
    [[RBRefreshUserServerConnection sharedInstance] refreshWithFacebookUsername:[self.user.uid stringValue]];
}



#pragma mark - Network Notification
- (void)userRefreshed:(NSNotification*)aNotif {
    // Refresh UI if needed :
    NSManagedObjectID* userRefreshedID = [aNotif.userInfo objectForKeyOrNil:@"userID"];
    if ([userRefreshedID isEqual:self.user.objectID])
        [self configureView];
}

- (void)pictureRefreshed:(NSNotification*)aNotif {
    NSNumber* userRefreshedFacebookID = [aNotif.userInfo objectForKeyOrNil:@"facebookID"];
    if ([userRefreshedFacebookID isEqual:self.user.uid])
        [self configureView];
}



#pragma mark - Split view
- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
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
    
    [self setPictureImageView:nil];
    [self setContentView:nil];
    [self setScrollView:nil];
    [self setFirstNameCaptionLabel:nil];
    [self setNameCaptionLabel:nil];
    [self setGenderCaptionLabel:nil];
    [self setIdCaptionLabel:nil];
    [self setLocaleCaptionLabel:nil];
    [self setFirstNameLabel:nil];
    [self setNameLabel:nil];
    [self setGenderLabel:nil];
    [self setIdLabel:nil];
    [self setLocaleLabel:nil];
    [self setProfileButton:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.user = nil ;
    [_usernameLabel release];
    [_masterPopoverController release];
    [_pictureImageView release];
    [_contentView release];
    [_scrollView release];
    [_firstNameCaptionLabel release];
    [_nameCaptionLabel release];
    [_genderCaptionLabel release];
    [_idCaptionLabel release];
    [_localeCaptionLabel release];
    [_firstNameLabel release];
    [_nameLabel release];
    [_genderLabel release];
    [_idLabel release];
    [_localeLabel release];
    [_profileButton release];
    [super dealloc];
}

@synthesize user ;


@end
