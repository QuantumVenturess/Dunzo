//
//  AppDelegate.h
//  Dunzo
//
//  Created by Tommy DANGerous on 9/8/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFSideMenuContainerViewController;
@class NoteDetailViewController;
@class NoteDoneViewController;
@class NoteNotDoneViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) NoteDetailViewController *centerViewController;
@property (nonatomic, strong) NoteNotDoneViewController *leftViewController;
@property (nonatomic, strong) NoteDoneViewController *rightViewController;

@property (nonatomic, strong) MFSideMenuContainerViewController *panel;
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong, readonly) NSManagedObjectContext 
  *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel 
  *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator 
  *persistentStoreCoordinator;

- (void) saveContext;
- (NSURL *) applicationDocumentsDirectory;

@end
