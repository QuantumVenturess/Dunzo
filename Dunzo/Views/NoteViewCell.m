//
//  NoteViewCell.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DunzoTableViewController.h"
#import "Note+Custom.h"
#import "NoteViewCell.h"
#import "UIColor+Extensions.h"

@implementation NoteViewCell

@synthesize note = _note;
@synthesize tableViewController = _tableViewController;

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
reuseIdentifier: (NSString *) reuseIdentifier
{
  self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
  if (self) {
    CGRect screen = [[UIScreen mainScreen] bounds];

    // UITableViewCell properties
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // Main view
    mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor white];
    mainView.frame = CGRectMake(0, 0, screen.size.width, 80);
    [self.contentView addSubview: mainView];

    // Title view
    titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor black];
    titleView.frame = mainView.frame;
    [mainView addSubview: titleView];

    // Date time view
    dateTimeView = [[UIView alloc] init];
    dateTimeView.backgroundColor = [UIColor white];
    dateTimeView.layer.cornerRadius = 2.0;
    [titleView addSubview: dateTimeView];
    // Date time label
    dateTimeLabel = [[UILabel alloc] init];
    dateTimeLabel.backgroundColor = [UIColor clearColor];
    dateTimeLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 12];
    dateTimeLabel.textColor = [UIColor black];
    [dateTimeView addSubview: dateTimeLabel];

    panGestureRecognizer =
      [[UIPanGestureRecognizer alloc] initWithTarget: self
        action: @selector(drag:)];
    panGestureRecognizer.delegate = self;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [panGestureRecognizer setCancelsTouchesInView: YES];
    [self addGestureRecognizer: panGestureRecognizer];

  }
  return self;
}

#pragma mark - Protocol UIGestureRecognizerDelegate

- (BOOL) gestureRecognizer: (UIGestureRecognizer *) gestureRecognizer
shouldReceiveTouch: (UITouch *) touch
{
  CGPoint point    = [touch locationInView: self];
  horizontalOffset = point.x;
  return YES;
}

- (BOOL) gestureRecognizer: (UIGestureRecognizer *) gestureRecognizer 
shouldRecognizeSimultaneouslyWithGestureRecognizer: 
  (UIGestureRecognizer *) otherGestureRecognizer
{
  return YES;
}

#pragma mark - Methods

- (void) adjustDateTime
{
  NSString *text;
  if ([_note isDone]) {
    text = [_note doneTimeString];
  }
  else if (_note.dueDate) {
    text = [_note dueDateString];
    int secondsInDay = 60 * 60 * 24;
    if ([_note.dueDate timeIntervalSinceNow] < -1 * secondsInDay) {
      // Past due
      dateTimeLabel.textColor = [UIColor red];
      dateTimeView.backgroundColor = [UIColor clearColor];
    }
    else if ([_note.dueDate timeIntervalSinceNow] < 0) {
      // Due today
      dateTimeLabel.textColor = [UIColor green];
      dateTimeView.backgroundColor = [UIColor clearColor];
    }
    else {
      // Due in the future
      dateTimeLabel.textColor = [UIColor black];
      dateTimeView.backgroundColor = [UIColor white];
    }
  }
  if (text) {
    dateTimeLabel.text = text;
    // Adjust size of date time view and date time label
    CGRect textRect = [dateTimeLabel.text boundingRectWithSize:
      CGSizeMake(200, 14)
        options: NSStringDrawingUsesLineFragmentOrigin 
          attributes: @{NSFontAttributeName: dateTimeLabel.font} 
            context: nil];
    int originX;
    if ([_note isDone]) {
      originX = 20;
    }
    else {
      originX = 25;
    }
    dateTimeLabel.frame = CGRectMake(3, 3, textRect.size.width, 14);
    dateTimeView.frame = CGRectMake(originX, 55, 
      (dateTimeLabel.frame.size.width + 3 + 3), 20);
    dateTimeView.hidden = NO;
  }
  else {
    dateTimeView.hidden = YES;
  }
}

- (void) changeColors
{
  // Subclasses will implement this
}

- (void) checkPosition
{
  // Subclasses will implement this
}

- (void) drag: (UIPanGestureRecognizer *) gesture
{
  // Subclasses will implement this
}

- (void) hideTitleView
{
  // Subclasses will implement this
}

- (void) loadNote: (Note *) object
{
  // DO NOT CHANGE NOTE ATTRIBUTE VALUES
  // WILL CAUSE INFINITE LOOP FOR NSFetchedResultsController DELEGATE
  _note = object;
  NSString *text = [[_note content] stringByTrimmingCharactersInSet: 
    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (text.length > 0) {
    titleLabel.text      = text;
    titleLabel.textColor = [UIColor white];
  }
  else {
    titleLabel.text      = @"Empty note";
    titleLabel.textColor = [UIColor red];
  }
  mainView.backgroundColor      = [UIColor white];
  if (leftBorder) {
    leftBorder.backgroundColor  = [UIColor white];
  }
  if (rightBorder) {
    rightBorder.backgroundColor = [UIColor white];
  }
  CGRect titleViewFrame   = titleView.frame;
  titleViewFrame.origin.x = 0;
  titleView.frame         = titleViewFrame;
  [self adjustDateTime];
    
  [panGestureRecognizer requireGestureRecognizerToFail: 
    _tableViewController.table.panGestureRecognizer];
}

- (void) resetColors
{
  // Subclasses will implement this
}

- (void) showTitleView
{
  CGRect titleViewFrame = titleView.frame;
  titleViewFrame.origin.x = 0;
  void (^animations) (void) = ^(void) {
    titleView.frame = titleViewFrame;
  };
  [UIView animateWithDuration: 0.2 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations
      completion: nil];
}

@end
