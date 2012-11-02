//
//  RBUserServerConnection.m
//  Luluvise
//
//  Created by Romain Boulay on 11/1/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import "RBRefreshUserServerConnection.h"


@implementation RBRefreshUserServerConnection
+ (RBRefreshUserServerConnection*)sharedInstance {
    static RBRefreshUserServerConnection *sharedInstance = nil ;
    
    if (!sharedInstance){
        sharedInstance = [[RBRefreshUserServerConnection alloc] init] ;
    }
    
    return sharedInstance ;
}


- (void)refreshWithFacebookUsername:(NSString*)anID {
    [super performRequestWithFacebookUsername:anID];
}


#pragma mark - Network callback
- (void)handleReceivedData:(NSData *)data {
    [super handleReceivedData:data];
    
    if (!data)
        return ;
    
    // Get response from facebook :
    NSDictionary* userDictionary = [data objectFromJSONData];
    
    // Check if no errors are present :
    if ([userDictionary objectForKeyOrNil:@"error"]) {
        NSLog(@"User doesn't exist");
        return ;
    }
    
    // Get managed object :
    User* user = [User userWithUID:[userDictionary objectForKeyOrNil:UID_USER_JSON_KEY]] ;
    
    if (user) {
        // update it :
        [user configureWithDictionary:userDictionary];

        // Post notification to notify that user has been refreshed :
        NSDictionary* userInfo = (user.objectID) ? @{@"userID" : user.objectID} : nil ;
        
        // Notify listener of the update :
        if (userInfo)
            [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:USER_REFRESHED_NOTIFICATION
                                                                            object:self
                                                                          userInfo:userInfo];
        
        // Get picture in background :
        if (user.uid)
            [self performSelectorInBackground:@selector(bgGetPictureForUserID:)
                                   withObject:user.uid];
    }
}





@end
