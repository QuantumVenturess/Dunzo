//
//  NoteStore.h
//  Dunzo
//
//  Created by Tommy DANGerous on 9/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class Note;

@interface NoteStore : NSObject
{
  // The portal through which you talk to the database
  NSManagedObjectContext *context;
  // The persistent store coordinator uses the model file 
  // in the form of an instance of NSManagedObjectModel
  NSManagedObjectModel *model;
  NSMutableArray *notes;
}

@property (nonatomic, strong) NSFetchedResultsController 
  *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray *noteDoneGroups;

#pragma mark - Methods

+ (NoteStore *) sharedStore;

- (void) addNote: (Note *) note;
- (void) clearDoneNotes;
- (Note *) createNote;
- (void) deleteNote: (Note *) note;
- (void) groupByDoneDate;
- (void) loadNotesDone: (BOOL) done;
- (NSIndexPath *) indexPathForDoneNote: (Note *) note;
- (void) insertNote: (Note *) note;
- (NSArray *) notesDone: (BOOL) done sortedWithKey: (NSString *) key 
ascending: (BOOL) ascending;
- (NSArray *) notesDone: (BOOL) done sortedWithKey: (NSString *) key
ascending: (BOOL) ascending withQuery: (NSString *) string;
- (NSInteger) numberOfNotes;
- (void) reloadNotes;
- (void) removeNote: (Note *) note;
- (void) removeEmptyNotes;
- (BOOL) saveChanges;

@end
