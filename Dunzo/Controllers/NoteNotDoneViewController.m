//
//  NoteNotDoneViewController.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/12/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "Note+Custom.h"
#import "NoteDetailViewController.h"
#import "NoteDoneViewController.h"
#import "NoteStore.h"
#import "NoteNotDoneViewCell.h"
#import "NoteNotDoneViewController.h"
#import "NoteStore.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

@implementation NoteNotDoneViewController

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    noteSortKey = @"updatedAt";
    [NoteStore sharedStore].fetchedResultsController.delegate = self;
  }
  return self;
}

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  CGRect screen = [[UIScreen mainScreen] bounds];

  UIFont *buttonFont = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];

  UIView *headerView = [[UIView alloc] init];
  headerView.backgroundColor = [UIColor clearColor];
  headerView.frame = CGRectMake(0, 0, screen.size.width, (20 + 44 + 44));
  self.table.tableHeaderView = headerView;

  // Search
  UIView *searchView = [[UIView alloc] init];
  searchView.backgroundColor = [UIColor clearColor];
  searchView.frame = CGRectMake(0, 20, screen.size.width, 44);
  [headerView addSubview: searchView];
  search = [[TextFieldPadding alloc] init];
  search.backgroundColor = [UIColor white];
  search.clearButtonMode = UITextFieldViewModeWhileEditing;
  search.delegate = self;
  search.font = buttonFont;
  search.frame = CGRectMake(10, 5, (screen.size.width - 20), 34);
  search.keyboardAppearance = UIKeyboardAppearanceDark;
  search.layer.cornerRadius = 2;
  search.paddingX = 40;
  search.paddingY = 5;
  search.placeholder = @"Search notes";
  search.textColor = [UIColor black];
  [search addTarget: self action: @selector(searchNotes:)
    forControlEvents: UIControlEventEditingChanged];
  [searchView addSubview: search];
  // search field image
  UIImageView *searchImage = [[UIImageView alloc] init];
  searchImage.alpha = 0.5;
  searchImage.frame = CGRectMake(10, 0, 20, 20);
  searchImage.image = [UIImage image: [UIImage imageNamed: @"search.png"]
    size: CGSizeMake(20, 20)];
  UIView *searchImageView = [[UIView alloc] init];
  searchImageView.frame = CGRectMake(0, 0, 20, 20);
  [searchImageView addSubview: searchImage];
  search.leftView = searchImageView;
  search.leftViewMode = UITextFieldViewModeAlways;

  // Cancel
  UILabel *cancelButtonLabel = [[UILabel alloc] init];
  cancelButtonLabel.backgroundColor = [UIColor clearColor];
  cancelButtonLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
    size: 18];
  cancelButtonLabel.text = @"Cancel";
  cancelButtonLabel.textAlignment = NSTextAlignmentCenter;
  cancelButtonLabel.textColor = [UIColor white];
  CGRect textRect = [cancelButtonLabel.text boundingRectWithSize:
    CGSizeMake(100, 44)
      options: NSStringDrawingUsesLineFragmentOrigin 
        attributes: @{NSFontAttributeName: cancelButtonLabel.font} 
          context: nil];
  cancelButtonLabel.frame = CGRectMake(0, 0, textRect.size.width, 44);
  cancelButton = [[UIButton alloc] init];
  cancelButton.alpha = 0;
  cancelButton.backgroundColor = [UIColor clearColor];
  cancelButton.frame = 
    CGRectMake((screen.size.width - (cancelButtonLabel.frame.size.width + 10)), 
      0, cancelButtonLabel.frame.size.width, 
        cancelButtonLabel.frame.size.height);
  [cancelButton addTarget: self action: @selector(cancelSearch)
    forControlEvents: UIControlEventTouchUpInside];
  [searchView addSubview: cancelButton];
  [cancelButton addSubview: cancelButtonLabel];

  // Sort control
  UIView *sortControl = [[UIView alloc] init];
  sortControl.backgroundColor = [UIColor clearColor];
  sortControl.frame = CGRectMake(0, (20 + 44), screen.size.width, 44);
  [headerView addSubview: sortControl];
  // created
  createdButton = [[UIButton alloc] init];
  createdButton.backgroundColor = [UIColor clearColor];
  createdButton.frame = CGRectMake(0, 0, (screen.size.width / 3.0), 44);
  createdButton.tag = 0;
  [createdButton addTarget: self action: @selector(changeNoteSortKey:)
    forControlEvents: UIControlEventTouchUpInside];
  [sortControl addSubview: createdButton];
  createdButtonLabel = [[UILabel alloc] init];
  createdButtonLabel.backgroundColor = [UIColor clearColor];
  createdButtonLabel.font = buttonFont;
  createdButtonLabel.frame = CGRectMake(0, 0, (screen.size.width / 3.0), 44);
  createdButtonLabel.text = @"Created";
  createdButtonLabel.textAlignment = NSTextAlignmentCenter;
  createdButtonLabel.textColor = [UIColor gray: 160];
  [createdButton addSubview: createdButtonLabel];
  // updated
  updatedButton = [[UIButton alloc] init];
  updatedButton.backgroundColor = [UIColor clearColor];
  updatedButton.frame = CGRectMake(((screen.size.width / 3.0) * 1), 0,
    (screen.size.width / 3.0), 44);
  updatedButton.tag = 1;
  [updatedButton addTarget: self action: @selector(changeNoteSortKey:)
    forControlEvents: UIControlEventTouchUpInside];
  [sortControl addSubview: updatedButton];
  updatedButtonLabel = [[UILabel alloc] init];
  updatedButtonLabel.backgroundColor = [UIColor clearColor];
  updatedButtonLabel.font = buttonFont;
  updatedButtonLabel.frame = CGRectMake(0, 0, (screen.size.width / 3.0), 44);
  updatedButtonLabel.text = @"Updated";
  updatedButtonLabel.textAlignment = NSTextAlignmentCenter;
  updatedButtonLabel.textColor = [UIColor white];
  [updatedButton addSubview: updatedButtonLabel];
  // due
  dueButton = [[UIButton alloc] init];
  dueButton.backgroundColor = [UIColor clearColor];
  dueButton.frame = CGRectMake(((screen.size.width / 3.0) * 2), 0,
    (screen.size.width / 3.0), 44);
  dueButton.tag = 2;
  [dueButton addTarget: self action: @selector(changeNoteSortKey:)
    forControlEvents: UIControlEventTouchUpInside];
  [sortControl addSubview: dueButton];
  dueButtonLabel = [[UILabel alloc] init];
  dueButtonLabel.backgroundColor = [UIColor clearColor];
  dueButtonLabel.font = buttonFont;
  dueButtonLabel.frame = CGRectMake(0, 0, (screen.size.width / 3.0), 44);
  dueButtonLabel.text = @"Due";
  dueButtonLabel.textAlignment = NSTextAlignmentCenter;
  dueButtonLabel.textColor = [UIColor gray: 160];
  [dueButton addSubview: dueButtonLabel];

  // Status bar
  topBar = [[UIView alloc] init];
  topBar.backgroundColor = [UIColor blackAlpha: 0.6];
  topBar.frame = CGRectMake(0, 0, screen.size.width, 20);
  [self.view addSubview: topBar];
}

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGRect frame   = topBar.frame;
  frame.origin.y = scrollView.contentOffset.y;
  topBar.frame   = frame;
  [search resignFirstResponder];
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return 1;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"NoteNotDoneViewCell";
  NoteNotDoneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell) {
    cell = [[NoteNotDoneViewCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  }
  [self configureCell: cell atIndexPath: indexPath];
  return cell;
}

- (NSInteger) tableView: (UITableViewCell *) tableView
numberOfRowsInSection: (NSInteger) section
{ 
  return [[self notes] count];
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  Note *note = [[self notes] objectAtIndex: indexPath.row];
  [[self appDelegate].centerViewController loadNote: note];
  [[self appDelegate].panel setMenuState: MFSideMenuStateClosed 
    completion: ^{
      [search resignFirstResponder];
    }
  ];
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  CGRect frame = search.frame;
  frame.size.width -= (10 + cancelButton.frame.size.width);
  void (^animations) (void) = ^(void) {
    cancelButton.alpha = 1;
    search.frame = frame;
  };
  [UIView animateWithDuration: 0.15 delay: 0 options: 0
    animations: animations completion: nil];
}

- (void) textFieldDidEndEditing: (UITextField *) textField
{
  CGRect frame = search.frame;
  frame.size.width += (10 + cancelButton.frame.size.width);
  void (^animations) (void) = ^(void) {
    cancelButton.alpha = 0;
    search.frame = frame;
  };
  [UIView animateWithDuration: 0.15 delay: 0 options: 0
    animations: animations completion: nil];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [self reloadTable];
  return YES;
}

#pragma mark - Methods

- (void) cancelSearch
{
  search.text = @"";
  searchQuery = nil;
  [search resignFirstResponder];
  [self reloadTable];
}

- (void) changeNoteSortKey: (id) sender
{
  UIButton *button = (UIButton *) sender;
  [self resetAllButtonLabels];
  switch (button.tag) {
    case 0: {
      createdButtonLabel.textColor = [UIColor white];
      noteSortKey = @"createdAt";
      break;
    }
    case 1: {
      updatedButtonLabel.textColor = [UIColor white];
      noteSortKey = @"updatedAt";
      break;
    }
    case 2: {
      dueButtonLabel.textColor = [UIColor white];
      noteSortKey = @"dueDate";
      break;
    }
    default:
      break;
  }
  [self reloadTable];
}

- (void) configureCell: (UITableViewCell *) cell 
atIndexPath: (NSIndexPath *) indexPath
{
  NoteNotDoneViewCell *noteNotDoneViewCell = (NoteNotDoneViewCell *) cell;
  noteNotDoneViewCell.tableViewController = self;
  [noteNotDoneViewCell loadNote:
    [[self notes] objectAtIndex: indexPath.row]];
}

- (void) deleteTopEmptyNote
{
  Note *note = [[self notes] objectAtIndex: 0];
  if (note && [note isEmpty]) {
    [[NoteStore sharedStore] deleteNote: note];
  }
  NSLog(@"%@", note);
}

- (void) menuStateEventOccurred: (NSNotification *) notification
{
  MFSideMenuStateEvent event = [[[notification userInfo] objectForKey: 
    @"eventType"] intValue];
  switch (event) {
    case MFSideMenuStateEventMenuWillOpen: {
      break;
    }
    case MFSideMenuStateEventMenuDidOpen: {
      break;
    }
    case MFSideMenuStateEventMenuWillClose: {
      [search resignFirstResponder];
      break;
    }
    case MFSideMenuStateEventMenuDidClose: {
      break;
    }
    default:
      break;
  }
}

- (NSArray *) notes
{
  if ([noteSortKey isEqualToString: @"createdAt"]) {
    return [[NoteStore sharedStore] notesDone: NO sortedWithKey: noteSortKey
      ascending: NO withQuery: searchQuery];
  }
  else if ([noteSortKey isEqualToString: @"dueDate"]) {
    NSArray *array = [[NoteStore sharedStore] notesDone: NO sortedWithKey:
      noteSortKey ascending: NO withQuery: searchQuery];

    // Notes with a due date
    NSPredicate *predicateDueDate = [NSPredicate predicateWithFormat:
      @"%K != %@", @"dueDate", [NSNull null]];
    NSArray *notesWithDueDate = 
      [array filteredArrayUsingPredicate: predicateDueDate];
    NSSortDescriptor *sortByDueDate = 
      [NSSortDescriptor sortDescriptorWithKey: @"dueDate" ascending: YES];
    notesWithDueDate = [notesWithDueDate sortedArrayUsingDescriptors:
      @[sortByDueDate]];

    // Notes with no due date
    NSPredicate *predicateNoDueDate = [NSPredicate predicateWithFormat:
      @"%K == %@", @"dueDate", [NSNull null]];
    NSArray *notesWithNoDueDate =
      [array filteredArrayUsingPredicate: predicateNoDueDate];
    NSSortDescriptor *sortByUpdatedAt = 
      [NSSortDescriptor sortDescriptorWithKey: @"updatedAt" ascending: NO];
    notesWithNoDueDate = [notesWithNoDueDate sortedArrayUsingDescriptors: 
      @[sortByUpdatedAt]];

    return [notesWithDueDate arrayByAddingObjectsFromArray: notesWithNoDueDate];
  }
  else if ([noteSortKey isEqualToString: @"updatedAt"]) {
    return [[NoteStore sharedStore] notesDone: NO sortedWithKey: noteSortKey
      ascending: NO withQuery: searchQuery];
  }
  return [NSArray array];
}

- (void) removeDoneNote1: (Note *) note
{
  int row = [[self notes] indexOfObject: note];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row inSection: 0];
  // If note is empty
  if ([note isEmpty]) {
    // Delete the note
    [[NoteStore sharedStore] deleteNote: note];
    [self reloadTable];
  }
  else {
    // Change the note to done
    note.done             = [NSNumber numberWithBool: YES];
    note.doneDate         = [NSDate date];
    // Do not change note.updatedAt
    [[NoteStore sharedStore] saveChanges];
  }
  // Switch to the next note or create an empty one
  [[self appDelegate].centerViewController checkDoneStatusForNote: note
    andSwitchToNoteAtIndexPath: indexPath];
  [[self appDelegate].rightViewController reloadTable];
}

