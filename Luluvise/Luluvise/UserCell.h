//
//  UserCell.h
//  Luluvise
//
//  Created by Romain Boulay on 11/1/12.
//  Copyright 2012 Romain Boulay. All rights reserved.
//

#define UserCell_ID @"UserCellID"
#define UserCell_HEIGHT 44
#define UserCell_XIB @"UserCell"

@interface UserCell : UITableViewCell {
	// Define IBOutlets here
	IBOutlet UILabel *labTitle;
    IBOutlet UIImageView *thumbnailImageView;
}

/* Configure cell using a User */
- (void)configureCellWithUser:(User*)aUser;

/* Cell nib */
+ (UINib*)cellNib;

/* Cell ID */
+ (NSString*)cellID;

/* Compute cell height */
+ (CGFloat)cellHeightForUser:(User*)aUser;


@end
