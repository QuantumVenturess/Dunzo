//
//  CalendarViewController.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/16/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AppDelegate.h"
#import "CalendarViewController.h"
#import "Note+Custom.h"
#import "NoteDetailViewController.h"
#import "NoteStore.h"
#import "UIColor+Extensions.h"

@implementation CalendarViewController

@synthesize calendarView = _calendarView;
@synthesize note = _note;

#pragma mark - Override UIViewController

- (void) loadView
{
  CGRect screen = [[UIScreen mainScreen] bounds];

  // Navigation
  self.navigationController.navigationBar.barTintColor = [UIColor gray: 160];
  CGSize maxSize = CGSizeMake(screen.size.width, 18);
  UIFont *font  = [UIFont fontWithName: @"HelveticaNeue-Light" size: 17];
  // cancel
  NSString *cancelString = @"Cancel";
  CGRect textRect = [cancelString boundingRectWithSize: maxSize
    options: NSStringDrawingUsesLineFragmentOrigin 
      attributes: @{NSFontAttributeName: font} context: nil];
  UILabel *cancelLabel = [[UILabel alloc] init];
  cancelLabel.backgroundColor = [UIColor clearColor];
  cancelLabel.font = font;
  cancelLabel.frame = CGRectMake(5, 0, 
    textRect.size.width, textRect.size.height);
  cancelLabel.text = cancelString;
  cancelLabel.textColor = [UIColor white];
  UIButton *cancelButton = [[UIButton alloc] init];
  cancelButton.frame = CGRectMake(0, 0, 
    textRect.size.width + 5, textRect.size.height);
  [cancelButton addTarget: self action: @selector(cancel)
    forControlEvents: UIControlEventTouchUpInside];
  [cancelButton addSubview: cancelLabel];
  self.navigationItem.leftBarButtonItem = 
    [[UIBarButtonItem alloc] initWithCustomView: cancelButton];
  // submit
  NSString *submitString = @"Done";
  textRect = [submitString boundingRectWithSize: maxSize
    options: NSStringDrawingUsesLineFragmentOrigin 
      attributes: @{NSFontAttributeName: font} context: nil];
  UILabel *submitLabel = [[UILabel alloc] init];
  submitLabel.backgroundColor = [UIColor clearColor];
  submitLabel.font = font;
  submitLabel.frame = CGRectMake(0, 0, 
    textRect.size.width, textRect.size.height);
  submitLabel.text = submitString;
  submitLabel.textColor = [UIColor white];
  UIButton *submitButton = [[UIButton alloc] init];
  submitButton.frame = CGRectMake(0, 0, 
    textRect.size.width + 5, textRect.size.height);
  [submitButton addTarget: self action: @selector(done)
    forControlEvents: UIControlEventTouchUpInside];
  [submitButton addSubview: submitLabel];
  self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithCustomView: submitButton];

  // Calendar View
  _calendarView           = [[TSQCalendarView alloc] init];
  _calendarView.backgroundColor = [UIColor gray: 160];
  _calendarView.delegate  = self;
  _calendarView.firstDate = [NSDate date];
  _calendarView.frame     = self.parentViewController.view.bounds;
  _calendarView.lastDate  = [[NSDate date] dateByAddingTimeInterval:
    60 * 60 * 24 * 365];
  self.view = _calendarView;
}

#pragma mark - Protocol TSQCalendarViewDelegate

- (void) calendarView: (TSQCalendarView *) calendarView
didSelectDate: (NSDate *) date
{
  _note.dueDate = date;
}

#pragma mark - Methods

- (void) cancel
{  
  _note.dueDate = nil;
  [self updateAndSave];
}

- (void) done
{
  // [[NSNotificationCenter defaultCenter] postNotificationName: 
  //   FlashMessageNotification object: _note userInfo: @{
  //     @"message": [NSString stringWithFormat:
  //       @"Due %@", [_note dueDateStringLong]]
  //   }
  // ];
  [self updateAndSave];
}

- (void) updateAndSave
{
  _note.updatedAt = [NSDate date];
  [[NoteStore sharedStore] saveChanges];
  [(NoteDetailViewController *) [self appDelegate].centerViewController 
    updateDueDate];
  [self dismissViewControllerAnimated: YES completion: nil];
}

@end
