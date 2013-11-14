//
//  DBManager.h
//  FoodSafetyZone
//
//  Created by railsfactory on 18/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
@interface DBManager : NSObject
{
    FMDatabase *fmDatabase;
    FMResultSet *fmResults;
    NSMutableString *tempStorageValues;
    NSMutableArray *tempArray;
}

@property(nonatomic,retain)FMDatabase *fmDatabase;
@property(nonatomic,retain)FMResultSet *fmResults;
@property(nonatomic,strong)NSMutableString *tempStorageValues;
@property(nonatomic,retain) NSMutableArray *tempArray;

+(DBManager *)sharedInstance;

+(void)insertDataBaseIntoDocumentPath:(NSString *)stringFileName;
+(NSString *)doumentFilePath:(NSString *)fileName;
+ (NSString*) createEditableCopyOfDatabaseIfNeeded;
@end
