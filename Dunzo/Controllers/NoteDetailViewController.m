//
//  NoteDetailViewController.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AddNoteView.h"
#import "AppDelegate.h"
#import "CalendarViewController.h"
#import "DunzoButton.h"
#import "DunzoNavigationViewController.h"
#import "MenuButtonView.h"
#import "MFSideMenu.h"
#import "Note+Custom.h"
#import "NoteStore.h"
#import "NoteDetailViewController.h"
#import "NoteNotDoneViewController.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

// extern NSString *const FlashMessageNotification = @"FlashMessageNotification";

@implementation NoteDetailViewController

@synthesize contentTextView   = _contentTextView;
@synthesize flashMessageLabel = _flashMessageLabel;
@synthesize flashMessageView  = _flashMessageView;
@synthesize note              = _note;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    // [[NSNotificationCenter defaultCenter] addObserver: self 
    //   selector: @selector(showFlashMessage:) 
    //     name: FlashMessageNotification object: nil];
  }
  return self;
}

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  CGRect screen = [[UIScreen mainScreen] bounds];
  UIFont *textFont = [UIFont fontWithName: @"HelveticaNeue-Light" size: 20];
  // Main
  self.view = [[UIView alloc] initWithFrame: screen];
  self.view.backgroundColor = [UIColor white];

  // Calendar View Controller
  calendarViewController = [[CalendarViewController alloc] init];
  calendarViewController.title = @"Due Date";
  // Calendar Navigation Controller
  calendarNav = 
    [[DunzoNavigationViewController alloc] initWithRootViewController:
      calendarViewController];

  // Content Text View
  _contentTextView = [[UITextView alloc] init];
  _contentTextView.autocapitalizationType = 
    UITextAutocapitalizationTypeSentences;
  _contentTextView.autocorrectionType = UITextAutocorrectionTypeYes;
  _contentTextView.backgroundColor = [UIColor clearColor];
  _contentTextView.contentInset = UIEdgeInsetsMake(-8, -2, -2, -2);
  _contentTextView.delegate = self;
  _contentTextView.frame = CGRectMake(20, 40, (screen.size.width - 40), 
    (screen.size.height - (20 + 20 + 20 + 44)));
  _contentTextView.font = textFont;
  _contentTextView.keyboardAppearance = UIKeyboardAppearanceLight;
  _contentTextView.returnKeyType = UIReturnKeyDefault;
  _contentTextView.showsVerticalScrollIndicator = NO;
  _contentTextView.textColor = [UIColor black];
  [self.view addSubview: _contentTextView];

  // Text View Placeholder
  textViewPlaceholder = [[UILabel alloc] init];
  textViewPlaceholder.backgroundColor = [UIColor clearColor];
  textViewPlaceholder.font = textFont;
  textViewPlaceholder.text = @"Start writing your thoughts...";
  textViewPlaceholder.textColor = [UIColor blackAlpha: 0.6];
  CGRect textRect = [textViewPlaceholder.text boundingRectWithSize:
    CGSizeMake(_contentTextView.frame.size.width, 100) 
      options: NSStringDrawingUsesLineFragmentOrigin 
        attributes: @{NSFontAttributeName: textViewPlaceholder.font} 
          context: nil];
  textViewPlaceholder.frame = CGRectMake((20 + 2), 40, 
    textRect.size.width, textRect.size.height);
  [self.view addSubview: textViewPlaceholder];

  UIImage *clockImage = [UIImage image: [UIImage imageNamed: @"clock.png"]
    size: CGSizeMake(20, 20)];
  UIBarButtonItem *dueButton =
    [[UIBarButtonItem alloc] initWithImage: clockImage
      style: UIBarButtonItemStylePlain target: self 
        action: @selector(showCalendar)];
  dueButton.tintColor = [UIColor gray: 160];

  UIBarButtonItem *spaceButton = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem: 
      UIBarButtonSystemItemFlexibleSpace target: nil action: nil];

  UIBarButtonItem *addButton = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem: 
      UIBarButtonSystemItemAdd target: self action: @selector(addNote)];
  addButton.tintColor = [UIColor gray: 160];

  toolbar = [[UIToolbar alloc] init];
  toolbar.barTintColor = [UIColor white];
  toolbar.frame = CGRectMake(0, (screen.size.height - 44), 
    screen.size.width, 44);
  toolbar.items = @[dueButton, spaceButton, addButton];
  [self.view addSubview: toolbar];

  dueDateLabel = [[UILabel alloc] init];
  dueDateLabel.backgroundColor = [UIColor clearColor];
  dueDateLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 12];
  dueDateLabel.frame = CGRectMake(((screen.size.width - 200) / 2.0), 12,
    200, 20);
  dueDateLabel.textAlignment = NSTextAlignmentCenter;
  dueDateLabel.textColor = [UIColor gray: 160];
  [toolbar addSubview: dueDateLabel];

  // Menu Button View
  // menuButtonView = [[MenuButtonView alloc] init];
  // [self.view addSubview: menuButtonView];
  // [menuButtonView.button addTarget: self action: @selector(showCalendar)
  //   forControlEvents: UIControlEventTouchUpInside];

  // Add Note View
  // addNoteView = [[AddNoteView alloc] init];
  // [self.view addSubview: addNoteView];
  // [addNoteView.button addTarget: self action: @selector(addNote)
  //   forControlEvents: UIControlEventTouchUpInside];

  // _flashMessageView = [[UIView alloc] init];
  // _flashMessageView.backgroundColor = [UIColor redAlpha: 0.8];
  // _flashMessageView.frame = CGRectMake(0, screen.size.height, 
  //   screen.size.width, 44);
  // [self.view addSubview: _flashMessageView];
  // _flashMessageLabel = [[UILabel alloc] init];
  // _flashMessageLabel.backgroundColor = [UIColor clearColor];
  // _flashMessageLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
  //   size: 15];
  // _flashMessageLabel.frame = CGRectMake(0, 0, 
  //   _flashMessageView.frame.size.width, _flashMessageView.frame.size.height);
  // _flashMessageLabel.text = @"Due on";
  // _flashMessageLabel.textAlignment = NSTextAlignmentCenter;
  // _flashMessageLabel.textColor = [UIColor white];
  // [_flashMessageView addSubview: _flashMessageLabel];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
}

