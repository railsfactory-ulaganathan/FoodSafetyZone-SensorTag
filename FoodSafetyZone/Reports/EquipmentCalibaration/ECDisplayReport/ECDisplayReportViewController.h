//
//  ECDisplayReportViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 22/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECDisplayCell.h"
#import "DBManager.h"

@interface ECDisplayReportViewController : UITableViewController
{
    DBManager *dbManager;
    NSMutableArray *equipmentNames;
    NSMutableArray *contractors;
    NSMutableArray *iceWaterTemps;
    NSMutableArray *boilingWaterTemps;
    NSMutableArray *passStatus;
    NSMutableArray *correctiveActions;
    NSMutableString *tempStorageValues;
}

@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@end
