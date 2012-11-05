//
//  UserCell.m
//  FacebookReader
//
//  Created by Romain Boulay on 11/1/12.
//  Copyright 2012 Romain Boulay. All rights reserved.
//

#import "UserCell.h"

@interface UserCell ()
// Define IBOutlet properties here
@property (nonatomic, retain) UILabel *labTitle;
@end

@implementation UserCell
#pragma mark Utils
static UINib *cellNib;
+ (UINib*)cellNib
{
	if (cellNib)
		return cellNib;
	
	// Build cell nib
	cellNib = [[UINib nibWithNibName:UserCell_XIB
							  bundle:nil] retain];
	
	return cellNib;
}

+ (NSString*)cellID
{
	return UserCell_ID;
}

#pragma mark Constructor
- (void)awakeFromNib
{
	[super awakeFromNib];
}

#pragma mark Cell computation
+ (CGFloat)cellHeightForUser:(User*)aUser
{
	return UserCell_HEIGHT;
}

#pragma mark Configuration methods
- (void)configureCellWithUser:(User*)aUser;
{
	labTitle.text = aUser.name;
    thumbnailImageView.image = [UIImage imageWithContentsOfFile:aUser.picturePath];
    
    if ([aUser.gender isEqualToString:@"male"])
        self.selectedBackgroundView.backgroundColor = MALE_COLOR;
    else if ([aUser.gender isEqualToString:@"female"])
        self.selectedBackgroundView.backgroundColor = FEMALE_COLOR;
    else
        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];}

#pragma mark Memory
- (void)dealloc
{
	self.labTitle = nil;
    [thumbnailImageView release];
	[super dealloc];
}

@synthesize labTitle;
@end