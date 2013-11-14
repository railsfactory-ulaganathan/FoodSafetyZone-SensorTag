//
//  ShowTimeLogReportViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 04/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelogReportCell.h"
#import "DBManager.h"

@interface ShowTimeLogReportViewController : UITableViewController
{
    DBManager *dbManager;
    NSMutableArray *FoodNames;
    NSMutableArray *activityNames;
    NSMutableArray *foodTemps;
    NSMutableArray *startTimes;
    NSMutableArray *stopTimes;
    NSMutableArray *actionsTaken;
    NSMutableArray *totalTimes;
    NSMutableString *tempStorageValues;
}

@end
