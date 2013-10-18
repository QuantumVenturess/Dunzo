//
//  DunzoNavigationViewController.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/16/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "DunzoNavigationViewController.h"
#import "FlatNavigationBar.h"

@implementation DunzoNavigationViewController

#pragma mark - Initializer

- (id) initWithRootViewController: (UIViewController *) rootViewController
{
  self = [super initWithRootViewController: rootViewController];
  if (self) {
    // Navigation bar
    // [self setValue: [[FlatNavigationBar alloc] init] forKey: 
    //   @"navigationBar"];
  }
  return self;
}

@end
