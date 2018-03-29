//
//  CoreDataManager.h
//  038Lottery
//
//  Created by ruihao on 2017/7/10.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, copy) NSString *modelName;

+ (id)sharedInstance;
- (id)init;

- (NSManagedObject *)createObjectWithEntityName:(NSString *)entityName;

- (NSObject *)getOneWithEntity:(NSString *)entityName
                     predicate:(NSString *)predicateName
                          sort:(NSString *)sortName
                     ascending:(BOOL)ascending;

- (NSArray *) fetchObjectsWithEntity:(NSString *)entityName
                           predicate:(NSString *)predicateName
                                sort:(NSString *)sortName
                           ascending:(BOOL)ascending
                               limit:(NSNumber *)limit;

// sort & group
- (NSArray *) fetchObjectsWithEntity:(NSString *)entityName
                           predicate:(NSString *)predicateName
                                sort:(NSString *)sortName
                           ascending:(BOOL)ascending
                               limit:(NSNumber *)limit
                               group:(NSArray *)group;

// sort by property
- (NSArray *)fetchObjectsWithEntity:(NSString *)entityName
                          predicate:(NSString *)predicateName
                               sort:(NSString *)sortName
                          ascending:(BOOL)ascending;

// sort by multiple properties
- (NSArray *)fetchObjectsWithEntity:(NSString *)entityName
                          predicate:(NSString *)predicateName
                            sortArr:(NSArray *)sortNameArr
                       ascendingArr:(NSArray *)ascendingArr;

- (void)deleteManagedObject:(NSManagedObject *)object;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
