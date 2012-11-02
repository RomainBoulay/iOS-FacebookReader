//
//  User+Utils.m
//  Luluvise
//
//  Created by Romain Boulay on 11/1/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//


#import "User+Utils.h"

@implementation User (Utils)

#pragma mark - Static Getter
+ (NSURL*)pictureURLForFacebookID:(NSNumber*)anID {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/picture", FACEBOOK_GRAPH_BASE_URL, [anID stringValue]]];
}

+ (NSString*)picturePathForFacebookID:(NSNumber*)anID {
    return [PATH_DOCUMENTS stringByAppendingPathComponent:[User pictureFilenameForFacebookID:anID]] ;
}

+ (NSString*)pictureFilenameForFacebookID:(NSNumber*)anID {
    return [NSString stringWithFormat:@"%@.jpeg", [anID stringValue]];
}



#pragma mark - Core Data
- (void)configureWithDictionary:(NSDictionary*)userDictionnary {
    self.uid = [NSNumber numberWithLongLong:[[userDictionnary objectForKeyOrNil:UID_USER_JSON_KEY] longLongValue]];
    self.firstName = [userDictionnary objectForKeyOrNil:FIRSTNAME_USER_JSON_KEY];
    self.lastName = [userDictionnary objectForKeyOrNil:LASTNAME_USER_JSON_KEY];
    self.name = [userDictionnary objectForKeyOrNil:NAME_USER_JSON_KEY];
    self.locale = [userDictionnary objectForKeyOrNil:LOCALE_USER_JSON_KEY];
    self.link = [userDictionnary objectForKeyOrNil:LINK_USER_JSON_KEY];
    self.username = [userDictionnary objectForKeyOrNil:USERNAME_USER_JSON_KEY];
    self.gender = [userDictionnary objectForKeyOrNil:GENDER_USER_JSON_KEY];
    
    self.picturePath = [User picturePathForFacebookID:self.uid];
}

+ (NSDictionary*)keyMappingDictionary {
    static NSMutableDictionary *mappingDictionary = nil ;
    
    if (!mappingDictionary) {
        mappingDictionary = [[NSMutableDictionary alloc] init];
        [mappingDictionary setObject:FIRSTNAME_USER_JSON_KEY
                              forKey:FIRSTNAME_USER_COREDATA_KEY];
        [mappingDictionary setObject:GENDER_USER_JSON_KEY
                              forKey:GENDER_USER_COREDATA_KEY];
        [mappingDictionary setObject:UID_USER_JSON_KEY
                              forKey:UID_USER_COREDATA_KEY];
        [mappingDictionary setObject:LASTNAME_USER_JSON_KEY
                              forKey:LASTNAME_USER_COREDATA_KEY];
        [mappingDictionary setObject:LINK_USER_JSON_KEY
                              forKey:LINK_USER_COREDATA_KEY];
        [mappingDictionary setObject:LOCALE_USER_JSON_KEY
                              forKey:LOCALE_USER_COREDATA_KEY];
        [mappingDictionary setObject:NAME_USER_JSON_KEY
                              forKey:NAME_USER_COREDATA_KEY];
        [mappingDictionary setObject:USERNAME_USER_JSON_KEY
                              forKey:USERNAME_USER_COREDATA_KEY];
    }
    
    return mappingDictionary ;
}

+ (User*)userWithUID:(NSNumber*)aUID {
    return [RBCoreDataHelpers managedObjectForEntityName:NSStringFromClass([self class])
                                               predicate:[NSPredicate predicateWithFormat:@"%K == %@", UID_USER_COREDATA_KEY, aUID]
                                                 context:MAIN_MOC];
}


+ (User*)insertUserWithDictionary:(NSDictionary*)aDictionary inContext:(NSManagedObjectContext*)aMoc {
    User* u = [RBCoreDataHelpers insertEntityNamed:NSStringFromClass([self class])
                          withDictionary:aDictionary
                               inContext:aMoc];
    
    NSError *error = nil ;
    [aMoc save:&error] ;
    
    if (error)
        NSLog(@"%@", [error localizedDescription]);
    
    return u ;
}



@end
