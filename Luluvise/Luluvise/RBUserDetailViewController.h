//
//  RBUserDetailViewController.h
//  Luluvise
//
//  Created by Romain Boulay on 10/31/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BUIButton.h"

@interface RBUserDetailViewController : UIViewController <UISplitViewControllerDelegate>

// The name of the user
@property (retain, nonatomic) IBOutlet UILabel *usernameLabel;

// The picture of the user
@property (retain, nonatomic) IBOutlet UIImageView *pictureImageView;

// The view that contains all the sub views
@property (retain, nonatomic) IBOutlet UIView *contentView;

// All is embedded in that scollview in order to make the UI more "touchable"
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

// The user to display :
@property (retain, nonatomic) User* user;

// Caption labels :
@property (retain, nonatomic) IBOutlet UILabel *firstNameCaptionLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameCaptionLabel;
@property (retain, nonatomic) IBOutlet UILabel *genderCaptionLabel;
@property (retain, nonatomic) IBOutlet UILabel *idCaptionLabel;
@property (retain, nonatomic) IBOutlet UILabel *localeCaptionLabel;

// User data labels :
@property (retain, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *genderLabel;
@property (retain, nonatomic) IBOutlet UILabel *idLabel;
@property (retain, nonatomic) IBOutlet UILabel *localeLabel;

// Go to facebook profile button :
@property (retain, nonatomic) BUIButton *profileButton;
- (IBAction)goToProfile:(id)sender;

@end
