//
//  NoteViewCell.h
//  Dunzo
//
//  Created by Tommy DANGerous on 9/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DunzoTableViewController;
@class Note;

@interface NoteViewCell : UITableViewCell <UIGestureRecognizerDelegate>
{
  UILabel *dateTimeLabel;
  UIView *dateTimeView;
  float horizontalOffset;
  UIView *leftBorder;
  UIView *mainView;
  UIPanGestureRecognizer *panGestureRecognizer;
  UIView *rightBorder;
  UILabel *titleLabel;
  UIView *titleView;
}

@property (nonatomic, weak) Note *note;
@property (nonatomic, weak) DunzoTableViewController *tableViewController;

#pragma mark - Methods

- (void) adjustDateTime;
- (void) changeColors;
- (void) checkPosition;
- (void) drag: (UIPanGestureRecognizer *) gesture;
- (void) hideTitleView;
- (void) loadNote: (Note *) object;
- (void) resetColors;
- (void) showTitleView;

@end
