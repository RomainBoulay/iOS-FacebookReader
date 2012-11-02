//
//  RBUserServerConnection.h
//  Luluvise
//
//  Created by Romain Boulay on 11/1/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import "RBServerConnection.h"

@interface RBAddUserServerConnection : RBServerConnection

// Shared instance :
+ (RBAddUserServerConnection*)sharedInstance ;

// Call Graph Facebook API to retrieve informations about given user :
- (void)getUserWithFacebookUsername:(NSString*)anID ;


@end
