//
//  SyncApiData.m
//  FoodSafetyZone
//
//  Created by railsfactory on 02/08/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "SyncApiData.h"
#import "DBManager.h"


@implementation SyncApiData
@synthesize dbmanager;


-(void)sendDataToApi
{
    dbmanager = [DBManager sharedInstance];
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM AddStorageUnits"];
    while([dbmanager.fmResults next])
    {
        [storageUnitname addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"StorageUnitName"]]];
        [storageUnitImage addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults dataForColumn:@"storageUnitImage"]]];
        [unitType addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"UnitType"]]];
    }
    for (int i = 0; i<[unitType count]; i++)
    {
        dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM AddStorageUnitType WHERE StorageUnitType = ?",[unitTypeId objectAtIndex:i]];
        while([dbmanager.fmResults next])
        {
            [unitTypeId addObject:[NSString stringWithFormat:@"%d",[dbmanager.fmResults intForColumn:@"id"]]];
            [maxTemp addObject:[NSString stringWithFormat:@"%.2f",[dbmanager.fmResults doubleForColumn:@"maxTemp"]]];
            [minTemp addObject:[NSString stringWithFormat:@"%.2f",[dbmanager.fmResults doubleForColumn:@"minTemp"]]];
        }
    }
}

-(void)getDataFromApi
{
    dbmanager = [DBManager sharedInstance];
    BOOL sucess =[dbmanager.fmDatabase executeUpdate:@"DELETE FROM AddStorageUnits"];
    
    NSLog(@"%c",sucess);
      NSHTTPURLResponse *response = nil;
      NSError *error = nil;
      NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://api.foodsmart.railsfactory.com/storage_units"]];
      NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
      [theRequest setHTTPMethod:@"GET"];
    
      [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
      [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
      NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
      NSString *ResponseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
      NSMutableArray *responseDict = [[ResponseString JSONValue] objectForKey:@"storage"];
      NSLog(@"%@",responseDict);
    
      if ([responseDict count]>0)
      {
          NSLog(@"RESPONSE %d",[responseDict count]);
          int len=[responseDict count];
          
          
          for (int i=0; i<len; i++)
          {
              NSLog(@"%@",[responseDict objectAtIndex:i]);
              
//              status = [dbmanager.fmDatabase  executeUpdate:@"INSERT INTO AddStorageUnits(StorageUnitName,UnitType,alertMessage,storageUnitImage,tempRange,storageUnitTypeId) VALUES(?,?,?,?,?,?)",[[[responseDict objectAtIndex:i] objectForKey:@"equipment"] objectForKey:@"name"],nil];
              
          }
          
      }
}


@end
