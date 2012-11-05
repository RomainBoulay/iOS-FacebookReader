//
//  NSDictionary+Utils.h
//  FacebookReader
//
//  Created by Romain Boulay on 11/1/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utils)

/* Same as objectForKey:, but returning nil if object is [NSNull null] */
- (id)objectForKeyOrNil:(id)key;

@end
