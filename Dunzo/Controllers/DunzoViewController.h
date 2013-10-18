//
//  DunzoViewController.h
//  Dunzo
//
//  Created by Tommy DANGerous on 9/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@class AppDelegate;

@interface DunzoViewController : UIViewController

#pragma mark - Methods

- (AppDelegate *) appDelegate;
- (void) menuStateEventOccurred: (NSNotification *) notification;

@end
