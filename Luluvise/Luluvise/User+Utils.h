//
//  User+Utils.h
//  Luluvise
//
//  Created by Romain Boulay on 11/1/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import "User.h"

@interface User (Utils)

// Static Getter
+ (NSURL*)pictureURLForFacebookID:(NSNumber*)anID ;
+ (NSString*)pictureFilenameForFacebookID:(NSNumber*)anID ;
+ (NSString*)picturePathForFacebookID:(NSNumber*)anID ;

// Core Data
- (void)configureWithDictionary:(NSDictionary*)userDictionnary ;

+ (NSDictionary*)keyMappingDictionary ;
+ (User*)userWithUID:(NSNumber*)aUID ;
+ (User*)insertUserWithDictionary:(NSDictionary*)aDictionary inContext:(NSManagedObjectContext*)aMoc ;

@end
