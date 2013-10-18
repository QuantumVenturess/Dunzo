//
//  NoteNotDoneViewController.h
//  Dunzo
//
//  Created by Tommy DANGerous on 9/12/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "NoteListViewController.h"

@class TextFieldPadding;

@interface NoteNotDoneViewController : NoteListViewController
<UITextFieldDelegate>
{
  UIButton *cancelButton;
  UIButton *createdButton;
  UILabel *createdButtonLabel;
  UIButton *dueButton;
  UILabel *dueButtonLabel;
  NSString *noteSortKey;
  TextFieldPadding *search;
  NSString *searchQuery;
  UIButton *updatedButton;
  UILabel *updatedButtonLabel;
}

#pragma mark - Methods

- (void) deleteTopEmptyNote;

@end