#pragma mark - Protocol UITextViewDelegate

- (void) textViewDidBeginEditing: (UITextView *) textView
{
  // int dimension = addNoteView.frame.size.width;
  // int spacing   = 5;
  CGRect screen = [[UIScreen mainScreen] bounds];
  // float newOriginY = screen.size.height - (dimension + 216 + spacing);
  CGRect contentTextViewFrame = _contentTextView.frame;
  // CGRect addNoteViewFrame     = addNoteView.frame;
  // CGRect menuButtonViewFrame  = menuButtonView.frame;
  contentTextViewFrame.size.height = screen.size.height - 
    (20 + 20 + 20 + 44 + 216);
  // addNoteViewFrame.origin.x        = screen.size.width - 
  //    (dimension + spacing);
  // addNoteViewFrame.origin.y        = newOriginY;
  // menuButtonViewFrame.origin.x     = spacing;
  // menuButtonViewFrame.origin.y     = newOriginY;
  CGRect toolbarFrame = toolbar.frame;
  toolbarFrame.origin.y = screen.size.height - 
    (toolbar.frame.size.height + 216);
  void (^animations) (void) = ^(void) {
    _contentTextView.frame = contentTextViewFrame;
    // addNoteView.frame      = addNoteViewFrame;
    // menuButtonView.frame   = menuButtonViewFrame;    
    toolbar.frame = toolbarFrame;
  };
  [UIView animateWithDuration: 0.15 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations
      completion: nil];
  [self adjustButtonBackground];
}

