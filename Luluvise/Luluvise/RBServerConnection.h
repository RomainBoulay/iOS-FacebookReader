//
//  RBServerConnection.h
//  Luluvise
//
//  Created by Romain Boulay on 11/1/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBServerConnection : NSObject <NSURLConnectionDelegate> {
    NSArray* trustedHosts;
}

- (void)performRequestWithFacebookUsername:(NSString*)anID ;
- (void)handleReceivedData:(NSData *)data ;
- (void)bgGetPictureForUserID:(NSNumber*)anID ;

@end
