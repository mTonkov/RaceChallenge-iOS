//
//  CoreDataDBHelper.h
//  RaceChallenge
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@interface CoreDataDBHelper : NSObject

@property(nonatomic,strong) NSManagedObjectContext* context;
@property(nonatomic, strong) NSManagedObjectModel* model;
@property(nonatomic, strong) NSPersistentStoreCoordinator* coordinator;
@property(nonatomic, strong) NSPersistentStore* store;

- (void)saveContext;
- (void)setupCoreData;
+(CoreDataDBHelper*) getInstance;

@end