- (void) textViewDidChange: (UITextView *) textView
{
  // This makes the UITextView scroll automatically when reaching the bottom
  [textView scrollRangeToVisible: NSMakeRange(textView.text.length, 0)];
  [self adjustButtonBackground];
  [self togglePlaceholder];
  [self updateNote];
}

- (void) textViewDidEndEditing
{
  [self resetTextViewSize];
}

#pragma mark - Methods

- (void) addNote
{
  // Only add a new note if the current note is not empty
  if (![_note isEmpty])
    _note = [[NoteStore sharedStore] createNote];
  [self addNoteFollowUpActions];
}

- (void) addNoteFollowUpActions
{
  _contentTextView.text = _note.content;
  if ([_note isEmpty]) {
    _contentTextView.contentSize = CGSizeMake(_contentTextView.frame.size.width,
      22);
  }
  [_contentTextView becomeFirstResponder];
  [self adjustButtonBackground];
  [self togglePlaceholder];
  [self updateDueDate];
}

- (void) addNoteRegardless
{
  _note = [[NoteStore sharedStore] createNote];
  [self addNoteFollowUpActions];
}

- (void) adjustButtonBackground
{
  // Do nothing
}

- (void) adjustButtonBackground1
{
  float opacity;
  if (_contentTextView.contentSize.height >= 
    _contentTextView.frame.size.height) {

    // [addNoteView fadeBackground];
    // [menuButtonView fadeBackground];
    opacity = 0.5;
  }
  else {
    // [addNoteView restoreBackground];
    // [menuButtonView restoreBackground];
    opacity = 1.0;
  }
  [UIView animateWithDuration: 0.15 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: ^{
      toolbar.alpha = opacity;
    } completion: nil
  ];
}

- (void) adjustContentSize
{
  CGRect textRect = [_note.content boundingRectWithSize:
    CGSizeMake(([[UIScreen mainScreen] bounds].size.width - 40), 5000)
      options: NSStringDrawingUsesLineFragmentOrigin 
        attributes: @{NSFontAttributeName: _contentTextView.font} 
          context: nil];
  _contentTextView.contentSize = CGSizeMake(textRect.size.width,
    textRect.size.height);
}

