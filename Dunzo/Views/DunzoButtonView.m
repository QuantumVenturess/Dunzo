//
//  DunzoButtonView.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/19/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "DunzoButtonView.h"

@implementation DunzoButtonView

@synthesize button = _button;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    int dimension = 70;
    // Button
    _button                 = [[DunzoButton alloc] init];
    _button.backgroundColor = [UIColor clearColor];
    _button.frame           = CGRectMake(0, 0, dimension, dimension);
    // [_button setColor: [UIColor blue] forState: 
    //   UIControlStateHighlighted];
    
    [self addSubview: _button];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.cancelsTouchesInView = NO;
    [tap addTarget: self action: @selector(tapped:)];
    [self addGestureRecognizer: tap];
  }
  return self;
}

#pragma mark - Methods

- (void) fadeBackground
{
  // Subclasses implement this
}

- (void) restoreBackground
{
  // Subclasses implement this
}

- (void) tapped: (UIGestureRecognizer *) gesture
{
  // Subclasses implement this
}

@end
