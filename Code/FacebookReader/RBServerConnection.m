//
//  RBServerConnection.m
//  FacebookReader
//
//  Created by Romain Boulay on 11/1/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import "RBServerConnection.h"

@interface RBServerConnection()

@property(nonatomic, retain) NSArray* trustedHosts;
@end

@implementation RBServerConnection

// Initialize server connection object and trusted hosts
- (id)init {
    if (self = [super init]) {
        // Add graph.facebook.com as trusted host :
        self.trustedHosts = @[@"graph.facebook.com"] ;
    }
    
    return self ;
}

- (void)performRequestWithFacebookUsername:(NSString*)anID {
    if (![anID length]) {
        NSLog(@"getUserWithID : No given id");
        return ;
    }
    
    // Concatenate the right URL
    NSString* urlString = [FACEBOOK_GRAPH_BASE_URL stringByAppendingPathComponent:anID];
    
    // Build the URL to call
    NSURLRequest* getRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    // Send request
    NSURLConnection* urlConnection = [NSURLConnection connectionWithRequest:getRequest
                                                                   delegate:self];
    [urlConnection start] ;
    [getRequest release] ;
    
    // Notify user that the app is using network
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (void)handleReceivedData:(NSData *)data {
    if (!data)
        return ;
    
    // Just print the response :
    NSDictionary* responseDic = [data objectFromJSONData];
    NSLog(@"%@", responseDic);
}



#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Stop notify user for networking
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"RBWebViewController.alert.title", @"Information")
                                                    message:NSLocalizedString(@"RBWebViewController.alert.message", @"Network problem occured")
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"RBMasterViewController.addUser.ok", @"OK")
                                          otherButtonTitles:nil] ;
    
    [alert show];
    [alert release];
}


// HTTPS handling
- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    return YES ;
}

// HTTPS handling
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

// HTTPS handling
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([trustedHosts containsObject:challenge.protectionSpace.host]) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
                 forAuthenticationChallenge:challenge];
        }
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


// response from WS :
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    [self handleReceivedData:data];
}


#pragma mark - User utils
- (void)bgGetPictureForUserID:(NSNumber*)anID {
    if (!anID)
        return ;
    
    NSAutoreleasePool * thePool = [[NSAutoreleasePool alloc] init];
    
    // Get picture data from facebook :
    NSError* error = nil ;
    NSData* pictureData = [NSData dataWithContentsOfURL:[User pictureURLForFacebookID:anID]];
    
    [pictureData writeToFile:[User picturePathForFacebookID:anID]
                  atomically:YES];
    
    // Check errors :
    if (error)
        NSLog(@"dataWithContentsOfURL error : %@", [error localizedDescription]);
    else {
        // Post notification to notify that user has been refreshed :
        [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:PICTURE_CONTENT_DOWNLOADED
                                                                        object:self
                                                                      userInfo:@{@"facebookID" : anID}];
    }
    
    [thePool drain];
}

#pragma mark - Memory 
- (void)dealloc {
    self.trustedHosts = nil ;
    
    [super dealloc];
}

@synthesize trustedHosts;

@end
