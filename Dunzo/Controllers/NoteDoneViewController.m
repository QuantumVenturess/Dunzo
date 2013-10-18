//
//  NoteDoneViewController.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/12/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "Note+Custom.h"
#import "NoteDetailViewController.h"
#import "NoteDoneGroup.h"
#import "NoteDoneViewCell.h"
#import "NoteDoneViewController.h"
#import "NoteNotDoneViewController.h"
#import "NoteStore.h"
#import "UIColor+Extensions.h"

@implementation NoteDoneViewController

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {

  }
  return self;
}

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  CGRect screen = [[UIScreen mainScreen] bounds];

  // Header
  UIView *headerView = [[UIView alloc] init];
  headerView.backgroundColor = [UIColor clearColor];
  headerView.frame = CGRectMake(0, 0, screen.size.width, 20);
  self.table.tableHeaderView = headerView;
  // Footer
  UIView *footerView = [[UIView alloc] init];
  footerView.backgroundColor = [UIColor clearColor];
  footerView.frame = CGRectMake(0, 0, screen.size.width, 84);
  self.table.tableFooterView = footerView;
  clearNotesButton = [[UIButton alloc] init];
  clearNotesButton.alpha = 0;
  clearNotesButton.backgroundColor = [UIColor red];
  clearNotesButton.frame = CGRectMake(20, 20, (screen.size.width - 40), 44);
  clearNotesButton.layer.cornerRadius = 2;
  [clearNotesButton addTarget: self action: @selector(clearNotes)
    forControlEvents: UIControlEventTouchUpInside];
  [footerView addSubview: clearNotesButton];
  UILabel *clearNotesLabel = [[UILabel alloc] init];
  clearNotesLabel.backgroundColor = [UIColor clearColor];
  clearNotesLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 18];
  clearNotesLabel.frame = CGRectMake(0, 0, 
    clearNotesButton.frame.size.width, 44);
  clearNotesLabel.text = @"Clear Notes";
  clearNotesLabel.textAlignment = NSTextAlignmentCenter;
  clearNotesLabel.textColor = [UIColor white];
  [clearNotesButton addSubview: clearNotesLabel];

  noDoneNotesLabel = [[UILabel alloc] init];
  noDoneNotesLabel.alpha = 1;
  noDoneNotesLabel.backgroundColor = [UIColor clearColor];
  noDoneNotesLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 18];
  noDoneNotesLabel.frame = CGRectMake(20, 20, (screen.size.width - 40), 44);
  noDoneNotesLabel.text = @"You have nothing done";
  noDoneNotesLabel.textAlignment = NSTextAlignmentCenter;
  noDoneNotesLabel.textColor = [UIColor white];
  [footerView addSubview: noDoneNotesLabel];

  // Status bar
  topBar = [[UIView alloc] init];
  topBar.backgroundColor = [UIColor blackAlpha: 0.8];
  topBar.frame = CGRectMake(0, 0, screen.size.width, 20);
  [self.view addSubview: topBar];
}

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGRect frame   = topBar.frame;
  frame.origin.y = scrollView.contentOffset.y;
  topBar.frame   = frame;
}


#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"NoteDoneViewCell";
  NoteDoneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell) {
    cell = [[NoteDoneViewCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  }
  [self configureCell: cell atIndexPath: indexPath];
  return cell;
}

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return [[self notes] count];
}

- (NSInteger) tableView: (UITableViewCell *) tableView
numberOfRowsInSection: (NSInteger) section
{
  NoteDoneGroup *noteDoneGroup = (NoteDoneGroup *) [[self notes] objectAtIndex: 
    section];
  return [noteDoneGroup.notes count];
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSLog(@"Click");
}

- (CGFloat) tableView: (UITableView *) tableView
heightForHeaderInSection: (NSInteger) section
{
  return 40;
}

- (UIView *) tableView: (UITableView *) tableView
viewForHeaderInSection: (NSInteger) section
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  NoteDoneGroup *noteDoneGroup = (NoteDoneGroup *) [[self notes] objectAtIndex: 
    section];
  UIView *headerView = [[UIView alloc] init];
  headerView.backgroundColor = [UIColor blackAlpha: 0.6];
  headerView.frame = CGRectMake(0, 0, screen.size.width, 40);
  CALayer *borderBottom = [CALayer layer];
  borderBottom.backgroundColor = [UIColor whiteColor].CGColor;
  borderBottom.frame = CGRectMake(0, 39, screen.size.width, 1);
  [headerView.layer addSublayer: borderBottom];
  UILabel *label = [[UILabel alloc] init];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  label.frame = CGRectMake(20, 10, (screen.size.width - 40), 20);
  label.text = [noteDoneGroup dateString];
  label.textAlignment = NSTextAlignmentRight;
  label.textColor = [UIColor whiteColor];
  [headerView addSubview: label];
  return headerView;
}

