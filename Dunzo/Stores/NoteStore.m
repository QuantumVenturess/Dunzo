//
//  NoteStore.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "Note+Custom.h"
#import "NoteDoneGroup.h"
#import "NoteStore.h"
#import "NSString+Extensions.h"

@implementation NoteStore

@synthesize fetchedResultsController;
@synthesize noteDoneGroups = _noteDoneGroups;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    // Read in AppName.xcdatamodeld
    // NSManagedObjectModel holds entity information
    model = [NSManagedObjectModel mergedModelFromBundles: nil];

    // The NSManagedObjectContext uses an NSPersistentStoreCoordinator
    // You ask the persistent store coordinator to open
    // a SQLite database at a particular filename
    NSPersistentStoreCoordinator *psc = 
      [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: model];

    // Where does the SQLite file go?
    NSString *path  = [self itemArchivePath];
    NSURL *storeURL = [NSURL fileURLWithPath: path];
    NSError *error  = nil;
    
    if (![psc addPersistentStoreWithType: NSSQLiteStoreType configuration: nil
      URL: storeURL options: nil error: &error]) {

      [NSException raise: @"Open failed" format: @"Reason: %@",
        error.localizedDescription];
    }

    // Create the managed object context
    // Use this persistent store coordinator to save and load objects
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator: psc];

    // The Managed object context can manage undo, but we don't need it
    [context setUndoManager: nil];

    [self loadNotes];
    // [self loadNotesDone: NO];
  }
  return self;
}

#pragma mark - Methods

+ (NoteStore *) sharedStore
{
  static NoteStore *store = nil;
  if (!store) {
    store = [[NoteStore alloc] init];
  }
  return store;
}

- (void) addNote: (Note *) note
{
  [notes addObject: note];
}

- (NSArray *) allNotes
{
  // id <NSFetchedResultsSectionInfo> sectionInfo =
  //   [[self.fetchedResultsController sections] objectAtIndex: 0];
  // return [sectionInfo objects];
  return notes;
}

- (void) clearDoneNotes
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K == %i", @"done", [[NSNumber numberWithBool: YES] intValue]];
  NSArray *doneNotes = [[self allNotes] filteredArrayUsingPredicate: 
    predicate];
  for (Note *note in doneNotes) {
    [self deleteNote: note];
  }
}

- (Note *) createNote
{
  Note *note = [NSEntityDescription insertNewObjectForEntityForName: @"Note"
    inManagedObjectContext: context];
  note.createdAt = [NSDate date];
  note.done      = [NSNumber numberWithBool: NO];
  note.updatedAt = [NSDate date];
  // [notes addObject: note];
  [self reloadNotes];
  return note;
}

- (void) deleteNote: (Note *) note
{
  [context deleteObject: note];
  [self reloadNotes];
}

- (NSDictionary *) doneDateDictionary
{
  // Create a dictionary of notes with a M/D/Y key
  NSMutableDictionary *group = [NSMutableDictionary dictionary];
  for (Note *note in [self notesDone: YES sortedWithKey: @"doneDate" 
    ascending: NO]) {

    if ([note doneDateWithoutTime]) {
      NSMutableArray *array = [group objectForKey: [note doneDateWithoutTime]];
      if (!array) {
        array = [NSMutableArray array];
        [group setObject: array forKey: [note doneDateWithoutTime]];
      }
      [array addObject: note];
    }
  }
  return group;
}

- (void) groupByDoneDate
{
  // Create an array of NoteDoneGroup
  NSMutableArray *array = [NSMutableArray array];
  for (int i = 0; i < [self doneDateDictionary].count; i++) {
    NoteDoneGroup *noteDoneGroup = [[NoteDoneGroup alloc] init];
    noteDoneGroup.date  = [[self doneDateDictionary].allKeys objectAtIndex: i];
    noteDoneGroup.notes = [[self doneDateDictionary].allValues objectAtIndex: 
      i];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:
      @"doneDate" ascending: NO];
    noteDoneGroup.notes = (NSMutableArray *) 
      [noteDoneGroup.notes sortedArrayUsingDescriptors: @[sort]];
    [array addObject: noteDoneGroup];
  }
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:
    @"date" ascending: NO];
  _noteDoneGroups = [NSMutableArray arrayWithArray:
    [array sortedArrayUsingDescriptors: @[sort]]];
}

- (NSIndexPath *) indexPathForDoneNote: (Note *) note
{
  int section = [_noteDoneGroups indexOfObjectPassingTest:
    ^(id obj, NSUInteger idx, BOOL *stop) {
      NoteDoneGroup *noteDoneGroup = (NoteDoneGroup *) obj;
      if ([noteDoneGroup.date compare: 
        [note doneDateWithoutTime]] == NSOrderedSame) {

        return YES;
      }
      return NO;
    }
  ];
  NoteDoneGroup *noteDoneGroup = [_noteDoneGroups objectAtIndex: 
    section];
  int row = [noteDoneGroup.notes indexOfObject: note];
  return [NSIndexPath indexPathForRow: row inSection: section];
}

