//
//  DunzoButton.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/19/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "DunzoButton.h"

@implementation DunzoButton

#pragma mark - Methods

- (void) setColor: (UIColor *) color forState: (UIControlState) state
{
  UIView *colorView         = [[UIView alloc] init];
  colorView.backgroundColor = color;
  colorView.frame           = self.frame;

  UIGraphicsBeginImageContext(colorView.bounds.size);
  [colorView.layer renderInContext: UIGraphicsGetCurrentContext()];

  UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  [self setBackgroundImage: colorImage forState: state];

  colorView = nil;
  colorImage = nil;
}

@end
