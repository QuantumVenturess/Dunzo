//
//  NoteListViewController.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "Note+Custom.h"
#import "NoteListViewController.h"

NSString *const NoteUpdateNotification = @"NoteUpdateNotification";

@implementation NoteListViewController

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    [[NSNotificationCenter defaultCenter] addObserver: self 
      selector: @selector(reloadTable) name: NoteUpdateNotification object: nil];
    // Subclasses will implement this
  }
  return self;
}

#pragma mark - Protocol NSFetchedResultsController

- (void) controllerWillChangeContent1: (NSFetchedResultsController *) controller
{
  [self.table beginUpdates];
}

- (void) controller1: (NSFetchedResultsController *) controller
didChangeObject: (id) anObject atIndexPath: (NSIndexPath *) indexPath
forChangeType: (NSFetchedResultsChangeType) type
newIndexPath: (NSIndexPath *) newIndexPath
{
  UITableView *tableView = self.table;
  switch (type) {
    case NSFetchedResultsChangeDelete:
      // Delete
      [tableView deleteRowsAtIndexPaths: @[indexPath]
        withRowAnimation: UITableViewRowAnimationFade];
      NSLog(@"Deleted at %@", indexPath);
      break;
    case NSFetchedResultsChangeInsert:
      // Insert
      [tableView insertRowsAtIndexPaths: @[newIndexPath]
        withRowAnimation: UITableViewRowAnimationFade];
      NSLog(@"Insert at %@", newIndexPath);
      break;
    case NSFetchedResultsChangeMove:
      // Move
      [tableView deleteRowsAtIndexPaths: @[indexPath]
        withRowAnimation: UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths: @[newIndexPath]
        withRowAnimation: UITableViewRowAnimationFade];
      NSLog(@"Moved from %@ to %@", indexPath, newIndexPath);
      break;
    case NSFetchedResultsChangeUpdate: {
      if ([anObject isKindOfClass: [Note class]]) {
        Note *note = (Note *) anObject;
        // If done and marked for done or not done and marked for not done
        if ([note.done boolValue]) {
          [tableView deleteRowsAtIndexPaths: @[indexPath]
            withRowAnimation: UITableViewRowAnimationFade];
          NSLog(@"Update Delete %@", indexPath);
        }
        else {
          // Update
          [tableView reloadRowsAtIndexPaths: @[indexPath] 
            withRowAnimation: UITableViewRowAnimationFade];
          NSLog(@"Update %@", indexPath);
        }
      }
      break;
    }
  }
}

- (void) controllerDidChangeContent: (NSFetchedResultsController *) controller
{
  [self reloadTable];
  // [self.table endUpdates];
  NSLog(@"Controller Did Change Content");
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 80;
}

#pragma mark - Methods

- (void) configureCell: (UITableViewCell *) cell 
atIndexPath: (NSIndexPath *) indexPath
{
  // Subclasses will implement this
}

- (void) reloadTable
{
  [self.table reloadData];
}

@end
