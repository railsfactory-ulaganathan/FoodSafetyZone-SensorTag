//
//  ALDisplayReportListViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 30/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface ALDisplayReportListViewController : UITableViewController
{
    DBManager *dbmanager;
    UIView *GeneratePDF;
    NSMutableArray *listOfDates;
    NSMutableArray *listOfRecords;
    UITextField *myTextField;
    int totalRows,totalColumns,xpos,ypos,cellWidth,cellHeight,viewTags;
    
    NSMutableArray *allIds;
    NSMutableArray *rowwise;
    NSMutableArray *allViews;
    NSMutableString *tempStorageValues;
}

@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@end
