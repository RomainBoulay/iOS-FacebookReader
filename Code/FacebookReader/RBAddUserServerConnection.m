//
//  RBUserServerConnection.m
//  FacebookReader
//
//  Created by Romain Boulay on 11/1/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import "RBAddUserServerConnection.h"


@implementation RBAddUserServerConnection
+ (RBAddUserServerConnection*)sharedInstance {
    static RBAddUserServerConnection *sharedInstance = nil ;
    
    if (!sharedInstance){
        sharedInstance = [[RBAddUserServerConnection alloc] init] ;
    }
    
    return sharedInstance ;
}


- (void)getUserWithFacebookUsername:(NSString*)anID {
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
    
    // Update it if already exists :
    if (user) {
        [user configureWithDictionary:userDictionary];

        // Post notification to notify that user has been refreshed :
        NSDictionary* userInfo = (user.objectID) ? @{@"userID" : user.objectID} : nil ;
        
        if (userInfo)
            [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:USER_REFRESHED_NOTIFICATION
                                                                            object:self
                                                                          userInfo:userInfo];
    }
    // else, create one :
    else
        user = [User insertUserWithDictionary:userDictionary inContext:MAIN_MOC];

    
    // Get picture in background :
    if (user.uid)
        [self performSelectorInBackground:@selector(bgGetPictureForUserID:)
                           withObject:user.uid];
}



@end
