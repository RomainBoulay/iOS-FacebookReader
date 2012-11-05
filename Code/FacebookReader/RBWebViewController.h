//
//  RBWebViewController.h
//  FacebookReader
//
//  Created by Romain Boulay on 11/1/12.
//  Copyright (c) 2012 Romain Boulay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBWebViewController : UIViewController

// URL string to load :
@property (nonatomic, retain) NSString* urlString ;

// Webview :
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
