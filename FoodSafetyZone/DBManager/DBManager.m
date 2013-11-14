//
//  DBManager.m
//  FoodSafetyZone
//
//  Created by railsfactory on 18/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "DBManager.h"
#define SAFETYFOODZONE @"SafetyFoodZone.sqlite"
static DBManager *_shareInstane;

@implementation DBManager
@synthesize fmDatabase,fmResults,tempStorageValues,tempArray;

+(DBManager *)sharedInstance {
	if (_shareInstane == nil) {
		_shareInstane = [[DBManager alloc] init];
	}
	return _shareInstane;
}

-(id)init
{
    if(self == [super init])
    {
        
    }
    
    return self;
}

#pragma mark -

+ (NSString*) createEditableCopyOfDatabaseIfNeeded
{
	// First, test for existence.
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:SAFETYFOODZONE];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) return writableDBPath;
	// The writable database does not exist, so copy the default to the appropriate location.
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SAFETYFOODZONE];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success)
	{
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
    
    return writableDBPath;
}

+(void)insertDataBaseIntoDocumentPath:(NSString *)stringFileName {
	NSString *documentsDirectory = [DBManager doumentFilePath:stringFileName];
	
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory])
    {
        NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:@"SafetyFoodZone" ofType:@"sqlite"];
		
		NSLog(@"Test backuppatjh %@",backupDbPath);
        if (backupDbPath == nil)
        {
            NSLog(@"Database path is nil");
        }
        else
        {
            BOOL copiedBackupDb = [[NSFileManager defaultManager] copyItemAtPath:backupDbPath toPath:documentsDirectory error:nil];
            if (!copiedBackupDb) NSLog(@"Copying database failed");
        }
    }
}

+(NSString *)doumentFilePath:(NSString *)fileName
{
    
    NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    if (backupDbPath == nil)
    {
        NSLog(@"Database path is nil");
    }
    
    return backupDbPath;
}


@end