- (void) removeDoneNote: (Note *) note
{
  int row = [[self notes] indexOfObject: note];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row inSection: 0];
  // Disabled delegate
  [NoteStore sharedStore].fetchedResultsController.delegate = nil;

  [CATransaction begin];
  [self.table beginUpdates];
  // Delete the row
  [self.table deleteRowsAtIndexPaths: @[indexPath] withRowAnimation:
    UITableViewRowAnimationFade];
  // If note is empty
  if ([note isEmpty]) {
    // Delete the note
    [[NoteStore sharedStore] deleteNote: note];
  }
  else {
    // Change the note to done
    note.done             = [NSNumber numberWithBool: YES];
    note.doneDate         = [NSDate date];
    [[NoteStore sharedStore] saveChanges];
  }
  // Need to re-calculate and group done notes
  [[NoteStore sharedStore] groupByDoneDate];
  [CATransaction setCompletionBlock: ^{
    [NoteStore sharedStore].fetchedResultsController.delegate = self;
  }];
  [self.table endUpdates];
  [CATransaction commit];

  // Switch to the next note or create an empty one
  [[self appDelegate].centerViewController checkDoneStatusForNote: note
    andSwitchToNoteAtIndexPath: indexPath];
  [[self appDelegate].rightViewController reloadTable];
}

- (void) resetAllButtonLabels
{
  createdButtonLabel.textColor = [UIColor gray: 160];
  dueButtonLabel.textColor     = [UIColor gray: 160];
  updatedButtonLabel.textColor = [UIColor gray: 160];
}

- (void) searchNotes: (id) sender
{
    UITextField *textField = (UITextField *) sender;
  searchQuery = textField.text;
  [self reloadTable];
}

@end
