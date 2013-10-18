//
//  NoteNotDoneViewCell.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/12/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "DunzoTableViewController.h"
#import "ImageStore.h"
#import "Note+Custom.h"
#import "NoteNotDoneViewCell.h"
#import "UIColor+Extensions.h"

@implementation NoteNotDoneViewCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
reuseIdentifier: (NSString *) reuseIdentifier
{
  self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
  if (self) {
    CGRect screen = [[UIScreen mainScreen] bounds];

    // Checkmark
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.frame = CGRectMake(20, 20, 40, 40);
    imageView.image = [[ImageStore sharedStore].images objectForKey:
      @"checkmark"];
    [mainView insertSubview: imageView atIndex: 0];

    // Left border
    leftBorder = [[UIView alloc] init];
    leftBorder.backgroundColor = [UIColor white];
    leftBorder.frame = CGRectMake(0, 20, 1, 40);
    [titleView addSubview: leftBorder];

    // Title label
    titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 20];
    titleLabel.frame = CGRectMake(21, 20, (screen.size.width - 41), 40);
    titleLabel.textColor = [UIColor white];
    [titleView addSubview: titleLabel];
  }
  return self;
}

#pragma mark - Methods

- (void) changeColors
{
  leftBorder.backgroundColor = [UIColor green];
  mainView.backgroundColor   = [UIColor green];
}

- (void) checkPosition
{
  [super checkPosition];
  if (titleView.frame.origin.x >= 80) {
    [self hideTitleView];
  }
  else {
    [self showTitleView];
  }
}

- (void) drag: (UIPanGestureRecognizer *) gesture
{
  [super drag: gesture];
  CGPoint point    = [gesture locationInView: self];
  CGPoint velocity = [gesture velocityInView: self];
  float horizontalDifference = point.x - horizontalOffset;
  float newOriginX = titleView.frame.origin.x + horizontalDifference;
  if (newOriginX >= 0) {
    CGRect titleViewFrame = titleView.frame;
    titleViewFrame.origin.x = newOriginX;
    titleView.frame = titleViewFrame;
    horizontalOffset = point.x;
  }
  if (titleView.frame.origin.x >= 80) {
    [self changeColors];
  }
  else {
    [self resetColors];
  }
  if (gesture.state == UIGestureRecognizerStateEnded) {
    if (velocity.x >= 1000) {
      [self changeColors];
      [self hideTitleView];
    }
    else {
      [self checkPosition];
    }
  }
}

- (void) hideTitleView
{
  [super hideTitleView];
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGRect titleViewFrame = titleView.frame;
  titleViewFrame.origin.x = screen.size.width;
  void (^animations) (void) = ^(void) {
    titleView.frame = titleViewFrame;
  };
  DunzoTableViewController *viewController = self.tableViewController;
  [UIView animateWithDuration: 0.2 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations
      completion: ^(BOOL finished) {
        [viewController removeDoneNote: self.note];
      }
  ];
}

- (void) resetColors
{
  leftBorder.backgroundColor = [UIColor white];
  mainView.backgroundColor   = [UIColor white];
}

@end
