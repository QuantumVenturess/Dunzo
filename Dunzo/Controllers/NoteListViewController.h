//
//  NoteListViewController.h
//  Dunzo
//
//  Created by Tommy DANGerous on 9/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "DunzoTableViewController.h"

extern NSString *const NoteUpdateNotification;

@interface NoteListViewController : DunzoTableViewController
<NSFetchedResultsControllerDelegate>
{
  UIView *topBar;
}

@property (nonatomic, strong) NSMutableIndexSet *deletedSectionIndexes;
@property (nonatomic, strong) NSMutableIndexSet *insertedSectionIndexes;
@property (nonatomic, strong) NSMutableArray *deletedRowIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertedRowIndexPaths;
@property (nonatomic, strong) NSMutableArray *updatedRowIndexPaths;

#pragma mark - Methods

- (void) configureCell: (UITableViewCell *) cell 
atIndexPath: (NSIndexPath *) indexPath;

@end
