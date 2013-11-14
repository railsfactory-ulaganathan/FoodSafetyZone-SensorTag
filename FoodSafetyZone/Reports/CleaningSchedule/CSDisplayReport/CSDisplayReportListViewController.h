//
//  CSDisplayReportListViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 29/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "CSDisplayCell.h"

@interface CSDisplayReportListViewController : UITableViewController
{
    DBManager *dbManager;
    NSMutableArray *frequencies;
    NSMutableArray *cleaningInstrs;
    NSMutableArray *products;
    NSMutableArray *responsiblePersons;
    NSMutableArray *reviewers;
    NSMutableArray *splInstrs;
    NSMutableString *tempStorageValues;
}

@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@end
