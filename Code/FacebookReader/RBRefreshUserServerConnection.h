//
//  RBUserServerConnection.h
//  FacebookReader
//
//  Created by Romain Boulay on 11/1/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import "RBServerConnection.h"

@interface RBRefreshUserServerConnection : RBServerConnection

// Shared instance :
+ (RBRefreshUserServerConnection*)sharedInstance ;

// Call Graph Facebook API to refresh informations about given user :
- (void)refreshWithFacebookUsername:(NSString*)anID ;


@end
