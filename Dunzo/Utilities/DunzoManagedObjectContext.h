//
//  DunzoManagedObjectContext.h
//  Dunzo
//
//  Created by Tommy DANGerous on 9/13/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DunzoManagedObjectContext : NSManagedObjectContext

// The persistent store coordinator uses the model file 
// in the form of an instance of NSManagedObjectModel
@property (nonatomic, strong) NSManagedObjectModel *model;

#pragma mark - Methods

+ (DunzoManagedObjectContext *) sharedContext;

@end
