//
//  NSDictionary+Utils.m
//  Luluvise
//
//  Created by Romain Boulay on 11/1/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import "NSDictionary+Utils.h"

@implementation NSDictionary (Utils)

#pragma mark Utils
- (id)objectForKeyOrNil:(id)key
{
	id obj = [self objectForKey:key];
	if (obj == [NSNull null])
		return nil;
	return obj;
}


@end
