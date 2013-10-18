//
//  MenuButtonView.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/11/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "MenuButtonView.h"

@implementation MenuButtonView

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    int dimension = 70;
    int padding   = 15;

    CGRect screen        = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor whiteAlpha: 0.6];
    self.frame = CGRectMake(0, (screen.size.height - (dimension - 20)), 
      dimension, dimension);
    self.layer.borderWidth   = 1;
    self.layer.borderColor   = [UIColor red].CGColor;
    self.layer.cornerRadius  = dimension / 2;
    self.layer.masksToBounds = YES;

    // Image for button
    int imageDimension        = dimension - (padding * 2);
    normalImage = [UIImage image: [UIImage imageNamed: @"clock_red.png"]
      size: CGSizeMake(imageDimension, imageDimension)];
    selectedImage = [UIImage image: [UIImage imageNamed: @"clock_white.png"]
      size: CGSizeMake(imageDimension, imageDimension)];
    imageView                 = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.frame = CGRectMake(padding, padding, 
      imageDimension, imageDimension);
    imageView.image = normalImage;
    [self addSubview: imageView];

    // Menu Bars
    // bar1 = [[UIView alloc] init];
    // bar1.backgroundColor = [UIColor blackColor];
    // bar1.frame = CGRectMake(15, 15, 20, 4);
    // [self addSubview: bar1];
    // bar2 = [[UIView alloc] init];
    // bar2.backgroundColor = [UIColor blackColor];
    // bar2.frame = CGRectMake(15, (15 + 4 + 4), 20, 4);
    // [self addSubview: bar2];
    // bar3 = [[UIView alloc] init];
    // bar3.backgroundColor = [UIColor blackColor];
    // bar3.frame = CGRectMake(15, (15 + 4 + 4 + 4 + 4), 20, 4);
    // [self addSubview: bar3];
  }
  return self;
}

#pragma mark - Methods

- (void) fadeBackground 
{
  void (^animations) (void) = ^(void) {
    float opacity          = 0.4;
    self.backgroundColor   = [UIColor whiteAlpha: opacity];
    self.layer.borderColor = [UIColor redAlpha: opacity].CGColor;
    imageView.alpha        = opacity;
  //  self.backgroundColor = [UIColor colorWithRed: 255 green: 255 
  //    blue: 255 alpha: 0.2];
  //  UIColor *fadedBlack = [UIColor colorWithRed: 0 green: 0 
  //    blue: 0 alpha: 0.3];
  //  bar1.backgroundColor = fadedBlack;
  //  bar2.backgroundColor = fadedBlack;
  //  bar3.backgroundColor = fadedBlack;
  };
  [UIView animateWithDuration: 0.15 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations
      completion: nil];
}

- (void) restoreBackground 
{
  void (^animations) (void) = ^(void) {
    self.backgroundColor   = [UIColor whiteAlpha: 0.6];
    self.layer.borderColor = [UIColor red].CGColor;
    imageView.alpha        = 1;
    imageView.image        = normalImage;
  //  self.backgroundColor = [UIColor whiteColor];
  //  bar1.backgroundColor = [UIColor blackColor];
  //  bar2.backgroundColor = [UIColor blackColor];
  //  bar3.backgroundColor = [UIColor blackColor];
  };
  [UIView animateWithDuration: 0.15 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations
      completion: nil];
}

- (void) tapped: (UIGestureRecognizer *) gesture
{
  void (^animations) (void) = ^(void) {
    self.backgroundColor = [UIColor red];
    imageView.image      = selectedImage;
  };
  void (^completion) (BOOL) = ^(BOOL finisheD) {
    [self restoreBackground];
  };
  [UIView animateWithDuration: 0.2 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations
      completion: completion];
}

@end
