//
//  GRDisplayReportViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 15/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DBManager.h"
#import "GRCustomCell.h"

@interface GRDisplayReportViewController : UITableViewController
{
    DBManager *dbManager;
    NSMutableArray *foodTypes;
    NSMutableArray *suppliers;
    NSMutableArray *temperatures;
    NSMutableArray *usedByDates;
    NSMutableArray *times;
    NSMutableArray *correctiveActions;
    NSMutableArray *acceptStatus;
    NSMutableString *tempStorageValues;
}

@property (strong, nonatomic) IBOutlet UILabel *HeaderLbl;
@end