- (void) insertNote: (Note *) note
{
  [context insertObject: note];
  [self reloadNotes];
}

- (NSString *) itemArchivePath
{
  // Searches the filesystem for a path that meets the criteria
  NSArray *documentDirectories = 
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
      NSUserDomainMask, YES);

  // Get one and only document directory from that list
  NSString *documentDirectory = [documentDirectories objectAtIndex: 0];

  return [documentDirectory stringByAppendingPathComponent: @"Dunzo.sqlite"];
}

- (void) loadNotes
{
  // To get objects back from the NSManagedObjectContext
  // you must prepare and execute an NSFetchRequest
  // Prepare and execute the fetch request
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  // A fetch request needs an entity description that
  // defines which entity you want to get objects from
  NSEntityDescription *entity = [[model entitiesByName] 
    objectForKey: @"Note"];
  [request setEntity: entity];
  // Set the request's sort descriptors to specify
  // the order of the objects in the array
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:
    @"updatedAt" ascending: NO];
  [request setSortDescriptors: [NSArray arrayWithObjects: sort, nil]];

  self.fetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest: request 
      managedObjectContext: context sectionNameKeyPath: nil 
        cacheName: nil];
  [self reloadNotes];
}

- (void) loadNotesDone: (BOOL) done
{
  // To get objects back from the NSManagedObjectContext
  // you must prepare and execute an NSFetchRequest
  // Prepare and execute the fetch request
  if (!notes) {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // A fetch request needs an entity description that
    // defines which entity you want to get objects from
    NSEntityDescription *entity = [[model entitiesByName] 
      objectForKey: @"Note"];
    [request setEntity: entity];
    // Set the request's sort descriptors to specify
    // the order of the objects in the array
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:
      @"updatedAt" ascending: NO];
    [request setSortDescriptors: [NSArray arrayWithObjects: sort, nil]];

    NSError *error;
    self.fetchedResultsController = 
      [[NSFetchedResultsController alloc] initWithFetchRequest: request 
        managedObjectContext: context sectionNameKeyPath: nil 
          cacheName: nil];
    [self.fetchedResultsController performFetch: &error];
    id <NSFetchedResultsSectionInfo> sectionInfo =
      [[self.fetchedResultsController sections] objectAtIndex: 0];
    NSArray *result = [sectionInfo objects];
    if (!result) {
      [NSException raise: @"Fetch failed" format: @"Reason: %@", 
        error.localizedDescription];
    }
    notes = [[NSMutableArray alloc] initWithArray: result];
  }
}

- (NSArray *) notesDone: (BOOL) done sortedWithKey: (NSString *) key 
ascending: (BOOL) ascending
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K == %i", @"done", [[NSNumber numberWithBool: done] intValue]];
  NSArray *array = [[self allNotes] filteredArrayUsingPredicate: predicate];
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: key
    ascending: ascending];
  return [array sortedArrayUsingDescriptors: @[sort]];
}

- (NSArray *) notesDone: (BOOL) done sortedWithKey: (NSString *) key
ascending: (BOOL) ascending withQuery: (NSString *) string
{
  NSArray *array = [self notesDone: done sortedWithKey: key 
    ascending: ascending];
    if ([[NSString stripLower: string] length] > 0) {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"(%K BEGINSWITH[cd] %@) OR (%K CONTAINS[cd] %@)",
      @"content", string, @"content", string];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: key
      ascending: ascending];
    return [[array filteredArrayUsingPredicate: 
      predicate] sortedArrayUsingDescriptors: @[sort]];
  }
  return array; 
}

- (NSInteger) numberOfNotes
{
  return [notes count];
}

- (void) reloadNotes
{
  NSError *error;
  [self.fetchedResultsController performFetch: &error];
  id <NSFetchedResultsSectionInfo> sectionInfo =
    [[self.fetchedResultsController sections] objectAtIndex: 0];
  if (![sectionInfo objects]) {
    [NSException raise: @"Fetch failed" format: @"Reason: %@", 
      error.localizedDescription];
  }
  notes = [NSMutableArray arrayWithArray: [sectionInfo objects]];
  [self groupByDoneDate];
}

- (void) removeEmptyNotes
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K == %@", @"content", [NSNull null]];
  NSArray *emptyNotes = [[self allNotes] filteredArrayUsingPredicate: 
    predicate];
  for (Note *note in emptyNotes) {
    [self deleteNote: note];
  }
}

- (void) removeNote: (Note *) note
{
  [notes removeObjectIdenticalTo: note];
}

- (BOOL) saveChanges
{
  NSError *error = nil;
  BOOL successful = [context save: &error];
  if (!successful) {
    NSLog(@"Error saving: %@", error.localizedDescription);
  }
  return successful;
}

@end
