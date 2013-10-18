//
//  DunzoViewController.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AppDelegate.h"
#import "DunzoViewController.h"
#import "MFSideMenu.h"

@implementation DunzoViewController

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    [[NSNotificationCenter defaultCenter] addObserver: self
      selector: @selector(menuStateEventOccurred:) 
        name: MFSideMenuStateNotificationEvent object: nil];
  }
  return self;
}

#pragma mark - Setters

- (void) setTitle: (NSString *) string
{
  [super setTitle: string];
  UILabel *label = [[UILabel alloc] init];
  label.backgroundColor = [UIColor clearColor];
  label.font            = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 20];
  label.frame           = CGRectMake(0, 0, 0, 44);
  label.shadowColor     = [UIColor clearColor];
  label.shadowOffset    = CGSizeMake(0, 0);
  label.text            = string;
  label.textAlignment   = NSTextAlignmentCenter;
  label.textColor       = [UIColor whiteColor];
  [label sizeToFit];
  self.navigationItem.titleView = label;
}

#pragma mark - Methods

- (AppDelegate *) appDelegate
{
  return [UIApplication sharedApplication].delegate;
}

- (void) menuStateEventOccurred: (NSNotification *) notification
{
  // Subclasses implement this;
}

@end
