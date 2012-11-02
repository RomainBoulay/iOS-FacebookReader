//
//  RBWebViewController.m
//  Luluvise
//
//  Created by Romain Boulay on 11/1/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import "RBWebViewController.h"

@interface RBWebViewController ()

@end

@implementation RBWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"RBWebViewController.title", @"Facebook profile");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

// Handle orientation for iOS < 6 :
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Ask to go to user URL before appearance :
    if ([urlString length]) {
        NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]] ;
        [self.webView loadRequest:urlRequest] ;
        [urlRequest release] ;
    }    
}

#pragma mark - Web view delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activity stopAnimating] ;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activity startAnimating] ;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    // Notify user on network failure :
    [self.activity stopAnimating] ;

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"RBWebViewController.alert.title", @"Information")
                                                    message:NSLocalizedString(@"RBWebViewController.alert.message", @"Network problem occured")
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"RBMasterViewController.addUser.ok", @"OK")
                                          otherButtonTitles:nil] ;
    
    [alert show];
    [alert release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window)
    {
        self.view = nil;
        [self viewDidUnload];
    }
}

- (void)dealloc {
    self.urlString = nil ;
    [_webView release];
    [_activity release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [self setActivity:nil];
    [super viewDidUnload];
}
@synthesize urlString ;

@end
