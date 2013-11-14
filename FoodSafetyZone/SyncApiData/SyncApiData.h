//
//  SyncApiData.h
//  FoodSafetyZone
//
//  Created by railsfactory on 02/08/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "JSONInterface.h"
#import "DBManager.h"

@interface SyncApiData : NSObject
{
    DBManager *dbmanager;
    NSMutableArray *storageUnitname;
    NSMutableArray *storageUnitImage;
    NSMutableArray *unitType;
    NSMutableArray *minTemp;
    NSMutableArray *maxTemp;
    NSMutableArray *unitTypeId;
}
@property (nonatomic,retain)DBManager *dbmanager;
-(void)sendDataToApi;
-(void)getDataFromApi;
@end