- (void) checkDoneStatusForNote: (Note *) object 
andSwitchToNoteAtIndexPath: (NSIndexPath *) indexPath
{
  // Check to see if the note that was just marked done is currently open
  if (_note == object) {
    int numberOfNotes = [[[NoteStore sharedStore] notesDone: NO 
      sortedWithKey: @"updatedAt" ascending: NO] count];
    // If there is 1 or more notes that are not done
    if (numberOfNotes > 0) {
      // Set self.note to the note at index
      if (indexPath.row > numberOfNotes - 1) {
        indexPath = [NSIndexPath indexPathForRow: numberOfNotes - 1
          inSection: indexPath.section];
      }
      _note = [[[NoteStore sharedStore] notesDone: NO sortedWithKey:
        @"updatedAt" ascending: NO] objectAtIndex: indexPath.row];
    }
    else {
      // Create a new note and set it to self.note
      NSLog(@"No more notes, create one");
      _note = [[NoteStore sharedStore] createNote];

      NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow: 0
        inSection: 0];
      [[self appDelegate].leftViewController.table insertRowsAtIndexPaths:
        @[firstIndexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
      // Need this so that the tableView reloads its cells
      // [[self appDelegate].leftViewController reloadTable];

    }
    _contentTextView.text = _note.content;
    [self togglePlaceholder];
    [self updateDueDate];
  }
}

- (void) loadNote: (Note *) object
{
  _note = object;
  _contentTextView.text = self.note.content;
  [self adjustContentSize];
  [self adjustButtonBackground];
  [self togglePlaceholder];
  [self updateDueDate];
}

- (void) menuStateEventOccurred: (NSNotification *) notification
{
  MFSideMenuStateEvent event = [[[notification userInfo] objectForKey: 
    @"eventType"] intValue];
  switch (event) {
    case MFSideMenuStateEventMenuWillOpen: {
      [self.contentTextView resignFirstResponder];
      [self resetTextViewSize];
      break;
    }
    case MFSideMenuStateEventMenuDidOpen: {
      [self adjustButtonBackground];
      break;
    }
    case MFSideMenuStateEventMenuWillClose: {
      break;
    }
    case MFSideMenuStateEventMenuDidClose: {
      break;
    }
    default:
      break;
  }
}

- (void) resetTextViewSize
{
  // int dimension = addNoteView.frame.size.width;
  CGRect screen = [[UIScreen mainScreen] bounds];
  // float newOriginY            = screen.size.height - (dimension + 20);
  CGRect contentTextViewFrame = _contentTextView.frame;
  // CGRect addNoteViewFrame     = addNoteView.frame;
  // CGRect menuButtonViewFrame  = menuButtonView.frame;
  contentTextViewFrame.size.height = screen.size.height - (20 + 20 + 20 + 44);
  // addNoteViewFrame.origin.x        = screen.size.width - (dimension + 20);
  // addNoteViewFrame.origin.y        = newOriginY;
  // menuButtonViewFrame.origin.x     = 20;
  // menuButtonViewFrame.origin.y     = newOriginY;
  CGRect toolbarFrame = toolbar.frame;
  toolbarFrame.origin.y = screen.size.height - toolbar.frame.size.height;
  void (^animations) (void) = ^(void) {
    _contentTextView.frame = contentTextViewFrame;
    // addNoteView.frame      = addNoteViewFrame;
    // menuButtonView.frame   = menuButtonViewFrame;
    toolbar.frame = toolbarFrame;
  };
  [UIView animateWithDuration: 0.15 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations
      completion: nil];
}

- (void) showCalendar
{
  calendarViewController.note = _note;
  if (_note.dueDate) {
    calendarViewController.calendarView.selectedDate = _note.dueDate;
  }
  [self resetTextViewSize];
  [self presentViewController: calendarNav animated: YES completion: nil];
}

- (void) showFlashMessage: (NSNotification *) notification
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGRect flashFrameShow = _flashMessageView.frame;
  flashFrameShow.origin.y = screen.size.height - flashFrameShow.size.height;
  CGRect flashFrameHide = _flashMessageView.frame;
  flashFrameHide.origin.y = screen.size.height;
  _flashMessageLabel.text = [[notification userInfo] objectForKey: @"message"];
  void (^animations) (void) = ^(void) {
    _flashMessageView.frame = flashFrameShow;
  };
  void (^completion) (BOOL) = ^(BOOL finished) {
    [UIView animateWithDuration: 0.2 delay: 3 options: 0 animations: ^{
      _flashMessageView.frame = flashFrameHide;
    } completion: nil];
  };
  [UIView animateWithDuration: 0.2 delay: 0 options: 0 animations: animations
    completion: completion];
}

- (void) showLeftMenu
{
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.panel setMenuState: MFSideMenuStateLeftMenuOpen completion: ^{}];
}

- (void) togglePlaceholder
{
  NSString *text = [self.contentTextView.text stringByTrimmingCharactersInSet:
    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (text.length > 0) {
    textViewPlaceholder.hidden = YES;
  }
  else {
    textViewPlaceholder.hidden = NO;
  }
}

- (void) updateDueDate
{
  if (_note.dueDate) 
    dueDateLabel.text = [NSString stringWithFormat: @"Due %@",
      [_note dueDateString]];
  else
    dueDateLabel.text = @"";
}

- (void) updateNote
{
  NSString *text = [self.contentTextView.text stringByTrimmingCharactersInSet:
    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (text.length > 0) {
    _note.content = self.contentTextView.text;
  }
  else {
    _note.content = nil;
  }
  _note.updatedAt = [NSDate date];
  [[NoteStore sharedStore] saveChanges];
}

@end
