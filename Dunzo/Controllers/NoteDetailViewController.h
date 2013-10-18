//
//  NoteDetailViewController.h
//  Dunzo
//
//  Created by Tommy DANGerous on 9/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "DunzoViewController.h"

extern NSString *const FlashMessageNotification;

@class AddNoteView;
@class CalendarViewController;
@class DunzoNavigationViewController;
@class MenuButtonView;
@class Note;

@interface NoteDetailViewController : DunzoViewController <UITextViewDelegate>
{
  AddNoteView *addNoteView;
  DunzoNavigationViewController *calendarNav;
  CalendarViewController *calendarViewController;
  UILabel *dueDateLabel;
  MenuButtonView *menuButtonView;
  UILabel *textViewPlaceholder;
  UIToolbar *toolbar;
}

@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UILabel *flashMessageLabel;
@property (nonatomic, strong) UIView *flashMessageView;
@property (nonatomic, strong) Note *note;

#pragma mark - Methods

- (void) addNoteRegardless;
- (void) checkDoneStatusForNote: (Note *) object 
andSwitchToNoteAtIndexPath: (NSIndexPath *) indexPath;
- (void) loadNote: (Note *) object;
- (void) updateDueDate;

@end