#pragma mark - Methods

- (void) clearNotes
{
  NSInteger numberOfSections = [self numberOfSectionsInTableView: self.table];
  NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange: 
    NSMakeRange(0, numberOfSections)];

  [CATransaction begin];
  [self.table beginUpdates];

  [self.table deleteSections: indexSet 
    withRowAnimation: UITableViewRowAnimationFade];
  [[NoteStore sharedStore] clearDoneNotes];
  [[NoteStore sharedStore] saveChanges];
  [CATransaction setCompletionBlock: ^{
    [self toggleClearNotesButton];
  }];

  [self.table endUpdates];
  [CATransaction commit];
}

- (void) configureCell: (UITableViewCell *) cell 
atIndexPath: (NSIndexPath *) indexPath
{
  NoteDoneGroup *noteDoneGroup = (NoteDoneGroup *) [[self notes] objectAtIndex: 
    indexPath.section];
  NoteDoneViewCell *noteDoneViewCell = (NoteDoneViewCell *) cell;
  noteDoneViewCell.tableViewController = self;
  [noteDoneViewCell loadNote: 
    [noteDoneGroup.notes objectAtIndex: indexPath.row]];
}

- (NSArray *) notes
{
  return [NoteStore sharedStore].noteDoneGroups;
}

- (void) reloadTable
{
  [super reloadTable];
  [self toggleClearNotesButton];
}

- (void) removeDoneNote1: (Note *) note
{
  NSIndexPath *indexPath = [[NoteStore sharedStore] indexPathForDoneNote: 
    note];
  int numberOfRows = [self tableView: self.table 
    numberOfRowsInSection: indexPath.section];
  // If the section containing the note has only 1 note left
  if (numberOfRows == 1) {
    [self.table beginUpdates];
    // Delete the section
    [self.table deleteSections: 
      [NSIndexSet indexSetWithIndex: indexPath.section]
        withRowAnimation: UITableViewRowAnimationFade];
    note.done      = [NSNumber numberWithBool: NO];
    note.doneDate  = nil;
    note.updatedAt = [NSDate date];
    [self.table endUpdates];
  }
  else {
    note.done      = [NSNumber numberWithBool: NO];
    note.doneDate  = nil;
    note.updatedAt = [NSDate date];
  } 
  [[NoteStore sharedStore] saveChanges];
  [self toggleClearNotesButton];
  [[self appDelegate].centerViewController loadNote: note];
  [self reloadTable];
}

- (void) removeDoneNote: (Note *) note
{
  NSIndexPath *indexPath = [[NoteStore sharedStore] indexPathForDoneNote: 
    note];

  [[self appDelegate].leftViewController deleteTopEmptyNote];

  [CATransaction begin];
  [self.table beginUpdates];
  // Delete the row
  [self.table deleteRowsAtIndexPaths: @[indexPath] withRowAnimation:
    UITableViewRowAnimationFade];
  int numberOfRows = [self tableView: self.table 
    numberOfRowsInSection: indexPath.section];
  // If the section containing the note has only 1 note left
  if (numberOfRows == 1) {
    // Delete the section
    [self.table deleteSections: 
      [NSIndexSet indexSetWithIndex: indexPath.section]
        withRowAnimation: UITableViewRowAnimationFade];
  }
  note.done      = [NSNumber numberWithBool: NO];
  note.doneDate  = nil;
  note.updatedAt = [NSDate date];
  [[NoteStore sharedStore] saveChanges];
  // Need to re-calculate and group done notes
  [[NoteStore sharedStore] groupByDoneDate];
  [CATransaction setCompletionBlock: ^{
    [self toggleClearNotesButton];
  }];

  [self.table endUpdates];
  [CATransaction commit];
  
  [[self appDelegate].centerViewController loadNote: note];
}

- (void) toggleClearNotesButton
{
  int count = [self numberOfSectionsInTableView: self.table];
  if (count > 0 && clearNotesButton.alpha == 0) {
    [UIView animateWithDuration: 0.2 delay: 0 options: 0
      animations: ^{
        noDoneNotesLabel.alpha = 0;
        clearNotesButton.alpha = 1;
      }
    completion: nil];
  }
  else if (count == 0 && clearNotesButton > 0) {
    [UIView animateWithDuration: 0.2 delay: 0 options: 0
      animations: ^{
        clearNotesButton.alpha = 0;
        noDoneNotesLabel.alpha = 1;
      }
    completion: nil];
  }
}

@end
